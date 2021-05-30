package rapidex.system.esapi;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

import org.owasp.esapi.ESAPI;
import org.owasp.esapi.SecurityConfiguration;
import org.owasp.esapi.StringUtilities;
import org.owasp.esapi.errors.ValidationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This response wrapper simply overrides unsafe methods in the
 * HttpServletResponse API with safe versions.
 *
 */
public class EsapiSecurityWrapperResponse extends HttpServletResponseWrapper implements HttpServletResponse {

	private static final Logger LOGGER = LoggerFactory.getLogger(EsapiSecurityWrapperRequest.class);

	// modes are "log", "skip", "sanitize", "throw"

	private String mode = "log";

	private HttpServletResponse response;

	private boolean isPassMode = false;

	/**
	 * 
	 * Construct a safe response that overrides the default response methods
	 * 
	 * with safer versions. Default is 'log' mode.
	 *
	 * 
	 * 
	 * @param response
	 * 
	 */

	public EsapiSecurityWrapperResponse(HttpServletResponse response) {

		super(response);

		this.response = response;

	}

	/**
	 * 
	 * Construct a safe response that overrides the default response methods
	 * 
	 * with safer versions.
	 *
	 * 
	 * 
	 * @param response
	 * 
	 * @param mode     The mode for this wrapper. Legal modes are "log", "skip",
	 *                 "sanitize", "throw".
	 * 
	 */

	public EsapiSecurityWrapperResponse(HttpServletResponse response, String mode) {

		super(response);

		this.response = response;

		this.mode = mode;

	}

	public void setPassMode(boolean isPassMode) {

		this.isPassMode = isPassMode;

	}

	private HttpServletResponse getHttpServletResponse() {

		return (HttpServletResponse) super.getResponse();

	}

	/**

     * Add a cookie to the response after ensuring that there are no encoded or

     * illegal characters in the name and name and value. This method also sets

     * the secure and HttpOnly flags on the cookie. This implementation uses a

     * custom "set-cookie" header instead of using Java's cookie interface which

     * doesn't allow the use of HttpOnly.

     * @param cookie

     */

    public void addCookie(Cookie cookie) {

        String name = cookie.getName();

        String value = cookie.getValue();

        int maxAge = cookie.getMaxAge();

        String domain = cookie.getDomain();

        String path = cookie.getPath();

        boolean secure = cookie.getSecure();

        SecurityConfiguration sc = ESAPI.securityConfiguration();

 

        try {

            String cookieName = ESAPI.validator().getValidInput("cookie name", name, "HTTPCookieName", sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), false);

            String cookieValue = ESAPI.validator().getValidInput("cookie value", value, "HTTPCookieValue", sc.getIntProp("HttpUtilities.MaxHeaderValueSize"), false);

            String header = createCookieHeader(cookieName, cookieValue, maxAge, domain, path, secure);

            this.addHeader("Set-Cookie", header);

        }catch (ValidationException e) {

            if(isPassMode) {

                LOGGER.warn("[passMode]Attempt to add unsafe data to cookie denied.", e);

                response.addCookie(cookie);

            }else {

                throw new OwaspValidationException(e);

            }

        }

    }

	private String createCookieHeader(String name, String value, int maxAge, String domain, String path,
			boolean secure) {

		// create the special cookie header instead of creating a Java cookie

		// Set-Cookie:<name>=<value>[; <name>=<value>][; expires=<date>][;

		// domain=<domain_name>][; path=<some_path>][; secure][;HttpOnly

		String header = name + "=" + value;

		if (maxAge >= 0) {

			header += "; Max-Age=" + maxAge;

		}

		if (domain != null) {

			header += "; Domain=" + domain;

		}

		if (path != null) {

			header += "; Path=" + path;

		}

		if (secure || ESAPI.securityConfiguration().getBooleanProp("HttpUtilities.ForceSecureCookies")) {

			header += "; Secure";

		}

		if (ESAPI.securityConfiguration().getBooleanProp("HttpUtilities.ForceHttpOnlyCookies")) {

			header += "; HttpOnly";

		}

		return header;

	}

	/**
	 * 
	 * Add a cookie to the response after ensuring that there are no encoded or
	 * 
	 * illegal characters in the name.
	 * 
	 * @param name
	 * 
	 * @param date
	 * 
	 */

	public void addDateHeader(String name, long date) {

		try {

			SecurityConfiguration sc = ESAPI.securityConfiguration();

			String safeName = ESAPI.validator().getValidInput("safeSetDateHeader", name, "HTTPHeaderName",
					sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), false);

			getHttpServletResponse().addDateHeader(safeName, date);

		} catch (ValidationException e) {

			if (isPassMode) {

				LOGGER.warn("[passMode]Attempt to set invalid date header name denied.", e);

				response.addDateHeader(name, date);

			} else {

				throw new OwaspValidationException(e);

			}

		}

	}

	/**

     * Add a header to the response after ensuring that there are no encoded or

     * illegal characters in the name and name and value. This implementation

     * follows the following recommendation: "A recipient MAY replace any linear

     * white space with a single SP before interpreting the field value or

     * forwarding the message downstream."

     * http://www.w3.org/Protocols/rfc2616/rfc2616-sec2.html#sec2.2

     * @param name

     * @param value

     */

    public void addHeader(String name, String value) {

        try {

            SecurityConfiguration sc = ESAPI.securityConfiguration();

            String strippedName = StringUtilities.stripControls(name);

            String strippedValue = StringUtilities.stripControls(value);

            String safeName = ESAPI.validator().getValidInput("addHeader", strippedName, "HTTPHeaderName", sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), false);

            String safeValue = ESAPI.validator().getValidInput("addHeader", strippedValue, "HTTPHeaderValue", sc.getIntProp("HttpUtilities.MaxHeaderValueSize"), false);

            getHttpServletResponse().addHeader(safeName, safeValue);

        } catch (ValidationException e) {

            if(isPassMode) {

                LOGGER.warn("[passMode]Attempt to add invalid header denied.", e);

                response.addHeader(name, value);

            }else {

                throw new OwaspValidationException(e);

            }

        }

    }

	/**

     * Add an int header to the response after ensuring that there are no

     * encoded or illegal characters in the name and value.

     * @param name

     * @param value

     */

    public void addIntHeader(String name, int value) {

        try {

            SecurityConfiguration sc = ESAPI.securityConfiguration();

            String safeName = ESAPI.validator().getValidInput("addIntHeader", name, "HTTPHeaderName", sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), false);

            getHttpServletResponse().addIntHeader(safeName, value);

        } catch (ValidationException e) {

            if(isPassMode) {

                LOGGER.warn("[passMode]Attempt to set invalid int header name denied.", e);

                response.addIntHeader(name, value);

            }else {

                throw new OwaspValidationException(e);

            }

        }

    }

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @param name
	 * 
	 * @return True if the current response already contains a header of the
	 *         supplied name.
	 * 
	 */

	public boolean containsHeader(String name) {

		return getHttpServletResponse().containsHeader(name);

	}

	/**
	 * 
	 * Return the URL without any changes, to prevent disclosure of the
	 * 
	 * Session ID. The default implementation of this method can add the
	 * 
	 * Session ID to the URL if support for cookies is not detected. This
	 * 
	 * exposes the Session ID credential in bookmarks, referer headers, server
	 * 
	 * logs, and more.
	 *
	 * 
	 * 
	 * @param url
	 * 
	 * @return original url
	 * 
	 * @deprecated in servlet spec 2.1. Use
	 * 
	 *             {@link #encodeRedirectUrl(String)} instead.
	 * 
	 */

	@Deprecated

	public String encodeRedirectUrl(String url) {

		return url;

	}

	/**
	 * 
	 * Return the URL without any changes, to prevent disclosure of the
	 * 
	 * Session ID The default implementation of this method can add the
	 * 
	 * Session ID to the URL if support for cookies is not detected. This
	 * 
	 * exposes the Session ID credential in bookmarks, referer headers, server
	 * 
	 * logs, and more.
	 *
	 * 
	 * 
	 * @param url
	 * 
	 * @return original url
	 * 
	 */

	public String encodeRedirectURL(String url) {

		return url;

	}

	/**
	 * 
	 * Return the URL without any changes, to prevent disclosure of the
	 * 
	 * Session ID The default implementation of this method can add the
	 * 
	 * Session ID to the URL if support for cookies is not detected. This
	 * 
	 * exposes the Session ID credential in bookmarks, referer headers, server
	 * 
	 * logs, and more.
	 *
	 * 
	 * 
	 * @param url
	 * 
	 * @return original url
	 * 
	 * @deprecated in servlet spec 2.1. Use
	 * 
	 *             {@link #encodeURL(String)} instead.
	 * 
	 */

	@Deprecated

	public String encodeUrl(String url) {

		return url;

	}

	/**
	 * 
	 * Return the URL without any changes, to prevent disclosure of the
	 * 
	 * Session ID The default implementation of this method can add the
	 * 
	 * Session ID to the URL if support for cookies is not detected. This
	 * 
	 * exposes the Session ID credential in bookmarks, referer headers, server
	 * 
	 * logs, and more.
	 *
	 * 
	 * 
	 * @param url
	 * 
	 * @return original url
	 * 
	 */

	public String encodeURL(String url) {

		return url;

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @throws IOException
	 * 
	 */

	public void flushBuffer() throws IOException {

		getHttpServletResponse().flushBuffer();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @return The buffer size of the current HTTP response.
	 * 
	 */

	public int getBufferSize() {

		return getHttpServletResponse().getBufferSize();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @return The character encoding of the current HTTP response.
	 * 
	 */

	public String getCharacterEncoding() {

		return getHttpServletResponse().getCharacterEncoding();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @return The content type of the current HTTP response.
	 * 
	 */

	public String getContentType() {

		return getHttpServletResponse().getContentType();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @return The Locale of the current HTTP response.
	 * 
	 */

	public Locale getLocale() {

		return getHttpServletResponse().getLocale();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @return The ServletOutputStream of the current HTTP response.
	 * 
	 * @throws IOException
	 * 
	 */

	public ServletOutputStream getOutputStream() throws IOException {

		return getHttpServletResponse().getOutputStream();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @return The PrintWriter of the current HTTP response.
	 * 
	 * @throws IOException
	 * 
	 */

	public PrintWriter getWriter() throws IOException {

		return getHttpServletResponse().getWriter();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @return The isCommitted() status of the current HTTP response.
	 * 
	 */

	public boolean isCommitted() {

		return getHttpServletResponse().isCommitted();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 */

	public void reset() {

		getHttpServletResponse().reset();

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 */

	public void resetBuffer() {

		getHttpServletResponse().resetBuffer();

	}

	/**
	 * 
	 * Override the error code with a 200 in order to confound attackers using
	 * 
	 * automated scanners. Overwriting is controlled by
	 * {@code HttpUtilities.OverwriteStatusCodes}
	 * 
	 * in ESAPI.properties.
	 * 
	 * @param sc -- http status code
	 * 
	 * @throws IOException
	 * 
	 */

	public void sendError(int sc) throws IOException {

		response.sendError(sc);

		/*
		 * 
		 * SecurityConfiguration config = ESAPI.securityConfiguration();
		 * 
		 * if (config.getBooleanProp("HttpUtilities.OverwriteStatusCodes")) {
		 * 
		 * LOGGER.
		 * debug("[ESAPI] HttpUtilities.OverwriteStatusCodes is true. sendError fixed error status code to "
		 * + HttpServletResponse.SC_OK);
		 * 
		 * getHttpServletResponse().sendError(HttpServletResponse.SC_OK,
		 * getHTTPMessage(sc));
		 * 
		 * } else {
		 * 
		 * getHttpServletResponse().sendError(sc, getHTTPMessage(sc));
		 * 
		 * }
		 * 
		 */

	}

	/**
	 * 
	 * Override the error code with a 200 in order to confound attackers using
	 * 
	 * automated scanners. The message is canonicalized and filtered for
	 * 
	 * dangerous characters. Overwriting is controlled by
	 * {@code HttpUtilities.OverwriteStatusCodes}
	 * 
	 * in ESAPI.properties.
	 * 
	 * @param sc  -- http status code
	 * 
	 * @param msg -- error message
	 * 
	 * @throws IOException
	 * 
	 */

	public void sendError(int sc, String msg) throws IOException {

		response.sendError(sc, msg);

		/*
		 * 
		 * SecurityConfiguration config = ESAPI.securityConfiguration();
		 * 
		 * if(config.getBooleanProp("HttpUtilities.OverwriteStatusCodes")){
		 * 
		 * LOGGER.
		 * debug("[ESAPI] HttpUtilities.OverwriteStatusCodes is true. sendError fixed error status code to "
		 * + HttpServletResponse.SC_OK);
		 * 
		 * getHttpServletResponse().sendError(HttpServletResponse.SC_OK,
		 * ESAPI.encoder().encodeForHTML(msg));
		 * 
		 * }else{
		 * 
		 * getHttpServletResponse().sendError(sc, ESAPI.encoder().encodeForHTML(msg));
		 * 
		 * }
		 * 
		 */

	}

	/**
	 * 
	 * This method generates a redirect response that can only be used to
	 * 
	 * redirect the browser to safe locations, as configured in the ESAPI
	 * 
	 * security configuration. This method does not that redirect requests can
	 * 
	 * be modified by attackers, so do not rely information contained within
	 * 
	 * redirect requests, and do not include sensitive information in a
	 * 
	 * redirect.
	 * 
	 * @param location
	 * 
	 * @throws IOException
	 * 
	 */

	public void sendRedirect(String location) throws IOException {

		if (!ESAPI.validator().isValidRedirectLocation("Redirect", location, false)) {

			LOGGER.error("Bad redirect location: " + location);

			throw new IOException("Redirect failed");

		}

		getHttpServletResponse().sendRedirect(location);

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @param size
	 * 
	 */

	public void setBufferSize(int size) {

		getHttpServletResponse().setBufferSize(size);

	}

	/**
	 * 
	 * Sets the character encoding to the ESAPI configured encoding.
	 * 
	 * @param charset
	 * 
	 */

	public void setCharacterEncoding(String charset) {

		response.setCharacterEncoding(charset);

		/*
		 * 
		 * SecurityConfiguration sc = ESAPI.securityConfiguration();
		 * 
		 * LOGGER.debug("[ESAPI] fixed charset to "+
		 * sc.getStringProp("HttpUtilities.CharacterEncoding"));
		 * 
		 * getHttpServletResponse().setCharacterEncoding(sc.getStringProp(
		 * "HttpUtilities.CharacterEncoding"));
		 * 
		 */

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @param len
	 * 
	 */

	public void setContentLength(int len) {

		getHttpServletResponse().setContentLength(len);

	}

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @param type
	 * 
	 */

	public void setContentType(String type) {

		getHttpServletResponse().setContentType(type);

	}

	/**
	 * 
	 * Add a date header to the response after ensuring that there are no
	 * 
	 * encoded or illegal characters in the name.
	 * 
	 * @param name
	 * 
	 * @param date
	 * 
	 */

	public void setDateHeader(String name, long date) {

		try {

			SecurityConfiguration sc = ESAPI.securityConfiguration();

			String safeName = ESAPI.validator().getValidInput("safeSetDateHeader", name, "HTTPHeaderName",
					sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), false);

			getHttpServletResponse().setDateHeader(safeName, date);

		} catch (ValidationException e) {

			if (isPassMode) {

				LOGGER.warn("[passMode]Attempt to set invalid date header name denied.", e);

				response.setDateHeader(name, date);

			} else {

				throw new OwaspValidationException(e);

			}

		}

	}

	/**

     * Add a header to the response after ensuring that there are no encoded or

     * illegal characters in the name and value. "A recipient MAY replace any

     * linear white space with a single SP before interpreting the field value

     * or forwarding the message downstream."

     * http://www.w3.org/Protocols/rfc2616/rfc2616-sec2.html#sec2.2

     * @param name

     * @param value

     */

    public void setHeader(String name, String value) {

        if (value == null) {

            return;

        }

 

        if ("ETag".equals(name)) {

            this.response.setHeader(name, value);

            return;

        }

       

        try {

            String strippedName = StringUtilities.stripControls(name);

            String strippedValue = StringUtilities.stripControls(value);

            SecurityConfiguration sc = ESAPI.securityConfiguration();

            String safeName = ESAPI.validator().getValidInput("setHeader", strippedName, "HTTPHeaderName", sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), false);

            String safeValue = ESAPI.validator().getValidInput("setHeader", strippedValue, "HTTPHeaderValue", sc.getIntProp("HttpUtilities.MaxHeaderValueSize"), false);

            getHttpServletResponse().setHeader(safeName, safeValue);

        } catch (ValidationException e) {

            if(isPassMode) {

                LOGGER.warn("[passMode]Attempt to set invalid header denied.", e);

                response.setHeader(name, value);

            }else {

                throw new OwaspValidationException(e);

            }

        }

    }

	/**

     * Add an int header to the response after ensuring that there are no

     * encoded or illegal characters in the name.

     * @param name

     * @param value

     */

    public void setIntHeader(String name, int value) {

        try {

            SecurityConfiguration sc = ESAPI.securityConfiguration();

            String safeName = ESAPI.validator().getValidInput("setIntHeader", name, "HTTPHeaderName", sc.getIntProp("HttpUtilities.MaxHeaderNameSize"), false);

            getHttpServletResponse().setIntHeader(safeName, value);

        } catch (ValidationException e) {

            if(isPassMode) {

                LOGGER.warn("[passMode]Attempt to set invalid int header name denied.", e);

                response.setIntHeader(name, value);

            }else {

                throw new OwaspValidationException(e);

            }

        }

    }

	/**
	 * 
	 * Same as HttpServletResponse, no security changes required.
	 * 
	 * @param loc
	 * 
	 */

	public void setLocale(Locale loc) {

		getHttpServletResponse().setLocale(loc);

	}

	/**
	 * 
	 * Override the status code with a 200 in order to confound attackers using
	 * 
	 * automated scanners.
	 * 
	 * @param sc
	 * 
	 */

	public void setStatus(int sc) {

		response.setStatus(sc);

		/*
		 * 
		 * SecurityConfiguration config = ESAPI.securityConfiguration();
		 * 
		 * if(config.getBooleanProp("HttpUtilities.OverwriteStatusCodes")){
		 * 
		 * LOGGER.
		 * debug("[ESAPI] HttpUtilities.OverwriteStatusCodes is true. setStatus fixed error status code to "
		 * + HttpServletResponse.SC_OK);
		 * 
		 * getHttpServletResponse().setStatus(HttpServletResponse.SC_OK);
		 * 
		 * }else{
		 * 
		 * getHttpServletResponse().setStatus(sc);
		 * 
		 * }
		 * 
		 */

	}

	/**
	 * 
	 * Override the status code with a 200 in order to confound attackers using
	 * 
	 * automated scanners. The message is canonicalized and filtered for
	 * 
	 * dangerous characters.
	 * 
	 * @param sc
	 * 
	 * @param sm
	 * 
	 * @deprecated In Servlet spec 2.1.
	 * 
	 */

	@Deprecated

	public void setStatus(int sc, String sm) {

		response.setStatus(sc, sm);

		/*
		 * 
		 * try {
		 * 
		 * SecurityConfiguration config = ESAPI.securityConfiguration();
		 * 
		 * if(config.getBooleanProp("HttpUtilities.OverwriteStatusCodes")){
		 * 
		 * LOGGER.
		 * debug("[ESAPI] HttpUtilities.OverwriteStatusCodes is true. setStatus fixed error status code to "
		 * + HttpServletResponse.SC_OK);
		 * 
		 * sendError(HttpServletResponse.SC_OK, sm);
		 * 
		 * }else{
		 * 
		 * sendError(sc, sm);
		 * 
		 * }
		 * 
		 * } catch (IOException e) {
		 * 
		 * LOGGER.warn("Attempt to set response status failed", e);
		 * 
		 * }
		 * 
		 */

	}

	/**
	 * 
	 * returns a text message for the HTTP response code
	 * 
	 */

	private String getHTTPMessage(int sc) {

		return "HTTP error code: " + sc;

	}

}