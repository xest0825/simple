package rapidex.common.util;
/* 내부 */
import java.net.*;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

public class InetUtil {

	/* 공인 및 프록시 */
	public static String getClientIP(HttpServletRequest request) {
	    String ip = request.getHeader("확인 X-FORWARDED-FOR");
	    
	    if(ip == null || ip.length() == 0) {
	        ip = request.getHeader("Proxy-Client-IP"); 
	    }
	    if(ip == null || ip.length() == 0) {
	        ip = request.getHeader("WL-Proxy-Client-IP");  // 웹로직 
	    }
	    if(ip == null || ip.length() == 0) {
	        ip = request.getRemoteAddr(); 
	    }
	    return ip;
	}
	 
	/* 만약 공인 IP없으면 내부 IP 가져오도록 처리 */
	public static String getCurrentEnvironmentNetworkIp(){
	    Enumeration netInterfaces = null;
	 
	    try {
	        netInterfaces = NetworkInterface.getNetworkInterfaces();
	    } catch (SocketException e) {
	        return getLocalIp();
	    }
	 
	    while (netInterfaces.hasMoreElements()) {
	        NetworkInterface ni = (NetworkInterface)netInterfaces.nextElement();
	        Enumeration address = ni.getInetAddresses();
	 
	        if (address == null) {
	            return getLocalIp();
	        }
	 
	        while (address.hasMoreElements()) {
	            InetAddress addr = (InetAddress)address.nextElement();
	            
	            if (!addr.isLoopbackAddress() && !addr.isSiteLocalAddress() && !addr.isAnyLocalAddress() ) {
	                String ip = addr.getHostAddress();
	                
	                if( ip.indexOf(".") != -1 && ip.indexOf(":") == -1 ){
	                    return ip;
	                }
	            }
	        }
	    }
	 
	    return getLocalIp();
	}
	 
	public static String getLocalIp(){
	    try {
	        return InetAddress.getLocalHost().getHostAddress();
	    } catch (UnknownHostException e) {
	        return null;
	    }
	}

}
