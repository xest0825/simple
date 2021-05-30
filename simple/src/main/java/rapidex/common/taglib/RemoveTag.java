package rapidex.common.taglib;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 *  html 코드를 제거한다
 *  @author kihon
 *  
 */
public class RemoveTag extends BodyTagSupport {

	private static final long serialVersionUID = 8250091446710532324L;

	private static final Logger logger = LoggerFactory.getLogger(CutStringByLength.class);
	
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
    	
    	content = content.replace("&nbsp;", " ");
    	content = StringUtils.defaultString(content).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");	//태그제거
    	content = content.replaceAll("<!--[^>]*-->", "");	//주석제거
    	try {
    		bodyContent.getEnclosingWriter().write(content);
    	} catch(IOException e) {
    		logger.error(e.getMessage());
    		throw new JspException(e);
    	}
    	
    	return EVAL_PAGE;
    }
}
