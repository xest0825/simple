package rapidex.config;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * 시스템 전역 상수
 * @author SonJooArm
 *
 */
public class Constants {

	public enum UPLOADS{ROOT, UPLOAD_ROOT, FILE, TEMP};
	
	public enum LOGGING{LOGGING, NOLOGGING};
	
	public static LOGGING QueryLogging = LOGGING.LOGGING;
	
	private static  String WEB_ROOT_PATH = "";

	private static  String UPLOAD_ROOT_PATH = "";
	

    /** FILE_PATH */
	private static  String FILE_PATH = "";
	private static  String TEMP_FILE_PATH = "";

	private static final String UPLOAD_ROOT_URL = "/upload";
	private static final String DOWNLOAD_ROOT_URL = "/download";
	
	private static final String FILE_URL = UPLOAD_ROOT_URL + "/files/";
	
	private static final String TEMP_FILE_URL = UPLOAD_ROOT_URL + "/tempFiles/";

	
    public static void setConstants(String WebRootPath)
    {
    	Logger logger = LoggerFactory.getLogger(Constants.class);
    	logger.debug("-----Set Constants...-----");
    	
    	Constants.WEB_ROOT_PATH = WebRootPath;
    	
    	Constants.UPLOAD_ROOT_PATH = WebRootPath+Constants.UPLOAD_ROOT_URL;
        
    	/** FILE_PATH */
    	Constants.FILE_PATH = Constants.WEB_ROOT_PATH + Constants.FILE_URL;
        
    	/** TEMP_FILE_PATH */
    	Constants.TEMP_FILE_PATH = Constants.WEB_ROOT_PATH + Constants.TEMP_FILE_URL;

    	mkdir(Constants.UPLOAD_ROOT_PATH);
    	logger.debug("-Constants.UPLOAD_ROOT_PATH={}-",Constants.UPLOAD_ROOT_PATH);
    	
    	mkdir(Constants.FILE_PATH);
    	logger.debug("-Constants.FILE_PATH={}-",Constants.FILE_PATH);
    	
    	mkdir(Constants.TEMP_FILE_PATH);
    	logger.debug("-Constants.TEMP_FILE_PATH={}-",Constants.TEMP_FILE_PATH);
    }
    
    public static String getURL(UPLOADS u)
    {
    	String rtnURL = "";
    	switch(u)
    	{
    		case ROOT:
    			rtnURL = "/";
    			break;
    			
    		case UPLOAD_ROOT:
    			rtnURL = Constants.UPLOAD_ROOT_URL;
    			break;
    			
    		case FILE:
    			rtnURL = Constants.FILE_URL;
    			break;
    			
    		case TEMP:
    			rtnURL = Constants.TEMP_FILE_URL;
    			break;
    			
    		default:
    			rtnURL = "/";
    			break;
    	}
    	return rtnURL;
    }
    

    public static String getPATH(UPLOADS u)
    {
    	String rtnPATH = "";
    	switch(u)
    	{
    		case ROOT:
    			rtnPATH = Constants.WEB_ROOT_PATH;
    			break;
    			
    		case UPLOAD_ROOT:
    			rtnPATH = Constants.UPLOAD_ROOT_PATH;
    			break;
    			
    		case FILE:
    			rtnPATH = Constants.FILE_PATH;
    			break;
    			
    		case TEMP:
    			rtnPATH = Constants.TEMP_FILE_PATH;
    			break;
    			
    		default:
    			rtnPATH = Constants.WEB_ROOT_PATH;
    			break;
    	}
    	return rtnPATH;
    }
    
    private static void mkdir(String path)
    {
    	File upDir = new File(path);
    	if(!upDir.exists())//해당 디렉토리의 존재여부를 확인
    	{
    		upDir.mkdirs();//없다면 생성 
    	}
    }

    

}///~
