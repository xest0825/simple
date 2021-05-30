<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<html>
<head>
<script>


$(document).ready(function(){
	
	// setDeviceInfo();
	console.log('login')

	var easyPsNum;
		easyPsNum =  function() {
			return {
				init: function() {
					this.easyPsNumDisplay();
				},
				easyPsNumDisplay: function() {
					var $dpViewOnCnt = $('#dp_view_login span.on').length;
					var easy_pwd = $('#keycode').val();
					var temp_pwd = '';
					
					$(document).off('click', '#key_input button').on('click', '#key_input button' , function(e){
						if($(this).hasClass('clear')){
							easy_pwd = easy_pwd.substr(0, easy_pwd.length-1);
							$('#keycode').val(easy_pwd.replace(/[0-9]/g,"*"));
							temp_pwd = temp_pwd.substr(0, temp_pwd.length-1);
							$('#s_keycode').val(temp_pwd);
							
						}else{
							var selectNum = $(this).children('span').text();
							if(easy_pwd.length <= 3){
								temp_pwd += selectNum;
								$('#s_keycode').val(temp_pwd);
								easy_pwd += selectNum;
								$('#keycode').val(easy_pwd.replace(/[0-9]/g,"*"));
							}
							if(easy_pwd.length == 4 && temp_pwd.length){
								/* 간편로그인으로 DEVICE_ID와 간편 잠금 비밀번호 여부 확인
								맞으면 GA_CD, EMP_NO, PASSWORD로 ID/PW로그인절차 */
								easyLogin();
							}
						}
					});
				}
			}
		}
        easyPsNum().init();
        
        /*$('#idpsLoginbtn').click(function(){ /!* 아이디 비밀번호로 로그인시 *!/
        	idpsLogin();
        });*/
        
    	var fail = "${fail}"||'';
    	var msg = '${SPRING_SECURITY_LAST_EXCEPTION}'||'';
    	console.log(fail + ', ' + msg);

});

function setDeviceInfo (){
	
	try {
		reqSendDeviceInfo();
	} catch (err) {
		console.log(err);
		console.log('앱X, 웹O');
		
	}
	
	var devc_info = {};
	if (deviceParam.devc_id != undefined && deviceParam.devc_id != ''  && deviceParam.devc_id.length > 0){
		devc_info = deviceParam;
	} else {
		devc_info.os_nm = '';
		devc_info.os_ver = '';
		devc_info.devc_id = '';
		devc_info.devc_nm = '';
		devc_info.app_ver = '';
	}
	
	
	$('input[name=os_nm]').val(devc_info.os_nm);
	$('input[name=os_ver]').val(devc_info.os_ver);
	$('input[name=devc_id]').val(devc_info.devc_id);
	$('input[name=devc_nm]').val(devc_info.devc_nm);
	$('input[name=app_ver]').val(devc_info.app_ver);	
}


function defaultAction(){
	var turl = location.pathname;
	if($("#login_fail").val() == 'true' && turl == '/login.go'){
		turl = $("#target_url").val();
	}

	$("#login_fail").val('');
}
function loginTypeChk(type){
	if(type == "idps"){
		$('#idpsLoginArea').show();
		$('#easyLoginArea').hide();
	}else{
		$('#idpsLoginArea').hide();
		$('#easyLoginArea').show();
	}
}

/* id,password 로그인 */
function idpsLogin(){

	var mb_id = $('#mb_id').val(); /* 회사코드 */
	var id = $('#emp_no').val();	/* 사용자 아이디 */
	var pass = $('#pass').val();	/* 사용자 비밀번호 */

	$('#login_pw').val(pass)

	if(mb_id == "" || mb_id.length == 0){
		alert('회사코드를 입력하세요!');
		return;
	}else if(id == "" || id.length == 0){
		alert('사용자 ID를 입력하세요!');
		return;
	}else if(pass == "" || pass.length ==0){
		alert('비밀번호를 입력하세요!');
		return;
	}
	
	//console.log(mb_id + ', '+ id + ', ' + pass);

	$('#loginForm').submit();
	
}

/* 간편로그인 */
function easyLogin(){
	
	if (deviceParam.devc_id != undefined && deviceParam.devc_id != ''  && deviceParam.devc_id.length > 0){
		// 모바일 기기 접속 
	} else {
		alert('현재 기기에서는 간편 잠금 비밀번호를 사용할 수 없습니다.');
		return;
	}

	$.ajax({
		url : '/login/getUserInfo.ajax',
		type : 'post', 
        datatype: 'json',
        data : { 
        	SIMP_LOGIN_DEVC_ID : deviceParam.devc_id,
			//SIMP_LOGIN_DEVC_ID : '111',
        	SIMP_LOCK_PSWD : $('#s_keycode').val()
        },
		success : function(data) {
			console.log('사용자 DB정보 조회 성공');
			
			if(data.results != null && data.results.EMP_NO != ''){
				var emp_no = data.results.EMP_NO;
				var emp_pw = data.results.LOGIN_PSWD;
				var ga_cd = data.results.CUR_BLONG_GA_CD;

				$('#emp_no2').val(data.results.EMP_NO);
				$('#device_id').val(data.results.DEVC_ID);
				$('#loginForm2').submit();
				
			}else{
				alert('정보가 없습니다! 다시 확인해주세요');
			}
		}, 
		error:function(request,status,error){ 
			console.log(request+","+status+","+error); 
		} 
	});

}

/* 사용자관리 테이블에 먼저 있는지 여부 검사 없다면 최초등록, 있으면 update치기 위함 */
function getUserCheck(emp_no,ga_cd){	
	$.ajax({
		url : '/login/getUserInfo.ajax',
		type : 'post', 
        datatype: 'json',
        data : { EMP_NO : emp_no },
		success : function(data) {
			console.log('사용자 DB정보 조회 성공');
			if(data.results == null){ 
			/* 정보 없을때 최초 사용자 등록(insert) */ 
				insertUser(emp_no); 
			} else {	
			/* 받은 정보중에 비밀번호로 정보 최신화함(update) */
				updateUser(emp_no);
			}
		}, 
		error:function(request,status,error){ 
			console.log(request+","+status+","+error); 
		} 
	});
}

/* 사용자정보 존재하지 않을 시 최초 등록 */
function insertUser(){
	
	$.ajax({
		url : '/interfacetestdata/getMemberInfo.json',
		type : 'post', 
        datatype: 'json',
		success : function(data) {
			console.log('사용자 정보 인터페이스 받아오기 성공');
			var result = data.res_data;
			
			var param = {
				EMP_NO : result.emp_no,
				USER_NM : result.emp_nm,
				EMAIL_ADDR : result.email_addr,
				FC_REG_NO : result.fc_reg_no,
				BIRTH_DT : result.birth_dt,
				SCD_CD_PATH: result.scd_cd_path,
				SCD_NM_PATH : result.scd_nm_path,
				SEX_GB : result.sex_gb,
				STS_GB : result.sts_gb,
				TEL_NO : result.tel_no,
				LOGIN_PSWD : $('#pass').val(),
				LOGIN_ID : result.emp_no,
				CUR_BLONG_GA_CD : $('#ga_cd').val()
			}
			
			/* 인터페이스 정보 받아서 INSERT */
			$.ajax({ 
				url : '/login/insertUser.ajax',
				type : 'post', 
		        datatype: 'json',
		        data : param,
				success : function(data) {
					console.log('사용자 정보 DB 저장성공');
					pageAct({URL: '/pccplus/goAttachSign.go'});
				}, 
				error:function(request,status,error){ 
					console.log(request+","+status+","+error); 
				} 
			});
		
		}, 
		error:function(request,status,error){ 
			console.log(request+","+status+","+error); 
		} 
	});
}

/* 사용자정보 존재 시 정보(비밀번호) 업데이트 */
function updateUser(emp_no){
	$.ajax({
		url : '/interfacetestdata/getMemberInfo.json',
		type : 'post', 
        datatype: 'json',
		success : function(data) {
			console.log('사용자 정보 인터페이스 받아오기 성공(업데이트)');
			var result = data.res_data;
			
			var param = {
				EMP_NO : result.emp_no,
				USER_NM : result.emp_nm,
				LOGIN_PSWD : $('#pass').val()
			}
			
			/* 인터페이스 정보 받아서 UPDATE */
			$.ajax({ 
				url : '/login/updateUser.ajax',
				type : 'post', 
		        datatype: 'json',
		        data : param,
				success : function(data) {
					$.ajax({
						url : '/login/getUserInfo.ajax',
						type : 'post', 
				        datatype: 'json',
				        data : { EMP_NO : result.emp_no },
						success : function(data) {
							console.log('사용자 DB정보 조회 성공[updatecase]');
							if(data.results.SIGN == ""){ //서명 없을때
								location.href = '/pccplus/goAttachSign.go';
							}else{
								location.href= '/pccplus/main.go';
							}
						}, 
						error:function(request,status,error){ 
							console.log(request+","+status+","+error); 
						} 
					});
					
				}, 
				error:function(request,status,error){ 
					console.log(request+","+status+","+error); 
				} 
			});
		
		}, 
		error:function(request,status,error){ 
			console.log(request+","+status+","+error); 
		} 
	});
}


function testApilogin(emp_no,mb_id){	
	var mb_id = $('#mb_id').val();
	var emp_no = $('#emp_no').val();
	var pass = $('#pass').val();
	
	$.ajax({
		url : '/pccplus/loginTest.ajax',
		type : 'post', 
        datatype: 'json',
        data : { mb_id : mb_id, EMP_NO : emp_no, PASS : pass },
		success : function(data) {
			console.log('API 조회 성공');
			if(data.results == null){ 
				alert('데이터 없습니다.');
			} else {	
				alert(data.results);
			}
		}, 
		error:function(request,status,error){ 
			console.log(request+","+status+","+error); 
		} 
	});
}

function testApilogin2(emp_no,mb_id){	
	var mb_id = $('#mb_id').val();
	var emp_no = $('#emp_no').val();
	var pass = $('#pass').val();
	
	$.ajax({
		url : '/pccplus/getApiUserInfoTest.ajax',
		type : 'post', 
        datatype: 'json',
        data : { mb_id : mb_id, EMP_NO : emp_no, PASS : pass },
		success : function(data) {
			console.log('API 조회 성공');
			if(data.results == null){ 
				alert('데이터 없음.')
			} else {	
				alert(data.results);
			}
		}, 
		error:function(request,status,error){ 
			console.log(request+","+status+","+error); 
		} 
	});
}

function goMain(dataMap){
	$.mobile.changePage(dataMap.URL);
}

</script>
</head>
<body>
    <div class="login01">
      <h1>Smart 확인서</h1>

	  <!-- ID/PW LOGIN 영역 START -->
	  <div id="idpsLoginArea">
	  	  <form name="loginForm" id="loginForm" action="/m/login.do" method="POST" >

		  	  <input type="hidden" id="login_type" name = "login_type"  value="idpw">
			  <input type="hidden" id="mb_id" name="mb_id" value="GAK">
			  <input type="hidden" id="os_nm" name="os_nm" value="">
			  <input type="hidden" id="os_ver" name="os_ver" value="">
			  <input type="hidden" id="devc_id" name="devc_id" value="">
			  <input type="hidden" id="devc_nm" name="devc_nm" value="">
			  <input type="hidden" id="app_ver" name="app_ver" value="">

		      <ul class="input_sty mt20">
		        <%--<li>
		          <span>회사코드</span>
		          <input type="text" placeholder="아이디를 입력해 주세요" id="mb_id" name="mb_id" data-role="none">
		        </li>--%>
		        <li>
		          <span>아이디</span>
		          <input type="text" placeholder="사번을 입력해 주세요" id="emp_no" name="j_username" data-role="none">
		        </li>
		        <li>
		          <span>비밀번호</span>
		          <input type="password" placeholder="비밀번호를 입력해 주세요" id="pass" name="j_password" data-role="none">
		        </li>
		      </ul>
	      </form>
		  <c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION}">
		  <div style="margin-top: 25px; text-align: center;font-size: 1.2em; color:red;">
			  <p>로그인이 되지 않았습니다. 계정 정보를 확인해주세요.<br/></p>
		  </div>
		  </c:if>
	      <button class="btn_b mt30 mb10" id="idpsLoginbtn" onclick="idpsLogin();">로그인</button>
	      <!-- <button class="btn_b mt30 mb10" id="idpsLoginbtn" onclick="goMain({URL:'/m/main.go'});">로그인</button> -->
	      <!-- <button class="fr br0" id="easyLogin" onclick="loginTypeChk('easy')">잠금 비밀번호 로그인</button> -->
	  </div>
	  <!-- ID/PW LOGIN 영역 END -->

    </div><!-- //class="login01" -->

	  <!-- 간편 LOGIN 영역 END -->	
	  <div id="easyLoginArea" style="display:none;">
	  	  <form name="loginForm2" id="loginForm2" action="/m/login.do" method="POST" >
		  	  <input type="hidden" id="login_type2" name="login_type"  value="ezpw">
			  <input type="hidden" id="mb_id2" 		name="mb_id" 	   value="GAK">
			  <input type="hidden" id="emp_no2" 	name="j_username"  value="">
		  <div class="keyboard_bg">
	          <input class="key" id="keycode"/>
	          <input type="hidden" id="s_keycode"  name="j_password" />
	          <input type="hidden" id="device_id" name="simp_login_devc_id"/>
	          <input type="hidden" id="os_nm2"     name="os_nm"   value="">
			  <input type="hidden" id="os_ver2"    name="os_ver"  value="">
			  <input type="hidden" id="devc_id2"   name="devc_id" value="">
			  <input type="hidden" id="devc_nm2"   name="devc_nm" value="">
			  <input type="hidden" id="app_ver2"   name="app_ver" value="">
	      </div>
	      </form>
	
	      <div class="keyboard">
	          <div class="btn-group" id="key_input">
	              <button type="button" class=""><span>1</span></button>
	              <button type="button" class=""><span>2</span></button>
	              <button type="button" class="br0"><span>3</span></button>
	          
	              <button type="button" class=""><span>4</span></button>
	              <button type="button" class=""><span>5</span></button>
	              <button type="button" class="br0"><span>6</span></button>
	          
	              <button type="button" class=""><span>7</span></button>
	              <button type="button" class=""><span>8</span></button>
	              <button type="button" class="br0"><span>9</span></button>
	         
	              <button type="button" class="" onclick=""></button>
	              
	              <button type="button" class=""><span>0</span></button>
	              <button type="button" class="br0 clear">&lt;</button>
	          </div>
	      </div>
      </div>
      
    <div class="bottom">
      <button class="fl" 	 id="idpsLogin" onclick="loginTypeChk('idps')">ID/비밀번호 로그인</button>
      <button class="fr br0" id="easyLogin" onclick="loginTypeChk('easy')">잠금 비밀번호 로그인</button>
    </div>

	<div id="target">
	
	</div>
</body>
</html>