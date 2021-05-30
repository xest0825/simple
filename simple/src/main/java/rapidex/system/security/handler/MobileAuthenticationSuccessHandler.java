package rapidex.system.security.handler;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;

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

import rapidex.common.util.InetUtil;
import rapidex.system.log.LogService;
import rapidex.system.security.model.User;
import rapidex.system.session.SessionUtil;
import rapidex.system.session.SessionVO;


@Component("MobileAuthenticationSuccessHandler")
public class MobileAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
	private static final Logger logger = LoggerFactory.getLogger("SampleMobileAuthenticationSuccessHandler");
	
//	@Autowired
//	MobileLoginService mobileLoginService;
	
	@Autowired
	LogService logService;
	
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
		sessionVO.setLocation("Mobile");
		
		SessionUtil.insertSessionVO(request.getSession(), sessionVO);
		
		HashMap<String, String> loginHistMap = new HashMap<String, String>();
		 
		loginHistMap.put("login_tp", user.getLogin_typ()); 		/* VARCHAR(50) 	로그인 유형 */
		loginHistMap.put("mb_id",    user.getMb_id()); 			/* VARCHAR(50) 	회사코드    */
		loginHistMap.put("devc_tp",  user.getDevc_typ()); 		/* VARCHAR(5) 	기기 유형   */
		loginHistMap.put("devc_id",  user.getDevc_id()); 		/* VARCHAR(255) 기기 ID     */
		loginHistMap.put("login_ip", InetUtil.getClientIP(request)); 		/* VARCHAR(20) 	로그인 IP   */
		loginHistMap.put("user_id",  user.getUser_id());		/* VARCHAR(100) 사용자 ID   */
		loginHistMap.put("app_ver",  user.getApp_ver()); 		/* VARCHAR(50) 	OS 명       */
		logService.insertAppLoginLog(loginHistMap);

        //request.getRequestDispatcher(targetUrl).forward(request, response);
		redirectStrategy.sendRedirect(request, response, targetUrl);
        
        
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
        	url = "/m/access_denied.go";
        }else {
        	url = "/m/before_main.do";
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
