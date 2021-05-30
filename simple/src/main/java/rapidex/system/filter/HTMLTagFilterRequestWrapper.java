package rapidex.system.filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HTMLTagFilterRequestWrapper extends HttpServletRequestWrapper {
	private static final Logger logger = LoggerFactory.getLogger(HTMLTagFilterRequestWrapper.class);
	public HTMLTagFilterRequestWrapper(HttpServletRequest request) {
		super(request);
	}
	
	@Override
	public String getParameter(String parameter) {
		logger.debug("HTMLTagFilterRequestWrapper.getParameter");
		String value = super.getParameter(parameter);
		
		if( value == null ) {
			return null;
		}
		
		StringBuffer strBuff = new StringBuffer();
		for( int i=0; i<value.length(); i++) {
			char c = value.charAt(i);
			switch(c) {
			case '<':
				strBuff.append("<");
				break;
			case '>':
				strBuff.append(">");
				break;
			case '&':
				strBuff.append("&");
				break;
			case '"':
				strBuff.append("\"");
				break;
			case '\'':
				strBuff.append("'");
				break;
			default:
				strBuff.append(c);
				break;
			}
		}
		
		value = strBuff.toString();
		return value;
	}
	
	@Override
	public String[] getParameterValues(String parameter) {
		logger.debug("HTMLTagFilterRequestWrapper.getParameterValues");
		String[] values = super.getParameterValues(parameter);
		
		if( values == null ) {
			return null;
		}
		
		for(int i=0; i<values.length; i++) {
			if( values[i] != null ) {
				StringBuffer strBuff = new StringBuffer();
				for( int j=0; j<values[i].length(); j++) {
					char c = values[i].charAt(j);
					switch(c) {
					case '<':
						strBuff.append("<");
						break;
					case '>':
						strBuff.append(">");
						break;
					case '&':
						strBuff.append("&");
						break;
					case '"':
						strBuff.append("\"");
						break;
					case '\'':
						strBuff.append("'");
						break;
					default:
						strBuff.append(c);
						break;
					}
				}
				values[i] = strBuff.toString();
				
			} else {
				values[i] = null;
			}
		}
		
		return values;
		
	}
	
}
