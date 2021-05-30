package rapidex.common.taglib;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import rapidex.common.util.CommUtil;

/**
 * 
 *  커스텀 테그 포멧
 *  @author kihon
 *  
 */
public class Format extends BodyTagSupport {

	
	private static final long serialVersionUID = 1L;

	private static final Logger logger = LoggerFactory.getLogger(Format.class);
	
	private String formattype;		// format type

	public String getFormattype() {
		return formattype;
	}

	public void setFormattype(String formattype) {
		this.formattype = formattype;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
        return EVAL_BODY_BUFFERED;
    }
    
    /* (non-Javadoc)
     * @see javax.servlet.jsp.tagext.BodyTagSupport#doEndTag()
     */
    @Override
	public int doEndTag() throws JspException {
    	
    	BodyContent bodyContent = getBodyContent();
    	String content = bodyContent.getString();
    	content = CommUtil.codeToStr(content);
        content= content.trim();
        
    	//휴대전화
    	if("MOBILE".equals(formattype)){
    	  	
    		if(content.length() >= 11){
        		content =  content.substring(0,3) + "-" 
        				 + content.substring(3,7) + "-" 
        				 + content.substring(7,11); 
        	}
    	//생년월일	
    	}else if("BIRTHDAY".equals(formattype)){
    			
    		if(content.length() >= 8){
        		content =  content.substring(0,4) + "년" 
        				 + content.substring(4,6) + "월" 
        				 + content.substring(6,8) + "일"; 
        	}
    	}else if("DATETIME".equals(formattype)){
			
			if(content.length() >= 8){
	    		content =  content.substring(0,4) + "-" 
	    				 + content.substring(4,6) + "-" 
	    				 + content.substring(6,8) + "-"; 
	    	}
		}else if("COM_YM".equals(formattype)){
			
			if(content.length() >= 6){
	    		content =  content.substring(0,4) + "년" 
	    				 + content.substring(4,6) + "월"; 
	    	}
		}    	
	    	
    	content = CommUtil.strToCode(content);
    	
    	try{
    		bodyContent.getEnclosingWriter().write(content);
    	}catch(IOException e){
    		logger.error(e.getMessage());
    		throw new JspException(e);
    	}
    	return EVAL_PAGE;
    }
}
