package rapidex.config;

import rapidex.config.Constants.LOGGING;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;

/**
 * 시스템 초기화 클래스이다. 서버 실행시 업로드경로설정등의 초기화 작업을 처리한다.
 * 
 * @author yoonsik
 *
 */
public class Startup {

	final static Logger logger = LoggerFactory.getLogger(Startup.class);

	@Value("#{globals['Globals.LoggerYN']}")
	private String LoggerYN;

	@Value("#{globals['Globals.PdfPath']}")
	private String PdfPath;

	public void init() {
		logger.debug("######################################");
		logger.debug("-Rapidex SMAPLE SYSTEM Starting -");
		logger.debug("######################################");
		logger.debug("-LOGGING = {}-", LoggerYN); // globals.properties에서 읽어옴.
		LoadInit();
		logger.debug("######################################");
		logger.debug("-Rapidex SAMPLE SYSTEM Started -");
		logger.debug("######################################");
	}

	private void LoadInit() {
		try {
			logger.debug("-----LoadInitData...-----");

			String[] wrPathArr = this.getClass().getResource("/").getPath().split("/");
			String wrPath = org.apache.commons.lang.StringUtils.join(wrPathArr, "/", 0, wrPathArr.length - 2);

			logger.debug("-Web Root Path = {}-", wrPath);
			Constants.setConstants(wrPath);
			if (LoggerYN.equals("N")) {
				Constants.QueryLogging = LOGGING.NOLOGGING;
			} else {
				Constants.QueryLogging = LOGGING.LOGGING;
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("######################################");
			logger.debug("-Rapidex SAMPLE SYSTEM Start Fail -");
			logger.debug("######################################");
		}
	}

}
