package rapidex.system.security.handler;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

@Component("WebAccessDeniedHandler")
public class WebAccessDeniedHandler implements AccessDeniedHandler {
	private static final Logger logger = LoggerFactory.getLogger("WebAccessDeniedHandler");
	
	private Boolean redirect = true;
	public Boolean getRedirect() {
		return redirect;
	}
	public void setRedirect(Boolean redirect) {
		this.redirect = redirect;
	}

	private String errorPage;
	public void setErrorPage(String errorPage) {
		this.errorPage = errorPage;
	}
	public String getErrorPage() {
		return errorPage;
	}

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException, ServletException {
		String url = request.getRequestURI();
		String Method = request.getMethod();
		try {
			
			logger.debug("url="+url);
			logger.debug("Method="+Method);
			if(redirect) {
				response.sendRedirect(errorPage);			
			}else{
				RequestDispatcher dispatcher = request.getRequestDispatcher(errorPage);
				response.sendError(HttpServletResponse.SC_FORBIDDEN);
				//dispatcher.forward(request, response);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
