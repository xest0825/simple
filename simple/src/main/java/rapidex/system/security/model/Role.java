package rapidex.system.security.model;

import java.util.List;

import org.springframework.security.core.GrantedAuthority;

import rapidex.base.BaseVO;

//import io.swagger.annotations.ApiModelProperty;

public class Role extends BaseVO implements GrantedAuthority  {

	private static final long serialVersionUID = 7077755420106314539L;
	
//	@ApiModelProperty(value="권한명",allowEmptyValue=false,hidden=false)
	private String name;
	private List<Privilege> privileges;
	
	private String role_id;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<Privilege> getPrivileges() {
		return privileges;
	}
	public void setPrivileges(List<Privilege> privileges) {
		this.privileges = privileges;
	}

	//@Override
	public String getAuthority() {
		return this.name;
	}
	
	@Override
	public String toString() {
		return "Role [name=" + name + ", privileges=" + privileges + "]";
	}
	public String getRole_id() {
		return role_id;
	}
	public void setRole_id(String role_id) {
		this.role_id = role_id;
	}
	
}
