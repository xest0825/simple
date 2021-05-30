<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="viewport" content="width=device-width, viewport-fit=cover, height=device-height, initial-scale=1, user-scalable=no">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="Pragma" content="no-cache">
	<title>Sample 모바일</title>

	<link rel="stylesheet" href="/resources/css/common.css">
	<link rel="stylesheet" href="/resources/css/animate.css">
	<link rel="stylesheet" href="/resources/css/font-awesome.min.css">
	<link rel="stylesheet" href="/resources/css/base.css">
	<link rel="stylesheet" href="/resources/css/swiper.min.css">

	<script type="text/javascript" src="/resources/js/jquery/jquery.min.js"></script><!-- 12.4 ver -->
	<script type="text/javascript" src="/resources/js/jquery/jquery.mobile-1.4.5.min.js"></script>
	<script type="text/javascript" src="/resources/js/jquery/jquery-ui.min.js"></script>

	<script type="text/javascript" src="/resources/js/common/genexon.js"></script>
	<script type="text/javascript" src="/resources/js/common/datepicker.js"></script>
	<script type="text/javascript" src="/resources/js/common/icons-lte-ie7.js"></script>
	<script type="text/javascript" src="/resources/js/common/script.js"></script>
	<script type="text/javascript" src="/resources/js/common/swiper.min.js"></script>
	<script type="text/javascript" src="/resources/js/common/gnx_app_connector.js"></script>

	<script>
	$(document).bind("mobileinit", function(){
		console.log('[LM] mobileinit');
		$.mobile.ajaxLinksEnabled = false;
		$.mobile.ajaxFormsEnabled = false;
		$.mobile.ajaxEnabled = false;
		$.mobile.selectmenu.prototype.options.nativeMenu = false;
		$.mobile.selectmenu.prototype.options.hidePlaceholderMenuItems = false;
	});

	</script>

	 <style>
		[disabled]{border:1px solid #C7C0B8 !important;background-color:#C7C0B8 !important;pointer-events: none;}
	</style>

<sitemesh:write property='head'/>
</head>
<body>
<div>
	<div id="wrap" data-role="page">
		<sitemesh:write property='body'/>
	</div>
</div>

<script type="text/javascript">
	var joinParam = new Object();	// 회원가입 파라미터
	var deviceParam = new Object();	// 디바이스정보 파라미터
	var userParam = {};
	var iaaList = [];
	
	$(document).on('pageinit', function(){
		$('.ui-loader').css('display','none'); // .ui-loader <- jquery.mmobile-1.4.5.js
	});
	


	 // ajax 실행/완료시 로딩바
	 window.onload = function(){
		console.log('[LM] onload');
		  
		$('.ui-loader').css('display','none'); // .ui-loader <- jquery.mmobile-1.4.5.js
		
		$("#mask").fadeOut();
		
		$(window).ajaxStart(function(){
			$("#mask").fadeIn();
		}).ajaxStop(function(){
			setTimeout(function(){
				$("#mask").fadeOut('slow'); // ajax가 정료되고 1.5 초가 지나면 자동으로 프로그레스바가 사라진다.
			},1500);
		});

		$.ajaxSetup({

	        beforeSend: function(xhr) {
	           xhr.setRequestHeader("AJAX", true);
	        },

	        error: function(xhr, status, err) {
	            if(xhr.status == 401) {
	              	alert("권한이 없습니다. 로그인 화면으로 이동합니다.");
	            }else if(xhr.status == 403){
	            	alert("세션이 만료되었습니다. 로그인 화면으로 이동합니다.");
	            }else {
	                alert("예외가 발생했습니다. 관리자에게 문의하세요.");
	            }
	            location.href = "/m/login.go"; // 모바일 로그인페이지를 /login.go 에서 /m/login.go 로 변경함.
	        }
	    });
		 	
		$("body").off().on("pagechange", function(e){
			pageChanged();
		});
		
		function pageChanged(){
			console.log('- pageChanged'); // url을 변경하여 페이지를 변경할 경우 호출 되지 않는다.
			var pageId = $(".ui-page-active").prop("id");
			console.log('- pageId : ' + pageId);
			console.log('- page.size : ' + $(".ui-mobile-viewport [data-role=page]").length);
		
			// 페이지가 2개 이상 생기는 경우 오래된 첫번째 것 제거
			
			if($(".ui-mobile-viewport [data-role=page]").length > 1){
				console.log('-- page.size > 1, removing page[0]');
				$(".ui-mobile-viewport [data-role=page]").eq(0).remove();
			}
			
		}
		

	 };

	// 페이지별 배열
	var pageArr = [
		{ID: 'PCCMAKE', URL: '/mobile/getPccMake.go'}
		, {ID: 'PCCLIST', URL: '/mobile/getPccList.go'}
		, {ID: 'PCCCAM', URL: '/mobile/getPccCam.go'}
		//, {ID: 'INFOMAKE', URL: '/mobile/getInfoMake.go'}
		//, {ID: 'INFOLIST', URL: '/mobile/getInfoList.go'}
		, {ID: 'PCCMARK', URL: '/mobile/getPccMark.go'}
	];

	//페이지 변경전 파라미터 세팅
	var pageAct = function(map, data, method){
		console.log('pageAct');
		var param = new Object();

		var changePage = function(url, param){
			$("#mask").fadeIn();

			setTimeout(function(){
				$.mobile.changePage(url, param); // 페이지 전환후 0.3 초 이후 프로그레스바가 사라진다.
			}, 300);
		}

		// 기본 파라미터
		param.type = "post";
		if(method) {
			param.type = method;
		}

		param.changeHash = true;
		param.showLoadMsg = false;
		param.reloadPage = true;
		// ( fade | flip | flow | pop | slide | slidedown | slidefade | slideup | turn | none )
		param.transition = "slide";
		// param.reverse = true;
		param.data = data || {};
		if(map.URL == '/mobile/getPccDetail.go'
				|| map.URL == '/mobile/getPccDetail2.go'
				|| map.URL == '/mobile/setEmpSign.go'){
			param.transition = "pop";
		}else if(map.URL == '/pccplus/customerVerification.go'
			   || map.URL == '/pccplus/employeeInfoConfirm.go'
			   || map.URL == '/pccplus/gumsoDocumentConfirm.go'
			   || map.URL == '/pccplus/gumsoPaintOver.go'
			   || map.URL == '/pccplus/prodDocumentConfirm.go'
			   || map.URL == '/pccplus/prodPaintOver.go'
			    ){
			param.type = "get";
		}else if(map.URL == '/mobile/getPccMake.go'){
			// 사인이 필요함
			hasEmpSignNew(changePage, map.URL, param);
			return false;
		}else{

		}

		changePage(map.URL, param);	// 내부함수
	}

	/* var nav = new Swiper('.nav', {
		slidesPerView : 'auto',
		touchRatio : 1,
		nextButton : '.swiper-button-next',
		prevButton : '.swiper-button-prev',
		centeredSlides : false,
		slideToClickedSlide : true,
		//onInit : firstNav,
		onClick : refreshNavmenu
		//onSlideChangeStart : onSelectNavmenu
	}); */

	//메뉴를 다시 눌렀을때 리로드 해주는 함수
	function refreshNavmenu(e){
		var num = e.clickedIndex;
		if(null == num){	// 화살표를 클릭했을때 이벤트 막음
			return false;
		}
		pageAct(pageArr[num]);

		nav.slideTo(num, 300, true);
		activeControll(num);
	}

	//버튼 애니메이션 동작함수
	function activeControll(num){
		$(".navlabel").each(function(e){
			$(this).removeClass("navAction navActive");
		});
		$(".navlabel").eq(num).addClass("navAction navActive");
		setTimeout(function(e){	// 애니메이션 동작 시간 후에 지워버림
			$(".navlabel").eq(num).removeClass("navAction");
		}, 1000);
	}

	// 인풋 닫기 이벤트
	function labelAndSelectEvent(){
		$("input").on('keypress', function(e){
			if(e.keyCode==9 || e.keyCode==13){
				$(this).blur();
				e.preventDefault();
			}
		});
	}

	//데이터 겟
	function dataGet(){
		var target = $("#infoform").find('input[type=hidden]');
		var data = {};
		target.each(function(e){
			data[$(this).prop("id")] = $(this).val();
		});
		return data;
	}

	//데이터 셋
	function dataSet(result){
		var keyArr = Object.keys(result);
		for (var i = 0; i < keyArr.length; i++) {
			$("#"+keyArr[i]).val(result[keyArr[i]] || '');
		}
	}

	//뒤로가기 버튼
	function bkbtn(){
		history.go(-1);
	}

	function formatPx(str) {return parseInt(str.replace("px", ""));} //x px 값 int 형 포멧
	function numberFormat(num) {return num < 10 ? '0' + num : num + '';} //10보다 작은 숫자 앞에 0을 붙여 문자열(String)로 반환
	//NULL 포멧
	function null_fm(str){
		return (str == null || str == '') ? '' : str;
	}
	//NULL 포멧
	function null_X(str){
		return (str == null || str == '') ? 'X' : str;
	}
	//디바이스 종류 파악
	function check_device(){
		var mobileKeyWords = new Array('iPhone', 'iPod', 'BlackBerry', 'Android', 'Windows CE', 'LG', 'MOT', 'SAMSUNG', 'SonyEricsson');
		var device_name = '', api = 'and';
		for (var word in mobileKeyWords){
			if (navigator.userAgent.match(mobileKeyWords[word]) != null){
				device_name = mobileKeyWords[word];
				break;
			}
		}
		if(device_name == 'iPhone' || device_name == 'iPod'){
			api = 'ios';
		}
		return api;
	}

	//다른상품 선택 옵션 포멧 널값을 'X'로 처리해야 정상적인 상품리스트가 나옴
	function formatOption(str){
		if(str == '' || str == null || str == 'undefined'){
			return 'X';
		}else{
			return str;
		}
	}

	//확인서 전송 팝업
	var sendPop = function(){
		$("#SEND_VERSION").val("2");

		$(".imgborder").removeClass("selected");
		$(".imgborder").eq(0).addClass("selected");
		$(".imgchk").hide();
		$("#verchk2").show();

		$("#sendPop").slideDown();
		$("#sendBtn").slideUp();

		var option = $("#SEND_OPTION").val();
		//if(option == "C013" || option == "C012"){
		if(option == "C012"){
			$(".imgborder :eq(1)")[0].click();
			$(".imgborder").off("click");
			//swal("안내", "자동차, 일반의 경우 (구)양식으로 생성합니다.", "info");
			swal("안내", "자동차의 경우 (구)양식으로 생성합니다.", "info");
		}else{
			versionEvent();
		}

		/* if($("#SEND_GUBUN").val() < 2) {
			$(".imgborder :eq(1)")[0].click();
			$(".imgborder").off("click");
		}else{
			versionEvent();
		} */
	}

	//샌드팝업 닫기
	var canclePop = function(){
		$("#sendBtn").slideDown();
		$('#sendPop').slideUp();
	}

	//버전이벤트
	var versionEvent = function(){
		$(".imgborder").off("click");
		$(".imgborder").on("click", function(){
			$(".imgborder").removeClass("selected");
			$(".imgchk").hide();

			var id = $(this).prop("id").replace("version", "");

			$("#SEND_VERSION").val(id);
			$("#verchk"+id).show();

			$(this).addClass("selected");
		});
	}

	//증권번호 등록
	function setInspol(inspol){
		//var inspol = $("#inspol").text();
		swal({
			  title: "증권번호/청약서번호 등록/수정",
			  type: "input",
			  showCancelButton: true,
			  closeOnConfirm: false,
			  animation: "slide-from-top",
			  inputPlaceholder: "증권번호/청약서번호"
			},
			function(inputValue){
				if (inputValue === false) return false;
				if (inputValue === "") {
					swal.showInputError("공백을 증권번호/청약서번호로 등록할 수 없습니다");
					return false;
				}
				if (inputValue.length > 0) {
					var activePage = $(".ui-page-active").prop("id");
					if(activePage == ''){
						$("#inspol").text(inputValue);
						swal("증권번호/청약서번호 등록", "증권번호/청약서번호: " + inputValue + ", 등록되었습니다.", "success");
						$("#INSPOL_NO").val(inputValue);
					}else{
						// PCCDETAIL
						$.ajax({
							url: '/api/settingInspol.api',
							type: 'POST',
							data : {
								INSPOL_NO : inputValue
								/* , MB_ID : document.getElementById('MB_ID').value
								, EMPCD : document.getElementById('EMPCD').value
								, CUST_CODE : document.getElementById('CUST_CODE').value */
							},
							dataType : 'json',
							success: function(data){
								$("#inspol").text(inputValue);
							},
							error: function(){
								genexon.alert("error", "ERROR", "알 수 없는 에러가 발생했습니다");
							}
						});
					}
					swal("증권번호/청약서번호 등록", "증권번호/청약서번호: " + inputValue + ", 등록되었습니다.", "success");
				}
		});
	}

	//확인서 파일 뷰
	function pdfFileView(num, insco, prod){
		var file = $("#getFile"+num).val();
		var name = $("#getName"+num).val();
		$.ajax({
			url: '/api/getFileDownload.api',
			type: 'POST',
			data : {
				FILE_PATH : file
				, FILE_NAME : name
			},
			dataType : 'json',
			success: function(data){
				var isAnd = parent.parent.check_device();
				if(isAnd == 'ios'){		// 디바이스 검증
					$('#dinsco').text('').append(insco);
					$('#dprod').text('').append(prod);
					$('#file').val(data.code);
					$("#prodBtn").fadeIn();
				}else{
					window.open('http://pcc.genexon.co.kr/Upload/UpImages/' + data.code);
				}
			},
			error: function(err){
				parent.parent.swal("ERROR", "알 수 없는 에러가 발생했습니다", "error");
			}
		});
	}

	/*
	 * [상품비교설명확인서 코드 생성] by JJT
	 */
	function getCustCode(){
		//고객코드  = 사원명 + 날짜 + 초 + 분 + 시간
		var d = new Date();
		var m = d.getMinutes() < 10 ? "0"+d.getMinutes() : d.getMinutes();
		var d2 = d.getDate() < 10 ? "0"+d.getDate() : d.getDate();
		var h = d.getHours() < 10 ? "0"+d.getHours() : d.getHours();
		var s = d.getSeconds() < 10 ? "0"+d.getSeconds() : d.getSeconds();
		var y = d.getFullYear();
		var code = $("#EMPCD").val()+''+m+''+d2+''+h+''+s+''+y;
		$("#CUST_CODE").val(code);
		return code;
	}

	/*
	 * [저장전 전화번호세팅 castingPhone()] by JJT, 20170329
	 *	CUST_HP input태그에 저장된 전화번호에 '-'를 붙여줌
	 *  자리수에 따라 000-0000-0000, 000-000-0000 으로 구분
	 */
	function castingPhone(){
		var number = "";
		number = $("#CUST_HP").val();
		if(number.length > 0){
			if(number.length == 11){
				number = number.substr(0, 3) + "-" + number.substr(3, 4) + "-" + number.substr(7, 4);
			}
			if(number.length == 10){
				number = number.substr(0, 3) + "-" + number.substr(3, 3) + "-" + number.substr(6, 4);
			}
		}
		$("#CUST_HP").val(number);
	}

	/*
	 * [사원 서명 등록여부 hasEmpSign(order)] by JJT, 20170329
	 * 사원의 사인이 등록되어 있는지 여부를 판별하고 사원 사인을 등록하는 창을 불러온다(slide)
	 * hasEmpSign
	 *	├ case1: 서명 있음 -> isOnEmpSign(order) ->  sendSMS() / sendKAKAO()
	 *	└ case2: 서명 없음 -> isOffEmpSign(order)
	 *				   -> 사인있으면 수정, 없으면 등록 mergeEmpSign() :: /api/mergeEmpSign.ajax
	 *				   -> order에 따른 구분
	 */
	function hasEmpSign(order){
		getCustCode();

		var version = $("#SEND_VERSION").val();
		var option = $("#SEND_OPTION").val();
		//if(option == "C013" || option == "C012"){
		if(option == "C012"){
			$(".imgborder :eq(1)")[0].click();
			version = "1";
		}

		isOnEmpSign(order);
	}

	 /*
	  * [사원 서명 등록됨 isOnEmpSign(order)] by JJT, 20170329
	  *	order(kakao, sms) 구분으로 해당 메세지를 전송
	  */
	function isOnEmpSign(order){
		if("kakao" == order)	sendKAKAO();
		if("sms" == order)		sendSMS();
	}

	//KAKAO전송 함수 by JJT
	function sendKAKAO(){
		// 팝업창에 띄울 HTML 세팅, 고객의 성명과 휴대폰 번호를 바꿀 수 있는 기회
		var str = "<span style='color:#FF5722;'>상품비교설명 확인서<span>를 전송하시겠습니까?<hr style='border: 0px solid;padding-bottom: 1em;'>";

		// 컨펌 버튼에 데이터 세팅
		function hasId(){
			$(".confirm").data("name", "kko_btn");
			if($(".confirm").data("name") == "kko_btn"){
				clearInterval(setterId);
			}
		}
		var setterId = setInterval(hasId, 10);
		var title = '카카오톡 전송';
		var datas = dataGet();

		swal({
			  title: title,
			  text: str,
			  html: true,
			  type: "warning",
			  showCancelButton: true,
			  confirmButtonColor: "#DD6B55",
			  confirmButtonText: "카카오톡전송",
			  cancelButtonText: "취소",
			  closeOnConfirm: true,
			  closeOnCancel: true
		},
		function(){
			if($(".confirm").data("name") == 'kko_btn'){
				// kakao 정보저장 ajax
				/* document.getElementById('isKakao').value = 'Y'; */
				commonSender('/api/sendKakaoProductInfo.api');
			}
		});
	}

	//SMS전송 함수 by JJT
	/*function sendSMS(){
		// 팝업창에 띄울 HTML 세팅, 고객의 성명과 휴대폰 번호를 바꿀 수 있는 기회
		var custnm = document.getElementById('CUST_NM').value;
		var custhp = document.getElementById('CUST_HP').value.replace(/-/g, '');
		var str = "<span style='color:#FF5722;'>상품비교설명 확인서<span>를 전송하시겠습니까?<hr style='border: 0px solid;padding-bottom: 1em;'>";
		str += "<table class='swalTable'><colgroup><col width='40%'><col width='60%'></colgroup>";
		str += "<tr><th>고객명</th><td>";
		str += "<input type='text' id='subnm' style='display:block;margin: 0;height: 2em;' value='"+custnm+"' onkeydown='if(event.keyCode==13)keyControll(event, this.id);'>";
		str += "</td></tr><tr><th>휴대전화</th><td>";
		str += "<input type='number' inputmode='numeric' id='subhp' style='display:block;margin: 0;height: 2em;' value='"+custhp+"' onkeydown='if(event.keyCode==9)keyControll(event, this.id);'>";
		str += "</td></tr></table>";

		var title = '문자전송';
		swal({
			  title: title,
			  text: str,
			  html: true,
			  type: "warning",
			  showCancelButton: true,
			  confirmButtonColor: "#DD6B55",
			  confirmButtonText: "전송",
			  cancelButtonText: "취소",
			  closeOnConfirm: false,
			  closeOnCancel: true,
			  timer: 3000,
			  showLoaderOnConfirm: true
		},
		function(isConfirm){
		  if (isConfirm) {	// 전송버튼 누를시
			  if($("#EMPHP").val().length == 0){
				  swal("문자전송실패", "발송번호가 없어 문자전송을 할 수 없습니다.", "error");
			  }else{
				// swal창에서 띄웠던 고객명과 고객번호를 다시 base 파라미터에 세팅
				document.getElementById('CUST_NM').value = $("#subnm").val();
				document.getElementById('CUST_HP').value = $("#subhp").val();
				commonSender('/api/sendProductInfo.api');
			  }
		  }
		});
	}
*/
	// 공통 전송 함수
	function commonSender(url){
		// before_send 닫음
		$("#sendBtn").slideDown();
		$('#sendPop').slideUp();

		//$("#mask").show();

		// 코드생성
		var code = $("#CUST_CODE").val();

		// 버전체크
		var version = $("#SEND_VERSION").val() || "2";
		var option = $("#SEND_OPTION").val();
		//if(option == "C013" || option == "C012"){
		if(option == "C012"){
			version = "1";
		}

		// 링크 메세지 작성
		var msg = $("#subnm").val() + " 고객님을 위한\n상품비교설명 확인서입니다\n";
			//msg += 'http://192.168.0.49:8034/api/check'+version;
			msg += location.origin + '/api/check'+version;
			msg += '.api?Code='+code;

		document.getElementById('SMS_CONTENTS').value = msg;
		$("#VERSION").val(version);

		// 전화번호에 '-'붙이기
		castingPhone();

		var datas = dataGet();

		// sms전송 ajax
		$.ajax({
			url : url
			,type:"POST"
			,data: datas
			,dataType: "json"
			,success: function(data){

				$.ajax({
					url :"/api/getPCChtmlInfo_forCustomer.ajax"
					,type:"POST"
					,data: {CUST_CODE: $("#CUST_CODE").val()}
					,success: function(data){

						$.ajax({
							url :"/api/makePDFfile.ajax"
							,type:"POST"
							,data: {
								JSON_HTML: data
								, CUST_CODE: $("#CUST_CODE").val()
								, MB_ID: $("#MB_ID").val()
								, GUBUN: "customer"
							}
							,success: function(data){

								if(url == "/api/sendProductInfo.api"){
									swal("전송성공!", "상품비교설명 확인서를 전송했습니다", "success");
								}

								$("#sendBtn").slideUp();
								// 전송성공시 확인서관리 탭으로 이동

								refreshNavmenu({clickedIndex: 1});

								var activePage = $(".ui-page-active").prop("id");
								if(activePage == 'PCCDETAIL'){
									distroyBeforeSend();
								}
								$("#mask").fadeOut();
							}
							,error: function(xhr,status, error){
								$("#mask").fadeOut();
								swal("에러발생", "알 수 없는 에러가 발생하였습니다", "error");
							}
						});

					}
					,error: function(xhr,status, error){
						swal("에러발생", "알 수 없는 에러가 발생하였습니다", "error");
					}
				});
			}
			,error: function(xhr,status, error){
				swal("에러발생", "알 수 없는 에러가 발생하였습니다", "error");
			}
		});
	}

	//재전송인 경우 기존의 리스트 상태를 변경함
	function distroyBeforeSend(){
		$.ajax({
			url :"/api/distroyBeforeSend.ajax"
			,type:"POST"
			,data: {CUST_CODE: document.getElementById('KILL_CUST_CODE').value}
			,dataType: "json"
			,error: function(xhr,status, error){
				swal("에러발생", "알 수 없는 에러가 발생하였습니다", "error");
			}
		});
	}

	/*
	 * [사원 서명 등록되지 않음 isOffEmpSign(order)] by JJT, 20170329
	 *	order를 SIGN_ORDER에 저장하고 캔버스 세팅, 페이지를 로드
	 */
	function hasEmpSignNew(fn, url, param){
		$.ajax({
			url :"/api/hasEmpSign.ajax"
			,type:"POST"
			,data: dataGet()
			,dataType: "json"
			,async : false
			,success: function(result){
				var hasSign = result.data;
				if(hasSign == 0){	// 사인없음
					swal("알림", "확인서를 사용하기 위해서는 본인의 서명이 등록되어 있어야 합니다", "info");
					isOffEmpSign();
					return false;
				}else{
					fn(url, param);
					return true;
				}
			}
			,error: function(xhr,status, error){
				swal("에러발생", "알 수 없는 에러가 발생하였습니다", "error");
				return false;
			}
		});
	}

	/*
	 * [사원 서명 등록되지 않음 isOffEmpSign(order)] by JJT, 20170329
	 *	order를 SIGN_ORDER에 저장하고 캔버스 세팅, 페이지를 로드
	 */
	function isOffEmpSign(order){

		// 상세페이지 조회
		pageAct({ID: 'PCCSIGN', URL: '/mobile/setEmpSign.go'});
	}

	// 유사상품 정보 쇼 하이드
	function infoSlide(num){
		var info = $("#info"+num);
		if("none" == info.css("display")){
			info.slideDown();
			$("#arrow"+num).empty().append('<i class="fa fa-chevron-up"></i>&nbsp;<span class="detailbtn">상품비교안내표</span>');
		}else{
			info.slideUp();
			$("#arrow"+num).empty().append('<i class="fa fa-chevron-down"></i>&nbsp;<span class="detailbtn">상품비교안내표</span>');
		}
	}

	//유사상품 상품정보 테이블 그리기
	var drowProductDetail = function(data, num){
		var html = "";
		if(data.results != null){
			var info = data.results;
			if(info.default_contract_gubun != null && info.default_contract_gubun != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">기본계약 <br /> (보장명 / 보장금액)</td>';
				html += '<td colspan="3" class="br0">'+info.default_contract_gubun.replace(/\n/g, '<br>')+'</td></td>';
			}
			if(info.contract_condition_guide != null && info.contract_condition_guide != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">보험금이 지급되지 <br /> 않는 경우</td>';
				html += '<td colspan="3" class="br0">'+info.contract_condition_guide.replace(/\n/g, '<br>')+'</td></td>';
			}
			if(info.m_nap_premium != null && info.m_nap_premium != ''
					|| info.w_nap_premium != null && info.w_nap_premium != ''){
				html += '<tr><td rowspan="2" colspan="2" class="tac col2 colf5">월 납입 <br /> 보험료</td>';
				html += '<td class="tac col2 colf5">남</td>';
				html += '<td colspan="3" class="br0 co_fwb1">'+info.m_nap_premium+'</td>';
				html += '</tr><tr><td class="tac col2 colf5">여</td>';
				html += '<td colspan="3" class="br0 co_fwb1">'+info.w_nap_premium+'</td></tr>';
			}
			var mcnt = 0;
			var wcnt = 0;
			if(info.m_one_year_nap_premium != null && info.m_one_year_nap_premium != '') mcnt++;
			if(info.m_three_year_nap_premium != null && info.m_three_year_nap_premium != '') mcnt++;
			if(info.m_five_year_nap_premium != null && info.m_five_year_nap_premium != '') mcnt++;
			if(info.m_ten_year_nap_premium != null && info.m_ten_year_nap_premium != '') mcnt++;
			if(info.m_twenty_year_nap_premium != null && info.m_twenty_year_nap_premium != '') mcnt++;

			if(info.w_one_year_nap_premium != null && info.w_one_year_nap_premium != '') wcnt++;
			if(info.w_three_year_nap_premium != null && info.w_three_year_nap_premium != '') wcnt++;
			if(info.w_five_year_nap_premium != null && info.w_five_year_nap_premium != '') wcnt++;
			if(info.w_ten_year_nap_premium != null && info.w_ten_year_nap_premium != '') wcnt++;
			if(info.w_twenty_year_nap_premium != null && info.w_twenty_year_nap_premium != '') wcnt++;

			if((mcnt + wcnt) > 0){
				var row = 1 + mcnt + wcnt;
				html += '<tr><td rowspan="'+row+'" class="tac col2 colf5">해지<br />환급<br />예시</td>';
				html += '<td colspan="2" class="tac col2 colf5">구분</td>';
				html += '<td class="tac col2 colf5">납입보험료</td>';
				html += '<td class="tac col2 colf5">해지환급금</td>';
				html += '<td class="tac col2 colf5">해지환급률</td></tr>';

				if(mcnt > 0){
					html += '<tr><td rowspan="'+mcnt+'" class="tac col2 colf5">남</td>';
					if(info.m_one_year_nap_premium != null && info.m_one_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">1년</td>';
						html += '<td class="tar ls_1">'+info.m_one_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.m_one_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.m_one_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					if(info.m_three_year_nap_premium != null && info.m_three_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">3년</td>';
						html += '<td class="tar ls_1">'+info.m_three_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.m_three_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.m_three_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					if(info.m_five_year_nap_premium != null && info.m_five_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">5년</td>';
						html += '<td class="tar ls_1">'+info.m_five_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.m_five_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.m_five_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					if(info.m_ten_year_nap_premium != null && info.m_ten_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">10년</td>';
						html += '<td class="tar ls_1">'+info.m_ten_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.m_ten_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.m_ten_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					if(info.m_twenty_year_nap_premium != null && info.m_twenty_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">20년</td>';
						html += '<td class="tar ls_1">'+info.m_twenty_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.m_twenty_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.m_twenty_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					html = html.slice(0, -4);
				}
				if(wcnt > 0){
					html += '<tr><td rowspan="'+wcnt+'" class="tac col2 colf5">여</td>';
					if(info.w_one_year_nap_premium != null && info.w_one_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">1년</td>';
						html += '<td class="tar ls_1">'+info.w_one_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.w_one_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.w_one_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					if(info.w_three_year_nap_premium != null && info.w_three_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">3년</td>';
						html += '<td class="tar ls_1">'+info.w_three_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.w_three_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.w_three_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					if(info.w_five_year_nap_premium != null && info.w_five_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">5년</td>';
						html += '<td class="tar ls_1">'+info.w_five_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.w_five_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.w_five_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					if(info.w_ten_year_nap_premium != null && info.w_ten_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">10년</td>';
						html += '<td class="tar ls_1">'+info.w_ten_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.w_ten_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.w_ten_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					if(info.w_twenty_year_nap_premium != null && info.w_twenty_year_nap_premium != ''){
						html += '<td class="tac col2 colf5">20년</td>';
						html += '<td class="tar ls_1">'+info.w_twenty_year_nap_premium+'</td>';
						html += '<td class="tar ls_1">'+info.w_twenty_year_cance_refund_amt+'</td>';
						html += '<td class="tar ls_1">'+info.w_twenty_year_cance_refund_rate+'</td>';
						html += '</tr><tr>';
					}
					html = html.slice(0, -4);
				}
			}
			if(info.insurance_period != null && info.insurance_period != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">보험기간 / 갱신여부</td>';
				html += '<td colspan="3" class="br0 tac">'+info.insurance_period+'</td></tr>';
			}
			if(info.buga_special_contract_cnt != null && info.buga_special_contract_cnt != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">부가가능 특약수</td>';
				html += '<td colspan="3" class="br0 tac">'+info.buga_special_contract_cnt+'</td></tr>';
			}
			if(info.join_special_contract_one_default != null && info.join_special_contract_one_default != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">선택가입특약1</td>';
				html += '<td colspan="2" class="br0">'+info.join_special_contract_one_default+'</td>';
				html += '<td class="br0 tac">'+info.join_special_contract_one_detail+'</td></tr>'
			}
			if(info.join_special_contract_two_default != null && info.join_special_contract_two_default != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">선택가입특약2</td>';
				html += '<td colspan="2" class="br0">'+info.join_special_contract_two_default+'</td>';
				html += '<td class="br0 tac">'+info.join_special_contract_two_detail+'</td></tr>'
			}
			if(info.join_special_contract_three_default != null && info.join_special_contract_three_default != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">선택가입특약3</td>';
				html += '<td colspan="2" class="br0">'+info.join_special_contract_three_default+'</td>';
				html += '<td class="br0 tac">'+info.join_special_contract_three_detail+'</td></tr>'
			}
			if(info.join_special_contract_four_default != null && info.join_special_contract_four_default != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">선택가입특약4</td>';
				html += '<td colspan="2" class="br0">'+info.join_special_contract_four_default+'</td>';
				html += '<td class="br0 tac">'+info.join_special_contract_four_detail+'</td></tr>'
			}
			if(info.join_special_contract_five_default != null && info.join_special_contract_five_default != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">선택가입특약5</td>';
				html += '<td colspan="2" class="br0">'+info.join_special_contract_five_default+'</td>';
				html += '<td class="br0 tac">'+info.join_special_contract_five_detail+'</td></tr>'
			}
			if(info.product_features != null && info.product_features != ''){
				html += '<tr><td colspan="3" class="tac col2 colf5">상품특징</td>';
				html += '<td colspan="3" class="br0">'+info.product_features.replace(/\n/g, '<br>')+'</td></tr>';
			}
		}
		$("#infodraw"+num).empty().append(html);

		if(num > 1){
			$("#arrow"+num).empty().hide();
			if(html.length > 0){
				$("#arrow"+num).append('<i class="fa fa-chevron-down"></i>&nbsp;<span class="detailbtn">상품비교안내표</span>').show();
			}
		}
	}

	//유사상품 상세정보 테이블 그리기
	function drawInfoTableAjax_CD(productcd, num){
		if(productcd != null && productcd != 'undefind' && productcd != ''){
			$.ajax({
				url: '/api/getProdDetailInfo.ajax',
				type: 'POST',
				data : {PRODUCT_CD : productcd},
				async : false,
				dataType : 'json',
				success: function(data){
					drowProductDetail(data, num);
				}
			});
		}
	}

	//유사상품 상세정보 테이블 그리기
	function drawInfoTableAjax_SEQ(seq, num){
		if(seq != null && seq != 'undefind' && seq != ''){
			$.ajax({
				url: '/api/getProdDetailInfo.ajax',
				type: 'POST',
				data : {SEQ : seq},
				dataType : 'json',
				async : false,
				success: function(data){
					drowProductDetail(data, num);
				}
			});
		}
	}
	/* 모바일 기기정보 받기 */
	var reqSendDeviceInfo = function(){
		gnx_app_master.call('reqSendDeviceInfo'
				, function(data){
					joinParam.DEVICE_ID = data.uuid.replace('-', '');
				} // gnx_app_master.function
			);	// gnx_app_master
	}

  function openNav() {

	try {
			gnx_app_master.call("openSideMenu", function(data) {}, "");
		} catch (err) {
			console.log('err');
			openNavWeb();

		}

	}

	function openNavWeb() {
		document.getElementById("mySidenav").style.width = "80%";
	}

	function closeNav() {
		document.getElementById("mySidenav").style.width = "0";
	}
</script>


<form method="post" action="/login.do" name="loginFrm" id="loginFrm">
</form>

<div id="mask">
	<div class="loadingio-spinner-dual-ring-fmnw3vvpi5h">
		<div class="ldio-8q45d1yex6m">
			<div></div><div><div></div></div>
		</div>
	</div>
</div>


	<!-- 사진으로 확인서 등록을 위한 hidden 태그 -->
	<div>
		<input type="hidden" id="implementation_file_id">
		<input type="hidden" id="product_file_id">
		<input type="hidden" id="individual1_file_id">
		<input type="hidden" id="individual2_file_id">
	</div>

</body>
</html>