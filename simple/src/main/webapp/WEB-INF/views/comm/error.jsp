<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page isErrorPage="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="user-scalable=no, viewport-fit=cover, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
	<!-- <link rel="stylesheet" href="/css/common.css" /> -->
 	<script type="text/javascript" src="/resources/js/jquery/jquery-3.3.1.min.js"></script>

</head>
 
<body>
<div>
		<form id="fromerror" name="fromerror">
			
			<input type="hidden" name="ERROR_CODE" id="ERROR_CODE" value="${requestScope['javax.servlet.error.status_code']}"/>
			<input type="hidden" name="ERROR_TYPE" id="ERROR_TYPE" value="${requestScope['javax.servlet.error.exception_type']}"/>
			<input type="hidden" name="ERROR_MSG" id="ERROR_MSG" value=""/>
			<input type="hidden" name="ERROR_EXCEPTION" id="ERROR_EXCEPTION" value="${requestScope['javax.servlet.error.exception']}"/>
			<input type="hidden" name="ERROR_URL" id="ERROR_URL" value="${requestScope['javax.servlet.error.request_url']}"/>
			<input type="hidden" name="ERROR_SERVLET" id="ERROR_SERVLET" value="${requestScope['javax.servlet.error.servlet_name']}"/>
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
			    <td width="100%" height="100%" align="center" valign="middle" style="padding-top:150px;">
			    	<table border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td class="<spring:message code='image.errorBg'/>">
							<span>해당 URL에 오류가 있습니다.</span>
							<br/>
							<br/><span>에러코드:${requestScope['javax.servlet.error.status_code']}</span>
							<br/><span>에러타입:${requestScope['javax.servlet.error.exception_type']}</span>
							<br/><span id ="errormessage" >에러메시지:${requestScope['javax.servlet.error.message']}</span>
							<br/><span>에러객체:${requestScope['javax.servlet.error.exception']}</span>
							<br/><span>에러REFFERE_URL:${requestScope['javax.servlet.error.request_url']}</span>
							<br/><span>에러서블릿:${requestScope['javax.servlet.error.servlet_name']}</span>
						</td>
					  </tr>
					</table>
				</td>
			  </tr>
			</table>
		</form>
	</div>
</body>

</html>