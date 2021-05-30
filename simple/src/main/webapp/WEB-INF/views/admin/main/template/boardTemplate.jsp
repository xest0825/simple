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

.boardTitle {
	cursor: pointer;
}

.boardTitle:hover {
	text-decoration: underline;
}
</style>
<script type="text/javascript">
function goBoard(board_no) {
	window.parent.parent.addTab("BD_000", "게시판", "/board/board/boardItem.go?board_no="+board_no, "게시판", "Y");
}

//상세보기
function goViewItem(item_no, board_no) {
	// 게시글 상세보기
	genexon.PopWindowOpen({
		pID    : "goItemViewPop"+item_no
        ,pTitle : "게시글 상세보기"
        ,pURL   : '/board/board/boardItemView.pop?${_csrf.parameterName}=${_csrf.token}'
        ,pWidth : "1000"
    	,pHeight : "770"
    	,position : {top:50, left:200}
		,data	: {item_no: item_no, board_no: board_no}
        ,pModal : true
    });
}
</script>
</head>
<body>
	<ul class="main_box01">
		<li>
			<p>${BoardView.board_nm } <a href="#" onclick="goBoard(${BoardView.board_no})">+ 전체보기</a></p>
			<dl>
				<c:forEach items="${BoardItemList }" var="list" begin="0" end="3">
				<dd class="boardTitleBox">
					<span>${list.in_dtm }</span>
					<b class="boardTitle" onclick="goViewItem('${list.item_no}', '${list.board_no}')">${list.title }</b>
					<!-- <a href="#">다운로드</a> -->
				</dd>
				</c:forEach>
			</dl>
		</li>
	</ul>
</body>
</html>