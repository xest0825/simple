<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 03. 11
	화면 설명 : 보험사 등록/수정
######################################################################################### 
 -->
<html>
<head>
<script type="text/javascript">
$(document).ready(function() {

	$(function() {
		//폼전송
		$('#myForm').ajaxForm({
			//보내기전 validation check가 필요할경우
			beforeSubmit : function(data, frm, opt) {
				return true;
			},
			//submit이후의 처리
			success : function(responseText, statusText) {
				genexon.PopWindowClose2("#CN_810");
				genexon.alert("success", "결과" , "정상처리되었습니다.");
			},
			//ajax error
			error : function() {
				alert("에러발생!!");
			}
		});
	});
	
	// 저장
	$('#bt_save').bind('click', function(e) {
		save();
	});

 	$("#prtn_start_ymd").kendoDatePicker();
 	$("#prtn_end_ymd").kendoDatePicker();
 	
 // 조회기간시작일 
 	$("#prtn_start_ymd").kendoDatePicker({ format : "yyyy-MM-dd" });
 	$('#prtn_start_ymd').kendoMaskedTextBox({ mask : "0000-00-00" });
 	// 조회기간종료일
 	$("#prtn_end_ymd").kendoDatePicker({ format : "yyyy-MM-dd" });
 	$('#prtn_end_ymd').kendoMaskedTextBox({ mask : "0000-00-00" });
	//시작일자 종료일자 관련
 	genexon.compareSrchTerm("prtn_start_ymd", "prtn_end_ymd");

	// 수정폼은 보험사코드 수정 못함
	if ($("#insco_cd").val() == "") {
		$("#insco_cd").attr("readonly", false);
	} else {
		$("#insco_cd").attr("readonly", true);
	}
	
	var sort_no = '${InscoVO.sort_no}';
	if(genexon.nvl(sort_no, "") == "") {
		$("#sort_no").val("999");
	}
});

// 저장
function save() {
	var insavo;
	var flag = checkBeforeSave();
	if (flag == true) {
		if (confirm("보험사정보를 저장하시겠습니까?") == true) {
			insavo = genexon.getJSONString(genexon.getAllInputDataToJson());
			// TODO : 모은 JSON으로 서버로 전송
			$('#myForm').submit();
		}
	}

}

//저장전 확인
function checkBeforeSave() {
	var flag = false;

	var insco_cd = $('#insco_cd').val();
	if (insco_cd != undefined && insco_cd.length > 0 && insco_cd != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "보험사를 입력하세요.");
		$('#insco_cd').focus();
		return;
	}

	var insco_type = $('#insco_type').val();
	if (insco_type != undefined && insco_type.length > 0 && insco_type != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "보험구분을 선택하세요.");
		$('#insco_type').focus();
		return;
	}

	var insco_nm = $('#insco_nm').val();
	if (insco_nm != undefined && insco_nm.length > 0 && insco_nm != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "보험사명을 입력하세요.");
		$('#insco_nm').focus();
		return;
	}
	
	var useyn = $('#use_yn').val();
	if (useyn != undefined && useyn.length > 0 && useyn != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "사용유무를 선택하세요.");
		$('#use_yn').focus();
		return;
	}

	return flag;
}

function closeMe() {
	genexon.alert("success", "저장", "저장하였습니다.");
	genexon.PopWindowClose(parent.genexon.openwindowID);
}
</script>

</head>
<body>
<form id="myForm" name="myForm" method="post" action="/system/insco/insertOrUpdateInsco.ajax?${_csrf.parameterName}=${_csrf.token}" enctype="multipart/form-data">
	<div class="content" style="background: white;">
		<table class="ta_sample2">
			<caption>테이블 샘플</caption>
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="30%" />
			</colgroup>
			<tbody>
				<tr>
					<th class="essential">보험사</th>
					<td>
						<input type="text" class="k-textbox in_dis" name="insco_cd" id="insco_cd" style="width:70px" value="${InscoVO.insco_cd}" />
						<input type="text" class="kddl" name="insco_type" id="insco_type" ddcode="INSCO_TYPE" optionLabel="선택" value="${InscoVO.insco_type}" />
					</td>
					<th class="essential">보험사명</th>
					<td>
						<input type="text" class="k-textbox" name="insco_nm" id="insco_nm" style="width: 99%;" value="${InscoVO.insco_nm}" /></td>
				</tr>
				<tr>
					<th>가입설계 URL</th>
					<td colspan="3">
						<input type="text" class="k-textbox" name="plan_url" id="plan_url" style="width: 99%;" value="${InscoVO.plan_url}" />
					</td>
				</tr>
				<tr>
					<th>홈페이지 URL</th>
					<td colspan="3">
						<input type="text" class="k-textbox" name="home_url" id="home_url" style="width: 99%;" value="${InscoVO.home_url}" />
					</td>
				</tr>
				<tr>
					<th>대표연락처</th>
					<td><input type="text" class="k-textbox" name="preno" id="preno" style="width: 99%;" value="${InscoVO.preno}" /></td>
					<th>FAX</th>
					<td><input type="text" class="k-textbox" name="faxno" id="faxno" style="width: 99%;" value="${InscoVO.faxno}" /></td>
				</tr>
				<tr>
					<th>헬프데스크</th>
					<td><input type="text" class="k-textbox" name="helpno" id="helpno" style="width: 99%;" value="${InscoVO.helpno}" /></td>
					<th>IT 데스크</th>
					<td><input type="text" class="k-textbox" name="itno" id="itno" style="width: 99%;" value="${InscoVO.itno}" /></td>
				</tr>
				<tr>
					<th>로고(이미지)</th>
					<td colspan="3">
						<input type="text" class="k-textbox" name="ci_url" id="ci_url" style="width: 55%;" value="${InscoVO.ci_url}">&nbsp;
						<input type="file" name="file_nm" id="file_nm" style="width: 42%; border: 1px solid #adadad;">&nbsp;
					</td>
				</tr>
				<tr>
					<th>제휴시작일</th>
					<td><input type="text" name="prtn_start_ymd" id="prtn_start_ymd" value="${InscoVO.prtn_start_ymd}"></td>
					<th>제휴종료일</th>
					<td><input type="text" name="prtn_end_ymd" id="prtn_end_ymd" value="${InscoVO.prtn_end_ymd}"></td>
				</tr>
				<tr>
					<th class="essential">사용유무</th>
					<td><input type="text" class="kddl" name="use_yn" id="use_yn" ddcode="USE_YN" value="${InscoVO.use_yn}" optionLabel="선택" defaultIndex="1"></td>
					<th>정렬순서</th>
					<td><input type="text" class="k-textbox" name="sort_no" id="sort_no" style="width: 99%;" value="${InscoVO.sort_no}"></td>
				</tr>
				<tr>
					<th>메모</th>
					<td colspan="3">
						<textarea rows="5" id="memo" name="memo"  style="width: 99%; resize: none;">${InscoVO.memo}</textarea>
					</td>
				</tr>
			</tbody>
		</table>

		<div class="bt_right">
			<div class="bt_glay2_S" id="bt_cancel" onclick="genexon.PopWindowClose2('#CN_810');">취소</div>
			<div class="bt_glay2_S" id="bt_save">저장</div>
		</div>

	</div>
	<!--end content-->

</form>
</body>
</html>