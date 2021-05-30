<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 26
	화면 설명 : FP순위 템플릿
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
			<p>FP순위</p>
			<span class="ttxt01">(단위 : 천원, 건)</span>
			<!-- FC순위 AT에셋 : 장기 FC순위
				  그 외 : 장기, 자동차, 일반 FC순위 -->
			<c:choose>
				<c:when test="${User.mb_id eq 'AT'}">
					<div class="AT_table">
					<table class="table_st1 bt0">
						<colgroup>
							<col width=""></col>
							<col width=""></col>
							<col width=""></col>
							<col width=""></col>
							<col width="15%"></col>
						</colgroup>
						<thead>
							<tr>
								<th>순위</th>
								<th>조직</th>
								<th>FP</th>
								<th>보험료</th>
								<th class="br0">건수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${longTermList }" var="list" varStatus="status">
							<tr>
								<td style="text-align:center">${status.count}</td>
								<td class="tal">${list.snm }</td>
								<td class="tal">${list.emp_nm }</td>
								<td><fmt:formatNumber pattern="#,###">${list.share_longterm_prem_amt / 1000 }</fmt:formatNumber></td>
								<td class="br0"><fmt:formatNumber pattern="#,###">${list.cont_longterm_cnt }</fmt:formatNumber></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
					</div>
				</c:when>
				<c:when test="${User.mb_id eq 'TOP'}">
					<div class="AT_table">
					<table class="table_st1 bt0">
						<colgroup>
							<col width=""></col>
							<col width=""></col>
							<col width=""></col>
							<col width=""></col>
							<col width="15%"></col>
						</colgroup>
						<thead>
							<tr>
								<th>NO.</th>
								<th>이름</th>
								<th>건수</th>
								<th>보험료</th>
								<th class="br0">TOP환산</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${longTermList}" var="longTermList" varStatus="status">
								<c:if test="${longTermList.share_longterm_hwan / 1000 != 0 and longTermList.share_longterm_prem_amt / 1000 != 0 and longTermList.cont_longterm_cnt != 0}">
									<tr>
										<td style="text-align:center">${status.count}</td>
										<td style="text-align:center">${longTermList.emp_nm }</td>
										<td><fmt:formatNumber pattern="#,###">${longTermList.cont_longterm_cnt }</fmt:formatNumber></td>
										<td><fmt:formatNumber pattern="#,###">${longTermList.share_longterm_prem_amt / 1000 }</fmt:formatNumber></td>
										<td class="br0"><fmt:formatNumber pattern="#,###">${longTermList.share_longterm_hwan / 1000 }</fmt:formatNumber></td>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
					</table>
					</div>
				</c:when>
				<c:otherwise>
					<main>
						<input id="tab1" type="radio" name="tabs" checked>
						<label for="tab1">장기</label>
				
						<input id="tab2" type="radio" name="tabs">
						<label for="tab2">자동차</label>
				
						<input id="tab3" type="radio" name="tabs">
						<label for="tab3">일반</label>
				
						<section id="content1">
							<table class="table_st1 bt0">
								<colgroup>
									<col width=""></col>
									<col width=""></col>
									<col width=""></col>
									<col width=""></col>
								</colgroup>
								<thead>
									<tr>
										<th>조직</th>
										<th>FP</th>
										<th>보험료</th>
										<th class="br0">건수</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${longTermList }" begin="0" end="3" var="list">
									<tr>
										<td class="tal">${list.snm }</td>
										<td class="tal">${list.emp_nm }</td>
										<td><fmt:formatNumber pattern="#,###">${list.share_longterm_prem_amt / 1000 }</fmt:formatNumber></td>
										<td class="br0"><fmt:formatNumber pattern="#,###">${list.cont_longterm_cnt }</fmt:formatNumber></td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</section>
				
						<section id="content2">
							<table class="table_st1 bt0">
								<colgroup>
									<col width=""></col>
									<col width=""></col>
									<col width=""></col>
									<col width=""></col>
								</colgroup>
								<thead>
									<tr>
										<th>조직</th>
										<th>FP</th>
										<th>보험료</th>
										<th class="br0">건수</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${carList }" begin="0" end="3" var="list">
									<tr>
										<td class="tal">${list.snm }</td>
										<td class="tal">${list.emp_nm }</td>
										<td><fmt:formatNumber pattern="#,###">${list.share_non_life_car_prem_amt / 1000 }</fmt:formatNumber></td>
										<td class="br0"><fmt:formatNumber pattern="#,###">${list.share_non_life_car_cnt }</fmt:formatNumber></td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</section>
				
						<section id="content3">
							<table class="table_st1 bt0">
								<colgroup>
									<col width=""></col>
									<col width=""></col>
									<col width=""></col>
									<col width=""></col>
								</colgroup>
								<thead>
									<tr>
										<th>조직</th>
										<th>FP</th>
										<th>보험료</th>
										<th class="br0">건수</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${ilbanList }" begin="0" end="3" var="list">
									<tr>
										<td class="tal">${list.snm }</td>
										<td class="tal">${list.emp_nm }</td>
										<td><fmt:formatNumber pattern="#,###">${list.share_non_life_general_prem_a / 1000 }</fmt:formatNumber></td>
										<td class="br0"><fmt:formatNumber pattern="#,###">${list.share_non_life_general_cnt }</fmt:formatNumber></td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</section>
					</main>
				</c:otherwise>
			</c:choose>
		</li>
	</ul>
</body>
</html>