package rapidex.system.aop;
/*
 * Copyright GENEXON (c) 2013.
 */

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.sitemesh.webapp.contentfilter.HttpServletRequestFilterable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;

import rapidex.common.util.CommUtil;
import rapidex.config.Constants;
import rapidex.config.Constants.LOGGING;
import net.sf.json.JSONObject;

/**
 *
 * @author lws
 */
//@Aspect
public class aopAdapter {
	  
	private static final Logger logger = LoggerFactory.getLogger(aopAdapter.class);
	
//	@Autowired
//	private CommonService commonService;


	/**
	 * @param joinPoint
	 * @throws UnsupportedEncodingException
	 */
	@Before("execution(public * rapidex..*..*..*(..))")
	public void aopcheck(JoinPoint joinPoint) throws UnsupportedEncodingException , Exception {	
	// 메소드 실행전 실행
	    LOGGING qlog = Constants.QueryLogging;
	    Constants.QueryLogging = LOGGING.LOGGING; 
		
		logger.debug("========AOP=========");
		logger.debug("joinPoint.toString()");
		logger.debug(joinPoint.toString());
		logger.debug("## 시작 " + joinPoint.getTarget().getClass().getSimpleName() + " "+ joinPoint.getSignature().getName() + " ##");

		if (0 != joinPoint.getArgs().length) {
			// DefaultMultipartHttpServletRequest
			if ((joinPoint.getArgs()[0] instanceof HttpServletRequestFilterable)
					|| (joinPoint.getArgs()[0] instanceof DefaultMultipartHttpServletRequest)) {
				HttpServletRequest request = (HttpServletRequest) joinPoint
						.getArgs()[0];
				String url = request.getRequestURI();

				
			} // end if
		} // end if
		
		Constants.QueryLogging = qlog;
		logger.debug("");
	}
		
	
	
    /**
     * @param joinPoint
     */
    @After("execution(public * rapidex..*..*..*(..))")
    public void afterLogging(JoinPoint joinPoint) {
		// 메소드 실행후 실행
		logger.debug("## After!!!! {} {} ##", joinPoint.getTarget().getClass().getSimpleName() , joinPoint.getSignature().getName());
    }
	
	/**
	 * @param joinPoint
	 * @param ret
	 */
	@AfterReturning(pointcut = "execution(public * rapidex..*.*.*(..))", returning = "ret")
    public void returningLogging(JoinPoint joinPoint, Object ret) {
		// method 정상 실행후
 		logger.debug("## AfterReturning!!!! {}",  joinPoint.getSignature().getName());
    }
		    
    /**
     * @param joinPoint
     * @param ex
     */
    @AfterThrowing(pointcut = "execution(public * rapidex..*.*.*(..))", throwing = "ex")
    public void throwingLogging(JoinPoint joinPoint, Throwable ex){
    	// 예외 발생시 
		logger.error("## 에러 {} {} ##", joinPoint.getTarget().getClass().getSimpleName() , joinPoint.getSignature().getName());
        logger.error("## 메시지 : {}", ex.getMessage());		logger.error("");
    }
		    
		    


}