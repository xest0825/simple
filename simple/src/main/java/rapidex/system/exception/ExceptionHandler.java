package rapidex.system.exception;

import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;
import rapidex.config.Constants.LOGGING;
import rapidex.system.log.LogService;
import rapidex.system.security.CustomUserDetailsHelper;
import rapidex.system.security.model.User;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;


/**
 * ExceptionHandler 예외처리 ExceptionResolver
 * 
 * @author 
 */
public class ExceptionHandler extends SimpleMappingExceptionResolver {

	private static final Logger logger = LoggerFactory.getLogger(ExceptionHandler.class);

	@Autowired
	private LogService logService;

	@Override
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler,
			Exception ex) {

		StackTraceElement[] st = ex.getStackTrace();
		StringBuilder sb = new StringBuilder();

		for (int i = 0; i < st.length; i++) {
			sb.append(st[i]);
			sb.append("\n");

			if (i == 4)
				break;
		}

		logger.error("");
		logger.error("##########################");
		logger.error("#call  doResolveException#");
		logger.error("request.getRequestURI = {}", request.getRequestURI());
		logger.error("response.getStatus() = {}", response.getStatus());
		logger.error("ex.getClass()        = {}", ex.getClass());
		logger.error("ex.getMessage()      = {}", ex.getMessage());
		logger.error("ex.toString()        = {}", ex.toString());
		logger.error("StackTrace  = {}", sb.toString());
		logger.error("##########################");
		logger.error("");

		Map<String, String> map = new HashMap<String, String>();

		HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		Enumeration<?> param = req.getParameterNames();

		while (param.hasMoreElements()) {
			String name = (String) param.nextElement();
			logger.debug(name + " : " + request.getParameter(name));
			map.put(name.toLowerCase(), request.getParameter(name));
		}

		try {
			
			String uuid = "";
			User user = (User) CustomUserDetailsHelper.getAuthenticatedUser();
			if (user != null) {
				uuid = user.getUser_id();
			}

			HashMap<String, String> errMap = new HashMap<String, String>();
//			errMap.put("err_log_id", CommUtil.getUUIDExceptDash());
			errMap.put("err_sts", Integer.toString(response.getStatus()));
			errMap.put("err_cls", ex.getClass().toString());
			errMap.put("err_msg", ex.getMessage());
			errMap.put("err_trac", sb.toString());
			errMap.put("user_id", uuid);
			errMap.put("param", map.toString());
			LOGGING QueryLogging = rapidex.config.Constants.QueryLogging;
//
			logService.insertErrorLog(errMap);
			rapidex.config.Constants.QueryLogging = LOGGING.NOLOGGING;
			rapidex.config.Constants.QueryLogging = QueryLogging;

		} catch (Exception e1) {
			logger.error("error when insert error log");
			logger.error(e1.getMessage());
		}

		String exmsg = "";

		if (ex instanceof DuplicateKeyException) {
			exmsg = "중복된 데이타가 있습니다.";
		} else if (ex instanceof DataIntegrityViolationException) {
			DataIntegrityViolationException bEx = ((DataIntegrityViolationException) ex);

			logger.error("bEx.getErrorCode() = {}", bEx.getLocalizedMessage());

			exmsg = bEx.getLocalizedMessage();
			exmsg = exmsg.replaceAll("ORA", "<br/>ORA");

		} else if (ex instanceof UncategorizedSQLException) {
			SQLException bEx = ((UncategorizedSQLException) ex).getSQLException();

			logger.error("bEx.getErrorCode() = {}", bEx.getErrorCode());

			if (bEx.getErrorCode() > 20000) {
				exmsg = bEx.getMessage();
				exmsg = exmsg.substring(exmsg.indexOf(":") + 1, exmsg.indexOf("\n"));
			} else {
				exmsg = bEx.getMessage();
				exmsg = exmsg.substring(exmsg.indexOf(":") + 1, exmsg.indexOf("\n"));
			}
		} else if (ex instanceof SQLException) {
			SQLException sqlEx = (SQLException) ex;

			logger.error("sqlEx.getErrorCode() = {}", sqlEx.getErrorCode());
			if (sqlEx.getErrorCode() > 20000) {
				exmsg = sqlEx.getMessage();
				exmsg = exmsg.substring(exmsg.indexOf(":") + 1, exmsg.indexOf("\n"));
			} else {
				exmsg = sqlEx.getMessage();
				exmsg = exmsg.substring(exmsg.indexOf(":") + 1, exmsg.indexOf("\n"));
			}

		} else if (ex instanceof DataAccessException) {
			exmsg = "데이타 처리중 에러가 발생하였습니다.";
		} else if (ex instanceof NullPointerException) {
			exmsg = "필요 인자가 없어 에러가 발생하였습니다.";
		} else if (ex instanceof org.apache.poi.openxml4j.exceptions.InvalidFormatException) {
			exmsg = "xlsx 형식에 엑셀파일만 지원합니다.";
		} else {
			exmsg = ex.getMessage();
		}

		if (request.getRequestURI().toLowerCase().indexOf(".ajax") > 0) {

			JSONObject rtn = new JSONObject();
			rtn.element("errmsg", exmsg);

			try {

				return null;
			} catch (Exception e) {
				logger.error(exmsg);
			}

		} else {

			ModelAndView model = new ModelAndView();
			model.setViewName("comm/error");
			return model;
		}

		return null;
	}

}