package rapidex.system.security.model;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;


public class gxUserDetails extends User {

    /**
	 * 
	 */
	private static final long serialVersionUID = 4424979814070137320L;

	/**
     * User 클래스의 생성자 Override
     * @param username 사용자계정
     * @param password 사용자 패스워드
     * @param enabled 사용자계정 사용여부
     * @param accountNonExpired
     * @param credentialsNonExpired
     * @param accountNonLocked
     * @param authorities
     * @param gxVO 사용자 VO객체
     * @throws IllegalArgumentException
     */
	private String MB_ID;
	
	
	
    public String getMB_ID() {
		return MB_ID;
	}

	public void setMB_ID(String mB_ID) {
		MB_ID = mB_ID;
	}

	public gxUserDetails(String username, String password, boolean enabled,
            boolean accountNonExpired, boolean credentialsNonExpired,
            boolean accountNonLocked, Collection<? extends GrantedAuthority> authorities,
            Object gxVO) throws IllegalArgumentException {
        super(username, password, enabled, accountNonExpired,
            credentialsNonExpired, accountNonLocked, authorities);

        this.gxVO = gxVO;
    }
	
	public gxUserDetails(String username, String password, String mb_id, boolean enabled,
			boolean accountNonExpired, boolean credentialsNonExpired,
			boolean accountNonLocked, Collection<? extends GrantedAuthority> authorities,
			Object gxVO) throws IllegalArgumentException {
		super(username, password, enabled, accountNonExpired,
				credentialsNonExpired, accountNonLocked, authorities);
		
		this.gxVO = gxVO;
	}
    
    /* 현재사용중인 생성자 */
    public gxUserDetails(String username, String password, boolean enabled, 
    		Object gxVO) throws IllegalArgumentException { 
    	
    	this(username, password, enabled, true, true, true, 
    			Arrays.asList(new GrantedAuthority[] {new SimpleGrantedAuthority("HOLDER")}), gxVO);
    	
    }
    
    /* 추가한 생성자 - 윤식 */
    public gxUserDetails(String username, String password, String mb_id, boolean enabled, 
    		Object gxVO) throws IllegalArgumentException { 
    	this(username, password, mb_id, enabled, true, true, true, 
    			Arrays.asList(new GrantedAuthority[] {new SimpleGrantedAuthority("HOLDER")}), gxVO);
    }
    
    /* 추가한 생성자 - JJT */
    public gxUserDetails(String username, String password, Object gxVO, List<Role> list) throws IllegalArgumentException { 
    	this(username, password, true, true, true, true, list, gxVO);
    }

	private Object gxVO;

    /**
     * @return 사용자VO 객체
     */
    public Object getgxUserVO() {
        return gxVO;
    }

    /**
     * @param gxVO 사용자VO객체
     */
    public void setgxUserVO(Object gxVO) {
        this.gxVO = gxVO;
    }
}