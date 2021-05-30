<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 12. 03
	화면 설명 : 이달의 성과 조직 레벨별 템플릿
######################################################################################### 
 -->
<html>
<head>
<link rel="stylesheet" href="/resources/css/main.css" />
<style type="text/css">
.main_box01 {
	width: 100%;
	display: block;
	height: 300px;
	margin-left: 0px !important;
}
</style>
</head>
<body>
	<ul class="main_box01">
		<li>
			<p>${resultList[0].title }</p>
			<span class="ttxt01">(단위 : 천원)</span>
			<table class="table_st1">
				<colgroup>
					<col width=""></col>
		  			<col width=""></col>
		  			<col width=""></col>
		  			<col width=""></col>
				</colgroup>
				<thead>
					<tr>
						<th>조직</th>
						<th>장기</th>
						<th>환산</th>
						<th class="br0">기타</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${resultList}" var="list">
						<tr>
							<td class="tal">${list.snm }</td>
							<td><fmt:formatNumber value="${list.month_prem_amt }" pattern="#,###" /></td>
							<td><fmt:formatNumber value="${list.hwan }" pattern="#,###" /></td>
							<td class="br0"><fmt:formatNumber value="${list.non_longterm_prem_amt }" pattern="#,###" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</li>
	</ul>
</body>
</html>
