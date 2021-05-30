package rapidex.base;

import org.springframework.beans.factory.annotation.Autowired;

import rapidex.system.jwt.JwtDAO;
//import rapidex.mobile.login.MobileLoginDAO;
import rapidex.system.log.LogDAO;
import rapidex.system.role.RoleDAO;
import rapidex.system.security.UserDAO;
//import rapidex.system.security.UserDAO;

public class BaseService {
	
	@Autowired
	private JwtDAO jwtDAO;
	
//	@Autowired
//	private MobileLoginDAO mobileLoginDAO;
	
	@Autowired
	private UserDAO userDAO;
	
	@Autowired
	private LogDAO logDAO;
	
	@Autowired
	private RoleDAO roleDAO;
	

	public JwtDAO getJwtDAO() {
		return jwtDAO;
	}

//	public MobileLoginDAO getMobileLoginDAO() {
//		return mobileLoginDAO;
//	}

	public UserDAO getUserDAO() {
		return userDAO;
	}

	public LogDAO getLogDAO() {
		return logDAO;
	}

	public RoleDAO getRoleDAO() {
		return roleDAO;
	}
	
	
}
