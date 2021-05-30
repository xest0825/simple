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
 *   커스텀 테그  서브스트링 + ...
 *   @author kihon
 *   
 */
public class CutStringByLength extends BodyTagSupport {
	private static final long serialVersionUID = -694552415934133968L;
	
	private static final Logger logger = LoggerFactory.getLogger(CutStringByLength.class);
	
	private int length;				// 글자 길이
    private String extraString;		// default ...
    
	/**
	 * @param length
	 */
	public void setLength(int length) {
		this.length = length;
	}

	/**
	 * @param extraString
	 */
	public void setExtraString(String extraString) {
		this.extraString = extraString;
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
    	
    	if(length > 0 && content.length() > length) {
    		content = content.substring(0, length);
    		
    		if(extraString != null) {
    			content = content + extraString;
    		} else {
    			content = content + "...";
    		}
    	}
    	
    	content = CommUtil.strToCode(content);
    	
    	try {
    		bodyContent.getEnclosingWriter().write(content);
    	} catch(IOException e) {
    		logger.error(e.getMessage());
    		throw new JspException(e);
    	}
    	
    	length = 0;
    	extraString = null;
    	
    	return EVAL_PAGE;
    }
}