package rapidex.system.esapi;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.owasp.esapi.ESAPI;
import org.owasp.esapi.SecurityConfiguration;
import org.owasp.esapi.errors.AccessControlException;
import org.owasp.esapi.errors.ValidationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import rapidex.system.esapi.OwaspValidationException;
import rapidex.common.util.HttpUtils;

/**
*
 *
 */
public class EsapiSecurityWrapperRequest extends HttpServletRequestWrapper implements HttpServletRequest {

	private static final Logger LOGGER = LoggerFactory.getLogger(EsapiSecurityWrapperRequest.class);

	protected boolean isPassMode = false;

	protected HttpServletRequest request;

	protected Pattern skipParamNamePattern;

	/**
	 * 
	 * Construct a safe request that overrides the default request methods with
	 * 
	 * safer versions.
	 *
	 * 
	 * 
	 * @param request The {@code HttpServletRequest} we are wrapping.
	 * 
	 */

	public EsapiSecurityWrapperRequest(HttpServletRequest request) {

		super(request);

		this.request = request;

	}

	public boolean isPassMode() {

		return isPassMode;

	}

	public void setPassMode(boolean isPassMode) {

		this.isPassMode = isPassMode;

	}

	public Pattern getSkipParamNamePattern() {

		return skipParamNamePattern;

	}

	public void setSkipParamNamePattern(Pattern skipParamNamePattern) {

		this.skipParamNamePattern = skipParamNamePattern;

	}

	/**
	 * 
	 * Returns the context path from the HttpServletRequest after canonicalizing
	 * 
	 * and filtering out any dangerous characters.
	 * 
	 * @return The context path for this {@code HttpServletRequest}
	 * 
	 */

	@Override

	public String getContextPath() {

		String path = this.request.getContextPath();

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		// Return empty String for the ROOT context

		if (path == null || "".equals(path.trim()))
			return "";

		String clean = "";

		try {

			clean = ESAPI.validator().getValidInput("HTTP context path: " + path, path, "HTTPContextPath",
					sc.getIntProp("HttpUtilities.contextPathLength"), false);

		} catch (ValidationException e) {

			if (isPassMode) {

				return path;

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns the array of Cookies from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @return An array of {@code Cookie}s for this {@code HttpServletRequest}
	 * 
	 */

	@Override

	public Cookie[] getCookies() {

		Cookie[] cookies = this.request.getCookies();

		try {

			List<Cookie> newCookies = new ArrayList<Cookie>();

			if (cookies == null)
				return new Cookie[0];

			SecurityConfiguration sc = ESAPI.securityConfiguration();

			for (Cookie c : cookies) {

				// build a new clean cookie

				// get data from original cookie

				String name = ESAPI.validator().getValidInput("Cookie name: " + c.getName(), c.getName(),
						"HTTPCookieName", sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), true);

				String value = ESAPI.validator().getValidInput("Cookie value: " + c.getValue(), c.getValue(),
						"HTTPCookieValue", sc.getIntProp("HttpUtilities.MaxHeaderValueSize"), true);

				int maxAge = c.getMaxAge();

				String domain = c.getDomain();

				String path = c.getPath();

				Cookie n = new Cookie(name, value);

				n.setMaxAge(maxAge);

				if (domain != null) {

					// HTTPHeaderValue seems way too liberal of a regex for cookie domain

					// as it allows invalid characters for a domain name. Maybe create a new custom

					// HTTPCookieDomain regex???

					n.setDomain(ESAPI.validator().getValidInput("Cookie domain: " + domain, domain, "HTTPHeaderValue",
							sc.getIntProp("HttpUtilities.MaxHeaderValueSize"), false));

				}

				if (path != null) {

					// OPEN ISSUE: Would not HTTPServletPath make more sense here???

					n.setPath(ESAPI.validator().getValidInput("Cookie path: " + path, path, "HTTPHeaderValue",
							sc.getIntProp("HttpUtilities.MaxHeaderValueSize"), false));

				}

				newCookies.add(n);

			}

			return newCookies.toArray(new Cookie[newCookies.size()]);

		} catch (ValidationException e) {

			if (isPassMode) {

				return cookies;

			} else {

				throw new OwaspValidationException(e);

			}

		}

	}

	/**
	 * 
	 * Returns the named header from the HttpServletRequest after canonicalizing
	 * 
	 * and filtering out any dangerous characters.
	 * 
	 * @param name The name of an HTTP request header
	 * 
	 * @return The specified header value is returned.
	 * 
	 */

	@Override

	public String getHeader(String name) {

		String value = this.request.getHeader(name);

		String clean = "";

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		try {

			clean = ESAPI.validator().getValidInput("HTTP header value: " + value, value, "HTTPHeaderValue",
					sc.getIntProp("HttpUtilities.MaxHeaderValueSize"), true);

		} catch (ValidationException e) {

			if (isPassMode) {

				return super.getHeader(name);

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns the enumeration of header names from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @return An {@code Enumeration} of header names associated with this request.
	 * 
	 */

	@Override

	public Enumeration<String> getHeaderNames() {

		Vector<String> v = new Vector<String>();

		Enumeration<String> en = this.request.getHeaderNames();

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		while (en.hasMoreElements()) {

			try {

				String name = (String) en.nextElement();

				String clean = ESAPI.validator().getValidInput("HTTP header name: " + name, name, "HTTPHeaderName",
						sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), true);

				v.add(clean);

			} catch (ValidationException e) {

				if (isPassMode) {

					return this.request.getHeaderNames();

				} else {

					throw new OwaspValidationException(e);

				}

			}

		}

		return v.elements();

	}

	/**
	 * 
	 * Returns the enumeration of headers from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @param name The name of an HTTP request header.
	 * 
	 * @return An {@code Enumeration} of headers from the request after
	 * 
	 *         canonicalizing and filtering has been performed.
	 * 
	 */

	@Override

	public Enumeration<String> getHeaders(String name) {

		Vector<String> v = new Vector<String>();

		Enumeration<String> en = this.request.getHeaders(name);

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		while (en.hasMoreElements()) {

			try {

				String value = (String) en.nextElement();

				String clean = ESAPI.validator().getValidInput("HTTP header value (" + name + "): " + value, value,
						"HTTPHeaderValue", sc.getIntProp("HttpUtilities.MaxHeaderValueSize"), true);

				v.add(clean);

			} catch (ValidationException e) {

				if (isPassMode) {

					return this.request.getHeaders(name);

				} else {

					throw new OwaspValidationException(e);

				}

			}

		}

		return v.elements();

	}

	/**
	 * 
	 * Returns the named parameter from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @param name The parameter name for the request
	 * 
	 * @return The "scrubbed" parameter value.
	 * 
	 */

	@Override

	public String getParameter(String name) {

		return getParameter(name, true);

	}

	/**
	 * 
	 * Returns the named parameter from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @param name      The parameter name for the request
	 * 
	 * @param allowNull Whether null values are allowed
	 * 
	 * @return The "scrubbed" parameter value.
	 * 
	 */

	public String getParameter(String name, boolean allowNull) {

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		return getParameter(name, allowNull, sc.getIntProp("HttpUtilities.httpQueryParamValueLength"),
				"HTTPParameterValue");

	}

	/**
	 * 
	 * Returns the named parameter from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @param name      The parameter name for the request
	 * 
	 * @param allowNull Whether null values are allowed
	 * 
	 * @param maxLength The maximum length allowed
	 * 
	 * @return The "scrubbed" parameter value.
	 * 
	 */

	public String getParameter(String name, boolean allowNull, int maxLength) {

		return getParameter(name, allowNull, maxLength, "HTTPParameterValue");

	}

	/**
	 * 
	 * Returns the named parameter from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @param name      The parameter name for the request
	 * 
	 * @param allowNull Whether null values are allowed
	 * 
	 * @param maxLength The maximum length allowed
	 * 
	 * @param regexName The name of the regex mapped from ESAPI.properties
	 * 
	 * @return The "scrubbed" parameter value.
	 * 
	 */

	public String getParameter(String name, boolean allowNull, int maxLength, String regexName) {

		String orig = this.request.getParameter(name);

		String clean = null;

		try {

			if (this.skipParamNamePattern != null && this.skipParamNamePattern.matcher(name).find()) {

				return orig;

			}

			clean = ESAPI.validator().getValidInput("HTTP parameter name: " + name, orig, regexName, maxLength,
					allowNull);

		} catch (ValidationException e) {

			if (isPassMode) {

				return orig;

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns the parameter map from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @return A {@code Map} containing scrubbed parameter names / value pairs.
	 * 
	 */

	@Override

	public Map<String, String[]> getParameterMap() {

		Map<String, String[]> map = this.request.getParameterMap();

		Map<String, String[]> cleanMap = new HashMap<String, String[]>();

		for (Object o : map.entrySet()) {

			try {

				@SuppressWarnings("rawtypes")

				Map.Entry e = (Map.Entry) o;

				String name = (String) e.getKey();

				SecurityConfiguration sc = ESAPI.securityConfiguration();

				String cleanName = ESAPI.validator().getValidInput("HTTP parameter name: " + name, name,
						"HTTPParameterName", sc.getIntProp("HttpUtilities.httpQueryParamNameLength"), true);

				String[] value = (String[]) e.getValue();

				String[] cleanValues = new String[value.length];

				for (int j = 0; j < value.length; j++) {

					if (this.skipParamNamePattern != null && this.skipParamNamePattern.matcher(cleanName).find()) {

						cleanValues[j] = value[j];

					} else {

						String cleanValue = ESAPI.validator().getValidInput("HTTP parameter value: " + value[j],
								value[j], "HTTPParameterValue",
								sc.getIntProp("HttpUtilities.httpQueryParamValueLength"), true);

						cleanValues[j] = cleanValue;

					}

				}

				cleanMap.put(cleanName, cleanValues);

			} catch (ValidationException e) {

				if (isPassMode) {

					return map;

				} else {

					throw new OwaspValidationException(e);

				}

			}

		}

		return cleanMap;

	}

	/**
	 * 
	 * Returns the enumeration of parameter names from the HttpServletRequest
	 * 
	 * after canonicalizing and filtering out any dangerous characters.
	 * 
	 * @return An {@code Enumeration} of properly "scrubbed" parameter names..
	 * 
	 */

	@Override

	public Enumeration<String> getParameterNames() {

		Vector<String> v = new Vector<String>();

		Enumeration<String> en = this.request.getParameterNames();

		while (en.hasMoreElements()) {

			try {

				SecurityConfiguration sc = ESAPI.securityConfiguration();

				String name = (String) en.nextElement();

				String clean = ESAPI.validator().getValidInput("HTTP parameter name: " + name, name,
						"HTTPParameterName", sc.getIntProp("HttpUtilities.httpQueryParamNameLength"), true);

				v.add(clean);

			} catch (ValidationException e) {

				if (isPassMode) {

					return this.request.getParameterNames();

				} else {

					throw new OwaspValidationException(e);

				}

			}

		}

		return v.elements();

	}

	/**
	 * 
	 * Returns the array of matching parameter values from the
	 * 
	 * HttpServletRequest after canonicalizing and filtering out any dangerous
	 * 
	 * characters.
	 * 
	 * @param name The parameter name
	 * 
	 * @return An array of matching "scrubbed" parameter values or
	 * 
	 *         <code>null</code> if the parameter does not exist.
	 * 
	 */

	@Override

	public String[] getParameterValues(String name) {

		String[] values = this.request.getParameterValues(name);

		List<String> newValues;

		if (values == null) {

			return null;

		}

		if (this.skipParamNamePattern != null && this.skipParamNamePattern.matcher(name).find()) {

			return values;

		}

		newValues = new ArrayList<String>();

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		for (String value : values) {

			try {

				if (value != null && "".equals(value)) {

					newValues.add("");

				} else {

					String cleanValue = ESAPI.validator().getValidInput("HTTP parameter value: " + value, value,
							"HTTPParameterValue", sc.getIntProp("HttpUtilities.httpQueryParamValueLength"), true);

					newValues.add(cleanValue);

				}

			} catch (ValidationException e) {

				if (isPassMode) {

					return values;

				} else {

					throw new OwaspValidationException(e);

				}

			}

		}

		return newValues.toArray(new String[newValues.size()]);

	}

	/**
	 * 
	 * Returns the path info from the HttpServletRequest after canonicalizing
	 * 
	 * and filtering out any dangerous characters.
	 * 
	 * @return Returns any extra path information, appropriately scrubbed,
	 * 
	 *         associated with the URL the client sent when it made this request.
	 * 
	 */

	@Override

	public String getPathInfo() {

		String path = this.request.getPathInfo();

		if (path == null)
			return null;

		String clean = "";

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		try {

			clean = ESAPI.validator().getValidInput("HTTP path: " + path, path, "HTTPPath",
					sc.getIntProp("HttpUtilities.HTTPPATHLENGTH"), true);

		} catch (ValidationException e) {

			if (isPassMode) {

				return path;

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns the query string from the HttpServletRequest after canonicalizing
	 * 
	 * and filtering out any dangerous characters.
	 * 
	 * @return The scrubbed query string is returned.
	 * 
	 */

	@Override

	public String getQueryString() {

		String query = this.request.getQueryString();

		return query;

		// getQueryString의 경우 Filter에서도 자주 사용할수 있는데 만약 get형식의 parameter에 문제가 있다면
		// Filter에서 오류가 발생하여

		// Controller까지 도달하지 못해 ControllerAdvice를 사용할 수 없음. queryString을 체크하지 않아도
		// getParameter에서 체크하므로 esapi기능을 스킵

		/*
		 * 
		 * if(!StringUtils.hasLength(query)) {
		 * 
		 * return query;
		 * 
		 * }
		 * 
		 * 
		 * 
		 * String clean = "";
		 * 
		 * try {
		 * 
		 * //decode를 해주지 않으면 url인코딩되어 들어온 값을 검증 할 수 없다.
		 * 
		 * query = URLDecoder.decode(query, this..request.getCharacterEncoding());
		 * 
		 * SecurityConfiguration sc = ESAPI.securityConfiguration();
		 * 
		 * clean = ESAPI.validator().getValidInput("HTTP query string: " + query, query,
		 * "HTTPQueryString", sc.getIntProp("HttpUtilities.URILENGTH"), true);
		 * 
		 * } catch (ValidationException e) {
		 * 
		 * if(isPassMode) {
		 * 
		 * return query;
		 * 
		 * }else {
		 * 
		 * throw new OwaspValidationException(e);
		 * 
		 * }
		 * 
		 * } catch (UnsupportedEncodingException e) {
		 * 
		 * if(isPassMode) {
		 * 
		 * return query;
		 * 
		 * }else {
		 * 
		 * throw new OwaspValidationException(e);
		 * 
		 * }
		 * 
		 * }
		 * 
		 * return clean;
		 * 
		 */

	}

	/**
	 * 
	 * Returns the URI from the HttpServletRequest after canonicalizing and
	 * 
	 * filtering out any dangerous characters. Code must be very careful not to
	 * 
	 * depend on the value of a requested session id reported by the user.
	 * 
	 * @return The requested Session ID
	 * 
	 */

	@Override

	public String getRequestedSessionId() {

		String id = this.request.getRequestedSessionId();

		String clean = "";

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		try {

			clean = ESAPI.validator().getValidInput("Requested cookie: " + id, id, "HTTPJSESSIONID",
					sc.getIntProp("HttpUtilities.HTTPJSESSIONIDLENGTH"), false);

		} catch (ValidationException e) {

			if (isPassMode) {

				return id;

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns the URI from the HttpServletRequest after canonicalizing and
	 * 
	 * filtering out any dangerous characters.
	 * 
	 * @return The current request URI
	 * 
	 */

	@Override

	public String getRequestURI() {

		String uri = this.request.getRequestURI();

		String clean = "";

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		try {

			clean = ESAPI.validator().getValidInput("HTTP URI: " + uri, uri, "HTTPURI",
					sc.getIntProp("HttpUtilities.URILENGTH"), false);

		} catch (ValidationException e) {

			if (isPassMode) {

				return uri;

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns the URL from the HttpServletRequest after canonicalizing and
	 * 
	 * filtering out any dangerous characters.
	 * 
	 * @return The currect request URL
	 * 
	 */

	@Override

	public StringBuffer getRequestURL() {

		String url = this.request.getRequestURL().toString();

		String clean = "";

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		try {

			clean = ESAPI.validator().getValidInput("HTTP URL: " + url, url, "HTTPURL",
					sc.getIntProp("HttpUtilities.URILENGTH"), false);

		} catch (ValidationException e) {

			if (isPassMode) {

				return this.request.getRequestURL();

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return new StringBuffer(clean);

	}

	/**
	 * 
	 * Returns the scheme from the HttpServletRequest after canonicalizing and
	 * 
	 * filtering out any dangerous characters.
	 * 
	 * @return The scheme of the current request
	 * 
	 */

	@Override

	public String getScheme() {

		String scheme = this.request.getScheme();

		String clean = "";

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		try {

			clean = ESAPI.validator().getValidInput("HTTP scheme: " + scheme, scheme, "HTTPScheme",
					sc.getIntProp("HttpUtilities.HTTPSCHEMELENGTH"), false);

		} catch (ValidationException e) {

			if (isPassMode) {

				return scheme;

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns the server name (host header) from the HttpServletRequest after
	 * 
	 * canonicalizing and filtering out any dangerous characters.
	 * 
	 * @return The local server name
	 * 
	 */

	@Override

	public String getServerName() {

		String name = this.request.getServerName();

		String clean = "";

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		try {

			clean = ESAPI.validator().getValidInput("HTTP server name: " + name, name, "HTTPServerName",
					sc.getIntProp("HttpUtilities.HTTPHOSTLENGTH"), false);

		} catch (ValidationException e) {

			if (isPassMode) {

				return name;

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns the server port (after the : in the host header) from the
	 * 
	 * HttpServletRequest after parsing and checking the range 0-65536.
	 * 
	 * @return The local server port
	 * 
	 */

	@Override

	public int getServerPort() {

		int port = this.request.getServerPort();

		if (port < 0 || port > 0xFFFF) {

			port = 0;

		}

		return port;

	}

	/**
	 * 
	 * Returns the server path from the HttpServletRequest after canonicalizing
	 * 
	 * and filtering out any dangerous characters.
	 * 
	 * @return The servlet path
	 * 
	 */

	@Override

	public String getServletPath() {

		String path = this.request.getServletPath();

		if (path == null || "".equals(path)) {

			return path;

		}

		String clean = "";

		SecurityConfiguration sc = ESAPI.securityConfiguration();

		try {

			clean = ESAPI.validator().getValidInput("HTTP servlet path: " + path, path, "HTTPServletPath",
					sc.getIntProp("HttpUtilities.HTTPSERVLETPATHLENGTH"), false);

		} catch (ValidationException e) {

			if (isPassMode) {

				return path;

			} else {

				throw new OwaspValidationException(e);

			}

		}

		return clean;

	}

	/**
	 * 
	 * Returns a session, creating it if necessary, and sets the HttpOnly flag
	 * 
	 * on the Session ID cookie.
	 * 
	 * @return The current session
	 * 
	 */

	@Override

	public HttpSession getSession() {

		HttpSession session = this.request.getSession();

		// send a new cookie header with HttpOnly on first and second responses

		if (ESAPI.securityConfiguration().getBooleanProp("HttpUtilities.ForceHttpOnlySession")) {

			if (session.getAttribute("HTTP_ONLY") == null) {

				session.setAttribute("HTTP_ONLY", "set");

				Cookie cookie = new Cookie(
						ESAPI.securityConfiguration().getStringProp("HttpUtilities.HttpSessionIdName"),
						session.getId());

				cookie.setPath(this.request.getContextPath());

				cookie.setMaxAge(-1); // session cookie

				HttpServletResponse response = ESAPI.currentResponse();

				if (response != null) {

					ESAPI.currentResponse().addCookie(cookie);

				}

			}

		}

		return session;

	}

	/**
	 * 
	 * Returns a session, creating it if necessary, and sets the HttpOnly flag
	 * 
	 * on the Session ID cookie.
	 * 
	 * @param create Create a new session if one doesn't exist
	 * 
	 * @return The current session
	 * 
	 */

	@Override

	public HttpSession getSession(boolean create) {

		HttpSession session = this.request.getSession(create);

		if (session == null) {

			return null;

		}

		// send a new cookie header with HttpOnly on first and second responses

		if (ESAPI.securityConfiguration().getBooleanProp("HttpUtilities.ForceHttpOnlySession")) {

			if (session.getAttribute("HTTP_ONLY") == null) {

				session.setAttribute("HTTP_ONLY", "set");

				Cookie cookie = new Cookie(
						ESAPI.securityConfiguration().getStringProp("HttpUtilities.HttpSessionIdName"),
						session.getId());

				cookie.setMaxAge(-1); // session cookie

				cookie.setPath(this.request.getContextPath());

				HttpServletResponse response = ESAPI.currentResponse();

				if (response != null) {

					ESAPI.currentResponse().addCookie(cookie);

				}

			}

		}

		return session;

	}

	@Override

	public RequestDispatcher getRequestDispatcher(String path) {

		return super.getRequestDispatcher(path);

	}

}