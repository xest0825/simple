package rapidex.system.filter;

import java.io.IOException;
import java.util.regex.Pattern;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.owasp.esapi.ESAPI;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import rapidex.system.esapi.OwaspValidationException;
import rapidex.system.esapi.EsapiSecurityWrapperRequest;
import rapidex.system.esapi.EsapiSecurityWrapperResponse;
import rapidex.common.util.HttpUtils;

public class EsapiFilter implements Filter {
    private static final Logger LOGGER = LoggerFactory.getLogger(EsapiFilter.class);
    //private static final String[] OBFUSCATE = {"password"};
    private boolean passMode = false;
    private Pattern skipUrlPattern;
    private Pattern skipParamNamePattern;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String skipUrlPattern = filterConfig.getInitParameter("skipUrlPattern");
        if (StringUtils.hasText(skipUrlPattern)) {
            LOGGER.info("skipUrlPattern:{}", skipUrlPattern);
            this.skipUrlPattern = Pattern.compile(skipUrlPattern);
        }

        String skipParamNamePattern = filterConfig.getInitParameter("skipParamNamePattern");
        if (StringUtils.hasText(skipParamNamePattern)) {
            LOGGER.info("skipParameterNameRegExp:" + skipParamNamePattern);
            this.skipParamNamePattern = Pattern.compile(skipParamNamePattern);
        }

        this.passMode = "true".equals(filterConfig.getInitParameter("skipParamNamePattern"));
        LOGGER.info("skipUrlPattern:{}, skipParameterNameRegExp:{}, passMode:{}", this.skipUrlPattern,
                this.skipParamNamePattern, this.passMode);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String url = HttpUtils.getFullURI(req);
        if (url.startsWith("/resources/")) {
            chain.doFilter(req, resp);
            return;
        }

        if (this.skipUrlPattern != null) {
            if (this.skipUrlPattern.matcher(url).find()) {
                chain.doFilter(req, resp);
                return;
            }
        }

        try {
            ESAPI.httpUtilities().setCurrentHTTP(req, resp);
            // log this request, obfuscating any parameter named password
            //ESAPI.httpUtilities().logHTTPRequest(req, logger, Arrays.asList(OBFUSCATE));
            EsapiSecurityWrapperRequest secureReq = new EsapiSecurityWrapperRequest(req);
            secureReq.setPassMode(this.passMode);
            secureReq.setSkipParamNamePattern(this.skipParamNamePattern);

            EsapiSecurityWrapperResponse secureResp = new EsapiSecurityWrapperResponse(resp);
            secureResp.setPassMode(this.passMode);

            chain.doFilter(secureReq, secureResp);
            // set up response with content type
            ESAPI.httpUtilities().setContentType(resp);
            // set no-cache headers on every response
            // only do this if the entire site should not be cached
            // otherwise you should do this strategically in your controller or actions
            ESAPI.httpUtilities().setNoCacheHeaders(resp);
        } catch (Exception e) {
            //리퀘스트로 넘어가기도 전에 필터체인에서 에러가 나버리면 ControllerAdvice를 통해 에러처리가 불가능하다.
            //이때를 위해서 라도 에러 페이지는 꼭 설정해야 한다. 아니면  사용자가 stackTrace를 보게 된다..
            //이게 발생하는 상황은 filter에서 사용자가 위배되는 parameter를 던졌는데 esapi뒤쪽의 필터에서 에러가 나는경우로
            //지금 문제가 되는 부분은 SiteFilter에서 메뉴를 확인하기 위해 request.getQueryString()을 할때 발생한다.
            throw new OwaspValidationException(e);
        } finally {
            // VERY IMPORTANT
            // clear out the ThreadLocal variables in the authenticator
            // some containers could possibly reuse this thread without clearing the User
            ESAPI.clearCurrent();
        }
    }
 
    @Override
    public void destroy() {

    }

}