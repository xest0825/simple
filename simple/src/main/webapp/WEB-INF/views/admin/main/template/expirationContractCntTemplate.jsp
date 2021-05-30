<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 11. 27
	화면 설명 : 갱신계약(건수) TEMPLATE
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
			<p>갱신계약</p>
			<span class="ttxt01">(단위 : 건)</span>
			<table class="table_st1">
				<colgroup>
					<col width=""></col>
		  			<col width=""></col>
		  			<col width=""></col>
				</colgroup>
				<thead>
					<tr>
						<th>분류</th>
						<th>당월</th>
						<th class="br0">익월</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${resultList }" var="list" begin="0" end="1">
					<tr>
						<td class="tal">${list.ins_cont_type_nm }</td>
						<td><fmt:formatNumber value="${list.this_month_cnt }" pattern="#,###" /></td>
						<td class="br0"><fmt:formatNumber value="${list.next_month_cnt }" pattern="#,###" /></td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</li>
	</ul>
</body>
</html>
