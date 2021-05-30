package rapidex.system.security;

import rapidex.common.util.CommUtil;
import rapidex.system.jwt.JwtTokenUtil;
import rapidex.system.security.model.Role;
import rapidex.system.security.model.User;
import rapidex.system.security.model.gxUserDetails;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.*;


@Component
public class SsoAuthenticationProvider implements AuthenticationProvider {

	private static final Logger logger = LoggerFactory.getLogger(SsoAuthenticationProvider.class);

	@Autowired
	private UserService userService;

	private JwtTokenUtil jwtTokenUtil = new JwtTokenUtil();
	
	/**
	 * 변경된 로그인
	 * {systemgubun=mobile, emp_id=, mb_id=}
	 * @since 2021.03.11
	 * @author Ethan
	 */
	public Authentication authenticate(Authentication authentication) throws AuthenticationException{
		
		User user = new User();
		Map<String, String> map = new HashMap<String, String>();
		// login_id 설정
		// login_pw 설정
		// mb_id 설정
		
		// 기타정보 획득
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		Enumeration<?> param = request.getParameterNames();
		
		while (param.hasMoreElements()){
		    String name = (String)param.nextElement();
		    //System.out.println(name + " : " +request.getParameter(name));
		    map.put(name.toLowerCase(), request.getParameter(name));
		}
		
		
		// TODO : 로그인 유형 처리 (idpw, ezpw, SSO, 토큰)

		
		/**
		 * Token 풀기
		 * 	 * {
		 * 		  mb_id: "",
		 * 		  emp_cd: "",
		 * 		  emp_nm: "",
		 * 		  org_cd_path: "111>222>333",
		 * 		  org_nm_path: "가나다>라마바>사아자",
		 * 		  email_addr: "aaa@gmail.com",
		 *                }
		 */
		boolean isValidToken = jwtTokenUtil.validateToken(map.get("token"));

		//TODO Token 유효하지 않은 경우 처리할 것.
		String t_mb_id = jwtTokenUtil.getClaimsDataFromToken("mb_id", map.get("token"));
		String t_emp_cd = jwtTokenUtil.getClaimsDataFromToken("emp_cd", map.get("token"));
		String t_emp_nm = jwtTokenUtil.getClaimsDataFromToken("emp_nm", map.get("token"));
		String t_emp_pw = jwtTokenUtil.getClaimsDataFromToken("emp_pw", map.get("token"));
		String t_org_cd_path = jwtTokenUtil.getClaimsDataFromToken("org_cd_path", map.get("token"));
		String t_org_nm_path = jwtTokenUtil.getClaimsDataFromToken("org_nm_path", map.get("token"));
		String t_email_addr = jwtTokenUtil.getClaimsDataFromToken("email_addr", map.get("token"));
		String t_hp_no = jwtTokenUtil.getClaimsDataFromToken("hp_no", map.get("token"));
		String t_role_id = jwtTokenUtil.getClaimsDataFromToken("role_id", map.get("token"));

		user.setUser_id(t_emp_cd);
		user.setEmp_id(t_emp_cd);
		user.setUsername(t_emp_nm);
		user.setMb_id(t_mb_id);
		user.setEmail(t_email_addr);
		user.setTel_no(t_hp_no);
		user.setOrg_id_path(t_org_cd_path);
		user.setOrg_nm_path(t_org_nm_path);
		user.setRole_id(t_role_id);

		List<Role> roleList = new LinkedList<>();
		Role role = new Role();
		role.setName(t_role_id);
		roleList.add(role);


		/* User 정보 조회해서 없을 경우 DB 에 User 생성 */
		//public int insertMember(JoinVO param){  tbcm_join_info
		User joinVO = new User();
		joinVO.setUser_id(t_emp_cd);

		String memberCheck = "" ;
		//String memberCheck = userService.getMemberCheck(joinVO);
		 
		/* 사용자 정보가 등록되어있지 않은 경우 사용자 등룍 */
		if("none".equals(memberCheck)) {
			joinVO.setLogin_id(t_emp_cd);
			joinVO.setCust_nm(t_emp_nm);
			joinVO.setLogin_pw(t_emp_pw);
			joinVO.setMb_id(t_mb_id);
			joinVO.setMob_no(t_hp_no);
		
			if(CommUtil.isNotEmpty(t_org_cd_path)) {
				String[] org_cd_arr = t_org_cd_path.split(">");
				t_org_cd_path = org_cd_arr[org_cd_arr.length-1];
			}
			
			joinVO.setOrg_id_path(t_org_cd_path);
			
			//userService.insertJoinUser(joinVO);
		}

		//return new UsernamePasswordAuthenticationToken(new gxUserDetails(t_emp_cd, t_emp_cd, user, roleList), t_emp_cd, role);
		gxUserDetails gxDtl = new gxUserDetails(t_emp_cd, t_emp_cd, user, roleList);
		return new UsernamePasswordAuthenticationToken(gxDtl, t_emp_cd, roleList);
			

	}


	public boolean supports(Class<?> authentication) {
		return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
	}
}
