package rapidex.common.util;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import org.springframework.util.StreamUtils;
import org.springframework.util.StringUtils;

public class HttpUtils {

	public final static String APPLICATION_FORM_URLENCODED_VALUE = "application/x-www-form-urlencoded";

	@SuppressWarnings("serial")

	private static final Set<String> LOCALHOST = new HashSet<String>() {
		{

			add("127.0.0.1");// IPV4

			add("0:0:0:0:0:0:0:1");// IPV6

		}
	};

	@SuppressWarnings("serial")

	public static final Set<String> MULTI_READ_HTTP_METHODS = new HashSet<String>() {

		{

			add("PUT");

			add("POST");

		}

	};

	@SuppressWarnings("serial")

	public static final Set<String> SPRING_MOCK_REQUESTS = new HashSet<String>() {

		{

			add("MockHttpServletRequest"); // spring 3.x

			add("Servlet3MockHttpServletRequest"); // spring 4.x

		}

	};

	public static String getHttpBody(final HttpServletRequest request, final String encoding) {

		if (!isReadableHttpBody(request.getMethod())) {

			return null;

		}

		if (isFormUrlencoded(request)) {

			return readParameters(request);

		}

		if (isSpringMVCMockTest(request)) {

			return readBody(request, encoding);

		}

		/*
		 * if (!(request instanceof RereadableRequestWrapper)) {
		 * 
		 * if (LOGGER.isWarnEnabled()) {
		 * 
		 * LOGGER.
		 * warn("MultiReadHttpServletRequest 타입이 아닙니다. 필터를 설정하세요.. requestType={} URL={}"
		 * ,
		 * 
		 * request.getClass(), getFullURL(request));
		 * 
		 * }
		 * 
		 * return null;
		 * 
		 * }
		 */

		return readBody(request, encoding);

	}

	public static boolean isReadableHttpBody(final String method) {

		return MULTI_READ_HTTP_METHODS.contains(method);

	}

	public static boolean isXMLHttpRequest(final HttpServletRequest req) {

		return "XMLHttpRequest".equals(req.getHeader("x-requested-with"));

	}

	public static boolean isMultipartContent(HttpServletRequest request) {

		String contentType = request.getContentType();

		return contentType != null && contentType.toLowerCase().startsWith("multipart/");

	}

	public static boolean isFormUrlencoded(final HttpServletRequest request) {

		String contentType = request.getContentType();

		return contentType != null && contentType.toLowerCase().equals(APPLICATION_FORM_URLENCODED_VALUE);

	}

	public static boolean isSpringMVCMockTest(final HttpServletRequest request) {

		return SPRING_MOCK_REQUESTS.contains(request.getClass().getSimpleName());

	}

	public static String readParameters(final HttpServletRequest request) {

		StringBuilder sb = new StringBuilder();

		sb.append("[");

		Iterator<Map.Entry<String, String[]>> iterator = request.getParameterMap().entrySet().iterator();

		while (iterator.hasNext()) {

			Map.Entry<String, String[]> entry = iterator.next();

			String[] value = entry.getValue();

			for (int i = 0; i < value.length; i++) {

				sb.append(entry.getKey()).append("=").append(value[i]);

				if (i < value.length - 1) {

					sb.append("&");

				}

			}

			if (iterator.hasNext()) {

				sb.append("&");

			}

		}

		sb.append("]");

		return sb.toString();

	}

	public static String readParameters2(final HttpServletRequest req) {

		StringBuilder sb = new StringBuilder();

		Enumeration<String> paramNames = req.getParameterNames();

		while (paramNames.hasMoreElements()) {

			String paramName = paramNames.nextElement();

			sb.append("\t").append(paramName).append(":");

			String[] values = req.getParameterValues(paramName);

			if (values == null) {

				sb.append("null");

				continue;

			}

			int valueLen = values.length;

			if (valueLen == 1) {

				sb.append(values[0]);

			} else {

				sb.append("[");

				for (int i = 0; i < valueLen; i++) {

					if (i != 0) {

						sb.append(", ");

					}

					sb.append(values[i]);

				}

				sb.append("]");

			}

		}

		return sb.toString();

	}

	public static String getFullURL(final HttpServletRequest request) {

		StringBuilder requestURL = new StringBuilder(request.getRequestURL().toString());

		String queryString = request.getQueryString();

		if (queryString == null) {

			return requestURL.toString();

		} else {

			return requestURL.append('?').append(queryString).toString();

		}

	}

	public static String getFullURI(final HttpServletRequest request) {

		StringBuilder requestURL = new StringBuilder(request.getRequestURI().toString());

		String queryString = request.getQueryString();

		if (queryString == null) {

			return requestURL.toString();

		} else {

			return requestURL.append('?').append(queryString).toString();

		}

	}

	public static String readBody(final HttpServletRequest request, final String encoding) {

		try {

			if (request.getInputStream() == null) {

				return null;

			}

			return StreamUtils.copyToString(request.getInputStream(), Charset.forName(encoding));

		} catch (IOException e) {

			throw new IllegalStateException(e);

		}

	}

	public static String getRemoteAddr(final HttpServletRequest request) {

		String remoteAddr = request.getHeader("X-Forwarded-For");

		if (StringUtils.hasText(remoteAddr)) {

			return remoteAddr;

		}

		return request.getRemoteAddr();

	}

	public static boolean isAllowIp(String[] allowIps, String targetIp) {

		for (int i = 0, ic = allowIps.length; i < ic; i++) {

			if (isAllowIp(allowIps[i], targetIp)) {

				return true;

			}

		}

		return false;

	}

	public static boolean isAllowIp(String allowIp, String targetIp) {

		if ("*".equals(allowIp)) {

			return true;

		}

		if (isLocalHost(targetIp)) {

			targetIp = "127.0.0.1";

		}

		int p = allowIp.indexOf('*');

		if (p >= 0) {

			if ("*".equals(allowIp)) {

				return true;

			}

			String checkIp = allowIp.substring(0, p);

			if (targetIp.indexOf(checkIp) == 0) {

				return true;

			}

		} else if (allowIp.equals(targetIp)) {

			return true;

		}

		return false;

	}

	public static boolean isLocalHost(String targetIp) {

		return LOCALHOST.contains(targetIp);

	}

}