<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 22
	화면 설명 : 공통코드그룹, 공통코드 CRUD 화면
######################################################################################### 
 -->
<html>
<head>
<style type="text/css">
h4{
	border-left: 10px solid #36539e;
	padding-left: 10px;
	margin-left: 15px;
}

h3 {
	font-family: "dotum", Arial, sans-serif;
    font-size: 20px;
    color: #000;
    font-weight: bold;
    margin-top: 10px;
    margin-bottom: 10px;
}

</style>
<script type="text/javascript">
$(document).ready(function() {
	
});

/**
 * 조회
 */
function srch() {
	var grid = $("#grid").data("kendoGrid");
	
	grid.dataSource.read({
		json_string : genexon.getSearchParameterToJsonString()
	});

	var grid_sub = $("#gridsub").data("kendoGrid");
	grid_sub.dataSource.read();
 	$("#tempgrpcmmcd").val("");
	$("#tempgrpcmmcd_label").text(" ");
}
</script>

</head>
<body>
     <!-- Content //-->
     <div class="search">    
            <table class="se">
				<tr>
					<td><input type="text" class="k-textbox" name="search_word" id="search_word"  placeholder="(그룹)공통코드명" style="width: 600px" onkeydown="if(event.keyCode == 13) srch();" /></td>
					<td class="line">구분선</td>
					<td ><button class="kbtn k-primary" onclick="javascript:srch();" id="srch" name="srch">검색</button></td>                        
				</tr>    
            </table>                
     </div><!--// search -->
	        
        
	<!--// 그리드 상단에 타이틀이 없을경우 간격조절라인 -->
	<!-- 
	<hr style="display:block;height:10px;">
	 -->
	<div style="float:left;width:52%;">
		<h3 id="grplabel"> 공통그룹코드 </h3>
		<!-- grid start -->
		<div id="grid" class="resizegrid"></div>
	</div>
	
    
    <div style="float:right;width:47%;">
		<!-- gridsub key hidden -->
	    <input type="hidden" id="tempgrpcmmcd" name="tempgrpcmmcd"/>
	    <h3 id="tempgrpcmmcd_label"> (공통코드명) </h3>
		<!-- gridsub start -->
		<div id="gridsub" class="resizegrid"></div>
	</div>
	
	<script  type="text/javascript">
		
	/**
	* 그룹코드 그리드 필드 정의
	**/
	var gridpt = {
		toolbar: [{name:"create",text:"추가"}],
		columns:[
			{
				field: "grp_cmm_cd",
				title: "그룹공통코드",
				width: 160
			},
			{
				field: "grp_cmm_cd_nm",
				title: "그룹공통코드명",
				width: 240
			},
			{
				field: "grp_cmm_cd_desc",
				title: "그룹공통코드설명",
				width: 240
			},
			{
				field: "system_gubun",
				title: "시스템 구분",
				width: 120,
				template: "#=system_gubun_nm#",
				ddcode:"SYSTEM_GUBUN",
				editor:genexon.GridEditor_ddl,
				values:{ optionLabel: "-시스템 구분-", ddcode:"SYSTEM_GUBUN", requred: true }
			},
			{
				command: [
					{ name: "edit", text: "수정" },
					{ name: "Delete", text: "삭제", 	click: function(e) {genexon.deleteConfirm(e);}}
				],
				title: "변경",
				width: 130
			}
		],
		editable: {
			mode:"inline",
			createAt:"top",
			confirmation: "상세코드를 포함한 데이타가 삭제 됨니다. \n삭제하시겠습니까?"
		},
		edit: function(e) {
			e.model.dirty = true;
			
			if (!e.model.isNew()) {
				var grp_cmm_cd = e.container.find("input[name=grp_cmm_cd]");
				grp_cmm_cd.prop("disabled", true);
				grp_cmm_cd.addClass("k-state-disabled");
			}
		},
		change: onChange
	};
   
        
	/**
	 * 데이터 소스설정
	 * 그룹코드 그리드 url 및 스키마모델 정의
	 **/
	var ds = {
		transport: {
			read	: {url: "/commoncode/getCommonCodeGroup.ajax?${_csrf.parameterName}=${_csrf.token}"   },
			update  : {url: "/commoncode/updateCommonCodeGroup.ajax?${_csrf.parameterName}=${_csrf.token}" },
			destroy : {url: "/commoncode/deleteCommonCodeGroup.ajax?${_csrf.parameterName}=${_csrf.token}" },
			create  : {url: "/commoncode/insertCommonCodeGroup.ajax?${_csrf.parameterName}=${_csrf.token}" }
		},
		schema: {
			data : "results",
			model: {
				id: "grp_cmm_cd",
				fields: {
					grp_cmm_cd: { validation: {required: true, validationMessage:"필수항목"}},
					grp_cmm_cd_nm: { validation: {required: true, validationMessage:"필수항목"}},
					grp_cmm_cd_desc: {validation: {required: true, validationMessage:"필수항목"}},
					system_gubun: { validation: {required: true, validationMessage:"필수항목"}},
					system_gubun_nm : {}
				}
			}
		},
		batch: true,
		requestEnd : function(e) {
			if (e.type != undefined && e.type != "read") {
				srch();
			}
		}
	};
        
    /**
    *인라인 그리드 생성
    **/
   	genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);
    	
   	/**
    *인라인 그리드 리드
    **/
	var grid = $("#grid").data("kendoGrid");
   	grid.dataSource.read();
     
   	/**
   	* 그리드 클릭(체인지) 이벤트
   	**/
	function onChange(arg) {
   		var selectedItem =this.dataItem(this.select()[0]);
   		
   		var grpcmmcd = selectedItem.grp_cmm_cd;
   		var textname = selectedItem.grp_cmm_cd_nm;
			
		if(grpcmmcd !== "" && textname !== "") {
			$("#tempgrpcmmcd").val(grpcmmcd);
			$("#tempgrpcmmcd_label").text(grpcmmcd + "-" +genexon.nvl(textname, ""));
		}else {
			$("#tempgrpcmmcd").val("");
			$("#tempgrpcmmcd_label").text("");
		}
		
		var grid_sub = $("#gridsub").data("kendoGrid");
		grid_sub.dataSource.read({grp_cmm_cd: grpcmmcd});
	}
	
	/**
	* SUB 코드 그리드 필드 정의
	**/
	var gridptSub = {
		toolbar: [{name:"create",text:"추가"}],
		columns: [
			{
				field: "cd_vl",
				title: "코드값",
				width: "120px"
			},
			{
				field: "cd_vl_nm",
				title: "코드값명"
			},
			{
				field: "sort_no",
				title: "정렬순서",
				width: "120px",
				attributes: { "class" : "col-right" }
			},
			{
				field: "use_yn",
				title: "사용여부",
				width: "120px"
			},
			{
				command: [
					{ name: "edit", text: "수정" },
					{ name: "destroy", text: "삭제" }
				],
				title: "변경",
				width: "150px"
			}
		],
		editable: {
			mode: "inline",
			createAt: "top",
			confirmation: "선택하신 행을 삭제하시겠습니까??"
		},
		edit: function(e) {
			e.model.dirty = true;
			
			var use_yn = e.container.find("input[name=use_yn]");
			use_yn.attr("class", "kddl");
			use_yn.attr("ddcode", "USE_YN");
			use_yn.attr("optionLabel", "- 선택 -");
			genexon.initKendoUI_ddl(use_yn);
			
			if (!e.model.isNew()) { // 새로생성된 모델이 아니라면 
				var cd_vl = e.container.find("input[name=cd_vl]"); // cd_vl을 찾아 변수에 담음.
				cd_vl.prop("disabled",true);                       // cd_vl 필드의 특성을 변경
				cd_vl.addClass("k-state-disabled");
			}else { // 새로생성된 모델이라면
				if($("#tempgrpcmmcd").val() == "") { // 임시 그룹코드가 없다면
					alert("그룹코드를 먼저 선택하세요.");
					var grid_sub = $("#gridsub").data("kendoGrid");
					grid_sub.dataSource.read();
				}else { // 임시그룹코드가 있다면 grp_cmm_cd에 대입
					e.model.grp_cmm_cd = $("#tempgrpcmmcd").val();
				}
			}
		}
	};
					
	/**
	* SUB코드 그리드  url  및 lnline  스키마 정의
	**/
	var dsSub = {
		transport: {
			read    : {url: "/commoncode/getCommonCode.ajax?${_csrf.parameterName}=${_csrf.token}" },
			update  : {url: "/commoncode/updateCommonCode.ajax?${_csrf.parameterName}=${_csrf.token}" },
			destroy : {url: "/commoncode/deleteCommonCode.ajax?${_csrf.parameterName}=${_csrf.token}" },
			create  : {url: "/commoncode/insertCommonCode.ajax?${_csrf.parameterName}=${_csrf.token}" }
		},
		schema:	{
			data : "results",
			model: {
				id: "cd_vl",
				fields: {
					grp_cmm_cd: { validation: {required: true, validationMessage:"필수항목"}},
					cd_vl: { validation: {required: true, validationMessage:"필수항목"}},
					cd_vl_nm: { validation: {required: true, validationMessage:"필수항목"}},
					use_yn : { validation: {required: true, validationMessage:"필수항목"}},
					sort_no: {type: "number",  validation: {required: true, min: 1, max:999, validationMessage:"1~999허용"}}
				}
       		}
       	},
       	batch: true,
		requestEnd : function(e) {
			if (e.type != undefined && e.type != "read") {
				var grid = $('#grid').data('kendoGrid');
		    	var item = grid.dataItem(grid.select());
		    	
		    	var grp_cmm_cd = item.grp_cmm_cd;
		    	
		    	var grid_sub = $("#gridsub").data("kendoGrid");
				grid_sub.dataSource.read({grp_cmm_cd: grp_cmm_cd});
			}
		}
	};

    /**
     *인라인 그리드 생성
     **/
	genexon.initKendoUI_grid_inlineEdit("#gridsub", gridptSub, dsSub);
	</script>
</body> 
</html>