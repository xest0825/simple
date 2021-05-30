package rapidex.system.security;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.StandardPasswordEncoder;
import org.springframework.stereotype.Service;

import rapidex.system.security.model.Role;
import rapidex.system.security.model.User;


@Service("userService")
public class UserService{
	private static final Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private UserDAO userDAO;
	
	@Autowired
	StandardPasswordEncoder standardPasswordEncoder;
	
	
	public User getLoginUser(HashMap<String, String> paramap){
		logger.debug("UserService.getLoginUser");
		return userDAO.getLoginUser(paramap);
	}
	
	public List<Role> getRoleList(HashMap<String,String> paramap) {
		logger.debug("UserService.getRoleList");
		return userDAO.getRoleList(paramap);
	}
	
}
