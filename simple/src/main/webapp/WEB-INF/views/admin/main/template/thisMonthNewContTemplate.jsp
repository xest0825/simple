<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2020. 07. 28
	화면 설명 : 메인화면 당월 신계약 템플릿
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

.AT_table{
	width:100%;
	overflow-y: auto; 
	height: 220px;
}
.AT_table thead th{ 
	position: sticky;
	top: 0; 
}
.AT_table::-webkit-scrollbar-track
{
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.1);
	border-radius: 10px;
	background-color: #F5F5F5;
}

.AT_table::-webkit-scrollbar
{
	width: 5px;
	background-color: #F5F5F5;
}

.AT_table::-webkit-scrollbar-thumb
{
	border-radius: 10px;
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.5);
	background-color: #F5F5F5;
}
</style>
</head>
<body>
	<ul class="main_box01">
		<li>
			<p>당월 신계약</p>
			<span class="ttxt01"></span>
			<c:choose>
				<c:when test="${MainTemplateVO.template_code eq 'TM_NEW_CONT'}">
					<div class="AT_table">
					<table class="table_st1 bt0">
						<colgroup>
							<col width=""></col>
							<col width=""></col>
							<col width=""></col>
						</colgroup>
						<thead>
							<tr>
								<th>보험사</th>
								<th>계약자</th>
								<th class="br0">보험료</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${resultList }" var="list" varStatus="status">
							<tr>
								<td class="tal">${list.insco_nm }</td>
								<td class="tal">${list.policyholder }</td>
								<td><fmt:formatNumber pattern="#,###">${list.prem_amt }</fmt:formatNumber></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
					</div>
				</c:when>
			</c:choose>
		</li>
	</ul>
</body>
</html>