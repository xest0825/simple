<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 26
	화면 설명 : 이달의 성과 템플릿
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
			<p>${title }</p>
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
						<th>분류</th>
						<th>당월</th>
						<th>전월</th>
						<th class="br0">진도율</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="tal">생보장기</td>
						<td><fmt:formatNumber value="${results.lf_m_lt_pr_amt }" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${results.lf_l_m_lt_pr_amt }" pattern="#,###" /></td>
						<td class="br0"><fmt:formatNumber value="${results.lf_lt_pg_rt }" pattern="#,###.##" />%</td>
					</tr>
					<tr>
						<td class="tal">생보 일시납</td>
						<td><fmt:formatNumber value="${results.lf_m_is_pr_amt }" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${results.lf_l_m_is_pr_amt }" pattern="#,###" /></td>
			  			<td class="br0"><fmt:formatNumber value="${results.lf_is_pg_rt }" pattern="#,###.##" />%</td>
					</tr>
					<tr>
			  			<td class="tal">손보장기</td>
			  			<td><fmt:formatNumber value="${results.n_lf_m_lt_pr_amt }" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${results.n_lf_l_m_lt_pr_amt }" pattern="#,###" /></td>
			  			<td class="br0"><fmt:formatNumber value="${results.n_lf_lt_pg_rt }" pattern="#,###.##" />%</td>
					</tr>
					<tr>
			  			<td class="tal">손보자동차</td>
			  			<td><fmt:formatNumber value="${results.n_lf_m_cr_pr_amt }" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${results.n_lf_l_m_cr_pr_amt}" pattern="#,###" /></td>
			  			<td class="br0"><fmt:formatNumber value="${results.n_lf_cr_pg_rt }" pattern="#,###.##" />%</td>
					</tr>
					<tr>
						<td class="tal">손보일반</td>
						<td><fmt:formatNumber value="${results.n_lf_m_gn_pr_amt }" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${results.n_lf_l_m_gn_pr_amt }" pattern="#,###" /></td>
						<td class="br0"><fmt:formatNumber value="${results.n_lf_gn_pg_rt }" pattern="#,###.##" />%</td>
					</tr>
				</tbody>
			</table>
		</li>
	</ul>
</body>
</html>
