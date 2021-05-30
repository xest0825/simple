package rapidex.system.security.model;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;


public class User implements UserDetails{
	private static final long serialVersionUID = 1L;
	
	private String username;
	private String password;
	private List<Role> authorities;
	private boolean accountNonExpired = true;
	private boolean accountNonLocked = true;
	private boolean credentialsNonExpired = true;
	private boolean enabled = true;
	
	private String mb_id;
	private String mb_nm;
	
	private String user_id; // uuid
	private String user_nm;
	private String user_ip;
	
	private String login_typ;
	private String login_id;
	private String login_pw;
	private String simp_pw;
	
	private String emp_id;
	private String emp_no;
	private String org_id;
	private String org_nm;
	
	private String org_id_path;
	private String org_nm_path;
	
	private String cust_id;
	private String cust_nm;	
	
	private String email;
	private String tel_no;
	private String mob_no;
	
	private String role_id;
	
	private String devc_typ;
	private String devc_id;
	
	private String app_ver;

	public Collection<? extends GrantedAuthority> getAuthorities() { return this.authorities; } 
	
	public void setAuthorities(List<Role> authorities) { this.authorities = authorities; } 
	
	public boolean isAccountNonExpired() { return this.accountNonExpired; } 
	
	public void setAccountNonExpired(boolean accountNonExpired) { this.accountNonExpired = accountNonExpired; } 
	
	public boolean isAccountNonLocked() { return this.accountNonLocked; } 
	
	public void setAccountNonLocked(boolean accountNonLocked) { this.accountNonLocked = accountNonLocked; }
	
	public boolean isCredentialsNonExpired() { return this.credentialsNonExpired; } 
	
	public void setCredentialsNonExpired(boolean credentialsNonExpired) { this.credentialsNonExpired = credentialsNonExpired; } 
	
	public boolean isEnabled() { return this.enabled; } 
	
	public void setEnabled(boolean enabled) { this.enabled = enabled; }

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getMb_id() {
		return mb_id;
	}

	public void setMb_id(String mb_id) {
		this.mb_id = mb_id;
	}

	public String getMb_nm() {
		return mb_nm;
	}

	public void setMb_nm(String mb_nm) {
		this.mb_nm = mb_nm;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getUser_nm() {
		return user_nm;
	}

	public void setUser_nm(String user_nm) {
		this.user_nm = user_nm;
	}
	
	public String getUser_ip() {
		return user_ip;
	}

	public void setUser_ip(String user_ip) {
		this.user_ip = user_ip;
	}

	public String getLogin_typ() {
		return login_typ;
	}

	public void setLogin_typ(String login_typ) {
		this.login_typ = login_typ;
	}

	public String getLogin_id() {
		return login_id;
	}

	public void setLogin_id(String login_id) {
		this.login_id = login_id;
		this.username = login_id;
	}

	public String getLogin_pw() {
		return login_pw;
	}

	public void setLogin_pw(String login_pw) {
		this.login_pw = login_pw;
		this.password = login_pw;
	}

	public String getSimp_pw() {
		return simp_pw;
	}

	public void setSimp_pw(String simp_pw) {
		this.simp_pw = simp_pw;
	}

	public String getEmp_id() {
		return emp_id;
	}

	public void setEmp_id(String emp_id) {
		this.emp_id = emp_id;
	}

	public String getEmp_no() {
		return emp_no;
	}

	public void setEmp_no(String emp_no) {
		this.emp_no = emp_no;
	}

	public String getOrg_id() {
		return org_id;
	}

	public void setOrg_id(String org_id) {
		this.org_id = org_id;
	}

	public String getOrg_nm() {
		return org_nm;
	}

	public void setOrg_nm(String org_nm) {
		this.org_nm = org_nm;
	}
	
	public String getOrg_id_path() {
		return org_id_path;
	}

	public void setOrg_id_path(String org_id_path) {
		this.org_id_path = org_id_path;
	}

	public String getOrg_nm_path() {
		return org_nm_path;
	}

	public void setOrg_nm_path(String org_nm_path) {
		this.org_nm_path = org_nm_path;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTel_no() {
		return tel_no;
	}

	public void setTel_no(String tel_no) {
		this.tel_no = tel_no;
	}

	public String getMob_no() {
		return mob_no;
	}

	public void setMob_no(String mob_no) {
		this.mob_no = mob_no;
	}

	public String getCust_id() {
		return cust_id;
	}

	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}

	public String getCust_nm() {
		return cust_nm;
	}

	public void setCust_nm(String cust_nm) {
		this.cust_nm = cust_nm;
	}

	public String getDevc_typ() {
		return devc_typ;
	}

	public void setDevc_typ(String devc_typ) {
		this.devc_typ = devc_typ;
	}

	public String getDevc_id() {
		return devc_id;
	}

	public void setDevc_id(String devc_id) {
		this.devc_id = devc_id;
	}

	public String getApp_ver() {
		return app_ver;
	}

	public void setApp_ver(String app_ver) {
		this.app_ver = app_ver;
	}

	public String getRole_id() {
		return role_id;
	}

	public void setRole_id(String role_id) {
		this.role_id = role_id;
	}
	
	
}
