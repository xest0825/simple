<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 05. 02
	화면 설명 : 회원사관리
######################################################################################### 
 -->
<html>
<head>
<script>
$(document).ready(function(){
	// 회원사 등록
	/*
	$('#bt_regi').bind('click', function(e) {
		memberRegi();
	});
	*/

	srch();
	
	$("#search").on("click", srch);
	
	// 엑셀다운로드
	$('#bt_excel_download').bind('click', function(e){
		excelDown();
	});
});

//조회
function srch() {
	var grid = $("#grid").data("kendoGrid");
	
	grid.dataSource.options.transport.read.data = {
		json_string : genexon.getSearchParameterToJsonString()
	};
	console.log(genexon.getSearchParameterToJsonString());
		    
	grid.pager.page(1);
}

//엑셀다운로드
function excelDown(){

	var data = {
		search_word : $("#search_word").val(),
		sort_column : 'mb_id ASC'
	};
	
	genexon.excelDown("#excelForm", data);
}

function memberRegi(e) {
	var wd = genexon.body.find("#memberRegi");
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
	if (selectedItem != null) {
		genexon.PopWindowOpen({
			pID : "memberRegi",
			pTitle : "회원사 수정",
			pURL : "/system/member/memberRegi.pop?${_csrf.parameterName}=${_csrf.token}",
			pWidth : 900,
			pHeight : 600,
			callbackFunc : srch,
			pModal : true,
			resizable : true,
			position : {
				top : 200,
				left : 300
			},
			data : selectedItem
		});
	} else {
		genexon.PopWindowOpen({
			pID : "memberRegi",
			pTitle : "회원사 등록",
			pURL : "/system/member/memberRegi.pop?${_csrf.parameterName}=${_csrf.token}",
			pWidth : 900,
			pHeight : 500,
			callbackFunc : srch,
			pModal : true,
			resizable : true,
			position : {
				top : 200,
				left : 300
			}
		});
	}
}
</script>
</head>
<body>

	<input type="hidden" name="resource_url" id="resource_url" value="${menuRole.resource_url}"/>
	<input type="hidden" name="sort_column"	 id="sort_column" value="mb_id ASC"/>
	<form id="excelForm" name="excelForm" method="post" action="/system/member/getMemberListExcel.ajax?${_csrf.parameterName}=${_csrf.token}">
	</form>
	<div class="search">
		<table class="ta_sty01">
		
			<tr>
				<td>
					<input type="text" class="k-textbox" name="search_word" id="search_word" style="width: 250px;" onKeyPress="if(event.keyCode==13)srch();" placeholder="고객사 이름을 입력해주세요."/>
					<!-- <input type="text" name="use_yn" id="use_yn" class="kddl" ddcode="USE_YN" optionLabel="사용여부">  -->
										
					<button class="k-primary btn_sty02" id="search" >조회</button>
					<button class="k-primary btn_sty03 do_autr_type" id="bt_excel_download">엑셀다운로드</button>
					<!-- <button class="k-primary in_autr_type" id="bt_regi">등록</button>  -->
				</td>
				
			</tr>
		</table>
	</div>
	
	<div id="grid" class="resizegrid"></div>
	
<script  type="text/javascript">

// CI_URL
var ciPic = "<img src=\"#=kendo.toString(ci_url)#\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\"/>";
// 회사 로고
var logoPic = "<img src=\"#=kendo.toString(logo_url)#\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\"/>";
// 증명서 로고
var certlogoPic = "<img src=\"#=kendo.toString(certlogo_url)#\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\"/>";
// 직인
var sealPic = "<img src=\"#=kendo.toString(seal_url)#\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\"/>";

/**
 * 데이터 소스설정
 * 그룹코드 그리드 url 및 스키마모델 정의
 **/
var ds = {
	transport : {
		read : {
			url : "/system/member/getMemberList.ajax?${_csrf.parameterName}=${_csrf.token}",
			data : {
				json_string :  genexon.getSearchParameterToJsonString()
			}
		},
		create : {
			url : "/system/member/insertMember.ajax?${_csrf.parameterName}=${_csrf.token}"
		},
		update : {
			url : "/system/member/updateMember.ajax?${_csrf.parameterName}=${_csrf.token}"
		},
		destroy : {
			url : "/system/member/deleteMember.ajax?${_csrf.parameterName}=${_csrf.token}"
		}
	},
	schema : {
		model : {
			id : "mb_id",
			fields : {
			       seq : {}             /* 접근유형           BIGINT        */
			     , mb_id : {}           /* 회원사ID           VARCHAR(20)   */
			     , mb_nm : {}           /* 회사명             VARCHAR(100)  */
			     , mb_login_id : {}     /* 회원사로그인ID     VARCHAR(20)   */
			     , zipcd : {}           /* 우편번호           VARCHAR(7)    */
			     , addr1 : {}           /* 주소               VARCHAR(100)  */
			     , addr2 : {}           /* 상세주소           VARCHAR(100)  */
			     , mb_type : {}         /* 회사타입           VARCHAR(4)    */
			     , use_yn : {}          /* 사용여부           VARCHAR(1)    */
			     , cont_frymd : {}      /* 계약시작일         VARCHAR(10)   */
			     , cont_toymd : {}      /* 계약종료일         VARCHAR(10)   */
			     , corp_reg_num : {}    /* 법인등록번호       VARCHAR(12)   */
			     , represent_nm : {}    /* 대표명             VARCHAR(30)   */
			     , telno : {}           /* 전화번호           VARCHAR(14)   */
			     , faxno : {}           /* 팩스번호           VARCHAR(14)   */
			     , domain_url : {}      /* 도메인URL          VARCHAR(100)  */
			     , domain_mng : {}      /* 도메인관리         VARCHAR(100)  */
			     , domain_id : {}       /* 도메인ID           VARCHAR(100)  */
			     , domain_pw : {}       /* 도메인비번         VARCHAR(100)  */
			     , ci_url : {}          /* CI URL             VARCHAR(200)  */
			     , logo_url : {}        /* 로고 URL           VARCHAR(200)  */
			     , manager_nm : {}      /* 관리자명           VARCHAR(30)   */
			     , mtelno : {}          /* 관리자연락처       VARCHAR(14)   */
			     , pkg_name : {}        /* PKG명              VARCHAR(20)   */
			     , copy_right : {}      /* COPYRIGHT          VARCHAR(2000) */
			     , certlogo_url : {}    /* 증명서사용로고 URL VARCHAR(200)  */
			     , seal_url : {}        /* 직인 URL           VARCHAR(200)  */
			     , certificate_mb_nm : {}
			     , session_time : { type: "number" }
			     , sort_no : {}         /* 정렬순서           INT           */
			     , memo : {}            /* 메모               VARCHAR(200)  */
			     , bigo : {}            /* 비고               VARCHAR(100)  */
			}
		}
	},
	requestEnd : function(e) {
		if (e.type != undefined && e.type != "read") {
			srch();
		}
	},
	serverPaging: true
};

/**
 * 그룹코드 그리드 필드 정의
 **/
var gridpt = {
	columns : [ {
		field : "sort_no",
		title : "순서",
		width : 50,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "mb_id",
		title : "회사코드",
		hidden : true
	}, {
		field : "mb_login_id",
		title : "회사로그인ID",
		width : 100,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "mb_nm",
		title : "회사명",
		width : 150,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "addr1",
		title : "주소",
		width : 200,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "corp_reg_num",
		title : "법인등록번호",
		width : 120,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "represent_nm",
		title : "대표자명",
		width : 70,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "telno",
		title : "전화번호",
		width : 100,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "faxno",
		title : "팩스번호",
		width : 100,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "manager_nm",
		title : "담당자명",
		width : 70,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "mtelno",
		title : "담당자전화",
		width : 100,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "copy_right",
		title : "Copyright",
		width : 300,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "ci_url",
		title : "회사CI",
		template : function(e) {
			var ci_url = e.ci_url;
			
			if(genexon.nvl(ci_url, "") != "" && genexon.nvl(ci_url, "") != null) {
				return "<img src=\""+e.ci_url+"\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\"/>";
			}else {
				return "";
			}
		},
		width : 120,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "logo_url",
		title : "회사로고",
		template : function(e) {
			var logo_url = e.logo_url;
			
			if(genexon.nvl(logo_url, "") != "" && genexon.nvl(logo_url, "") != null) {
				return "<img src=\""+e.logo_url+"\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\"/>";
			}else {
				return "";
			}
		},
		width : 120,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "certlogo_url",
		title : "증명서사용로고 URL",
		template : function(e) {
			var certlogo_url = e.certlogo_url;
			
			if(genexon.nvl(certlogo_url, "") != "" && genexon.nvl(certlogo_url, "") != null) {
				return "<img src=\""+e.certlogo_url+"\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\"/>";
			}else {
				return "";
			}
		},
		width : 120,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "seal_url",
		title : "직인 URL",
		template : function(e) {
			var seal_url = e.seal_url;
			
			if(genexon.nvl(seal_url, "") != "" && genexon.nvl(seal_url, "") != null) {
				return "<img src=\""+e.seal_url+"\" alt=\"사진\" id=\"viewArea\" style=\"width:100px; height:50px;\"/>";
			}else {
				return "";
			}
		},
		width : 120,
		attributes :{
			style : "text-align : center"
		}
	}, {
		field : "certificate_mb_nm",
		title : "증명서 출력용 회사명",
		width : 150
	}, {
		field : "session_time",
		title : "세션유지시간(분)",
		width : 150,
		attributes: {
			"class" : "col-right"
		}
	}, {
		command : [ {
			name : "edit",
			text : "수정",
			click : memberRegi,
			iconClass: "none"
		}/* ,
		{	
			name: "destroy",
			text: "삭제",
			iconClass: "none"
		} */],
		title: "",
		attributes:{"class" : "col-center"},
		width: 150
	}],
	edit : function(e) {
	},
	change : onChange,
	pageable : true,
	autoBind : true
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
</script>

</body>
</html>