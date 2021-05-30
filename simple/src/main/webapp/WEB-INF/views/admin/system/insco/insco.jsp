<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 03. 11
	화면 설명 : 보험사관리
######################################################################################### 
 -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script>
$("document").ready(function(e) {
	
	// 최초로딩시 보험사 조회
	srch();

	// 보험사 등록
	$('#bt_regi').bind('click', function(e) {
		regiInscoPop();
	});

	// 보험사 조회
	$("#search").click(function(e) {
		srch();
	});
	
	// [엑셀다운로드]
	$('#bt_excel_download').bind('click', function(e) {
		excelDown();
	});
	
});

// 보험사 조회
function srch() {
	var grid = $("#grid").data("kendoGrid");

	grid.pager.page(1);
	grid.dataSource.read({
		json_string : genexon.getSearchParameterToJsonString()
	}); 
	
}

// 보험사 등록, 수정
function regiInscoPop(e) {
	var wd = genexon.body.find("#_CN_810");
	if (wd.length > 0) {
		var kwd = wd.data("kendoWindow");
		if (kwd != undefined) {
			kwd.close();
		}
	}
	var selectedItem = null;
	if (e != undefined) {
		selectedItem = this.dataItem($(e.target).closest("tr"));
	}
/* 	if (selectedItem != null) {
		genexon.menuIdAjax("CN_810", selectedItem.IDX);
	} else {
		genexon.menuIdAjax("CN_810");
	} */

	genexon.PopWindowOpen({
		pID : "CN_810",
		pTitle : "보험사 등록",
		pURL : "/system/insco/regiInscoPop.pop?${_csrf.parameterName}=${_csrf.token}",
		pWidth : 700,
		pHeight : 500,
		callbackFunc : srch,
		pModal : false,
		resizable : true,
		position : {
			top : 200,
			left : 300
		},
		data : selectedItem
	});
}

// 보험사 수정 팝업 복제본
function regiInscoPopUpdt(e) {
	var wd = genexon.body.find("#_CN_810");
	if (wd.length > 0) {
		var kwd = wd.data("kendoWindow");
		if (kwd != undefined) {
			kwd.close();
		}
	}
	var selectedItem = null;
	if (e != undefined) {
		selectedItem = this.dataItem($(e.target).closest("tr"));
	}
	/* 	if (selectedItem != null) {
            genexon.menuIdAjax("CN_810", selectedItem.IDX);
        } else {
            genexon.menuIdAjax("CN_810");
        } */

	genexon.PopWindowOpen({
		pID : "CN_810",
		pTitle : "보험사 수정",
		pURL : "/system/insco/regiInscoPop.pop?${_csrf.parameterName}=${_csrf.token}",
		pWidth : 700,
		pHeight : 500,
		callbackFunc : srch,
		pModal : false,
		resizable : true,
		position : {
			top : 200,
			left : 300
		},
		data : selectedItem
	});
}

//엑셀다운로드
function excelDown() {
	
	var data = {
			insco_type : $("#insco_type").val(),
			search_word : $("#search_word").val(),
			use_yn : $("#use_yn").val()
	};
	
	genexon.excelDown("#excelForm", data);
}
</script>
</head>
<body>
<h5>보험사관리</h5>
<form id="excelForm" name="excelForm" method="post" action="/system/insco/getInscoListExcel.ajax?${_csrf.parameterName}=${_csrf.token}">
</form>
<div class="search">
	<table class="ta_sty01">
		<tr>
			
			<td>
				<input type="text" class="kddl" name="insco_type" id=insco_type ddcode="INSCO_TYPE" optionLabel="전체" />
			
				<input type="text" class="k-textbox" name="search_word" id="search_word" onKeyPress="if(event.keyCode==13)srch();" placeholder="보험사명" />
			
				<input type="text" name="use_yn" id="use_yn" class="kddl" ddcode="USE_YN" optionLabel="전체" value="Y">
			</td>
			<td class="btn_r">
				<button class="k-primary btn_sty02" id="search" >조회</button>
				<button class="k-primary btn_sty03 do_autr_type" id="bt_excel_download">엑셀다운로드</button>
			</td>
		</tr>
	</table>
</div>

<div class="bt_left">
	<div class="bt_orange_S in_autr_type" id="bt_regi">등록</div>
</div>

<div id="grid" class="resizegrid"></div>
<script type="text/javascript">

// 보험사 로고(이미지)
var ciPic = "<img src=\"#=kendo.toString(ci_url)#\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\" onerror=\"this.style.display='none'\" />";

	/**
	 * 데이터 소스설정
	 * 그룹코드 그리드 url 및 스키마모델 정의
	 **/
	var ds = {
		transport : {
			read : {
				url : "/system/insco/getInscoList.ajax?${_csrf.parameterName}=${_csrf.token}",
				data: function() {
					return {
						json_string : genexon.getSearchParameterToJsonString()
					}
				}
			},
			destroy : {
				url : "/system/insco/deleteInsco.ajax?${_csrf.parameterName}=${_csrf.token}"
			}
		},
		schema : {
			model : {
				id : "insco_cd",
				fields : {
					insco_cd : {}
					, insco_nm : {}
					, insco_type : {}
					, insco_type_nm : {}
					, ci_url : {}
					, preno : {}
					, faxno : {}
					, helpno : {}
					, itno : {}
					, plan_url : {}
					, home_url : {}
					, prtn_start_ymd : {}
					, prtn_end_ymd : {}
					, use_yn : {}
					, sort_no : {}
					, memo : {}
					, mb_id : {}
				}
			}
		},
		requestEnd : function(e) {
			if (e.type != undefined && e.type != "read") {
				srch();
			}
		}
	};

	/**
	 * 그룹코드 그리드 필드 정의
	 **/
	var gridpt = {
		columns : [ {
			field : "insco_type_nm",
			title : "보험구분",
			width : 65
		}, {
			field : "insco_cd",
			title : "보험사코드",
			width : 60
		}, {
			field : "insco_nm",
			title : "보험사명",
			width : 105
		}, {
			field : "plan_url",
			title : "가입설계 URL",
			template : kendo.template('#if(plan_url != null){# <a href="#=plan_url#" target="_blank">#=plan_url#</a> #}#'),
			width : 200
		}, {
			field : "home_url",
			title : "홈페이지 URL",
			template : kendo.template('#if(home_url != null){# <a href="#=home_url#" target="_blank">#=home_url#</a> #}#'),
			width : 200
		}, {
			field : "preno",
			title : "대표번호",
			width : 100
		}, {
			field : "helpno",
			title : "헬프데스크",
			width : 100
		}, {
			field : "itno",
			title : "IT데스크",
			width : 100
		}, {
			field : "ci_url",
			title : "로고(이미지)",
			template : ciPic,
			width : 100
		}, {
			field : "prtn_start_ymd",
			title : "제휴시작일",
			width : 100
		}, {
			field : "prtn_end_ymd",
			title : "제휴종료일",
			width : 100
		}, {
			field : "use_yn",
			title : "사용유무",
			width : 50,
			attributes : {
				class : "col-center"
			}
		}, {
			field : "sort_no",
			title : "정렬순서",
			width : 50,
			attributes : {
				class : "col-center"
			}
		}, {
			field : "up_emp_cd",
			title : "수정자",
			template : "#=up_emp_cd# <br>#=up_dtm#",
			width : 110,
		}, {
			command : [ {
				name : "editPop",
				text : "수정",
				click : regiInscoPopUpdt
			}, {
				name : "Delete",
				iconClass: "none",
				text : "삭제",
				click: function(e) {genexon.deleteConfirm(e);}
			} ],
			title : "변경",
			width : 100,
			attributes : {
				class : "col-center"
			}
		}

		],
		editable : false,
		edit : function(e) {
		},
		change : onChange,
		pageable : true
	};

	/**
	 *인라인 그리드 생성
	 **/
	genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);

	/**
	 * 그리드 클릭(체인지) 이벤트	
	 **/
	function onChange(arg) {
	}

	function gridRemoveRow() {
		var grid = $("#grid").data("kendoGrid");
		var row = grid.select();

		grid.removeRow(row);
	}
</script>
</body>
</html>