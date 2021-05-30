package rapidex.system.security;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import rapidex.base.BaseDAO;
import rapidex.system.security.model.Role;
import rapidex.system.security.model.User;



@Repository("userDAO")
public class UserDAO extends BaseDAO {
	private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);
	
	public User getLoginUser(HashMap<String, String> paramap){
		logger.debug("UserDAO.getLoginUser");
		return getSqlSession().selectOne(getUsermapper()+"getLoginUser", paramap);
	}
	
	public List<Role> getRoleList(HashMap<String, String> paramap){
		logger.debug("UserDAO.getRoleList");
		List<Role> list = new ArrayList<Role>();
		return list;
		//return getSqlSession().selectList(getSpringsecuritymapper()+"SelectRolesHierarchyList", map);
	}
	
}