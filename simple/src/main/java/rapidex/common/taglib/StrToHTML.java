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
 *  문자형 테그를 html 테그로 변환한다
 *  @author kihon
 *  
 */
public class StrToHTML extends BodyTagSupport {

	private static final long serialVersionUID = -8031628491034630909L;

	private static final Logger logger = LoggerFactory.getLogger(StrToHTML.class);
	
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
    	logger.debug("StrToHTML.doEndTag");
    	BodyContent bodyContent = getBodyContent();
    	String content = bodyContent.getString();
    	
    	content = StringUtils.defaultString(content).replaceAll("<", "&lt;")
    												.replaceAll(">", "&gt;")
    												.replaceAll("\r\n", "<br/>")
    												.replaceAll("\n", "<br/>")
    												.replaceAll(" ", "&nbsp;");
    	
    	try {
    		bodyContent.getEnclosingWriter().write(content);
    	} catch(IOException e) {
    		logger.error(e.getMessage());
    		throw new JspException(e);
    	}
    	
    	return EVAL_PAGE;
    }
}
