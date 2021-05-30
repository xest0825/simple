<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 23
	화면 설명 : 이미지 링크 유형 등록/수정 팝업
######################################################################################### 
 -->
<html>
<head>
<style type="text/css">
.main_box01 {
	list-style: none;
	width: 100%;
	display: block;
	height: 300px;
}

.main_box01 li {
	width: 310px;
	height: 300px;
	margin-right: 25px;
	box-sizing: border-box;
	border: 1px solid #fff;
	border-radius: 2px;
	margin: 0 auto;
}

.imgsty01 {border-radius: 2px; width: 300px; height: 300px;}
.imgsty02 {border-radius: 2px; width: 300px; height: 150px;}
.imgsty03 {border-radius: 2px; width: 300px; height: 100px;}
.imgsty04 {border-radius: 2px; width: 150px; height: 150px;}
.imgsty06 {border-radius: 2px; width: 150px; height: 100px;}

tr.configTableTR2,
tr.configTableTR3,
tr.configTableTR4,
tr.configTableTR5,
tr.configTableTR6 {
	display: none;
}

/* 첨부파일 영역 START */
.k-upload-files {
	white-space: nowrap;
}

.k-file-extension-wrapper {
	border-width: 2px;
    color: #999;
    border-color: #999;
    position: relative;
    width: 24px;
    height: 34px;
    border-style: solid;
    vertical-align: top;
    font-size: .57em;
    text-transform: uppercase;
    box-sizing: content-box;
    display: inline-block;
}

.k-file-extension-wrapper::before {
	content: " ";
	background-color: #fff;
	border-color: transparent transparent #999 #999;
	position: absolute;
    content: "";
    display: inline-block;
    border-style: solid;
    top: -1px;
    right: -1px;
    width: 0;
    height: 0;
    border-width: 6px;
    margin-top: -1px;
    margin-right: -1px;
}

.k-file-name-size-wrapper {
	vertical-align: middle;
	margin-left: 0.4em;
	max-width: calc(100% - 24px - 7em);
	display: inline-block;
	box-sizing: content-box;
	text-align: left;
	font-size: 1.2em;
}

.k-file-extension {
    margin-bottom: .3em;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 100%;
	bottom: 0;
    line-height: normal;
    left: 2px;
    position: absolute;
}

.k-file-name {
	position: relative;
	max-width: 100%;
	vertical-align: middle;
	line-height: 1.2em;
	overflow: hidden;
	text-overflow: ellipsis;
	display: block;
	box-sizing: content-box;
}

.k-file-name:hover {
	cursor: pointer;
	text-decoration: underline;
}

.k-file-size {
	color: #999;
	line-height: 1.2em;
	font-size: .78em;
	display: block;
	box-sizing: content-box;
}

.k-upload-status {
	color: #444;
	line-height: 1;
	position: absolute;
	right: 10px;
	top: 1em;
	opacity: .65;
	box-sizing: content-box;
}

.k-upload-action {
	background: 0 0;
    border-width: 0;
    box-shadow: none;
    margin-right: 3px;
	vertical-align: top;
}

/* 첨부파일 영역 END */
</style>
<script type="text/javascript">
$(document).ready(function(e){
	//폼 전송 옵션세팅
	$('#myForm').ajaxForm({
		success : function(data) {
			genexon.alert("success", "이미지 링크 유형 저장", "정상 처리하였습니다");
			genexon.PopWindowClose2("#imagelinkRegiPop");
		},
		error : function(data) {
			genexon.alert("error", "이미지 링크 유형 저장", "입력 중 에러가 발생하였습니다.");
		}
	});
	
	//저장
	$("#bt_save").bind("click", insertOrUpdateImagelink);
	 	
 	//취소버튼
 	$("#bt_cancel").bind("click", function(e){
 		genexon.PopWindowClose2("imagelinkRegiPop");
 	});
 	
 	//동적으로 생성되는 file tag에 대해 이벤트 부여
 	$(document).on("change", "input[name=imageFiles]", function(e){
 		var fileTagIdx = $(this).attr("idx");
 		$("#imageRemoveBtn"+fileTagIdx).trigger("click");
 		$("#changeImageFileYN"+fileTagIdx).val("Y");
 		
 		readURL(this);
 	});
 	
 	//최초 로딩 시 화면 초기화(입력, 수정 둘 다)
 	$("#image_link_type").data("kendoDropDownList").bind("dataBound", function(e) {
		var type = this.value();
 		
		initInputArea(type);
 	});
 	
 	//유형 변경 시 동작
 	$("#image_link_type").data("kendoDropDownList").bind("change", function(e) {
 		var type = this.value();
 		
 		changeImageType(type);
 	});
 	
 	//링크구분 로딩 및 변경 시 동작
 	$("input[name=linkGbns]").each(function(idx, el){
 		var linkUrl = $("#linkUrl"+(idx+1));
 		
//  		$(this).data("kendoDropDownList").bind("dataBound", function(e){
//  			var linkGbn = this.value();
	 	 		
//  			if(linkGbn != "URL" && linkGbn != "MENU" && linkGbn != "BOARD") {
//  	 			linkUrl.attr("readonly", true);
//  	 		}else {
//  	 			linkUrl.attr("readonly", false);
//  	 		}
//  		});
 		
//  		$(this).data("kendoDropDownList").bind("change", function(e){
//  			var linkGbn = this.value();
	 	 		
//  			if(linkGbn != "URL" && linkGbn != "MENU" && linkGbn != "BOARD" && linkGbn != "ETCCAR") {
//  	 			linkUrl.attr("readonly", true);
//  	 		}else {
//  	 			linkUrl.attr("readonly", false);
//  	 		}
//  		});
 	})
});

//이미지 링크 입력 혹은 수정
function insertOrUpdateImagelink() {
	var flag = checkBeforeSave();
	
	if(!flag) return;
	
	genexon.confirm("이미지 링크 유형 저장", "이미지 링크를 저장하시겠습니까?", function(result) {
		if(result) {
			$("#myForm").submit();
		}
	});
}

//이미지 링크 저장 전 유효성 검사
function checkBeforeSave() {
	//유효성 검사
	var flag = true;
	var value = "";
	var title = "";
	var id = "";
	var image_link_type = $("#image_link_type").val();
	
	$("input[essential]").each(function(idx, e) {
		value = $(this).val();
		title = $(this).attr("essential");
		id = $(this).attr("id");
				
		if(genexon.nvl(value, "") == "") {
			genexon.alert("info", "유효성 검사", "["+title+"]은 필수 입력입니다.");
			flag = false;
			return false;
		}
	});
	
	//이미지 파일 유효성 검사
	var imageFileUpload;
	var imageUploadYN = "N";
		
	for(var i=1; i <= image_link_type; i++) {
		imageUploadYN =	$("#imageUploadYN"+i).val();
		$("#imageCount").val(i);
		
		if(imageUploadYN != "Y") {
			genexon.alert("info", "유효성 검사", "이미지"+i+"을(를) 업로드 해주세요.");
			flag = false;
			return false;
		}
	}
	
	for(var i=1; i <= image_link_type; i++) {
		linkUrl = $("#linkUrl"+i).val();
		
		if(linkUrl == "") {
			genexon.alert("info", "유효성 검사", "연결URL"+i+"은 필수 입력입니다.");
			flag = false;
			return false;
		}
	}
		
	return flag;
}

//이미지 업로드 시 이미지 테이블 영역에 이미지 그리기
function readURL(input) {
	var idx = $(input).attr("idx");
	
	if (input.files && input.files[0]) {
		var fileType = input.files[0].type;
		var fileTypeArr1 = input.files[0].type.split("/")[0];
		
		if(fileTypeArr1 != "image") {
			genexon.alert("info", "이미지 링크 유형 저장", "이미지 파일 형식만 업로드 가능합니다.(.png, .jpg ...)");
			$('#image'+idx).attr('src', "");
			$(input).val('');
			$("#imageUploadYN"+idx).val("N");
			
			return;
		}else {
			var reader = new FileReader();
			 
	        reader.onload = function (e) {
	            $('#image'+idx).attr('src', e.target.result);
	        }
	 
	        reader.readAsDataURL(input.files[0]);
	        $("#imageUploadYN"+idx).val("Y");
		}
    }else {
    	$('#image'+idx).attr('src', "");
    	$("#imageUploadYN"+idx).val("N");
    }
}

//해당 페이지 입력 영역 초기화
function initInputArea(type) {
	var configTotalCnt = type;	//설정 총 개수
	
	var allowedExtensions = [".jpg", ".gif", ".jpeg", ".png", ".bmp"];
		
	for(var i = 1; i <= 6; i++) {
		var configTableTr = $("tr.configTableTR"+i);
		
		if(i <= configTotalCnt) {
			configTableTr.show();
		}else {
			configTableTr.hide();
		}
		
		$("#imageFile"+i).kendoUpload({
			multiple : false,
			showFileList : true,
			localization : {
				select : "파일선택",
				dropFilesHere: "이미지를 파일을 올려주세요."
			},
			validation: {
                allowedExtensions: allowedExtensions
            },
			remove: function(e) {
				readURL(this.element[0]);
			}
		});
	}
}

//타입 변경에 따른 이미지 뷰 분할 및 설정 영역 추가/제거
function changeImageType(type) {
	//설정 영역 그리기 or 삭제
	var imageArr = new Array();
	
	$("img[name=image]").each(function(e) {
		imageArr.push($(this).attr("src"));
	});
		
	//설정 영역 그리기 or 삭제
	var configTotalCnt = type;	//설정 총 개수
	
	for(var i = 1; i <= 6; i++) {
		var configTableTr = $("tr.configTableTR"+i);
		
		if(i <= configTotalCnt) {
			configTableTr.show();
		}else {
			configTableTr.hide();
		}
	}
	
	//이미지 뷰 영역 그리기 or 삭제
	$("#imageTable li").empty();
	var imageArea = "";
	
	if(type == "2") {
		imageArea  = "<img alt='image1' id='image1' name='image' class='imgsty02'>";
		imageArea += "<img alt='image2' id='image2' name='image' class='imgsty02'>";
	}else if(type == "3") {
		imageArea  = "<img alt='image1' id='image1' name='image' class='imgsty03'>";
		imageArea += "<img alt='image2' id='image2' name='image' class='imgsty03'>";
		imageArea += "<img alt='image3' id='image3' name='image' class='imgsty03'>";
	}else if(type == "4") {
		imageArea  = "<img alt='image1' id='image1' name='image' class='imgsty04'>";
		imageArea += "<img alt='image2' id='image2' name='image' class='imgsty04'>";
		imageArea += "<img alt='image3' id='image3' name='image' class='imgsty04'>";
		imageArea += "<img alt='image4' id='image4' name='image' class='imgsty04'>";
	}else if(type == "5") {
		imageArea  = "<img alt='image1' id='image1' name='image' class='imgsty06'>";
		imageArea += "<img alt='image2' id='image2' name='image' class='imgsty06'>";
		imageArea += "<img alt='image3' id='image3' name='image' class='imgsty06'>";
		imageArea += "<img alt='image4' id='image4' name='image' class='imgsty06'>";
		imageArea += "<img alt='image5' id='image5' name='image' class='imgsty03'>";
	}else if(type == "6") {
		imageArea  = "<img alt='image1' id='image1' name='image' class='imgsty06'>";
		imageArea += "<img alt='image2' id='image2' name='image' class='imgsty06'>";
		imageArea += "<img alt='image3' id='image3' name='image' class='imgsty06'>";
		imageArea += "<img alt='image4' id='image4' name='image' class='imgsty06'>";
		imageArea += "<img alt='image5' id='image5' name='image' class='imgsty06'>";
		imageArea += "<img alt='image6' id='image6' name='image' class='imgsty06'>";
	}else {
		imageArea = "<img alt='image1' id='image1' name='image' class='imgsty01'>";
	}
	
	$("#imageTable li:last").append(imageArea);
	
	for(var i = 1; i <= imageArr.length; i++) {
		if($("#image"+i).length > 0) {
			$("#image"+i).attr("src", genexon.nvl(imageArr[i-1], null));
		}
	}
}

//이미지 파일 태그 영역의 이미 올라와있는 파일 수정
function deleteExistingAttachFile(imageFileAreaSel, imageTableIndex) {
	$("#"+imageFileAreaSel).remove();
	$("#image"+imageTableIndex).attr("src", "");
}
</script>
</head>
<body>
	<form id="myForm" name="myForm" method="post" action="/main/config/insertOrUpdateImagelinkMst.ajax?${_csrf.parameterName}=${_csrf.token}" enctype="multipart/form-data">
	<input type="hidden" id="seq" name="seq" value="${resultMap.seq }">
	<input type="hidden" id="imageCount" name="imageCount" value=""/>
	
	<!-- 이미지 테이블 -->
	<jsp:include page="./imageTableView.jsp"/>
	
	<hr style="display:block; height:10px; border: 0px;"><!--// 그리드 상단에 타이틀이 없을경우 간격조절라인 -->
	
	<table id="configTable" class="ta_sample2">
		<colgroup>
			<col width="25%" />
			<col width="75%" />
		</colgroup>
		<tbody>
		<tr>
			<th>보드이름</th>
			<td>
				<input type="text" class="k-textbox" name="title" id="title" value="${resultMap.title }" style="width: 100%;" essential="보드이름" />
			</td>
		</tr>
		<tr>
			<th>타입</th>
			<td>
				<input type="text" class="kddl" name="image_link_type" id="image_link_type" ddcode="IMAGE_LINK_TYPE" value="${resultMap.image_link_type }" />
			</td>
		</tr>
		<c:forEach begin="1" end="6" varStatus="i">
			<tr class="configTableTR${i.count }">
				<th>이미지${i.count }</th>
				<td>
					<input type="file" id="imageFile${i.count }" name="imageFiles" idx="${i.count }" accept="image/jpg, image/gif, image/jpeg, image/png, image/bmp">
					<input type="hidden" id="changeImageFileYN${i.count }" name="changeImageFileYN" value="N"/>						
					<c:if test="${not empty resultList[(i.count-1)] }">
						<input type="hidden" id="imageUploadYN${i.count }" name="imageUploadYN" value="Y"/>
						<ul class="k-upload-files k-reset" id="ul_files_${i.count }">
							<li class="k-file" id="${resultList[(i.count-1)].file_no}">
								<span class="k-file-extension-wrapper">
									<span class="k-file-extension">${resultList[(i.count-1)].file_format }</span>
									<span class="k-file-state"></span>
								</span>
								<span class="k-file-name-size-wrapper">
									<span class="k-file-name" title="${resultList[(i.count-1)].file_nm }">${resultList[(i.count-1)].file_nm }</span>
									<span class="k-file-size"><fmt:formatNumber value="${resultList[(i.count-1)].file_size / 1024 }" pattern=".00"/> KB</span>
								</span>
								<strong class="k-upload-status">
									<button type="button" id="imageRemoveBtn${i.count }" class="k-button k-upload-action" aria-label="Remove" onclick="javascript:deleteExistingAttachFile('ul_files_${i.count }', '${i.count }')">
										<span class="k-icon k-i-close k-i-x" title="Remove"></span>
									</button>
								</strong>
							</li>
						</ul>
					</c:if>
					<c:if test="${empty resultList[(i.count-1)] }">
						<input type="hidden" id="imageUploadYN${i.count }" name="imageUploadYN" value="N"/>
					</c:if>
				</td>
			</tr>
			<tr class="configTableTR${i.count }">
				<th>연결URL${i.count }</th>
				<td>
					<input type="text" class="kddl" id="linkGbn${i.count }" name="linkGbns" ddcode="LINK_GBN" value="${resultList[i.count-1].link_gbn }">
					<input type="text" class="k-textbox" id="linkUrl${i.count }" name="linkUrls" style="width: 100%;" value="${resultList[i.count-1].link_url }">
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	</form>
	
	<div class="bt_right">
		<button type="button" class="bt_glay2_S" id="bt_cancel">취소</button>
		<button type="button" class="bt_glay2_S" id="bt_save">저장</button>
	</div>
</body>
</html>