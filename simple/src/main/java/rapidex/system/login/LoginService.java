package rapidex.system.login;

import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import rapidex.base.BaseService;
import rapidex.system.security.model.User;
import rapidex.system.security.model.Role;

@Service(value = "LoginService")
public class LoginService extends BaseService{

	private static final Logger logger = LoggerFactory.getLogger(LoginService.class);
	
	public User getLoginAuthCheckedUser(LoginVO paramvo) {
		User user = new User();
		return user;
	}
	
	public User getLoginUser(HashMap<String, String> paramap) {
		return getUserDAO().getLoginUser(paramap);
	}
	
	public List<Role> getRoleList(HashMap<String, String> paramap){
		return getRoleDAO().getRoleList(paramap);
	}

}
