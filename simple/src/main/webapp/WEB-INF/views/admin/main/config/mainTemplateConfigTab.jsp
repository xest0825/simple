<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 18
	화면 설명 : 메인화면 설정 페이지 권한별 탭
######################################################################################### 
 -->
<html>
<head>
<script type="text/javascript">
$(document).ready(function(e) {
	$("#tabstrip").kendoTabStrip({
		animation: { open: { effects: "fadeIn" }},
		contentUrls: [
			'/main/config/mainTemplateConfig.go?${_csrf.parameterName}=${_csrf.token}&role_id=DEFAULT',
			<c:forEach items="${roleList}" var="list">
				'/main/config/mainTemplateConfig.go?${_csrf.parameterName}=${_csrf.token}&role_id=${list.role_id}',
			</c:forEach>
		]
	}).data('kendoTabStrip');
});
</script>
</head>
<body>
	<div class="new-wrapper">
		<div id="tabstrip" style="border: 0px; background:#fff;">
			<ul>
				<li class="k-state-active">default</li>
				<c:forEach items="${roleList}" var="list">
				<li>${list.role_nm }</li>
				</c:forEach>
			</ul>
		</div>
	</div>
</body>
</html>