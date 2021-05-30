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
						<li>
							<p>${BoardView1.board_nm } <a href="#" onclick="goBoard(${BoardView1.board_no})">more +</a></p>
							<dl>
								<c:forEach var="BoardTemplate1" items="${BoardTemplate1 }" begin="0" end="3" step="1">
									<dd>
										<span>${BoardTemplate1.in_dtm }</span>
										<b onclick="goViewItem('${BoardTemplate1.item_no}', '${BoardTemplate1.board_no}')" style="cursor: pointer;">${BoardTemplate1.title }</b>
									</dd>
								</c:forEach>
							</dl>
						</li>
						<li class="mr0">
							<p>${BoardView2.board_nm } <a href="#" onclick="goBoard(${BoardView2.board_no})">more +</a></p>
							<dl>
								<c:forEach var="BoardTemplate2" items="${BoardTemplate2 }" begin="0" end="3" step="1">
									<dd>
										<span>${BoardTemplate2.in_dtm }</span>
										<b onclick="goViewItem('${BoardTemplate2.item_no}', '${BoardTemplate2.board_no}')" style="cursor: pointer;">${BoardTemplate2.title }</b>
									</dd>
								</c:forEach>
							</dl>
						</li>
					</ul><!-- //class="main_box01" -->

					<ul class="main_box01" style="margin-top: 25px">

						<li style="margin-right: 260px;">
							<p>이달의 성과 <span class="ttxt01">( 단위:천원 )</span></p>

							
							<table class="table_st1" style="border-top:0;">
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
						        </thead>       
						        <tbody>
						          <tr>
						            <td class="tal">생보장기</td>
						            <td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.lf_m_lt_pr_amt }</fmt:formatNumber></td>
										<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.lf_l_m_lt_pr_amt }</fmt:formatNumber></td>
										<td class="br0"><fmt:formatNumber pattern="#,###.##">${MAIN_STATISTICS_OUTCOME.lf_lt_pg_rt }</fmt:formatNumber>%</td>
						          </tr>
						          <tr>
						            <td class="tal">생보 일시납</td>
										<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.lf_m_is_pr_amt }</fmt:formatNumber></td>
										<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.lf_l_m_is_pr_amt }</fmt:formatNumber></td>
							  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${MAIN_STATISTICS_OUTCOME.lf_is_pg_rt }</fmt:formatNumber>%</td>
						          </tr>
						          <tr>
						            <td class="tal">손보장기</td>
							  			<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.n_lf_m_lt_pr_amt }</fmt:formatNumber></td>
										<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.n_lf_l_m_lt_pr_amt }</fmt:formatNumber></td>
							  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${MAIN_STATISTICS_OUTCOME.n_lf_lt_pg_rt }</fmt:formatNumber>%</td>
						          </tr>
						          <tr>
						            <td class="tal">손보자동차</td>
							  			<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.n_lf_m_cr_pr_amt }</fmt:formatNumber></td>
										<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.n_lf_l_m_cr_pr_amt} </fmt:formatNumber></td>
							  			<td class="br0"><fmt:formatNumber pattern="#,###.##">${MAIN_STATISTICS_OUTCOME.n_lf_cr_pg_rt }</fmt:formatNumber>%</td>
						          </tr>
						          <tr>
						            <td class="tal">손보일반</td>
										<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.n_lf_m_gn_pr_amt }</fmt:formatNumber></td>
										<td><fmt:formatNumber pattern="#,###">${MAIN_STATISTICS_OUTCOME.n_lf_l_m_gn_pr_amt }</fmt:formatNumber></td>
										<td class="br0"><fmt:formatNumber pattern="#,###.##">${MAIN_STATISTICS_OUTCOME.n_lf_gn_pg_rt }</fmt:formatNumber>%</td>
						          </tr>
						        </tbody>
						      </table>
						</li>


						<li style="padding: 0">
							<img src="/resources/images/common/ba_1.png" onclick="goLinkPage('PCC')" style="cursor: pointer;">
							<!-- 자동차비교견적 3단계로 추후 반영예정
							<img src="/resources/images/common/ba_2.png" onclick="goLinkPage('ANYCAR')" style="cursor: pointer;">
							-->
							<img src="/resources/images/common/ba_2.png">
							<br />
							<img src="/resources/images/common/ba_3.png">
							<img src="/resources/images/common/ba_4.png">
						</li>

						<li class="mr0" style="padding: 0">
							<img src="/resources/images/common/ba_5.png" onclick="goInsaNumber()" style="cursor: pointer;">
							<img src="/resources/images/common/ba_6.png" onclick="overdueContract()" style="cursor: pointer;">
							<br />
							<img src="/resources/images/common/ba_7.png">
							<a href="https://www.in.or.kr/" target="_blank"><img src="/resources/images/common/ba_8.png"></a>
						</li>

						<img src="/resources/images/common/ba_bg.png" class="txt_h_02">
						
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
