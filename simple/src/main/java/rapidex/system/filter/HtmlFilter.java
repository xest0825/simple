package rapidex.system.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HtmlFilter implements Filter {
	private static final Logger logger = LoggerFactory.getLogger(HtmlFilter.class);
	private FilterConfig config;
	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		logger.debug("HtmlFilter.doFilter");
		//HttpServletResponse response = (HttpServletResponse) res;
		//response.setHeader("X-Frame-Options", "SAMEORIGIN");
		HttpServletRequest request = (HttpServletRequest) req;
		System.out.println(" &&& " + request.getRequestURI());
		
		chain.doFilter(new HTMLTagFilterRequestWrapper((HttpServletRequest)req), res);
	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		this.config = config;
	}

}
