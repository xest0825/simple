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
 *  커스텀 테그 바이트 기준(한글) 서브스트링 + ...
 *  
 */
public class CutStringByByte extends BodyTagSupport {
	private static final long serialVersionUID = 2455402603419267051L;
	
	private static final Logger logger = LoggerFactory.getLogger(CutStringByByte.class);
	
	private int length;				// byte 길이
    private String extraString;		// default ...
    private int charSize = 3;		// 한글 size
    
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
    	
    	char[] ch = content.toCharArray();
    	content = "";
    	int charLength = 0;
    	boolean isOver = false;
    	
    	for(int i = 0; i < ch.length; i++) {
    		if(ch[i] < 256) {
    			charLength++;
    		} else {
    			charLength = charLength + charSize;
    		}
    		
    		if(charLength > length) {
    			isOver = true;
    			break;
    		} 
    		
    		content += ch[i];
    	}
    	
    	if(isOver) {
    		if(extraString != null){
    			content = content + extraString;
    		}else{
    			content = content + "...";
    		}
    	}
    	
    	content = CommUtil.strToCode(content);
    	
    	try{
    		bodyContent.getEnclosingWriter().write(content);
    	}catch(IOException e){
    		logger.error(e.getMessage());
    		throw new JspException(e);
    	}
    	
    	length = 0;
    	extraString = null;
    	
    	return EVAL_PAGE;
    }
}
