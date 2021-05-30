package rapidex.system.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Component;

import rapidex.system.security.CustomUserDetailsHelper;
import rapidex.system.security.model.User;


@Component("ssoSuccessHandler")
public class SsoSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
	private static final Logger logger = LoggerFactory.getLogger("CustomSuccessHandler");
	
//	@Autowired
//	UserService userService;
	
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	@Override
	protected void handle(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
		
		if (response.isCommitted()) {
			logger.debug("Can't redirect");
            return;
        }

		// User 조회
		User userDetailsVO = (User) CustomUserDetailsHelper.getAuthenticatedUser();

		WebAuthenticationDetails webAuthenticationDetails = (WebAuthenticationDetails)authentication.getDetails();

		String sessionId = webAuthenticationDetails.getSessionId();
		
		// TODO: 여기서 로그인 성공시 이력 저장
		// 모바일 환경이므로 굳이 뒤로가기나 url을 따지는 리다이렉션이 필요없음
        request.getRequestDispatcher("/mobile/main.go").forward(request, response);        
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
