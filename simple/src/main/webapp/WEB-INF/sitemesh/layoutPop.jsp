<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache">
<title>::::: SIMPLE Pop :::::<%-- <sitemesh:write property='title'/> --%></title>
<!-- <link href="/resources/kendoui/styles/kendo.common.min.css" rel="stylesheet" />
<link href="/resources/kendoui/styles/kendo.bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="/resources/css/font-awesome.min.css" />
<link rel="stylesheet" href="/resources/css/search.css" />
<link rel="stylesheet" href="/resources/css/important.css" />
<link rel="stylesheet" href="/resources/css/tooltip.css" /> -->
<!-- <link rel="stylesheet" href="/resources/css/common.css" /> -->
<!-- <link href="/resources/css/simple-line-icons.css" rel="stylesheet" /> -->
<!-- <script type="text/javascript" src="/resources/js/jquery/jquery-3.3.1.min.js"></script> -->
<script type="text/javascript" src="/resources/js/jquery/jquery.min.js"></script>
<!-- <script type="text/javascript" src="/resources/kendoui/js/kendo.all.min.js"></script> -->
<!-- <script type="text/javascript" src="/resources/kendoui/js/cultures/kendo.culture.ko-KR.min.js"></script>
<script type="text/javascript" src="/resources/js/common/genexon.js"></script>
<script type="text/javascript" src="/resources/js/opensource/mit-license/moment/moment.js"></script>
<script type="text/javascript" src="/resources/js/opensource/mit-license/underscore/underscore-min.js"></script>
<link rel="stylesheet" href="/resources/css/loading.css" />
<script type="text/javascript" src="/resources/js/common/layout.js"></script>
<script type="text/javascript" src="/resources/js/jquery/jquery.fileDownload.js"></script>
<script type="text/javascript" src="/resources/js/common/session.js"></script>
<script type="text/javascript" src="/resources/js/jquery/jquery.form-3.51.0.js"></script> -->
<%-- <%@ include file="../views/comm/address.jsp" %> --%>
<%-- <%@ include file="../sitemesh/layoutPopstyle.jsp" %> --%>
<script>
    window.MSPointerEvent = null;
    window.PointerEvent = null;
</script>
<script type="text/javascript">
$(document).ready(function(){	
	console.log('Pop');
/* 	genexon.initKendoUI();
    kendo.fx($("#wrappop")).fade("in").duration(1000).play();
        
    resizeGrid();
    
    top.sessionExt();
    
    $("button, a").click(function(){
		top.sessionExt();
	}); */
});

</script>
    <sitemesh:write property='head'/>
</head>
<body>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	
	<!-- 마감코드 -->
	<input id="CL_STEP_CD" name="CL_STEP_CD" type="hidden" value="${CL_STEP_CD}"/>
	<input type="hidden" id="menuRole" value="${menuRole}"/>
	<input type="hidden" id="in_autr_type" value="${menuRole.in_autr_type}"/>
	<input type="hidden" id="up_autr_type" value="${menuRole.up_autr_type}"/>
	<input type="hidden" id="de_autr_type" value="${menuRole.de_autr_type}"/>
	<input type="hidden" id="lo_autr_type" value="${menuRole.lo_autr_type}"/>
	<input type="hidden" id="do_autr_type" value="${menuRole.do_autr_type}"/>

	<div id="containerpop">
		<!-- Wrap -->
		<div id="wrappop">
		    <sitemesh:write property='body'/>
		</div>
	</div>
	
	<iframe title="" id="ifmDetail" name="ifmDetail" style="width: 100%;height: 0px;border: 0px;overflow:hidden;" scrolling="no"></iframe>
    <form id="frmSubDetail" name="frmSubDetail" target="ifmDetail"></form>
</body>
</html>