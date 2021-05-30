<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<html>
<head>
</head>
<body class="top_bg">
	<div id="header">
      <!-- <a href="#" class="back">로그인화면으로 돌아가기</a> -->
      <a href="#" class="home" onclick="openNavi()">홈</a>
    </div>
    
    <div id="mySidenav" class="sidenav">
	    <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
	    
	    <div class="menu01">
	      <!-- <img src="/newMobile/img/logo/lo_axa.png"> --> <span>양재점</span>
	      <a href="#">${InfoVO.MB_EMPNM} <span>설계사</span></a>
	      <a href="#" onclick="pageAct('/newApi/customerInfoMain.go')" style="text-decoration:underline;">MyPage</a>
	    </div>
	
	    <div class="menu02">
	      <button class="menu02_1" onclick="pageAct('/newApi/createDoc1.go');"><span>확인서 생성</span></button>
	      <button class="menu02_2" onclick="pageAct('/newApi/manageDoc1.go');"><span>확인서 관리</span></button>
	      <button class="menu02_3" onclick="pageAct('/newApi/createCameraDoc1.go');"><span>확인서 촬영</span></button>
	    </div>
	    <div class="menu02 sty07">
	      <button class="menu02_4" onclick="pageAct('/newApi/updateCustomerSign.go');"><span>서명 관리</span></button>
	      <button class="menu02_5" onclick="pageAct('/newApi/docUseStatistics.go')"><span>사용 통계</span></button>
	    </div>
	
	    <div class="menu03">
	      <a href="#" onclick="pageAct('/newApi/customerNoticeList.go')">Smart확인서 공지사항</a>
	      <a href="#" onclick="pageAct('/newApi/main.go')">HOME</a>
	
	      <p>APP ver 1.0.0</p>
	    </div>

    </div>


    <div id="container2">

      <h3 class="mt15 mb30 pa16"><b>${User.user_nm} 님</b> 환영합니다</h3>
      <button class="main02" onclick="pageAct({URL: '/pccplus/generateConfirm1.go'});"><img src="/resources/img/im_menu_5_w.svg">새로운 확인서 생성하기</button>
      <button class="main03" onclick="pageAct({URL: '/pccplus/photoRegistration.go'});"><img src="/resources/img/img_3.svg">확인서를 사진으로 등록하기</button>

    </div><!-- //id="container" -->

    <div id="container">

     <p class="main01">
       <span id="_date"></span>월 나의 확인서<br />
         	총<span id="sent"></span>건의 확인서를 발송하였으며,<br>
         	서명이 완료 된 확인서는 <span id="signed">00</span>건 입니다.
     </p>

     <button class="btn_txt01 mt20" onclick="pageAct({URL : '/pccplus/myConfirmationMain.go'})">나의 확인서 보기</button>
     <button class="btn_txt01 mt20" onclick="goLogin({URL : '/m/login.go'})">로그인으로 이동</button>


    </div><!-- //id="container" -->
    
    <script>

	$(document).on("pageinit", function() {
		console.log('[#main] pageinit')
		$('.ui-loader').css('display','none');

		$('#_date').text(genexon.getDate("YM", new Date(), '년  ', 0, 'today'));
		/* console.log(${User.user_nm});
		console.log("ddd ${User.mb_id}");
		*/

		//sendUserInfo();

	    //getSentCount();  //페이지 시작시 확인서 발송 개수 호출
	});
	
	$(document).on('pageChange', function(){
		console.log('[main] pageChange');
	});
	
	function openNavi(){
		if ('${User.devc_id}' == null || '${User.devc_id}' == '') {
			openNavWeb();
		} else {
			openNav();
		}
	}



	//앱에 설계사 정보 보내기
	function sendUserInfo(){
		var cust_nm = "${User.user_nm}";
		var cust_mbid = "${User.mb_id}";
		console.log("sendUserInfo : " + cust_nm + " / " + cust_mbid);
		app_param = {
				data: {
					name: cust_nm,
					mb_id: cust_mbid
				}
		};

		try {
			gnx_app_master.call('sendUserInfo', function(data){}, app_param);
		} catch (err) {
			console.log(err);
		}
	}

	// 확인서 발송 개수
	function getSentCount() {
		var param = {
		    	USER_ID : "${User.user_id}"
		    }
	    $.ajax({
	        url: "/pccplus/getSentCount.ajax",
	        type: "post",
	        dataType: "json",
	        data: param,
	        success: function(e) {
	        	console.log(e)
	            $("#sent").text(e.sentCount || '0');
	            $("#signed").text(e.signedCount || '0');
	        },
	        error: function(){
				alert('전송된 확인서 가지고 오기 에러!!');
	        }
	    });
	}
	var pageAct = function(map, data, method){
		console.log('pageAct(\"' + map.URL + '\"}')
		var param = new Object();

		var changePage = function(url, param){
			console.log('changePage()');
			$("#mask").fadeIn();

			//setTimeout(function(){
				$.mobile.changePage(url, param);
			//}, 300);
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
			console.log('case pop');
			param.transition = "pop";
		}else if(map.URL == '/pccplus/customerVerification.go'
			   || map.URL == '/pccplus/employeeInfoConfirm.go'
			   || map.URL == '/pccplus/gumsoDocumentConfirm.go'
			   || map.URL == '/pccplus/gumsoPaintOver.go'
			   || map.URL == '/pccplus/prodDocumentConfirm.go'
			   || map.URL == '/pccplus/prodPaintOver.go'
			    ){
			console.log('case get');
			param.type = "get";
		}else if(map.URL == '/mobile/getPccMake.go'){
			// 사인이 필요함
			console.log('hasEmpSignNew');
			hasEmpSignNew(changePage, map.URL, param);
			return false;
		}else{
			console.log('else');
		}

		changePage(map.URL, param);	// 내부함수
	};
		
	function goLogin(dataMap){
		location.href = '/m/logout.do';
		/* $.mobile.changePage(dataMap.URL); */
	}
	

	</script>

</body>
</html>