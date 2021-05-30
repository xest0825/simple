<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache">
<title>::::: SIMPLE Web :::::</title>
<link href="/resources/kendoui/styles/kendo.common.min.css" rel="stylesheet" />
<link href="/resources/kendoui/styles/kendo.bootstrap.min.css" rel="stylesheet" />
<!--
<link rel="stylesheet" href="/resources/css/font-awesome.min.css" />
<link rel="stylesheet" href="/resources/css/search.css" />
<link rel="stylesheet" href="/resources/css/common.css" />
<link rel="stylesheet" href="/resources/css/loading.css" />
<link rel="stylesheet" href="/resources/css/important.css" />
<link rel="stylesheet" href="/resources/css/tooltip.css" />
<link href="/resources/css/simple-line-icons.css" rel="stylesheet" />
<link rel="stylesheet" href="/resources/css/swiper.min.css"> -->

<script type="text/javascript" src="/resources/js/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/common/genexon.js"></script>
<script type="text/javascript" src="/resources/kendoui/js/kendo.all.min.js"></script>
<script type="text/javascript" src="/resources/kendoui/js/cultures/kendo.culture.ko-KR.min.js"></script>
<!-- 
<script type="text/javascript" src="/resources/js/common/layout.js"></script>
<script type="text/javascript" src="/resources/js/opensource/mit-license/underscore/underscore-min.js"></script>
<script type="text/javascript" src="/resources/js/opensource/mit-license/moment/moment.js"></script>

<script type="text/javascript" src="/resources/js/jquery/jquery.fileDownload.js"></script>
<script type="text/javascript" src="/resources/js/common/session.js"></script>
<script type="text/javascript" src="/resources/js/jquery/jquery.form-3.51.0.js"></script>
<script type="text/javascript" src="/resources/js/common/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/common/swiper.min.js"></script> -->
<%-- <%@ include file="../views/comm/address.jsp" %> --%>
<%-- <%@ include file="../sitemesh/layoutstyle.jsp" %> --%>

<script>
    window.MSPointerEvent = null;
    window.PointerEvent = null;
</script>
<script type="text/javascript">
$(document).ready(function(){
	console.log('layout');
	var in_autr_type = "${menuRole.in_autr_type}";
	var up_autr_type = "${menuRole.up_autr_type}";
	var de_autr_type = "${menuRole.de_autr_type}";
	var lo_autr_type = "${menuRole.lo_autr_type}";
	var do_autr_type = "${menuRole.do_autr_type}";
	
	if(in_autr_type != "Y") {
		$('.in_autr_type').attr("style", "display: none !important");
	}
	
	if(up_autr_type != "Y") {
		$('.up_autr_type').attr("style", "display: none !important");
	}
		
	if(de_autr_type != "Y") {
		$('.de_autr_type').attr("style", "display: none !important");
	}
	
	//엑셀업로드 권한
	if(lo_autr_type != "Y") {
		$('.lo_autr_type').attr("style", "display: none !important");
	}
	
	//엑셀다운로드 권한
	if(do_autr_type != "Y") {
		$('.do_autr_type').attr("style", "display: none !important");
	}
	
	// console.log('genexon.initKendoUI() START ===>');
	genexon.initKendoUI();
	//resizeGrid();
	
	$(window).resize(function() {
		//resizeGrid();
	});
	
	// 메뉴경로에 입력
	var menu_path = "${menuRole.menu_path}";
	var resource_id = "${menuRole.resource_id}";
	
	//메인화면 메뉴는 네비게이션 표시하지 않도록..
	if(resource_id != "MN_000" && menu_path != "") {
		if(menu_path.indexOf(">")!= -1) {
			var bookmarkUseYn = "${menuRole.bookmark_use_yn}"; //메뉴 즐겨찾기 기능 사용유무
			var bookmarkYn = "${menuRole.bookmark_yn}";//즐겨찾기 등록유무
			var bookmarkHtml = '<img src="/resources/images/common/ic_fav_de.png" class="ml10" onclick="javascript:bookmarkClick(\''+resource_id+'\', \'Y\' , this);">';
			
			//즐겨찾기 기능을 사용하는지 안하는지
			if(bookmarkUseYn == "N") {
				bookmarkHtml = '';
			}
			
			//증겨찾기 등록했으면 아이콘 이미지변경
			if(bookmarkYn == "Y") {
				bookmarkHtml =  '<img src="/resources/images/common/ic_fav.png" class="ml10" onclick="javascript:bookmarkClick(\''+resource_id+'\', \'N\', this);">';
			}
			
			$("#image_menu_path").html('<span id="layout_menu_path" style="vertical-align: unset;">' + menu_path.replace(/>/gi,'<img src="/resources/images/common/ic_8.png">') + '</span>'+bookmarkHtml);
			$("#layout_menu_path").attr('onclick', 'javascript:helpItemView(\'' + resource_id + '\', \'' + menu_path + '\');');
		}else {
			$("#image_menu_path").html("");
		}
		
		$("body").css("padding", "18px 25px 0px 25px");
	}else {
		$("#image_menu_path").remove();
	}
	
	$(".init_background").fadeOut(1000);	//화면에서 등록, 수정 등 버튼이 jquery로 제어되면 화면이 뜬 다음에 버튼이 사라지는 현상이 발생하여 처리함
});

//도움말 팝업
function helpItemView(resource_id, menu_path) {
	genexon.PopWindowOpen({
		pID    : "helpItemView",
		pTitle : menu_path.replace(/>/gi,'<img src="/resources/images/common/ic_8.png">'),
		pURL   : "/board/board/helpItemView.pop?${_csrf.parameterName}=${_csrf.token}",
		data   : { 
			resource_id : resource_id
		},
		pWidth : 1000,
		pHeight: 570,
		pModal : true
   });
}

//즐겨찾기 클릭
function bookmarkClick(resource_id, yn ,imgObj){
	var confirmStr = "즐겨찾기를 등록하시겠습니까?";
	if(yn == "N") confirmStr = "즐겨찾기를 해제하시겠습니까?";
	
	genexon.confirm("즐겨찾기", confirmStr, function(result) {
		if(result){
			if(yn=="Y"){ //즐겨찾기 등록
				$.ajax({
					url: "/bookmark/insertBookmark.ajax?${_csrf.parameterName}=${_csrf.token}",
					type: "POST",
					dataType: "json",
					async: false,
					data: {
						"resource_id" : resource_id
					},
					success:function(){
						//등록완료 후 아이콘 및 함수 변경
						$(imgObj).attr("src", '/resources/images/common/ic_fav.png');
						$(imgObj).click(function(){
							bookmarkClick(resource_id,'N',this);
						});
						genexon.alert("success", "즐겨찾기", "정상적으로 처리되었습니다.");
					},
				    error: function(xhr,status, error){
				    	genexon.alert("error", "즐겨찾기", "에러발생");
				    }
				}); // end ajax
			}else{//즐겨찾기 해제
				$.ajax({
					url: "/bookmark/deleteBookmark.ajax?${_csrf.parameterName}=${_csrf.token}",
					type: "POST",
					dataType: "json",
					async: false,
					data: {
						"resource_id" : resource_id
					},
					success:function(){
						//해제 후 아이콘 및 함수 변경
						$(imgObj).attr("src", '/resources/images/common/ic_fav_de.png');
						$(imgObj).click(function(){
							bookmarkClick(resource_id,'Y',this);
						});
						genexon.alert("success", "즐겨찾기", "정상적으로 처리되었습니다.");
					},
				    error: function(xhr,status, error){
				    	genexon.alert("error", "즐겨찾기", "에러발생");
				    }
				}); // end ajax
			}
		}//end if
	});// end confirm	
}
</script>
    <sitemesh:write property='head'/>
</head>

<body style="overflow: auto;">
	<div id="init_background" class="init_background" style="width: 100%; height: 100%; position: fixed; z-index: 9999; background-color: white;"></div>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<!-- 마감코드 -->
	<%-- <input id="CL_STEP_CD" name="CL_STEP_CD" type="hidden" value="${CL_STEP_CD}"/> --%>
	
	<input type="hidden" id="menuRole" value="${menuRole}"/>
	<input type="hidden" id="view_auth" value="${menuRole.view_auth}"/>
	<input type="hidden" id="in_autr_type" value="${menuRole.in_autr_type}"/>
	<input type="hidden" id="up_autr_type" value="${menuRole.up_autr_type}"/>
	<input type="hidden" id="de_autr_type" value="${menuRole.de_autr_type}"/>
	<input type="hidden" id="lo_autr_type" value="${menuRole.lo_autr_type}"/>
	<input type="hidden" id="do_autr_type" value="${menuRole.do_autr_type}"/>
	
	<p class="breadcrumb" id="image_menu_path" style="cursor:pointer;z-index:1;"></p>
	
	<sitemesh:write property='body'/>
    <iframe title="" id="ifmDetail" name="ifmDetail" style="width: 100%; height: 0px; border: 0px; overflow:hidden; display: none;"></iframe>
    <form id="frmSubDetail" name="frmSubDetail" target="ifmDetail" style="display: none;"></form>

	<div id="sessionChkModal" style="display:none;">
		<h4>로그인 유지시간이 1분 남았습니다.<br>연장을 원하시면 유지버튼을 눌러주세요.</h4>
		<button class="kbtn" style="width: 150px; margin-top: 23px" onClick="javascript:sessionExt();">유지</button>
		<button class="kbtn" style="width: 150px; margin-top: 23px" onClick="javascript:sessionExp();">로그아웃</button>
	</div> <!-- 세션유지모달 -->
</body>
</html>