<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 05. 02
	화면 설명 : 회원사관리 등록/수정
######################################################################################### 
 -->
<html>
<head>
<%-- <%@ include file="../../comm/address.jsp"%> --%>
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
				genexon.PopWindowClose2("#memberRegi");
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

	// 수정폼은 회사코드 수정 못함
	if ($("#mb_id").val() == null || $("#mb_id").val() == "") {
		$("#mb_id").attr("readonly", false);
	} else {
		$("#mb_id").attr("readonly", true);
		$("#sel_mb").css("display", "none");
		
	}
	
	$("#session_time").kendoNumericTextBox({format: "###,###,###", spinners: false, decimals: 0});
	
});

// 저장
function save() {
	var flag = checkBeforeSave();
	
	if (flag == true) {
		if (confirm("회원사정보를 저장하시겠습니까?") == true) {
			genexon.getJSONString(genexon.getAllInputDataToJson());
			// TODO : 모은 JSON으로 서버로 전송
			$('#myForm').submit();
		}
	}

}

//저장전 확인
function checkBeforeSave() {
	var flag = false;

	var mb_id = $('#mb_id').val();
	if (mb_id != undefined && mb_id.length > 0 && mb_id != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "회사코드를 입력하세요.");
		$('#mb_id').focus();
		return;
	}

	var mb_login_id = $('#mb_login_id').val();
	if (mb_login_id != undefined && mb_login_id.length > 0 && mb_login_id != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "화원사로그인ID를 입력하세요.");
		$('#insco_type').focus();
		return;
	}

	var mb_nm = $('#mb_nm').val();
	if (mb_nm != undefined && mb_nm.length > 0 && mb_nm != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "회사명을 입력하세요.");
		$('#mb_nm').focus();
		return;
	}

	var sort_no = $('#sort_no').val();
	if (sort_no != undefined && sort_no.length > 0 && sort_no != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "정렬순서를 입력하세요.");
		$('#sort_no').focus();
		return;
	}
	
	var copy_mb_id = $('#copy_mb_id').val();
	if (copy_mb_id != undefined && copy_mb_id.length > 0 && copy_mb_id != '') {
		flag = true;
	} else {
		genexon.alert("error", "저장전 확인", "회사를 선택하세요.");
		$('#copy_mb_id').focus();
		return;
	}
	
	return flag;
}
</script>

</head>
<body>
<form id="myForm" name="myForm" method="post" action="/system/member/insertMember.ajax?${_csrf.parameterName}=${_csrf.token}" enctype="multipart/form-data">
	<input type="hidden" id="target_address" />
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
					<th class="essential">회사코드</th>
					<td>
						<input type="text" class="k-textbox" name="mb_id" id="mb_id" style="width:70px" value="${MemberVO.mb_id}" />
					</td>
					<th class="essential">회원사로그인ID</th>
					<td>
						<input type="text" class="k-textbox" name="mb_login_id" id="mb_login_id" style="width: 250px;" value="${MemberVO.mb_login_id}" />
					</td>
				</tr>
				<tr>
					<th class="essential">회사명</th>
					<td>
						<input type="text" class="k-textbox" name="mb_nm" id="mb_nm" style="width: 250px;" value="${MemberVO.mb_nm}" />
					</td>
					<th>법인등록번호</th>
					<td>
						<input type="text" class="k-textbox" name="corp_reg_num" id="corp_reg_num" style="width: 250px;" value="${MemberVO.corp_reg_num}" />
					</td>
				</tr>
				<tr id="sel_mb">
					<th class="essential">회사선택</th>
					<td colspan="3">
						<input type="text" class="kddl" name="copy_mb_id" id="copy_mb_id" ddcode="MB_ID" optionLabel="선택" defaultIndex="1" style="width: 120px;"/>
					</td>
				</tr>
				<tr>
					<th>주소</th>
					<td colspan="3" style="color: #555; font-weight: 600; font-size: 110%;">
						<input type="text" class="k-textbox" id="zipcd" name="zipcd" style="width: 70px;" value="${MemberVO.zipcd}" />&nbsp;
						<div class="bt_glay_S" id="bt_zcd_srch" onclick="javascript:newaddressOpen2('memberRegi', 'zipcd', 'addr1', 'addr2');">우편번호조회</div>&nbsp;
						<input type="text" class="k-textbox" id="addr1" name="addr1" style="width: 230px;" value="${MemberVO.addr1 }" />&nbsp;
						<input type="text" class="k-textbox" id="addr2" name="addr2" style="width: 256px;" value="${MemberVO.addr2 }" />
					</td>
				</tr>
				<tr>
					<th>도메인URL</th>
					<td>
						<input type="text" class="k-textbox" name="domain_url" id="domain_url" style="width: 250px;" value="${MemberVO.domain_url}" />
					</td>
					<th>대표자명</th>
					<td>
						<input type="text" class="k-textbox" name="represent_nm" id="represent_nm" style="width: 250px;" value="${MemberVO.represent_nm}" />
					</td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>
						<input type="text" class="k-textbox" name="telno" id="telno" style="width: 250px;" value="${MemberVO.telno}" />
					</td>
					<th>팩스번호</th>
					<td>
						<input type="text" class="k-textbox" name="faxno" id="faxno" style="width: 250px;" value="${MemberVO.faxno}" />
					</td>
				</tr>
				<tr>
					<th>사업자번호</th>
					<td>
						<input type="text" class="k-textbox" name="tax_reg_num" id="tax_reg_num" style="width: 250px;" value="${MemberVO.tax_reg_num}" />
					</td>
					<th>회사이메일</th>
					<td>
						<input type="text" class="k-textbox" name="corp_email" id="corp_email" style="width: 250px;" value="${MemberVO.corp_email}" />
					</td>
				</tr>
				<tr>
					<th>관리자명</th>
					<td>
						<input type="text" class="k-textbox" name="manager_nm" id="manager_nm" style="width: 250px;" value="${MemberVO.manager_nm}" />
					</td>
					<th>관리자전화</th>
					<td>
						<input type="text" class="k-textbox" name="mtelno" id="mtelno" style="width: 250px;" value="${MemberVO.mtelno}" />
					</td>
				</tr>
				<tr>
					<th>증명서 출력용 회사명</th>
					<td>
						<input type="text" class="k-textbox" name="certificate_mb_nm" id="certificate_mb_nm" style="width: 250px;" value="${MemberVO.certificate_mb_nm}" />
					</td>
					<th>세션유지시간(분)</th>
					<td>
						<input type="text" class="col-right" name="session_time" id="session_time" style="width: 250px;" value="${MemberVO.session_time}" min="10" />
					</td>
				</tr>
				<tr>
					<th>Copyright</th>
					<td>
						<input type="text" class="k-textbox" name="copy_right" id="copy_right" style="width: 250px;" value="${MemberVO.copy_right}">
					</td>
					<th class="essential">정렬순서</th>
					<td>
						<input type="number" class="k-textbox" name="sort_no" id="sort_no" value="${MemberVO.sort_no}" />
					</td>
				</tr>
				<tr>
					<th>회사CI</th>
					<td>
						<input type="hidden" name="ci_no" id="ci_no" value="${MemberVO.ci_no}">
						<input type="hidden" class="k-textbox" name="ci_url" id="ci_url" value="${MemberVO.ci_url}">
						<input type="file" name="ci_name" id="ci_name">
					</td>
					<th>회사로고</th>
					<td>
						<input type="hidden" name="logo_no" id="logo_no" value="${MemberVO.logo_no}">
						<input type="hidden" class="k-textbox" name="logo_url" id="logo_url" value="${MemberVO.logo_url}">
						<input type="file" name="logo_name" id="logo_name" >
					</td>
				</tr>
				<tr>
					<th>증명서사용로고</th>
					<td>
						<input type="hidden" name="certlogo_no" id="certlogo_no" value="${MemberVO.certlogo_no}">
						<input type="hidden" class="k-textbox" name="certlogo_url" id="certlogo_url" value="${MemberVO.certlogo_url}">
						<input type="file" name="certlogo_name" id="certlogo_name" >
					</td>
					<th>직인</th>
					<td>
						<input type="hidden" name="seal_no" id="seal_no" value="${MemberVO.seal_no}">
						<input type="hidden" class="k-textbox" name="seal_url" id="seal_url" value="${MemberVO.seal_url}">
						<input type="file" name="seal_name" id="seal_name" >
					</td>
				</tr>
			</tbody>
		</table>

		<div class="bt_right">
			<div class="bt_save" id="bt_save">저장</div>
		</div>

	</div>
	<!--end content-->

<script type="text/javascript">
$(document).ready(function() {
	CiUpload();
	LogoUpload();
	CertlogoUpload();
	SealUpload();
});

function CiUpload() {
	$("#ci_name").kendoUpload({
		multiple : false,
		async : {
			saveUrl : "/system/member/infoUrl.ajax?${_csrf.parameterName}=${_csrf.token}",
			removeUrl : "/system/member/deleteUrl.ajax?${_csrf.parameterName}=${_csrf.token}",
			autoUpload : true
		},
        files:[<c:if test="${MemberVO.ci_no ne null and MemberVO.ci_no != ''}">{name:"${MemberVO.ci_file_nm}",size:"${MemberVO.ci_file_size}"}</c:if>],
		upload : function(e) {
			e.data = {
				mb_id : $("#mb_id").val()
			}
		},
		remove : function(e) {
			if (confirm("이미지가 바로 삭제됩니다. 삭제하시겠습니까?") == true) {
				e.data = {
					file_no : $("#ci_no").val(),
					mb_id : $("#mb_id").val()
				}
			} else {
				e.preventDefault();
			}
		},
		validation : {
			allowedExtensions : [ ".jpg", ".png" ]
		},
		showFileList : true,
		localization : {
			select : "선택",
			remove : "삭제",
			dropFilesHere : "300X200 사이즈",
			uploadSelectedFiles : "파일선택",
			statusUploading : "전송중",
			statusUploaded : "전송 완료",
			statusFailed : "전송 실패",
			headerStatusUploading : "파일 처리중",
			headerStatusUploaded : "완료"
		},
		success : function(data) {
			if (data.response.FileVO != undefined) {
				$("#ci_url").val(data.response.FileVO.file_url);
				$("#ci_no").val(data.response.FileVO.file_no);
			}
		}
	});
}

function LogoUpload() {
	$("#logo_name").kendoUpload({
		multiple : false,
		async : {
			saveUrl : "/system/member/infoUrl.ajax?${_csrf.parameterName}=${_csrf.token}",
			removeUrl : "/system/member/deleteUrl.ajax?${_csrf.parameterName}=${_csrf.token}",
			autoUpload : true
		},
        files:[<c:if test="${MemberVO.logo_no ne null and MemberVO.logo_no != ''}">{name:"${MemberVO.logo_file_nm}",size:"${MemberVO.logo_file_size}"}</c:if>],
		upload : function(e) {
			e.data = {
				mb_id : $("#mb_id").val()
			}
		},
		remove : function(e) {
			if (confirm("이미지가 바로 삭제됩니다. 삭제하시겠습니까?") == true) {
				e.data = {
					file_no : $("#logo_no").val(),
					mb_id : $("#mb_id").val()
				}
			} else {
				e.preventDefault();
			}
		},
		validation : {
			allowedExtensions : [ ".jpg", ".png" ]
		},
		showFileList : true,
		localization : {
			select : "선택",
			remove : "삭제",
			dropFilesHere : "210X65 사이즈",
			uploadSelectedFiles : "파일선택",
			statusUploading : "전송중",
			statusUploaded : "전송 완료",
			statusFailed : "전송 실패",
			headerStatusUploading : "파일 처리중",
			headerStatusUploaded : "완료"
		},
		success : function(data) {
			if (data.response.FileVO != undefined) {
				$("#logo_url").val(data.response.FileVO.file_url);
				$("#logo_no").val(data.response.FileVO.file_no);
			}
		}
	});
}

function CertlogoUpload() {
	$("#certlogo_name").kendoUpload({
		multiple : false,
		async : {
			saveUrl : "/system/member/infoUrl.ajax?${_csrf.parameterName}=${_csrf.token}",
			removeUrl : "/system/member/deleteUrl.ajax?${_csrf.parameterName}=${_csrf.token}",
			autoUpload : true
		},
        files:[<c:if test="${MemberVO.certlogo_no ne null and MemberVO.certlogo_no != ''}">{name:"${MemberVO.certlogo_file_nm}",size:"${MemberVO.certlogo_file_size}"}</c:if>],
		upload : function(e) {
			e.data = {
				mb_id : $("#mb_id").val()
			}
		},
		remove : function(e) {
			if (confirm("이미지가 바로 삭제됩니다. 삭제하시겠습니까?") == true) {
				e.data = {
					file_no : $("#certlogo_no").val(),
					mb_id : $("#mb_id").val()
				}
			} else {
				e.preventDefault();
			}
		},
		validation : {
			allowedExtensions : [ ".jpg", ".png" ]
		},
		showFileList : true,
		localization : {
			select : "선택",
			remove : "삭제",
			dropFilesHere : "140X45 사이즈",
			uploadSelectedFiles : "파일선택",
			statusUploading : "전송중",
			statusUploaded : "전송 완료",
			statusFailed : "전송 실패",
			headerStatusUploading : "파일 처리중",
			headerStatusUploaded : "완료"
		},
		success : function(data) {
			if (data.response.FileVO != undefined) {
				$("#certlogo_url").val(data.response.FileVO.file_url);
				$("#certlogo_no").val(data.response.FileVO.file_no);
			}
		}
	});
}

function SealUpload() {
	$("#seal_name").kendoUpload({
		multiple : false,
		async : {
			saveUrl : "/system/member/infoUrl.ajax?${_csrf.parameterName}=${_csrf.token}",
			removeUrl : "/system/member/deleteUrl.ajax?${_csrf.parameterName}=${_csrf.token}",
			autoUpload : true
		},
        files:[<c:if test="${MemberVO.seal_no ne null and MemberVO.seal_no != ''}">{name:"${MemberVO.seal_file_nm}",size:"${MemberVO.seal_file_size}"}</c:if>],
		upload : function(e) {
			e.data = {
				mb_id : $("#mb_id").val()
			}
		},
		remove : function(e) {
			if (confirm("이미지가 바로 삭제됩니다. 삭제하시겠습니까?") == true) {
				e.data = {
					file_no : $("#seal_no").val(),
					mb_id : $("#mb_id").val()
				}
			} else {
				e.preventDefault();
			}
		},
		validation : {
			allowedExtensions : [ ".jpg", ".png" ]
		},
		showFileList : true,
		localization : {
			select : "선택",
			remove : "삭제",
			dropFilesHere : "140X45 사이즈",
			uploadSelectedFiles : "파일선택",
			statusUploading : "전송중",
			statusUploaded : "전송 완료",
			statusFailed : "전송 실패",
			headerStatusUploading : "파일 처리중",
			headerStatusUploaded : "완료"
		},
		success : function(data) {
			if (data.response.FileVO != undefined) {
				$("#seal_url").val(data.response.FileVO.file_url);
				$("#seal_no").val(data.response.FileVO.file_no);
			}
		}
	});
}
</script>
</form>
</body>
</html>