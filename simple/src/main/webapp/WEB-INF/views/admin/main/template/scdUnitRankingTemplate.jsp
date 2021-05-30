<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 29
	화면 설명 : 사업단 순위 템플릿
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
			<c:choose>
				<c:when test="${User.mb_id eq 'HSH'}">
					<p>지사/직영 순위(장기)</p>
					<span class="ttxt01">(단위 : 천원, 건)</span>
						<div class="AT_table">
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
										<th>보험료</th>
										<th>건수</th>
										<th class="br0">평가성적</th>
									</tr>
						        </thead>
						        <tbody>
				        			<c:forEach items="${results }" var="list">
									<tr>
										<td class="tal">${list.snm }</td>
										<td><fmt:formatNumber pattern="#,###">${list.longterm_prem_amt / 1000 }</fmt:formatNumber></td>
										<td><fmt:formatNumber pattern="#,###">${list.cont_longterm_cnt }</fmt:formatNumber></td>
										<td class="br0"><fmt:formatNumber pattern="#,###">${list.longterm_hwan / 1000 }</fmt:formatNumber></td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
				</c:when>
				<c:when test="${User.mb_id eq 'AT'}">
					<p>본부 순위(장기)</p>
					<span class="ttxt01">(단위 : 천원, 건)</span>
					<table class="table_st1">
						<colgroup>
							<col width=""></col>
							<col width=""></col>
							<col width=""></col>
						</colgroup>
						<thead>
							<tr>
								<th>조직</th>
								<th>보험료</th>
								<th class="br0">건수</th>
							</tr>
				        </thead>
				        <tbody>
				        	<c:forEach items="${results }" var="list">
							<tr>
								<td class="tal">${list.snm }</td>
								<td><fmt:formatNumber pattern="#,###">${list.longterm_prem_amt / 1000 }</fmt:formatNumber></td>
								<td class="br0"><fmt:formatNumber pattern="#,###">${list.cont_longterm_cnt }</fmt:formatNumber></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:when>
				<c:otherwise>
					<p>사업단 순위(장기)</p>
					<span class="ttxt01">(단위 : 천원, 건)</span>
					<table class="table_st1">
						<colgroup>
							<col width=""></col>
							<col width=""></col>
							<col width=""></col>
							<col width=""></col>
						</colgroup>
						<thead>
							<tr>
								<th>사업단</th>
								<th>보험료</th>
								<th>건수</th>
								<th class="br0">평가성적</th>
							</tr>
				        </thead>
				        <tbody>
				        	<c:forEach items="${results }" var="list" begin="0" end="3">
							<tr>
								<td class="tal">${list.snm }</td>
								<td><fmt:formatNumber pattern="#,###">${list.longterm_prem_amt / 1000 }</fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${list.cont_longterm_cnt }</fmt:formatNumber></td>
								<td class="br0"><fmt:formatNumber pattern="#,###">${list.longterm_hwan / 1000 }</fmt:formatNumber></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:otherwise>
			</c:choose>
		</li>
	</ul>
</body>
</html>