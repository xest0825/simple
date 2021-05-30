<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!DOCTYPE html>
<html>
<head>

<link rel="stylesheet" href="/resources/css/main.css" />
<link rel="stylesheet" href="/resources/css/swiper.min.css">
<style type="text/css">
.txt_h_01 {font-size: 21px;font-family:'Nanum Square' !important;font-weight: normal;color: #000;line-height: 1.3;position: absolute;
    top: 0; left: 0;text-align: left;}
.swiper-pagination {position: absolute;left: 0;top: 185px; text-align: left;}
.boardTitle {cursor: pointer;}
.boardTitle:hover {text-decoration: underline;}

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
dd.scheduleTitleBox span.scheduleDate {
	font-size: 10pt !important;
	color: #999;
	margin-right: 5px;
}

</style>
<script type="text/javascript">
$(document).ready(function(){

 	// 메인공지팝업
	if('${mainPopupList}' != '') {
		var mainPopupList = JSON.parse('${mainPopupList}');
		if(mainPopupList.length > 0) {
	        $.each(mainPopupList, function(i){
	    		if (getCookie('pop_'+mainPopupList[i].item_no) != 'checked') {
	        		goViewItemMain(mainPopupList[i].item_no, mainPopupList[i].board_no);
	    		}
	        });
		}
	}
});

//하루동안 표시안함 체크
function getCookie(name) {
	var nameOfCookie = name + "=";
	var x = 0;
	while (x <= document.cookie.length){
		var y = (x+nameOfCookie.length);

		if ( document.cookie.substring( x, y ) == nameOfCookie ) {
			if ((endOfCookie=document.cookie.indexOf( ";", y )) == -1)	endOfCookie = document.cookie.length;
			return unescape(document.cookie.substring( y, endOfCookie ));
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )	break;
	}
	return "";
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

// 일정 상세보기
function goViewItemschedule(seq) {
	genexon.PopWindowOpen({
		pID : "goViewItemschedulePop"
		,pTitle : "일정 확인"
		,pURL : "/support/schedule/scheduleView.pop?${_csrf.parameterName}=${_csrf.token}"
	    ,pWidth : "650"
	    ,pHeight : "400"
	    ,position : {top:300, left:700}
	    ,data	: {seq: seq}
        ,pModal : true
	});
}

// 메인공지팝업
function goViewItemMain(item_no, board_no) {
	genexon.PopWindowOpen({
		pID    : "goViewItemMainPop"+item_no
        ,pTitle : "메인 공지 팝업"
        ,pURL   : '/board/board/boardItemMainView.pop?${_csrf.parameterName}=${_csrf.token}'
        ,pWidth : "1000"
    	,pHeight : "670"
    	,position : {top:50, left:200}
		,data	: {item_no: item_no, board_no: board_no}
        ,pModal : true
    });
}

//이미지 링크 페이지 이동
function goLinkPage(link_gbn, url) {
	var serial = "";
		
	if(url != undefined && url != null) {
		url = url.replace("#", "");
	}
	
	if(link_gbn == "BOARD") {
		//게시글 팝업
		var item_no = "";
		var board_no = "";
		
		url.split(",").forEach(function(el, idx, arr) {
			var element = el.split(":");
			
			if(element[0] == "item_no") {
				item_no = element[1];
			}else if(element[0] == "board_no") {
				board_no = element[1];
			}
		});
		
		if(genexon.nvl(item_no, "") != "" && genexon.nvl(board_no, "") != "") {
			goViewItem(item_no, board_no);
		}
	}else if(link_gbn == "MENU") {
		//메뉴이동
		if(url.indexOf("overdueContract") != -1) {
			parent.addTab("CN_1100", "연체/실효 확인", "/contract/collectcontract/overdueContract.go", "계약관리 > 보유계약 > 연체/실효 확인", true);
		}else if(url.indexOf("contactNumber") != -1) {
			parent.addTab("HR_800", "연락처관리", "/insa/contactNumber/contactNumber.go", "인사관리 > 연락처관리", true);
		}else if(url.indexOf("expirationcontract") != -1) {
			parent.addTab("CN_140", "자동차/일반 만기확인", "/contract/existingcontract/expirationcontract.go", "계약관리 > 보유계약 > 자동차/일반 만기확인", true);
		}
	}else if(link_gbn == "ANYCAR") {
		//애니카 자동차 비교견적
		var params = {
			"MB_ID":"${User.mb_id}",
			"SK_ID":"${User.user_id}"
		};
		
		submitPost("http://anycar.genexon.co.kr/comm/ssologincheck.go", params);
	}else if(link_gbn == "FF") {
		parent.addTab("FACT_FINDER", "팩트파인더", "/comm/goLinkPage.go?pageUri=factfinder", "", true);
	}else if(link_gbn == "PCC") {
		url = "/api/pccMaster.go?${_csrf.parameterName}=${_csrf.token}";
		window.open(url, "_blank");
	}else if(link_gbn == "HUNET") {
		parent.addTab("HUNET", "휴넷", "/comm/goLinkPage.go?pageUri=HUNET", "", true);
	}else {
		if(genexon.nvl(url, "") != "") {
			window.open(url, "_blank");
		}
	}
}

//가입설계페이지 이동
function goInscoPage(url) {
	if(genexon.nvl(url, "") != "") {
		window.open(url, "_blank");
	}else {
		genexon.alert("info", "가입설계페이지", "보험사 관리 정보에 홈페이지 주소가 없습니다");
	}
}

//비교견적
function post_to_url(path, params, method) {
    method =  "post";

    var frm = document.createElement("form");
    frm.setAttribute("name", "form"+document.forms.length);
    frm.setAttribute("id", "form"+document.forms.length);
    frm.setAttribute("method", method);
    
    for(var key in params) {
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", key);
        hiddenField.setAttribute("value", params[key]);
        frm.appendChild(hiddenField);
    }
    
    document.body.appendChild(frm);
    
    window.open(path) ;
}

//마이매니저
function submitPost(url, params) {
	method = "post";
	var form = document.createElement("form");
	form.setAttribute("method", method);
	form.setAttribute("action", url);
	form.setAttribute("target", "_blank");
	
	for (var key in params) {
		var hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", key);
		hiddenField.setAttribute("value", params[key]);
		
		form.appendChild(hiddenField);
	}
	
	document.body.appendChild(form);
	form.submit();
}

// 파일다운로드
function downloadFile(url, file_nm) {
	$('#file_nm').val(file_nm);
	$('#file_path').val(url);
	$("#downform").submit();
}

//스케쥴 메뉴 이동
function goSchedule() {
	window.parent.parent.addTab("SP_300", "일정관리", "/support/schedule/schedule.go", "", true);
}

//인사관리 > 연락처관리메뉴 이동
function goInsaNumber() {
	window.parent.parent.addTab("HR_800", "연락처관리", "/insa/contactNumber/contactNumber.go", "", true);
}
// 게시판메뉴 이동
function goBoard(board_no) {
	window.parent.addTab("BD_000", "게시판", "/board/board/boardItem.go?board_no="+board_no, "게시판", "Y");
}
//연체/실효 확인매뉴이동
function overdueContract() {
	window.parent.addTab("CN_225", "연체/실효 확인", "/contract/collectcontract/overdueContract.go", "", true);
}
</script>
</head>
<body style="overflow-x: hidden;position:relative;">
<form name="downform" id="downform" method="post" action="/files/getFile.do?${_csrf.parameterName}=${_csrf.token}">
	<input type="hidden" name="file_nm" id="file_nm">
	<input type="hidden" name="file_path" id="file_path">
</form>
<!-- <img src="/resources/images/common/ic_promer.png" class="bypro"> -->
	<div id="wrap">
		<div id="container">
			<div class="new-wrapper">
				<div class="content" style="padding: 0px;">
					<div class="menu-trigger"></div>
					<div class="main_wrap" >메인 배경 이미지</div>
					<ul class="main_box01" style="margin-top: -230px;">
						<li class="main_box_ad01">
							<div class="swiper-container">
							    <div class="swiper-wrapper">
							      <div class="swiper-slide">
							      	<div class="txt_h_01">
										<span>혁신 금융 서비스</span><br />
										고객만을 생각하는 우리의 마음은 <br />
										앞으로도 변함없이 계속됩니다.
									</div>
							      </div>
							      <!-- <div class="swiper-slide">Slide 2</div>
							      <div class="swiper-slide">Slide 3</div> -->
							    </div>
							    <!-- Add Pagination -->
							    <div class="swiper-pagination"></div>
							</div>		
						</li>
						<c:forEach items="${templateMstList }" begin="1" end="2" var="list" varStatus="i">
						<li <c:if test="${list.main_board_type ne 'MAIN_IMAGE' }">style="overflow-y: auto;"</c:if> <c:if test="${i.index eq 2 }">class="mr0"</c:if> >
							<c:choose>
	                           <%-- 상단 이미지 링크형 시작 --%>
	                           <c:when test="${list.main_board_type eq 'MAIN_IMAGE' }">
	                              <script>
	                                 $(".main_box01").children().eq(${i.index}).css("padding", "0px");
	                              </script>
	                              <c:set var="MainImageTemplate" value="MainImageTemplate${i.index }"/>
	                              <c:if test="${fn:length(requestScope[MainImageTemplate]) eq 1 }">
	                                 <img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty01"  onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
	                              </c:if>
	                              <c:if test="${fn:length(requestScope[MainImageTemplate]) eq 2 }">
	                                 <img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty02"  onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty02"  onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;">
	                              </c:if>
	                              <c:if test="${fn:length(requestScope[MainImageTemplate]) eq 3 }">
	                                 <img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty03"  onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty03"  onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][2].file_url }" class="imgsty03"  onclick="goLinkPage('${requestScope[MainImageTemplate][2].link_gbn}', '${requestScope[MainImageTemplate][2].link_url}')" style="cursor: pointer;">
	                              </c:if>
	                              <c:if test="${fn:length(requestScope[MainImageTemplate]) eq 4 }">
	                                 <img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty04" onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty04" onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;"><br/>
	                                 <img src="${requestScope[MainImageTemplate][2].file_url }" class="imgsty04" onclick="goLinkPage('${requestScope[MainImageTemplate][2].link_gbn}', '${requestScope[MainImageTemplate][2].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][3].file_url }" class="imgsty04" onclick="goLinkPage('${requestScope[MainImageTemplate][3].link_gbn}', '${requestScope[MainImageTemplate][3].link_url}')" style="cursor: pointer;">
	                              </c:if>
	                              <c:if test="${fn:length(requestScope[MainImageTemplate]) eq 5 }">
	                                 <img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][2].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][2].link_gbn}', '${requestScope[MainImageTemplate][2].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][3].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][3].link_gbn}', '${requestScope[MainImageTemplate][3].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][4].file_url }" class="imgsty03" onclick="goLinkPage('${requestScope[MainImageTemplate][4].link_gbn}', '${requestScope[MainImageTemplate][4].link_url}')" style="cursor: pointer;">
	                              </c:if>
	                              <c:if test="${fn:length(requestScope[MainImageTemplate]) eq 6 }">
	                                 <img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][2].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][2].link_gbn}', '${requestScope[MainImageTemplate][2].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][3].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][3].link_gbn}', '${requestScope[MainImageTemplate][3].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][4].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][4].link_gbn}', '${requestScope[MainImageTemplate][4].link_url}')" style="cursor: pointer;">
	                                 <img src="${requestScope[MainImageTemplate][5].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][5].link_gbn}', '${requestScope[MainImageTemplate][5].link_url}')" style="cursor: pointer;">
	                              </c:if>
	                           </c:when>
	                           <%-- 상단 이미지 링크형 끝--%>
	                           <%-- 상단 게시판형 시작--%>
	                           <c:when test="${list.main_board_type eq 'MAIN_BOARD' }">
	                              <c:set var="BoardView" value="BoardView${i.index }"/>
	                              <c:set var="BoardTemplate" value="BoardTemplate${i.index }"/>
	                              <p>${requestScope[BoardView].board_nm } <a href="#" onclick="goBoard(${requestScope[BoardView].board_no})">+ 전체보기</a></p>
	                              <dl>
	                                 <c:forEach items="${requestScope[BoardTemplate] }" var="boardList" begin="0" end="3">
	                                 <dd class="boardTitleBox">
	                                    <span>${boardList.in_dtm }</span>
	                                    <b class="boardTitle" onclick="goViewItem('${boardList.item_no}', '${boardList.board_no}')">${boardList.title }</b>
	                                 </dd>
	                                 </c:forEach>
	                              </dl>
	                           </c:when>
	                           <%-- 상단 게시판형 끝 --%>
	                           <%-- 상단 통계형 시작 --%>
							   <c:when test="${list.main_board_type eq 'MAIN_STATISTICS' }">
	                              <c:choose>
	                                 <c:when test="${fn:contains(list.template_code, 'OUTCOME_') and not fn:contains(list.template_code, 'OUTCOME_LV') }">
	                                    <c:set var="MAIN_STATISTICS_OUTCOME" value="MAIN_STATISTICS_OUTCOME${i.index }"/>
	                                    <c:if test="${fn:contains(list.template_code, 'ALL') }">
	                                       <p>이달의 성과</p>
	                                    </c:if>
	                                    <c:if test="${fn:contains(list.template_code, 'SCD') }">
	                                       <p>이달의 성과(조직별)</p>
	                                    </c:if>
	                                    <c:if test="${fn:contains(list.template_code, 'FC') }">
	                                       <p>이달의 성과(FC)</p>
	                                    </c:if>
	                                    <span class="ttxt01">(단위 : 만원)</span>
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
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_month_longterm_prem_amt }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_last_month_longterm_prem_amt }</fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].life_longterm_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                          <tr>
	                                             <td class="tal">생보일시납</td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_month_ilsi_prem_amt }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_last_month_ilsi_prem_amt }</fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].life_ilsi_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                          <tr>
	                                             <td class="tal">손보장기</td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_month_longterm_prem_amt }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_last_month_longterm_prem_amt }</fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_longterm_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                          <tr>
	                                             <td class="tal">손보자동차</td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_month_car_prem_amt }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_last_month_car_prem_amt} </fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_car_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                          <tr>
	                                             <td class="tal">손보일반</td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_month_general_prem_amt }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_last_month_general_prem_amt }</fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_general_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                       </tbody>
	                                    </table>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'OUTCOMETYPE2') }">
	                                    <c:set var="MAIN_STATISTICS_OUTCOME" value="MAIN_STATISTICS_OUTCOME${i.index }"/>
	                                    <c:if test="${fn:contains(list.template_code, 'ALL') }">
	                                       <p>이달의 성과</p>
	                                    </c:if>
	                                    <c:if test="${fn:contains(list.template_code, 'SCD') }">
	                                       <p>이달의 성과(조직별)</p>
	                                    </c:if>
	                                    <c:if test="${fn:contains(list.template_code, 'FC') }">
	                                       <p>이달의 성과(FC)</p>
	                                    </c:if>
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
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].sum_month_logterm_cnt }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].sum_last_month_logterm_cnt }</fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].sum_logterm_cnt_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                          <tr>
	                                             <td class="tal">생보환산</td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_month_longterm_hwan }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_last_month_longterm_hwan }</fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].life_longterm_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                          <tr>
	                                             <td class="tal">손보환산</td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_month_longterm_hwan }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_last_month_longterm_hwan }</fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_longterm_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                          <tr>
	                                             <td class="tal">환산합계</td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].sum_month_logterm_hwan }</fmt:formatNumber></td>
	                                             <td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].sum_last_month_logterm_hwan} </fmt:formatNumber></td>
	                                             <td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].sum_logterm_hwan_progress_rate }</fmt:formatNumber>%</td>
	                                          </tr>
	                                       </tbody>
	                                    </table>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'FCRANK') }">
	                                    <c:set var="MAIN_STATISTICS_LONGTERM" value="MAIN_STATISTICS_LONGTERM${i.index }"/>
	                                    <c:set var="MAIN_STATISTICS_CAR" value="MAIN_STATISTICS_CAR${i.index }"/>
	                                    <c:set var="MAIN_STATISTICS_ILBAN" value="MAIN_STATISTICS_ILBAN${i.index }"/>
	                                    <p>FC순위</p>
	                                    <span class="ttxt01">(단위 : 천원, 건)</span>
	                                    <!-- FC순위 AT에셋 : 장기 FC순위
	                                         그 외 : 장기, 자동차, 일반 FC순위 -->
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
	                                                      <th>FC</th>
	                                                      <th>보험료</th>
	                                                      <th class="br0">건수</th>
	                                                   </tr>
	                                                </thead>
	                                                <tbody>
	                                                   <c:forEach items="${requestScope[MAIN_STATISTICS_LONGTERM] }" begin="0" end="3" var="longTermList">
	                                                   <tr>
	                                                      <td class="tal">${longTermList.snm }</td>
	                                                      <td class="tal">${longTermList.emp_nm }</td>
	                                                      <td><fmt:formatNumber pattern="#,###">${longTermList.share_longterm_prem_amt / 1000 }</fmt:formatNumber></td>
	                                                      <td class="br0"><fmt:formatNumber pattern="#,###">${longTermList.cont_longterm_cnt }</fmt:formatNumber></td>
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
	                                                      <th>FC</th>
	                                                      <th>보험료</th>
	                                                      <th class="br0">건수</th>
	                                                   </tr>
	                                                </thead>
	                                                <tbody>
	                                                   <c:forEach items="${requestScope[MAIN_STATISTICS_CAR] }" begin="0" end="3" var="carList">
	                                                   <tr>
	                                                      <td class="tal">${carList.snm }</td>
	                                                      <td class="tal">${carList.emp_nm }</td>
	                                                      <td><fmt:formatNumber pattern="#,###">${carList.share_non_life_car_prem_amt / 1000 }</fmt:formatNumber></td>
	                                                      <td class="br0"><fmt:formatNumber pattern="#,###">${carList.share_non_life_car_cnt }</fmt:formatNumber></td>
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
	                                                      <th>FC</th>
	                                                      <th>보험료</th>
	                                                      <th class="br0">건수</th>
	                                                   </tr>
	                                                </thead>
	                                                <tbody>
	                                                   <c:forEach items="${requestScope[MAIN_STATISTICS_ILBAN] }" begin="0" end="3" var="ilbanList">
	                                                   <tr>
	                                                      <td class="tal">${ilbanList.snm }</td>
	                                                      <td class="tal">${ilbanList.emp_nm }</td>
	                                                      <td><fmt:formatNumber pattern="#,###">${ilbanList.share_non_life_general_prem_amt / 1000 }</fmt:formatNumber></td>
	                                                      <td class="br0"><fmt:formatNumber pattern="#,###">${ilbanList.share_non_life_general_cnt }</fmt:formatNumber></td>
	                                                   </tr>
	                                                   </c:forEach>
	                                                </tbody>
	                                             </table>
	                                          </section>
	                                       </main>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'SCDRANK') }">
	                                    <c:set var="MAIN_STATISTICS_SCD" value="MAIN_STATISTICS_SCD${i.index }"/>
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
	                                             <c:forEach items="${requestScope[MAIN_STATISTICS_SCD] }" begin="0" end="3" var="scdRanklist">
	                                             <tr>
	                                                <td class="tal">${scdRanklist.snm }</td>
	                                                <td><fmt:formatNumber pattern="#,###">${scdRanklist.longterm_prem_amt / 1000 }</fmt:formatNumber></td>
	                                                <td><fmt:formatNumber pattern="#,###">${scdRanklist.cont_longterm_cnt }</fmt:formatNumber></td>
	                                                <td class="br0"><fmt:formatNumber pattern="#,###">${scdRanklist.longterm_hwan / 1000 }</fmt:formatNumber></td>
	                                             </tr>
	                                             </c:forEach>
	                                          </tbody>
	                                       </table>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'EXPR_CONT_CNT') }">
	                                    <c:set var="EXPR_CONT_CNT" value="EXPR_CONT_CNT${i.index }"/>
	                                    <p>갱신계약 <a href="#" onclick="goLinkPage('MENU', 'expirationcontract')">+ 전체보기</a></p>
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
	                                          <c:forEach items="${requestScope[EXPR_CONT_CNT] }" var="list" begin="0" end="1">
	                                          <tr>
	                                             <td class="tal">${list.ins_cont_type_nm }</td>
	                                             <td><fmt:formatNumber value="${list.this_month_cnt }" pattern="#,###" /></td>
	                                             <td class="br0"><fmt:formatNumber value="${list.next_month_cnt }" pattern="#,###" /></td>
	                                          </tr>
	                                          </c:forEach>
	                                       </tbody>
	                                    </table>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'OUTCOME_LV') }">
	                                    <c:set var="OUTCOME_LV" value="OUTCOME_LV${i.index }"/>
	                                    <p>${requestScope[OUTCOME_LV][0].title }</p>
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
	                                          <c:forEach items="${requestScope[OUTCOME_LV] }" var="list">
	                                             <tr>
	                                                <td class="tal">${list.snm }</td>
	                                                <td><fmt:formatNumber value="${list.month_prem_amt }" pattern="#,###" /></td>
	                                                <td><fmt:formatNumber value="${list.hwan }" pattern="#,###" /></td>
	                                                <td class="br0"><fmt:formatNumber value="${list.non_longterm_prem_amt }" pattern="#,###" /></td>
	                                             </tr>
	                                          </c:forEach>
	                                       </tbody>
	                                    </table>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'TM_NEW_CONT') }">
	                                    <c:set var="TM_NEW_CONT" value="TM_NEW_CONT${i.index }"/>
	                                    <p>당월 신계약</p>
	                                    <span class="ttxt01"></span>
	                                    <table class="table_st1">
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
	                                          <c:forEach items="${requestScope[TM_NEW_CONT] }" var="list">
	                                             <tr>
	                                                <td class="tal">${list.insco_nm }</td>
	                                                <td class="tal">${list.policyholder }</td>
	                                                <td class="br0"><fmt:formatNumber value="${list.prem_amt }" pattern="#,###" /></td>
	                                             </tr>
	                                          </c:forEach>
	                                       </tbody>
	                                    </table>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'OVERDUE_CONT') }">
	                                    <c:set var="OVERDUE_CONT" value="OVERDUE_CONT${i.index }"/>
	                                    <p>미유지(실효예정)</p>
	                                    <span class="ttxt01">(단위 : 천원)</span>
	                                    <table class="table_st1">
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
	                                          <c:forEach items="${requestScope[OVERDUE_CONT] }" var="list">
	                                             <tr>
	                                                <td class="tal">${list.insco_nm }</td>
	                                                <td class="tal">${list.policyholder }</td>
	                                                <td class="br0"><fmt:formatNumber value="${list.prem_amt }" pattern="#,###" /></td>
	                                             </tr>
	                                          </c:forEach>
	                                       </tbody>
	                                    </table>
	                                 </c:when>
	                              </c:choose>
	                           </c:when>
	                           <%-- 상단 통계형 끝 --%>
	                           <%-- 상단 차트형 시작 --%>
	                           <c:when test="${list.main_board_type eq 'MAIN_CONTRACT_CHART' }">
	                              <c:choose>
	                                 <c:when test="${fn:contains(list.template_code, 'FC_CNT') }">
	                                    <p>보유계약 현황(FC)</p>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'ORG_CNT') }">
	                                    <p>보유계약 현황(조직)</p>
	                                 </c:when>
	                                 <c:when test="${fn:contains(list.template_code, 'TOTAL_CNT') }">
	                                    <p>보유계약 현황(회사)</p>
	                                 </c:when>
	                              </c:choose>
	                              <span class="ttxt01">(단위 : 건)</span>
	                              <c:set var="MAIN_CONTRACT_CHART" value="MAIN_CONTRACT_CHART${i.index }"/>
	                              <div style="height: 85%;">
	                                 <div id="chart${i.index }" style="height: 221px;"></div>
	                              </div>
	                              <script>
	                                 var idx = "${i.index }";
	                                 var center;
	                                 var radius;
	                              
	                                 $("#chart"+idx).kendoChart({
	                                    legend: {
	                                       visible: true,
	                                       position: "bottom"
	                                    },
	                                    seriesDefaults: {
	                                            type: "donut",
	                                            startAngle: 90,
	                                            holeSize: 35,
	                                            labels: {
	                                                visible: true,
	                                                position: "center",
	                                                background: "transparent",
	                                                font: "16px sans-serif",
	                                                color: "#ffffff",
	                                                format: "{0:n0}"
	                                            },
	                                             background: "transparent"
	                                        },
	                                        chartArea: {
	                                          background: "transparent"
	                                        },
	                                        series: [
	                                          {
	                                             size: 55,
	                                             data: [
	                                                {
	                                                      category: "${requestScope[MAIN_CONTRACT_CHART][1].cont_status}",  /* 정상 */
	                                                      value: ${requestScope[MAIN_CONTRACT_CHART][1].cont_cnt},
	                                                      color: "#0063b8"
	                                                  },
	                                                  {
	                                                      category: "${requestScope[MAIN_CONTRACT_CHART][2].cont_status}",  /* 연체 */
	                                                      value: ${requestScope[MAIN_CONTRACT_CHART][2].cont_cnt},
	                                                      color: "#25b9f7"
	                                                  },
	                                                  {
	                                                      category: "${requestScope[MAIN_CONTRACT_CHART][3].cont_status}",  /* 실효 */
	                                                      value: ${requestScope[MAIN_CONTRACT_CHART][3].cont_cnt},
	                                                      color: "#9fd5f9"
	                                                  }
	                                             ],
	                                                visual: function(e) {
	                                                  center = e.center;
	                                                  radius = e.radius;
	
	                                                  return e.createVisual();
	                                                }
	                                          }
	                                        ],
	                                        tooltip: {
	                                            visible: true,
	                                            template: "#= category # - #= genexon.formatComma(value) #",
	                                            color: "white"
	                                        },
	                                        render: function(e) {
	                                          var draw = kendo.drawing;
	                                            var geom = kendo.geometry;
	                                            var chart = e.sender;
	                                            var textStr = genexon.formatComma("${requestScope[MAIN_CONTRACT_CHART][0].cont_cnt}");
	
	                                            var circleGeometry = new geom.Circle(center, radius);
	                                            var bbox = circleGeometry.bbox();
	
	                                            var text = new draw.Text(textStr, [0, 0], {
	                                             font: "bold 17px sans-serif"
	                                            });
	
	                                            draw.align([text], bbox, "center");
	                                            draw.vAlign([text], bbox, "center");
	
	                                            e.sender.surface.draw(text);
	                                        }
	                                 });
	                              </script>
	                           </c:when>
	                           <%-- 상단 차트형 끝 --%>
	                           <%-- 상단 일정목록 시작--%>
	                           <c:when test="${list.main_board_type eq 'MAIN_SCHEDULE' }">
	                              <c:set var="mainTemplate" value="MAIN_SCHEDULE${i.index }"/>
	                              <p>일정목록 <a href="#" onclick="goSchedule()">+ 전체보기</a></p>
	                              <dl>
	                                 <c:forEach items="${requestScope[mainTemplate]}" var="list" begin="0" end="3">
	                                 <dd class="scheduleTitleBox">
	                                    <span class="scheduleDate">${list.display_ymd }</span>
	                                    <span class="scheduleTitle" onclick="goViewItemschedule('${list.seq}')">${list.schedule_title }</span>
	                                 </dd>
	                                 </c:forEach>
	                              </dl>
	                           </c:when>
	                           <%-- 상단 일정목록 끝 --%>
	                        </c:choose>
	                     </li>
	                     </c:forEach>
					</ul><!-- //class="main_box01" -->
					<ul class="main_box01" style="margin-top: 25px">
						<c:forEach items="${templateMstList }"  begin="3" end="5" var="list" varStatus="i">
						<li style="<c:if test="${i.index eq 3 }">margin-right: 260px; </c:if> <c:if test="${list.main_board_type ne 'MAIN_IMAGE' }">overflow-y: auto;</c:if>" <c:if test="${i.index eq 5 }">class="mr0"</c:if>  >
							<c:if test="${list.template_code ne null or list.template_code ne ''}">
								<c:choose>
									<%-- 하단 이미지 링크형 시작 --%>
									<c:when test="${list.main_board_type eq 'MAIN_IMAGE' }">
										<script>
											$(".main_box01").children().eq(${i.index}).css("padding", "0px");
										</script>
										<c:set var="MainImageTemplate" value="MainImageTemplate${i.index }"/>
										<c:if test="${fn:length(requestScope[MainImageTemplate]) eq 1 }">
											<img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty01"  onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
										</c:if>
										<c:if test="${fn:length(requestScope[MainImageTemplate]) eq 2 }">
											<img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty02"  onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty02"  onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;">
										</c:if>
										<c:if test="${fn:length(requestScope[MainImageTemplate]) eq 3 }">
											<img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty03"  onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty03"  onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][2].file_url }" class="imgsty03"  onclick="goLinkPage('${requestScope[MainImageTemplate][2].link_gbn}', '${requestScope[MainImageTemplate][2].link_url}')" style="cursor: pointer;">
										</c:if>
										<c:if test="${fn:length(requestScope[MainImageTemplate]) eq 4 }">
											<img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty04" onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty04" onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;"><br/>
											<img src="${requestScope[MainImageTemplate][2].file_url }" class="imgsty04" onclick="goLinkPage('${requestScope[MainImageTemplate][2].link_gbn}', '${requestScope[MainImageTemplate][2].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][3].file_url }" class="imgsty04" onclick="goLinkPage('${requestScope[MainImageTemplate][3].link_gbn}', '${requestScope[MainImageTemplate][3].link_url}')" style="cursor: pointer;">
										</c:if>
										<c:if test="${fn:length(requestScope[MainImageTemplate]) eq 5 }">
											<img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][2].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][2].link_gbn}', '${requestScope[MainImageTemplate][2].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][3].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][3].link_gbn}', '${requestScope[MainImageTemplate][3].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][4].file_url }" class="imgsty03" onclick="goLinkPage('${requestScope[MainImageTemplate][4].link_gbn}', '${requestScope[MainImageTemplate][4].link_url}')" style="cursor: pointer;">
										</c:if>
										<c:if test="${fn:length(requestScope[MainImageTemplate]) eq 6 }">
											<img src="${requestScope[MainImageTemplate][0].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][0].link_gbn}', '${requestScope[MainImageTemplate][0].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][1].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][1].link_gbn}', '${requestScope[MainImageTemplate][1].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][2].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][2].link_gbn}', '${requestScope[MainImageTemplate][2].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][3].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][3].link_gbn}', '${requestScope[MainImageTemplate][3].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][4].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][4].link_gbn}', '${requestScope[MainImageTemplate][4].link_url}')" style="cursor: pointer;">
											<img src="${requestScope[MainImageTemplate][5].file_url }" class="imgsty06" onclick="goLinkPage('${requestScope[MainImageTemplate][5].link_gbn}', '${requestScope[MainImageTemplate][5].link_url}')" style="cursor: pointer;">
										</c:if>
									</c:when>
									<%-- 하단 이미지 링크형 끝--%>
									<%-- 하단 게시판형 시작--%>
									<c:when test="${list.main_board_type eq 'MAIN_BOARD' }">
										<c:set var="BoardView" value="BoardView${i.index }"/>
										<c:set var="BoardTemplate" value="BoardTemplate${i.index }"/>
										<p>${requestScope[BoardView].board_nm } <a href="#" onclick="goBoard(${requestScope[BoardView].board_no})">+ 전체보기</a></p>
										<dl>
											<c:forEach items="${requestScope[BoardTemplate] }" var="boardList" begin="0" end="3">
											<dd class="boardTitleBox">
												<span>${boardList.in_dtm }</span>
												<b class="boardTitle" onclick="goViewItem('${boardList.item_no}', '${boardList.board_no}')">${boardList.title }</b>
											</dd>
											</c:forEach>
										</dl>
									</c:when>
									<%-- 하단 게시판형 끝 --%>
									<%-- 하단 통계형 시작 --%>
									<c:when test="${list.main_board_type eq 'MAIN_STATISTICS' }">
										<c:choose>
											<c:when test="${fn:contains(list.template_code, 'OUTCOME_') }">
												<c:set var="MAIN_STATISTICS_OUTCOME" value="MAIN_STATISTICS_OUTCOME${i.index }"/>
												<c:if test="${fn:contains(list.template_code, 'ALL') }">
													<p>이달의 성과</p>
												</c:if>
												<c:if test="${fn:contains(list.template_code, 'SCD') }">
													<p>이달의 성과(조직별)</p>
												</c:if>
												<c:if test="${fn:contains(list.template_code, 'FC') }">
													<p>이달의 성과(FC)</p>
												</c:if>
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
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_month_longterm_prem_amt }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_last_month_longterm_prem_amt }</fmt:formatNumber></td>
															<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].life_longterm_progress_rate }</fmt:formatNumber>%</td>
														</tr>
														<tr>
															<td class="tal">생보일시납</td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_month_ilsi_prem_amt }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_last_month_ilsi_prem_amt }</fmt:formatNumber></td>
												  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].life_ilsi_progress_rate }</fmt:formatNumber>%</td>
														</tr>
														<tr>
												  			<td class="tal">손보장기</td>
												  			<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_month_longterm_prem_amt }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_last_month_longterm_prem_amt }</fmt:formatNumber></td>
												  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_longterm_progress_rate }</fmt:formatNumber>%</td>
														</tr>
														<tr>
												  			<td class="tal">손보자동차</td>
												  			<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_month_car_prem_amt }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_last_month_car_prem_amt} </fmt:formatNumber></td>
												  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_car_progress_rate }</fmt:formatNumber>%</td>
														</tr>
														<tr>
															<td class="tal">손보일반</td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_month_general_prem_amt }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_last_month_general_prem_amt }</fmt:formatNumber></td>
															<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_general_progress_rate }</fmt:formatNumber>%</td>
														</tr>
													</tbody>
												</table>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'OUTCOMETYPE2') }">
												<c:set var="MAIN_STATISTICS_OUTCOME" value="MAIN_STATISTICS_OUTCOME${i.index }"/>
												<c:if test="${fn:contains(list.template_code, 'ALL') }">
													<p>이달의 성과</p>
												</c:if>
												<c:if test="${fn:contains(list.template_code, 'SCD') }">
													<p>이달의 성과(조직별)</p>
												</c:if>
												<c:if test="${fn:contains(list.template_code, 'FC') }">
													<p>이달의 성과(FC)</p>
												</c:if>
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
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].sum_month_logterm_cnt }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].sum_last_month_logterm_cnt }</fmt:formatNumber></td>
															<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].sum_logterm_cnt_progress_rate }</fmt:formatNumber>%</td>
														</tr>
														<tr>
															<td class="tal">생보환산</td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_month_longterm_hwan }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].life_last_month_longterm_hwan }</fmt:formatNumber></td>
												  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].life_longterm_progress_rate }</fmt:formatNumber>%</td>
														</tr>
														<tr>
												  			<td class="tal">손보환산</td>
												  			<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_month_longterm_hwan }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_last_month_longterm_hwan }</fmt:formatNumber></td>
												  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].non_life_longterm_progress_rate }</fmt:formatNumber>%</td>
														</tr>
														<tr>
												  			<td class="tal">환산합계</td>
												  			<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].sum_month_logterm_hwan }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${requestScope[MAIN_STATISTICS_OUTCOME].sum_last_month_logterm_hwan} </fmt:formatNumber></td>
												  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${requestScope[MAIN_STATISTICS_OUTCOME].sum_logterm_hwan_progress_rate }</fmt:formatNumber>%</td>
														</tr>
													</tbody>
												</table>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'FCRANK') }">
												<c:set var="MAIN_STATISTICS_LONGTERM" value="MAIN_STATISTICS_LONGTERM${i.index }"/>
												<c:set var="MAIN_STATISTICS_CAR" value="MAIN_STATISTICS_CAR${i.index }"/>
												<c:set var="MAIN_STATISTICS_ILBAN" value="MAIN_STATISTICS_ILBAN${i.index }"/>
												<p>FC순위</p>
												<span class="ttxt01">(단위 : 천원, 건)</span>
												<!-- FC순위 AT에셋 : 장기 FC순위
													  그 외 : 장기, 자동차, 일반 FC순위 -->
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
																	<th>FC</th>
																	<th>보험료</th>
																	<th class="br0">건수</th>
																</tr>
															</thead>
															<tbody>
																<c:forEach items="${requestScope[MAIN_STATISTICS_LONGTERM] }" begin="0" end="3" var="longTermList">
																<tr>
																	<td class="tal">${longTermList.snm }</td>
																	<td class="tal">${longTermList.emp_nm }</td>
																	<td><fmt:formatNumber pattern="#,###">${longTermList.share_longterm_prem_amt / 1000 }</fmt:formatNumber></td>
																	<td class="br0"><fmt:formatNumber pattern="#,###">${longTermList.cont_longterm_cnt }</fmt:formatNumber></td>
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
																	<th>FC</th>
																	<th>보험료</th>
																	<th class="br0">건수</th>
																</tr>
															</thead>
															<tbody>
																<c:forEach items="${requestScope[MAIN_STATISTICS_CAR] }" begin="0" end="3" var="carList">
																<tr>
																	<td class="tal">${carList.snm }</td>
																	<td class="tal">${carList.emp_nm }</td>
																	<td><fmt:formatNumber pattern="#,###">${carList.share_non_life_car_prem_amt / 1000 }</fmt:formatNumber></td>
																	<td class="br0"><fmt:formatNumber pattern="#,###">${carList.share_non_life_car_cnt }</fmt:formatNumber></td>
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
																	<th>FC</th>
																	<th>보험료</th>
																	<th class="br0">건수</th>
																</tr>
															</thead>
															<tbody>
																<c:forEach items="${requestScope[MAIN_STATISTICS_ILBAN] }" begin="0" end="3" var="ilbanList">
																<tr>
																	<td class="tal">${ilbanList.snm }</td>
																	<td class="tal">${ilbanList.emp_nm }</td>
																	<td><fmt:formatNumber pattern="#,###">${ilbanList.share_non_life_general_prem_amt / 1000 }</fmt:formatNumber></td>
																	<td class="br0"><fmt:formatNumber pattern="#,###">${ilbanList.share_non_life_general_cnt }</fmt:formatNumber></td>
																</tr>
																</c:forEach>
															</tbody>
														</table>
													</section>
												</main>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'SCDRANK') }">
												<c:set var="MAIN_STATISTICS_SCD" value="MAIN_STATISTICS_SCD${i.index }"/>
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
											        	<c:forEach items="${requestScope[MAIN_STATISTICS_SCD] }" begin="0" end="3" var="scdRanklist">
														<tr>
															<td class="tal">${scdRanklist.snm }</td>
															<td><fmt:formatNumber pattern="#,###">${scdRanklist.longterm_prem_amt / 1000 }</fmt:formatNumber></td>
															<td><fmt:formatNumber pattern="#,###">${scdRanklist.cont_longterm_cnt }</fmt:formatNumber></td>
															<td class="br0"><fmt:formatNumber pattern="#,###">${scdRanklist.longterm_hwan / 1000 }</fmt:formatNumber></td>
														</tr>
														</c:forEach>
													</tbody>
												</table>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'EXPR_CONT_CNT') }">
												<c:set var="EXPR_CONT_CNT" value="EXPR_CONT_CNT${i.index }"/>
												<p>갱신계약 <a href="#" onclick="goLinkPage('MENU', 'expirationcontract')">+ 전체보기</a></p>
												<span class="ttxt01">(단위 : 건)</span>
												<table class="table_st1" style="height:80%">
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
														<c:forEach items="${requestScope[EXPR_CONT_CNT] }" var="list" begin="0" end="1">
														<tr>
															<td class="tal">${list.ins_cont_type_nm }</td>
															<td><fmt:formatNumber value="${list.this_month_cnt }" pattern="#,###" /></td>
															<td class="br0"><fmt:formatNumber value="${list.next_month_cnt }" pattern="#,###" /></td>
														</tr>
														</c:forEach>
													</tbody>
												</table>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'OUTCOME_LV') }">
												<c:set var="OUTCOME_LV" value="OUTCOME_LV${i.index }"/>
												<p>${requestScope[OUTCOME_LV][0].title }</p>
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
														<c:forEach items="${requestScope[OUTCOME_LV] }" var="list">
															<tr>
																<td class="tal">${list.snm }</td>
																<td><fmt:formatNumber value="${list.month_prem_amt }" pattern="#,###" /></td>
																<td><fmt:formatNumber value="${list.hwan }" pattern="#,###" /></td>
																<td class="br0"><fmt:formatNumber value="${list.non_longterm_prem_amt }" pattern="#,###" /></td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'TM_NEW_CONT') }">
												<c:set var="TM_NEW_CONT" value="TM_NEW_CONT${i.index }"/>
												<p>당월 신계약</p>
												<span class="ttxt01"></span>
												<table class="table_st1">
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
														<c:forEach items="${requestScope[TM_NEW_CONT] }" var="list">
															<tr>
																<td class="tal">${list.insco_nm }</td>
																<td class="tal">${list.policyholder }</td>
																<td class="br0"><fmt:formatNumber value="${list.prem_amt }" pattern="#,###" /></td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'OVERDUE_CONT') }">
												<c:set var="OVERDUE_CONT" value="OVERDUE_CONT${i.index }"/>
												<p>미유지(실효예정)</p>
												<span class="ttxt01"></span>
												<table class="table_st1">
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
														<c:forEach items="${requestScope[OVERDUE_CONT] }" var="list">
															<tr>
																<td class="tal">${list.insco_nm }</td>
																<td class="tal">${list.policyholder }</td>
																<td class="br0"><fmt:formatNumber value="${list.prem_amt }" pattern="#,###" /></td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</c:when>
										</c:choose>
									</c:when>
									<%-- 하단 통계형 끝 --%>
									<%-- 하단 차트형 시작 --%>
									<c:when test="${list.main_board_type eq 'MAIN_CONTRACT_CHART' }">
										<c:choose>
											<c:when test="${fn:contains(list.template_code, 'FC_CNT') }">
												<p>보유계약 현황(FC)</p>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'ORG_CNT') }">
												<p>보유계약 현황(조직)</p>
											</c:when>
											<c:when test="${fn:contains(list.template_code, 'TOTAL_CNT') }">
												<p>보유계약 현황(회사)</p>
											</c:when>
										</c:choose>
										<span class="ttxt01">(단위 : 건)</span>
										<c:set var="MAIN_CONTRACT_CHART" value="MAIN_CONTRACT_CHART${i.index }"/>
										<div style="height: 85%;">
											<div id="chart${i.index }" style="height: 221px;"></div>
										</div>
        								<script>
        									var idx = "${i.index }";
        									var center;
        									var radius;
        								
											$("#chart"+idx).kendoChart({
												legend: {
													visible: true,
													position: "bottom"
												},
												seriesDefaults: {
								                    type: "donut",
								                    startAngle: 90,
								                    holeSize: 35,
								                    labels: {
								                        visible: true,
								                        position: "center",
								                        background: "transparent",
								                        font: "16px sans-serif",
								                        color: "#ffffff",
								                        format: "{0:n0}"
								                    },
							                        background: "transparent"
								                },
								                chartArea: {
								                	background: "transparent"
								                },
								                series: [
								                	{
								                		size: 55,
								                		data: [
									                    	{
										                        category: "${requestScope[MAIN_CONTRACT_CHART][1].cont_status}",	/* 정상 */
										                        value: ${requestScope[MAIN_CONTRACT_CHART][1].cont_cnt},
										                        color: "#0063b8"
										                    },
										                    {
										                        category: "${requestScope[MAIN_CONTRACT_CHART][2].cont_status}",	/* 연체 */
										                        value: ${requestScope[MAIN_CONTRACT_CHART][2].cont_cnt},
										                        color: "#25b9f7"
										                    },
										                    {
										                        category: "${requestScope[MAIN_CONTRACT_CHART][3].cont_status}",	/* 실효 */
										                        value: ${requestScope[MAIN_CONTRACT_CHART][3].cont_cnt},
										                        color: "#9fd5f9"
										                    }
								                    	],
								                        visual: function(e) {
								                          center = e.center;
								                          radius = e.radius;

								                          return e.createVisual();
								                        }
								                	}
								                ],
								                tooltip: {
								                    visible: true,
								                    template: "#= category # - #= genexon.formatComma(value) #",
								                    color: "white"
								                },
								                render: function(e) {
								                	var draw = kendo.drawing;
								                    var geom = kendo.geometry;
								                    var chart = e.sender;
								                    var textStr = genexon.formatComma("${requestScope[MAIN_CONTRACT_CHART][0].cont_cnt}");

								                    var circleGeometry = new geom.Circle(center, radius);
								                    var bbox = circleGeometry.bbox();

								                    var text = new draw.Text(textStr, [0, 0], {
								                    	font: "bold 17px sans-serif"
								                    });

								                    draw.align([text], bbox, "center");
								                    draw.vAlign([text], bbox, "center");

								                    e.sender.surface.draw(text);
								                }
											});
										</script>
									</c:when>
									<%-- 하단 차트형 끝 --%>
									<%-- 하단 일정목록 시작--%>
									<c:when test="${list.main_board_type eq 'MAIN_SCHEDULE' }">
										<c:set var="mainTemplate" value="MAIN_SCHEDULE${i.index }"/>
										<p>일정목록 <a href="#" onclick="goSchedule()">+ 전체보기</a></p>
										<dl>
											<c:forEach items="${requestScope[mainTemplate]}" var="list" begin="0" end="3">
											<dd class="scheduleTitleBox">
												<span class="scheduleDate">${list.display_ymd }</span>
												<span class="scheduleTitle" onclick="goViewItemschedule('${list.seq}')">${list.schedule_title }</span>
											</dd>
											</c:forEach>
										</dl>
									</c:when>
									<%-- 하단 일정목록 끝 --%>
								</c:choose>
							</c:if>
						</li>
						</c:forEach>
					</ul><!-- //class="main_box01" -->
				</div><!-- // class="content"-->
			</div><!-- //class="new-wrapper" -->
		</div><!-- //id="container" -->
	</div><!--//wrap  -->
	<!-- <script>
	    var swiper = new Swiper('.swiper-container', {
	      pagination: {
	        el: '.swiper-pagination',
	      },
	    });
	  </script> -->
	  <script src="/resources/js/common/swiper.min.js"></script>
  <!-- Initialize Swiper -->
  <script>
    var swiper = new Swiper('.swiper-container', {
      pagination: {
        el: '.swiper-pagination',
        clickable: true,
        renderBullet: function (index, className) {
          return '<span class="' + className + '">' + (index + 1) + '</span>';
        },
      },
    });
  </script>
</body>
</html>