<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 03. 25
	화면 설명 : 겸직자 권한변경 팝업
######################################################################################### 
 -->
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<script type="text/javascript">
$(document).ready(function(){
	getEmpCdDropDown();
});

// 드랍다운 리스트
function getEmpCdDropDown() {
	$("#concurrent_nm").kendoDropDownList({
		optionLabel: "선택",
		dataTextField: "concurrent_nm",
		dataValueField: "role_id",
        filter: "contains",
		dataSource: {
			transport: {
				read: {url : "/userRole/getUserRoleList.ajax?${_csrf.parameterName}=${_csrf.token}"
					  ,data:{emp_cd : "${UserRoleVO.emp_cd}"}
					  }
			},schema: {
				data: "results" 
			}
		},
		select: function(e) {
			var dataItem = this.dataItem(e.item);
			$("#emp_cd").val(dataItem.emp_cd);
			$("#role_id").val(dataItem.role_id);
			$("#concurrent_idx").val(dataItem.concurrent_idx);
		}
	}).data("kendoDropDownList");
}

function onClick(e) {
	if($("#concurrent_nm").val() == "" || $("#concurrent_nm").val() == null) {
		genexon.alert("error", "변경전 확인", "변경할 직책을 선택해주세요");
		$("#concurrent_nm").focus();
		return;
	}
	
	$.ajax({
		 type : 'POST',
         url : '/index.go?${_csrf.parameterName}=${_csrf.token}',
         data : "mb_id=${UserRoleVO.mb_id}&user_id=" + $("#emp_cd").val() + "&role_id=" + $("#role_id").val() + "&concurrent_idx=" + $("#concurrent_idx").val(),
         complete : function(e) {
        	 parent.location.reload(true);
        	 genexon.PopWindowClose2("#change_concurrent");
         }
	});
 } 
</script>
</head>
<body>
  <input type="hidden" id="emp_cd" name="emp_cd" /> 
  <input type="hidden" id="role_id" name="role_id" /> 
  <input type="hidden" id="concurrent_idx" name="concurrent_idx" /> 
   <!-- Content //-->
  <div class="content">
    <div class="bg_con">
      <div class="searchPop">
		  <table class="se">
			<tr>
				<td>
					<input type="text" class="kddl" id="concurrent_nm" name="concurrent_nm" ddcode="" style="width:350px;"/>
				</td>
			</tr>   
		  </table>
	  </div>
	<div class="bt_right">
       	<div class="bt_glay_S" onclick="onClick()">변경</div>
	</div>
    </div>
    <!--end bg_con-->
  </div>
</body> 
</html>