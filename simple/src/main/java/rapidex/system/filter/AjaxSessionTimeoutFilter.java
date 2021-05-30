package rapidex.system.filter;

import rapidex.common.util.CommUtil;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationTrustResolver;
import org.springframework.security.authentication.AuthenticationTrustResolverImpl;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.util.ThrowableAnalyzer;
import org.springframework.security.web.util.ThrowableCauseExtractor;

/**
 * ajax 요청에 대한 세션 타임아웃 에러 처리
 * 
 * @author SonJooArm
 *
 */
public class AjaxSessionTimeoutFilter implements Filter {

	private static final Logger logger = LoggerFactory.getLogger(AjaxSessionTimeoutFilter.class);

	private ThrowableAnalyzer throwableAnalyzer = new DefaultThrowableAnalyzer();
	private AuthenticationTrustResolver authenticationTrustResolver = new AuthenticationTrustResolverImpl();

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		logger.debug("AjaxSessionTimeoutFilter implements Filter");
		HttpServletRequest req = (HttpServletRequest) request; // ServletReqeust 캐스팅
		HttpServletResponse res = (HttpServletResponse) response; // ServletResponse 캐스팅
		boolean AjaxReq = false;
		logger.debug("req.RequestURI : " + req.getRequestURI().toLowerCase());
		logger.debug("(req.getRequestURI().toLowerCase()).indexOf(\".ajax\") : "
				+ (req.getRequestURI().toLowerCase()).indexOf(".ajax"));
		if ((req.getRequestURI().toLowerCase()).indexOf(".ajax") == 0) {
			AjaxReq = true;
			logger.debug(".ajax");
		}
		try {
			chain.doFilter(req, res);
		} catch (IOException ex) {
			throw ex;
		} catch (Exception ex) {
			Throwable[] causeChain = throwableAnalyzer.determineCauseChain(ex);
			RuntimeException ase = (AuthenticationException) throwableAnalyzer
					.getFirstThrowableOfType(AuthenticationException.class, causeChain);

			if (ase == null) {
				logger.debug("AuthenticationException null");
				ase = (AccessDeniedException) throwableAnalyzer.getFirstThrowableOfType(AccessDeniedException.class,
						causeChain);
				logger.debug("set AuthenticationException");
			} else if (ase != null) {
				logger.debug("AuthenticationException is not null");
				if (ase instanceof AuthenticationException) {
					logger.debug("Athentication Exception");
					if (AjaxReq)
						res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
					else
						throw ase;
				} else if (ase instanceof AccessDeniedException) {
					logger.debug("AccessDenied Exception");
					if (authenticationTrustResolver
							.isAnonymous(SecurityContextHolder.getContext().getAuthentication())) {
						logger.debug("Anonymouns");
						logger.debug("Redirect to login page");
						if (AjaxReq)
							res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
						else
							throw ase;
					} else {
						logger.debug("not Anonymouns");
						try {
							if (AjaxReq)
								res.sendError(HttpServletResponse.SC_FORBIDDEN);
							else
								CommUtil.sendAlertMsg(res, "요청하신 서비스의 권한이 없습니다.", req.getHeader("referer"));
						} catch (Exception e1) {
							logger.error("권한요청중 에러 발생: {}", e1.getMessage());
						}
					}
				} else {
					logger.debug("not Authentication Exception, not AccessDenied Exception");
					throw ase;
				}
			}

		}
	}

	private static final class DefaultThrowableAnalyzer extends ThrowableAnalyzer {
		protected void initExtractorMap() {
			super.initExtractorMap();

			registerExtractor(ServletException.class, new ThrowableCauseExtractor() {
				public Throwable extractCause(Throwable throwable) {
					ThrowableAnalyzer.verifyThrowableHierarchy(throwable, ServletException.class);
					return ((ServletException) throwable).getRootCause();
				}
			});
		}
	}

	public void init(FilterConfig filterConfig) throws ServletException {
	}

}
