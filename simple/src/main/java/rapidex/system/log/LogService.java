package rapidex.system.log;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import rapidex.base.BaseService;

@Service(value = "LogService")
public class LogService extends BaseService {
	private static final Logger logger = LoggerFactory.getLogger(LogService.class);

	public int insertConnectionLog(HashMap<String, String> paramap) {
		return getLogDAO().insertConnectionLog(paramap);
	}

	public int insertLoginLog(HashMap<String, String> paramap) {
		return getLogDAO().insertLoginLog(paramap);
	}

	public int insertAppLoginLog(HashMap<String, String> paramap) {
		return getLogDAO().insertAppLoginLog(paramap);
	}

	public int insertActionLog(HashMap<String, String> paramap) {
		return getLogDAO().insertActionLog(paramap);
	}

	public int insertErrorLog(HashMap<String, String> paramap) {
		return getLogDAO().insertErrorLog(paramap);
	}
}
