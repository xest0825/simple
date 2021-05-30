package rapidex.system.security;

import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.stereotype.Component;

@Component
public class CsrfSecurityRequestMatcher implements RequestMatcher {
	private static final Logger logger = LoggerFactory.getLogger(CsrfSecurityRequestMatcher.class);
    private Pattern allowedMethods = Pattern.compile("^(GET|HEAD|TRACE|OPTIONS)$");
    // GET CSRF익셉션을 풀어버린다 GET만 푼다
    private Pattern allowedExceptionUrl = Pattern.compile("(\\/jquery_body.go)"	// 임시
    		+"|(\\/swagger-ui.html)"
    		+"|(\\/v2/api-docs)"
    		+"|(\\/swagger-resources/*)"
    		+"|(\\/webjars/*)"
    		+"|(\\/null/swagger-resources/configuration/ui)"
    		+"|(\\/api/.*)"
    		+ "");
    
    // POST CSRF익셉션을 풀어버린다 POST만 푼다
    private Pattern allowedUrls = Pattern.compile( "(\\/loginCheck.ajax)"// 로그인체크
    												+ "|(\\/insertErrorLog.ajax)"// 에러로그등록
    												+ "|(\\/login.do)"
    												+ "|(\\/api/.*)"
    												+ "|(\\/uploadExcel/insertUploadExcelDataMonth.ajax)"
    												+ "|(\\/uploadExcel/insertUploadExcelDataMonthRPA.ajax)"
    												+ "");

    //@Override
    public boolean matches(HttpServletRequest request) {
    	boolean result;
    	
    	String url = request.getRequestURI();
		String Method = request.getMethod();
		logger.debug("url="+url);
		logger.debug("Method="+Method);
		
        if(allowedMethods.matcher(Method).matches()){
        	result = false;
        	
        	if(allowedExceptionUrl.matcher(url).find()){
        		// Get 방식으로 연결 허용
        		result = false;
        	}else if(allowedUrls.matcher(url).find()){
        		// Get 방식으로 [bridge * .go] 연결 허용안함
        		result = true;
        	}
        }else{
        	// POST방식으로 [bridge * .go] 연결 허용
        	result = !allowedUrls.matcher(url).find();
        }
        logger.debug("result="+result);
        return result;
    }
}