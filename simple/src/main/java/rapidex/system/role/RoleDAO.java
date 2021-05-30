package rapidex.system.role;

import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import rapidex.base.BaseDAO;
import rapidex.system.security.model.Role;

@Repository(value="RoleDAO")
public class RoleDAO extends BaseDAO {
	private static final Logger logger = LoggerFactory.getLogger(RoleDAO.class);
	
	public List<Role> getRoleList(HashMap<String, String> paramap){
		logger.debug("RoleDAO.getRoleList()");
		return getSqlSession().selectList(getRolemapper()+ "getRoleList", paramap);
	}

}
