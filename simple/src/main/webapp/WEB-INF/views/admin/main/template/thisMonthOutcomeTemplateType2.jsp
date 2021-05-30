<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 10. 14
	화면 설명 : 이달의 성과 템플릿 Type2(환산)
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
			<c:choose>
				<c:when test="${User.mb_id eq 'TOP'}">
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
								<th>분류</th>
								<th>건수</th>
								<th>보험료</th>
								<th class="br0">TOP환산</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="tal">생보</td>
								<td><fmt:formatNumber pattern="#,###">${results.lf_m_lt_cnt }</fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${results.lf_m_lt_pr_amt }</fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${results.lf_m_lt_hwan }</fmt:formatNumber></td>
							</tr>
							<tr>
								<td class="tal">손보</td>
								<td><fmt:formatNumber pattern="#,###">${results.non_lf_m_lt_cnt }</fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${results.n_lf_m_lt_pr_amt }</fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${results.non_lf_m_lt_hwan }</fmt:formatNumber></td>
							</tr>
							<tr>
					  			<td class="tal">자동차</td>
					  			<td><fmt:formatNumber pattern="#,###">${results.non_lf_m_cr_cnt }</fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${results.n_lf_m_cr_pr_amt }</fmt:formatNumber></td>
								<td></td>
							</tr>
							<tr>
					  			<td class="tal">일반</td>
					  			<td><fmt:formatNumber pattern="#,###">${results.non_lf_m_gn_cnt }</fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${results.n_lf_m_gn_pr_amt} </fmt:formatNumber></td>
								<td></td>
							</tr>
							<tr>
					  			<td class="tal">합계</td>
					  			<td><fmt:formatNumber pattern="#,###">${results.total_cnt }</fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${results.total_prem_amt} </fmt:formatNumber></td>
								<td><fmt:formatNumber pattern="#,###">${results.total_hwan} </fmt:formatNumber></td>
							</tr>
						</tbody>
					</table>
				</c:when>
				<c:otherwise>
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
								<td class="tal">건수</td>
								<td><fmt:formatNumber value="${results.sum_m_lgt_cnt }" pattern="#,###" /></td>
								<td><fmt:formatNumber value="${results.sum_l_m_lgt_cnt }" pattern="#,###" /></td>
								<td class="br0"><fmt:formatNumber value="${results.sum_lgt_cnt_pg_rt }" pattern="#,###.#" />%</td>
							</tr>
							<tr>
								<td class="tal">생보환산</td>
								<td><fmt:formatNumber value="${results.lf_m_lt_hwan }" pattern="#,###" /></td>
								<td><fmt:formatNumber value="${results.lf_l_m_lt_hwan }" pattern="#,###" /></td>
					  			<td class="br0"><fmt:formatNumber value="${results.lf_lt_pg_rt }" pattern="#,###.#" />%</td>
							</tr>
							<tr>
					  			<td class="tal">손보환산</td>
					  			<td><fmt:formatNumber value="${results.non_lf_m_lt_hwan }" pattern="#,###" /></td>
								<td><fmt:formatNumber value="${results.non_lf_l_m_lt_hwan }" pattern="#,###" /></td>
					  			<td class="br0"><fmt:formatNumber value="${results.n_lf_lt_pg_rt }" pattern="#,###.#" />%</td>
							</tr>
							<tr>
					  			<td class="tal">환산합계</td>
					  			<td><fmt:formatNumber value="${results.sum_m_lgt_hwan }" pattern="#,###" /></td>
								<td><fmt:formatNumber value="${results.sum_l_m_lgt_hwan }" pattern="#,###" /></td>
					  			<td class="br0"><fmt:formatNumber value="${results.sum_lgt_hwan_pg_rt }" pattern="#,###.#" />%</td>
							</tr>
						</tbody>
					</table>
				</c:otherwise>
			</c:choose>
		</li>
	</ul>
</body>
</html>
