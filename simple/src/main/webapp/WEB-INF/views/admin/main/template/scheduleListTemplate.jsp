<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 02
	화면 설명 : 게시판 TEMPLATE
######################################################################################### 
 -->
<html style="overflow-y: hidden;">
<head>
<link rel="stylesheet" href="/resources/css/main.css" />
<style type="text/css">
.main_box01 {
	width: 100%;
	display: block;
	height: 300px;
	margin-left: 0px !important;
}

.main_box01 li {
	width: 300px;
	height: 300px;
	background: #f6f6f6;
	float: left;
	margin-right: 25px;
	box-sizing: border-box;
	padding: 20px;
	border: 1px solid #fff;
	border-radius: 2px;
}

.main_box01 li p {
	width: 100%;
	font-size: 18px;
	font-family: 'Nanum Square' !important;
	font-weight: bold;
	border-bottom: 2px solid #222;
	letter-spacing: -2px;
	color: #222;
	padding-bottom: 12px;
}

.main_box01 li p a {
	font-size: 12px;
	float: right;
	letter-spacing: -1px;
	padding-top: 5px;
}

.scheduleTitle {
	cursor: pointer;
    color: black;
    text-overflow: ellipsis;
    font-size: 12pt !important;
    font-weight: normal;
    white-space: nowrap;
    overflow-wrap: normal;
    padding-bottom: 0px !important;
    overflow: hidden;
    display: inline-block !important;
    vertical-align: baseline;
}

.scheduleTitle:hover {
	text-decoration: underline;
}

.main_box01 li dl dd.scheduleTitleBox {
	height: auto;
}

dd.scheduleTitleBox span.scheduleDate {
	font-size: 10pt !important;
	color: #999;
	margin-right: 5px;
}
</style>
<script type="text/javascript">
function goSchedule() {
	window.parent.parent.addTab("SP_300", "일정관리", "/support/schedule/schedule.go", "", true);
}
</script>
</head>
<body>
	<ul class="main_box01">
		<li>
			<p>일정목록 <a href="#" onclick="goSchedule()">+ 전체보기</a></p>
			<dl>
				<c:forEach items="${resultList }" var="list" begin="0" end="4">
				<dd class="scheduleTitleBox">
					<span class="scheduleDate">${list.display_ymd }</span>
					<span class="scheduleTitle" onclick="goViewItem('${list.seq}')">${list.schedule_title }</span>
				</dd>
				</c:forEach>
			</dl>
		</li>
	</ul>
</body>
</html>