<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 18
	화면 설명 : 메인화면 설정
######################################################################################### 
 -->
<html>
<head>
<style type="text/css">
.templateUl {
	width: 1200px !important;
	margin: 0 !important;
}

.templateUl li {
	display: inline-block;
	width: 350px !important;
	height: 350px !important;
	margin: 0 10px 0 0;
	text-align: center;
}
</style>
<script type="text/javascript">
$(document).ready(function(e) {
	//템플릿 유형 DropDownList
	for(var i=1; i <= 6; i++) {
		var template_code = $(document).find("#${MainTemplateVO.role_id }_main_board_type"+i);
		template_code.attr("ddcode", "MAIN_BOARD_TYPE");
		template_code.attr("optionLabel", "템플릿 유형");
	    genexon.initKendoUI_ddl(template_code);
	}
	
	for(var i=1; i <= 6; i++) {
		var template_code = $(document).find("#${MainTemplateVO.role_id }_template_code"+i);
		template_code.attr("ddcode", $("#${MainTemplateVO.role_id }_main_board_type"+i).val());
		template_code.attr("optionLabel", "템플릿 상세");
	    genexon.initKendoUI_ddl(template_code);
	    
	    template_code.trigger("change");
	}
});

//템플릿 유형 변경 시
function boardTypeChange(e, idx, role_id) {
	var main_board_type = e.value;
			
	var template_code = $(document).find("#"+role_id+"_template_code"+idx);
	template_code.attr("ddcode", main_board_type);
	template_code.attr("optionLabel", "템플릿 상세");
		
    genexon.initKendoUI_ddl(template_code);
    
    $("#"+role_id+"_template"+idx).attr("src", "");
}

//템플릿 상세 변경 시
function templateCodeChange(e, idx, role_id) {
	var template_code = genexon.nvl(e.value, "");
	
	var main_board_type = $("#"+role_id+"_main_board_type"+idx).val();
	var template_frame = $("#"+role_id+"_template"+idx);
	var frame_url = "";
	
	if(template_code != "") {
		if(main_board_type == "MAIN_IMAGE") {
			//이미지 형
			frame_url = "/main/template/imageLinkTemplate.go?${_csrf.parameterName}=${_csrf.token}&seq="+template_code;
		}else if(main_board_type == "MAIN_BOARD") {
			//게시판형
			frame_url = "/main/template/boardTemplate.go?${_csrf.parameterName}=${_csrf.token}&board_no="+genexon.nvl(template_code, "NONE");
		}else if(main_board_type == "MAIN_STATISTICS") {
			//통계형
			if(template_code.indexOf("OUTCOME_") != -1 && template_code.indexOf("OUTCOME_LV") < 0) {
				//이달의 성과(보험료)
				frame_url = "/main/template/thisMonthOutcomeTemplate.go?${_csrf.parameterName}=${_csrf.token}&template_code="+template_code;
			}else if(template_code.indexOf("OUTCOMETYPE2") != -1) {
				//이달의 성과 Type2(환산)
				frame_url = "/main/template/thisMonthOutcomeTemplateType2.go?${_csrf.parameterName}=${_csrf.token}&template_code="+template_code;
			}else if(template_code == "FCRANK") {
				//FC 순위
				frame_url = "/main/template/fcRankingTemplate.go?${_csrf.parameterName}=${_csrf.token}";
			}else if(template_code == "EXPR_CONT_CNT") {
				//자동차/일반 만기 건수
				frame_url = "/main/template/expirationContractCntTemplate.go?${_csrf.parameterName}=${_csrf.token}";
			}else if(template_code.indexOf("OUTCOME_LV") >= 0) {
				//이달의 성과 조직 레벨별
				frame_url = "/main/template/thisMonthOutcomeLvTemplate.go?${_csrf.parameterName}=${_csrf.token}&main_board_type="+main_board_type+"&template_code="+template_code;
			}else if(template_code.indexOf("TM_NEW_CONT") >= 0) {
				//당월 신계약
				frame_url = "/main/template/thisMonthNewContTemplate.go?${_csrf.parameterName}=${_csrf.token}&main_board_type="+main_board_type+"&template_code="+template_code;
			}else if(template_code.indexOf("OVERDUE_CONT") >= 0){
				//연체/실효 계약 확인
				frame_url = "/main/template/overdueContTemplate.go?${_csrf.parameterName}=${_csrf.token}&main_board_type="+main_board_type+"&template_code="+template_code;
			}else {
				//사업단 순위
				frame_url = "/main/template/scdUnitRankingTemplate.go?${_csrf.parameterName}=${_csrf.token}";
			}
		}else if(main_board_type == "MAIN_CONTRACT_CHART") {
			//보유계약 차트형
			frame_url = "/main/template/contractChartTemplate.go?${_csrf.parameterName}=${_csrf.token}&template_code="+template_code;
		}else if(main_board_type == "MAIN_SCHEDULE") {
			//일정관리
			frame_url = "/main/template/scheduleTemplate.go?${_csrf.parameterName}=${_csrf.token}&template_code="+template_code;
		}
	}else {
		frame_url = "";
	}
	
	template_frame.attr("src", frame_url);
}

//메인화면 템플릿 저장
function saveMainTemplate(role_id) {
	var obj = new Object();
	obj.models = new Array();
		
	for(var i=1; i <= 6; i++) {
		var MainTemplateVO = new Object();
		MainTemplateVO.role_id = role_id;
		MainTemplateVO.main_board_type = $("#"+role_id+"_main_board_type"+i).val();
		MainTemplateVO.template_code = genexon.nvl($("#"+role_id+"_template_code"+i).val(), "");
		MainTemplateVO.sort_no = i;
		
		obj.models.push(MainTemplateVO);
	}
	
	genexon.confirm("메인화면 템플릿 설정", "설정 내용을 저장하시겠습니까?", function(result){
		if(result) {
			$.ajax({
				url :"/main/config/insertMainTemplateMst.ajax?${_csrf.parameterName}=${_csrf.token}",
				type: "POST",
				data: JSON.stringify(obj),
				contentType : "application/json;charset=UTF-8",
				success:function(data) {
					genexon.alert("success", "메인화면 템플릿 설정", "정상적으로 저장되었습니다.");
				}
			}); // end ajax
		}
	});
}
</script>
</head>
<body>
	<hr style="display:block;height:15px;">
	
	<div class="bt_left">
		<!-- <button class="bt_orange_S" id="bt_preview" style="margin-bottom:7px;">미리보기</button> -->
		<button class="bt_orange_S" id="bt_regi" onclick="saveMainTemplate('${MainTemplateVO.role_id}');" style="margin-bottom:7px;">저장</button>
	</div>
	
	<ul class="templateUl" style="margin-top: 20px">
		<c:choose>
			<c:when test="${empty TemplateConfigList }">
				<c:forEach begin="0" end="5" varStatus="i">
				<li>
					<iframe id="${MainTemplateVO.role_id }_template${i.index + 1 }" style="width: 300px; height: 300px; margin: 0 auto; overflow-y: hidden; border: 1px solid lightgray;"></iframe>
					<div style="text-align: center;">
						<input type="text" id="${MainTemplateVO.role_id }_main_board_type${i.index + 1}" ddcode="MAIN_BOARD_TYPE" onchange="boardTypeChange(this, '${i.index + 1}', '${MainTemplateVO.role_id}')" style="width: 120px;">
						<input type="text" id="${MainTemplateVO.role_id }_template_code${i.index + 1}" ddcode="" onchange="templateCodeChange(this, '${i.index + 1}', '${MainTemplateVO.role_id}')" style="width: 120px;">
					</div>
				</li>
				</c:forEach>
			</c:when>
			<c:when test="${not empty TemplateConfigList }">
				<c:forEach items="${TemplateConfigList}" var="list" varStatus="i">
				<li>
					<iframe id="${MainTemplateVO.role_id }_template${i.index + 1 }" src="" style="width: 300px; height: 300px; margin: 0 auto; overflow-y: hidden;  border: 1px solid lightgray;"></iframe>
					<div style="text-align: center;">
						<input type="text" id="${MainTemplateVO.role_id }_main_board_type${i.index + 1 }" ddcode="MAIN_BOARD_TYPE" onchange="boardTypeChange(this, '${i.index + 1}', '${MainTemplateVO.role_id}')" value="${list.main_board_type }" style="width: 120px;">
						<input type="text" id="${MainTemplateVO.role_id }_template_code${i.index + 1}" ddcode="${list.main_board_type }" onchange="templateCodeChange(this, '${i.index + 1}', '${MainTemplateVO.role_id}')" value="${list.template_code }" style="width: 120px;">
					</div>
				</li>
				</c:forEach>
			</c:when>
		</c:choose>
	</ul>
</body>
</html>