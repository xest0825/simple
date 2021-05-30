<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 06. 02
	화면 설명 : 비밀번호 변경
######################################################################################### 
 -->
<html>
<head>
<script type="text/javascript">
$(document).ready(function() {
	$('#form').ajaxForm({
		success : function(data) {
			genexon.alert("success", "비밀번호 변경", "정상 처리하였습니다");
			
			$(".ta_sample2").children().find("input").each(function(idx){
				$(this).val('');
			});
		},
		error : function(data) {
			genexon.alert("error", "비밀번호 변경", "입력중 에러가 발생하였습니다.");
		}
	});
	
	$("#bt_save").on("click", function(e) {
		passwordChange();
	});
});

function passwordChange() {
	var flag = checkBeforeSave();
	
	if(!flag) return;
	
	$.ajax({
		url: "/comm/getAuthCheck.ajax",
		type: "POST",
		data: {
			mb_id: "${User.mb_id}",
			login_id: "${User.user_id}",
			login_pw: $("#currentPassword").val()
		},
		success: function(data) {
			if(data.SPRING_SECURITY_LAST_EXCEPTION != null) {
				genexon.alert("info", "비밀번호변경", "현재 비밀번호가 일치하지 않습니다.");
			}else {
				genexon.confirm("비밀번호변경", "비밀번호를 변경하시겠습니까?", function(result) {
					if(result) {
						$("#form").submit();
					}
				});
			}
		}
	});
}

function checkBeforeSave() {
	var flag = true;
	var value = "";
	var title = "";
	var id = "";
	
	$("input[essential]").each(function(idx){
		value = $(this).val();
		title = $(this).attr("essential");
		id = $(this).attr("id");
		
		if(value == "") {
			genexon.alert("info", "비밀번호 변경", "["+title+"]은 필수 입력입니다.");
			flag = false;
			return false;
		}
	});
	
	var newPassword = $("#user_pwd").val();
	var newPasswordConfirm = $("#user_pwd_confirm").val();
	
	if(newPassword.length < 8) {
		genexon.alert("info", "비밀번호변경", "새 비밀번호는 최소 8자리입니다.");
		return false;
	}
	
	if(newPassword != newPasswordConfirm) {
		genexon.alert("info", "비밀번호변경", "새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.");
		return false;
	}
	
	return flag;
}
</script>
</head>
<body>
<form id="form" name="form" method="post" action="/system/userAccountManage/passwordChange.ajax?${_csrf.parameterName}=${_csrf.token}">
<table class="ta_sample2">
	<colgroup>
		<col width="20%" />
		<col width="80%" />
	</colgroup>
	<tbody>
	<tr>
		<th>기존 비밀번호</th>
		<td>
			<input type="password" id="currentPassword" name="currentPassword" idx="1" class="기존 비밀번호">
			<!-- <span toggle="maskedtextbox" class="k-icon k-i-lock toggle-password" idx="1"></span> -->
		</td>
	</tr>
	<tr>
		<th>새 비밀번호</th>
		<td>
			<input type="password" id="user_pwd" name="user_pwd" idx="2" class="새 비밀번호">
			<!-- <span toggle="maskedtextbox" class="k-icon k-i-lock toggle-password" idx="2"></span> -->
		</td>
	</tr>
	<tr>
		<th>새 비밀번호 확인</th>
		<td>
			<input type="password" id="user_pwd_confirm" name="user_pwd_confirm" idx="3" class="새 비밀번호 확인">
			<!-- <span toggle="maskedtextbox" class="k-icon k-i-lock toggle-password" idx="3"></span> -->
		</td>
	</tr>
	</tbody>
</table>
<hr style="display:block;height:10px; border: none;">
<div class="bt_right">
	<div class="bt_glay2_S" id="bt_save">비밀번호 변경</div>
</div>
<!-- <p>● 비밀번호 조건 적용</p>
<p>1. 영문, 숫자, 특수문자를 포함하여 8자리 이상</p>
<p>2. 본인의 전화번호, ID, 핸드폰번호 금지</p>
<p>3. 연속되는 숫자, 문자 4자 이상 금지(ex> 1234, abcd)</p>
<p>4. 키보드상 연속되는 문자 4자 이상 금지(ex> qwer, asdf)</p>
<p>5. 같은 숫자, 문자 4자 이상 금지(ex> 1111, aaaa)</p> -->
</form>
</body>
</html>