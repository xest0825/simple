package rapidex.system.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.StandardPasswordEncoder;

import rapidex.common.util.CommUtil;
import rapidex.system.security.model.User;


//import gxframework.rte.improved.security.userdetails.gxUserDetails;

public class CustomUserDetailsHelper {
	private static Logger log = LoggerFactory.getLogger(CustomUserDetailsHelper.class);
    /**
     * 인증된 사용자객체를 VO형식으로 가져온다.
     * @return 사용자 ValueObject
     */
    public static Object getAuthenticatedUser() {
    	log.debug("## getAuthenticatedUser!!");
        SecurityContext context = SecurityContextHolder.getContext();
        //System.out.println(context.toString());
        Authentication authentication = context.getAuthentication();
        
        //System.out.println(authentication.toString());
        log.debug("gxUserDetailsHelper getAuthenticatedUser()");
        if (CommUtil.isEmpty(authentication)) {
            log.debug("## authentication object is null!!");
            return null;
        }        
        
        if (authentication.getPrincipal() instanceof User) {
        	User details = (User) authentication.getPrincipal();   
        	
	        //log.debug("## gxUserDetailsHelper.getAuthenticatedUser : AuthenticatedUser is {}", details.getUsername());
	        
	        return details;
        } else {
        	//return authentication.getPrincipal();
            return null;
        }
    }

    /**
     * 인증된 사용자의 권한 정보를 가져온다. 
     * 예) [ROLE_ADMIN, ROLE_USER, ROLE_A, ROLE_B, ROLE_RESTRICTED,
     * IS_AUTHENTICATED_FULLY,
     * IS_AUTHENTICATED_REMEMBERED,
     * IS_AUTHENTICATED_ANONYMOUSLY]
     * @return 사용자 권한정보 목록
     */
    public static List<String> getAuthorities() {
        List<String> listAuth = new ArrayList<String>();
        log.debug("## getAuthorities!!");
        SecurityContext context = SecurityContextHolder.getContext();
        Authentication authentication = context.getAuthentication();
        //log.debug("gxUserDetailsHelper getAuthorities()");
        if (CommUtil.isEmpty(authentication)) {
            log.debug("## authentication object is null!!");
            return null;
        }

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        Iterator<? extends GrantedAuthority> iter = authorities.iterator();
        
        while(iter.hasNext()) {
        	GrantedAuthority auth = iter.next();
        	listAuth.add(auth.getAuthority());

            log.debug("## gxUserDetailsHelper.getAuthorities : Authority is {}", auth.getAuthority());

        }
        
        return listAuth;
    }

    /**
     * 인증된 사용자 여부를 체크한다.
     * @return 인증된 사용자 여부(TRUE / FALSE)
     */
    public static Boolean isAuthenticated() {
    	//log.debug("## isAuthenticated!!");
        SecurityContext context = SecurityContextHolder.getContext();
        Authentication authentication = context.getAuthentication();
        log.debug("gxUserDetailsHelper isAuthenticated()");
        if (CommUtil.isEmpty(authentication)) {
            log.debug("## authentication object is null!!");
            return Boolean.FALSE;
        }

        String username = authentication.getName();
        if (username == null) {
        	return Boolean.FALSE;
        }
        
        if (username.equals("roleAnonymous")) {
            log.debug("## username is " + username);
            return Boolean.FALSE;
        }

        Object principal = authentication.getPrincipal();
        log.debug("principal : " + principal.toString());

        return (Boolean.valueOf(!CommUtil.isEmpty(principal)));
    }
    
    /**
     * 기본 algorithmd(SHA-256)에 대한 패스워드 얻기.(현재 ShaPasswordEncoder가 아닌 StandardPasswordEncoder사용중)
     * @param password
     * @return
     */
    public static String getHashedPassword(String password) {
    	ShaPasswordEncoder encoder = new ShaPasswordEncoder(256);
		String hashed = encoder.encodePassword(password, null);
		
		return hashed;
    }
    
	/**
	 * 로그인 페스워드 암호화  by 스프링 시큐리티
	 * @param message
	 * @return
	 * @throws Exception
	 */
	public static String encryptlogin(String message) throws Exception {
		
		StandardPasswordEncoder spe = new StandardPasswordEncoder();
		
		String enc = spe.encode(message);
		
		log.debug("----------------------------------" + enc);
		
		//return encrypt(getDeafaultKey(), message);
		return enc;
	}

	
	/**
	 * 로그인 페스워드 암호화  비교 
	 * @param rawPassword (암호화 되지 않은 패스워드)
	 * @param encodedPassword (암호화 된 패스워드)
	 * @return boolean
	 */
	public static boolean matches(CharSequence rawPassword, String encodedPassword)
	{
		StandardPasswordEncoder spe = new StandardPasswordEncoder();
		return spe.matches(rawPassword, encodedPassword);		
	}
}

