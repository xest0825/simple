package rapidex.system.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import rapidex.system.jwt.JwtDAO;
import rapidex.system.jwt.JwtTokenUtil;
import rapidex.system.jwt.JwtVO;


@Component
public class JwtAuthenticationFilter implements Filter {
	private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);
	private static final String HEADER_AUTH = "Authorization";
	private JwtTokenUtil jwtTokenUtil = new JwtTokenUtil();
	private Pattern allowedMethods = Pattern.compile("^(GET|POST|DELETE|PUT)$");
	private Pattern allowedExceptionUrl = Pattern.compile("(\\/api/.*)"
														+ "");
	private Pattern allowedUrl = Pattern.compile("(\\/api/.*)"+ "");

	@Autowired
	private JwtDAO jwtDAO;
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException{}

	@Override
	public void destroy(){}
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException{
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String url = httpRequest.getRequestURI();
		String Method = httpRequest.getMethod();
		String token = httpRequest.getHeader(HEADER_AUTH);
		logger.debug("url="+url);
		logger.debug("Method="+Method);
		logger.debug("token="+token);
		try {
			
		if(allowedUrl.matcher(url).find()){//API 관련만 token 체크한다.
			logger.debug("");
			if(!allowedExceptionUrl.matcher(url).find()) {//예외 URL이 아닐경우
				if(allowedMethods.matcher(Method).matches()){
					Boolean isTokenExpired = jwtTokenUtil.isTokenExpired(token);
					if(token != null && isTokenExpired){// 토큰정보가 없거나 만료일 경우
						
						JwtVO jwtvo = new JwtVO();
						jwtvo.setToken(token);
//						int tokenCount = jwtDAO.selectTokenHistCheckCount(jwtvo);
						int tokenCount = 0;
						if(tokenCount > 0) {// 토큰정보가 DB에 없을 경우
							logger.debug("else OK");
							Map _jwt = new HashMap<String, String>();
							_jwt.put("parameterName", HEADER_AUTH);
							_jwt.put("token", token);
							request.setAttribute("_jwt", _jwt);
							
							chain.doFilter(request, response);
							//return;
						} else {
							logger.debug("SC_UNAUTHORIZED");
							httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED);
							return;
						}
					}else{
						logger.debug("SC_UNAUTHORIZED");
						httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED);
						return;
					}
					
				}else{
					logger.debug("SC_FORBIDDEN");
					httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
					return;
				}
			}else {
				chain.doFilter(request, response);
			}
		}else {
			chain.doFilter(request, response);
		}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


}
