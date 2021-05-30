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

import rapidex.system.session.SessionUtil;

@Component("customFailureHandler")
public class WebAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {
	private static final Logger logger = LoggerFactory.getLogger(WebAuthenticationFailureHandler.class);
	
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, 
			AuthenticationException exception) throws IOException, ServletException {
		logger.debug("onAuthenticationFailure");
		String targetUrl = "/login.go";
		SessionUtil.deleteSessionVO(request.getSession());
		
		request.setAttribute("SPRING_SECURITY_LAST_EXCEPTION", exception.getMessage());
		request.getRequestDispatcher(targetUrl).forward(request, response);
	}
}
