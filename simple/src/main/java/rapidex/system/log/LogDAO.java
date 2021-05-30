package rapidex.system.log;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import rapidex.base.BaseDAO;

@Repository(value = "LogDAO")
public class LogDAO extends BaseDAO {
	
	private static final Logger logger = LoggerFactory.getLogger(LogDAO.class);
	
	
	public int insertConnectionLog(HashMap<String, String> paramap) {
		return getSqlSession().insert(getLogmapper() + "insertConnectionLog", paramap);
	}
	
	public int insertLoginLog(HashMap<String, String> paramap) {
		return getSqlSession().insert(getLogmapper() + "insertLoginLog", paramap);
	}
	
	public int insertAppLoginLog(HashMap<String, String> paramap) {
		return getSqlSession().insert(getLogmapper() + "insertAppLoginLog", paramap);
	}
	
	public int insertActionLog(HashMap<String, String> paramap) {
		return getSqlSession().insert(getLogmapper() + "insertActionLog", paramap);
	}
	
	public int insertErrorLog(HashMap<String, String> paramap) {
		return getSqlSession().insert(getLogmapper() + "insertErrorLog", paramap);
	}

}
