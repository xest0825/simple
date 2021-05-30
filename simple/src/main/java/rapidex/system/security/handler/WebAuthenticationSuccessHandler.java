package rapidex.system.security.handler;

import java.io.IOException;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Component;

import rapidex.system.security.UserService;
import rapidex.system.security.model.User;
import rapidex.system.session.SessionUtil;
import rapidex.system.session.SessionVO;

@Component("customSuccessHandler")
public class WebAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
	private static final Logger logger = LoggerFactory.getLogger("CustomSuccessHandler");
	
	@Autowired
	UserService userService;
	
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	@Override
	protected void handle(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
		String targetUrl = determineTargetUrl(authentication, request);
		
		if (response.isCommitted()) {
			logger.debug("Can't redirect");
            return;
        }
		User user = (User) authentication.getPrincipal();
		SessionVO sessionVO = new SessionVO();
		
		WebAuthenticationDetails webAuthenticationDetails = (WebAuthenticationDetails)authentication.getDetails();
		// IPv6 로 나옴
		String sessionId = webAuthenticationDetails.getSessionId();
		
		
		sessionVO.setUser(user);
		sessionVO.setSessionID(sessionId);
		sessionVO.setAuth(authentication);
		sessionVO.setLocation("WEB");
		
		SessionUtil.insertSessionVO(request.getSession(), sessionVO);

        request.getRequestDispatcher(targetUrl).forward(request, response);
        
        
	}
	
	/*
     * This method extracts the roles of currently logged-in user and returns
     * appropriate URL according to his/her role.
     */
    protected String determineTargetUrl(Authentication authentication, HttpServletRequest request) {
    	logger.debug("determineTargetUrl");
    	String url = "";

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
 
        User user = (User) authentication.getPrincipal();
        if(null == user) {
        	url = "/Access_Denied";
        }else {
        	url = "/beforeAction.do";
        }
        
        return url;
    }
    
    @Override
	public void setRedirectStrategy(RedirectStrategy redirectStrategy) {
        this.redirectStrategy = redirectStrategy;
    }
 
    @Override
	protected RedirectStrategy getRedirectStrategy() {
        return redirectStrategy;
    }

}
