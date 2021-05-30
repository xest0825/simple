package rapidex.system.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

@Component("SampleMobileAuthenticationFailureHandler")
public class MobileAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {
	private static final Logger logger = LoggerFactory.getLogger(MobileAuthenticationFailureHandler.class);
	
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, 
			AuthenticationException exception) throws ServletException, IOException {
		logger.debug("onAuthenticationFailure ===> ");
		String targetUrl = "/m/loginFail.go";
		
		
		// 모바일 환경이므로 굳이 뒤로가기나 url을 따지는 리다이렉션이 필요없음
		logger.debug("exception Message : " + exception.getMessage());
		request.setAttribute("fail", "true");
		request.setAttribute("SPRING_SECURITY_LAST_EXCEPTION", exception.getMessage());
		request.getRequestDispatcher(targetUrl).forward(request, response);
//		redirectStrategy.sendRedirect(request, response, targetUrl);
	}
}
