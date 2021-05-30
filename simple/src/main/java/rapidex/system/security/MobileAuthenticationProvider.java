package rapidex.system.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import rapidex.system.login.LoginService;
import rapidex.system.login.LoginVO;
import rapidex.system.security.model.User;
import rapidex.system.security.model.Role;




@Component
public class MobileAuthenticationProvider implements AuthenticationProvider {

	private static final Logger logger = LoggerFactory.getLogger(MobileAuthenticationProvider.class);
	
	@Autowired
	private LoginService loginService;
	
	/**
	 * 
	 * @since 2021.03.11
	 * @author Ethan
	 */
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		
		User user = new User();
		String login_id = authentication.getName();// 로그인아이디
		String login_pw = (String) authentication.getCredentials();//로그인패스워드
		logger.debug(login_id);
		logger.debug(login_pw);
		
		
		Collection<? extends GrantedAuthority> authorities = null;
		HashMap<String, String> loginData = new HashMap<String, String>();//로그인데이터정보 담음
		
		// 기타정보 획득
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		Enumeration<?> param = request.getParameterNames();
		
		logger.debug("params -------------------------------> ");
		while (param.hasMoreElements()){
			String name = (String)param.nextElement();
			
			// 비밀번호의 경우 여기에 등록하지 않음
			System.out.println(name + " = " + request.getParameter(name));
			if(name.toLowerCase().equals("password")) continue;
			if("j_username".equals(name)) {
				loginData.put("login_id", request.getParameter(name));
				loginData.put("j_username", request.getParameter(name));
			} 
			if(name.toLowerCase().equals("mb_id")) {
				loginData.put(name.toLowerCase(), request.getParameter(name).toUpperCase());
			} else {
				loginData.put(name.toLowerCase(), request.getParameter(name));				
			}
			
		}
		logger.debug("params <------------------------------- ");
		
		String t_mb_id = loginData.get("mb_id");
		String t_login_type = loginData.get("login_type");
		String t_login_id = loginData.get("j_username");
		String t_login_pw 	  = loginData.get("j_password");
		String t_simple_pw = loginData.get("j_password");
		String t_device_id = loginData.get("simp_login_devc_id");
		
		ArrayList<Role> roleList = new ArrayList<Role>();
		user = loginService.getLoginUser(loginData);
		if (user == null) {
			logger.debug("사용자 없음.");
			throw new BadCredentialsException("사용자 계정이 없거나 정보가 일치하지 않습니다.");
		} else {
			if (!t_login_pw.equals(user.getLogin_pw())) {
				logger.debug("비번 틀림.");
				throw new BadCredentialsException("사용자 계정이 없거나 정보가 일치하지 않습니다.");
			} else {
				roleList = (ArrayList<Role>) loginService.getRoleList(loginData);
				if (roleList == null || roleList.size() == 0) {
					logger.debug("권한이 없음");
					throw new BadCredentialsException("사용자 계정이 없거나 정보가 일치하지 않습니다.");
				} 
				user.setAuthorities(roleList);
				authorities = user.getAuthorities();
			}
		}
		
		return new UsernamePasswordAuthenticationToken(user, login_id, authorities);

	}


	public boolean supports(Class<?> authentication) {
		return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
	}
}
