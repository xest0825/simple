package rapidex.system.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import rapidex.common.util.CommUtil;
import rapidex.common.util.CryptoUtil;
import rapidex.system.security.model.Role;
import rapidex.system.security.model.User;
import rapidex.system.security.model.gxUserDetails;

import javax.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Component
public class WebAuthenticationProvider implements AuthenticationProvider {

	private static final Logger logger = LoggerFactory.getLogger(WebAuthenticationProvider.class);

	@Autowired
	private UserService userService;
	
	/**
	 * 변경된 로그인
	 * {systemgubun=web, username=, j_password=, mb_id=, password=, j_username=}
	 * @since 2021.03.11
	 * @author Ethan
	 */
	public Authentication authenticate(Authentication authentication) throws AuthenticationException{
		
		User user = new User();
		Map<String, String> map = new HashMap<String, String>();
		String LOGIN_ID = authentication.getName();// 로그인아이디
		String LOGIN_PW = (String) authentication.getCredentials();//로그인패스워드
		String mb_id = "";
		
		// 기타정보 획득
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		Enumeration<?> param = request.getParameterNames();
		
		//System.out.println("----------------------------");
		while (param.hasMoreElements()){
		    String name = (String)param.nextElement();
		    //System.out.println(name + " : " +request.getParameter(name));
		    map.put(name.toLowerCase(), request.getParameter(name));
		}
		//System.out.println("----------------------------");
		
		map.put("username", LOGIN_ID);
		map.put("password", LOGIN_PW);
		
		// 필수파라미터 확인
		if(CommUtil.isEmpty(map.get("mb_id"))
			|| CommUtil.isEmpty(LOGIN_ID)
			|| CommUtil.isEmpty(LOGIN_PW)
				) {
			throw new BadCredentialsException("필수값 누락");
		}
		
		mb_id = map.get("mb_id");
    	map.put("mb_id", mb_id);
    	

    	// 계정정보 및 권한 조회
//		user = userService.getUserView(map);
		//List<Role> role = userService.getRolesHierarchyList(map);
		List<Role> role = new ArrayList<Role>();
    	
		
		String initPassword = LOGIN_PW;
    	String queriedPassword = user.getPassword();
    	
    	try {
			
    		initPassword = CryptoUtil.encrypt(initPassword); 
    		logger.info(initPassword);
    		
		} catch (Exception e) {			
			e.printStackTrace();			
		}
    	
    	if(!initPassword.equals(queriedPassword)) {
    		throw new BadCredentialsException("비밀번호 틀림");
    	}
    	
		
		return new UsernamePasswordAuthenticationToken(new gxUserDetails(LOGIN_ID, LOGIN_PW, user, role), LOGIN_PW, role);
	}


	public boolean supports(Class<?> authentication) {
		return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
	}
}
