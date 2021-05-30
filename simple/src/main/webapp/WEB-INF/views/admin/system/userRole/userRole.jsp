<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 03. 05
	화면 설명 : 사용자권한관리
######################################################################################### 
 -->
<html>
<head>
<style type="text/css">
#grid table .k-state-selected {
	background-color: beige !important;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
	
	//화면 최초로딩시 조회처리
	srch();

 	// [조회]
 	$('#search').bind('click', function(e){
 		gridListSrch();
 	});

	// 조직찾기 팝업
	$('#bt_srch_org').bind('click', function(e){ 
		genexon.popOrgSearch(["srch_scd", "srch_snm"], $("#view_auth").val());
	});	

	// 소속 X 버튼
    genexon.addInitButton('srch_snm', ['srch_snm', 'srch_scd'], $("#view_auth").val());

	//전체선택 체크박스 클릭 시
	$("#check-all").bind("click", function () {
        if($("input:checkbox[id='check-all']").is(":checked")){
            $("input:checkbox[name='VALUE_ARR']").each(function(){
                this.checked=true;
             });
        }else{
            $("input:checkbox[name='VALUE_ARR']").each(function(){
                this.checked=false;
             });
        }
    });
});

// 조회
function srch() {
	var grid = $("#grid").data("kendoGrid");
	grid.dataSource.read();
}

// 권한 할당 사용자 조회
function gridListSrch() {

	if($("#role_id").val() == null || $("#role_id").val() == "") {
		genexon.alert("info","조회","권한을 선택하세요.");
		return;
	}
	
	var gridList = $("#gridList").data("kendoGrid");
	
	gridList.dataSource.read({
		role_id : $("#role_id").val()
	   ,srch_scd : $("#srch_scd").val()
	   ,srch_jikchk : $("#srch_jikchk").val()
	   ,srch_jikgub : $("#srch_jikgub").val()
	   ,srch_empsta : $("#srch_empsta").val()
	   ,srch_emp_value : $("#srch_emp_value").val()
	});
}

// 개별 체크박스 선택, 선택해제 시 전체선택 체크박스 해제
function removeChkAll() {
	$("#check-all").prop("checked", false);
}

// 사용자 권한 삭제
function deleteUserRole(e) {

	if($("#role_id").val() == null || $("#role_id").val() == "") {
		genexon.alert("info","권한 할당 사용자 삭제","권한을 선택하세요.");
		return;
	}
	
	var obj = new Object();
	obj.models = new Array();
	obj.VALUE_ARR = new Array();
	var seq_arr = new Array();
	var message = "";
	var gridData = $("#gridList").data("kendoGrid").dataSource.data();
	var errorCheck = true;

	$("input[name=VALUE_ARR]:checked").each(function() {
		seq_arr.push($(this).val());
		UserRoleVO = new Object();
		UserRoleVO.emp_cd = $(this).val();
		UserRoleVO.role_id = $("#role_id").val();
		
		// 겸직
		gridData.forEach(function(element, idx, elArr) {
			if(UserRoleVO.emp_cd == element.emp_cd) {
				UserRoleVO.concurrent_idx = element.concurrent_idx;
				UserRoleVO.scd = element.scd;
				UserRoleVO.jikgub = element.jikgub;
				UserRoleVO.jikchk = element.jikchk;
			}
		});
		
		// 주 권한 삭제 불가
		if(UserRoleVO.concurrent_idx == "1") {
			errorCheck = false;
			return;
		}
		
		obj.models.push(UserRoleVO);
	});
	
	if(seq_arr.length == 0) {
		genexon.alert("info", "권한 할당 사용자 삭제", "삭제할 권한 할당 사용자를 선택해주세요");
		
		return;
	}else {
		message = "선택한 권한 할당 사용자가 삭제됩니다.<br><br>진행하시겠습니까?";
		obj.VALUE_ARR.push(seq_arr);
	}

	if(errorCheck) {
		genexon.confirm("권한 할당 사용자 삭제", message, function(result) {
			if(result) {
				$.ajax({
					url: "/userRole/deleteUserRole.ajax?${_csrf.parameterName}=${_csrf.token}",
					contentType: "application/json; charset=UTF-8",
					type: "POST",
					dataType: "json",
					data: JSON.stringify(obj),
					success: function(result) {
						genexon.alert("success", "권한 할당 사용자 삭제", "정상적으로 처리되었습니다.");
						srch();
					},
					error: function(xhr, status, error) {
						genexon.alert("error", "권한 할당 사용자 삭제", xhr.responseJSON.errmsg);
					}
				});
			}
		});
	} else {
		genexon.alert("error", "권한 할당 사용자 삭제", "주 권한은 삭제할 수 없습니다.");
		return;
	}
}

// 사용자 권한 등록
function userRoleRegi(){
	if($("#role_id").val() == null || $("#role_id").val() == "") {
		genexon.alert("info","권한 할당 사용자 등록","권한을 선택하세요.");
		return;
	}
	
	genexon.PopWindowOpen({pID : "userRolePop"
        ,pTitle : "권한등록"
        ,pURL   : "/userRole/userRoleRegi.pop?${_csrf.parameterName}=${_csrf.token}"
        ,pWidth : "1200"
    	,pHeight : "600"
    	,data : { role_id : $("#role_id").val(), role_nm : $("#role_nm").val() }
    	,position : {top:50, left:100}
        ,callbackFunc : gridListSrch
        ,pModal : true
        ,resizable : true
    });
}
</script>
</head>
<body>
<div class="search">
	<table class="ta_sty01">
		<tr>
			<td>
				<input type="hidden" name="srch_scd" id="srch_scd" readonly="readonly" />
				<input type="text" class="k-textbox" name="srch_snm" id="srch_snm" readonly="readonly" style="background:#F8F8F8" placeholder="소속"/>
				<button class="k-primary2 btn_sty01 ml5" id="bt_srch_org">검색</button>
			
				<input type="text" class="k-textbox" name="srch_emp_value" id="srch_emp_value" style="width: 250px;" onKeyPress="if(event.keyCode==13)srch();" placeholder="성명/사원번호"/>
			
				<input type="text" class="kddl" name="srch_jikchk" id="srch_jikchk" ddcode="JIKCHK" optionLabel="직책"/>
			
				<input type="text" class="kddl" name="srch_jikgub" id="srch_jikgub" ddcode="JIKGUB"  optionLabel="직급"/>
			
				<input type="text" class="kddl" name="srch_empsta" id="srch_empsta" ddcode="EMPSTA" optionLabel="재직구분"/>
			
				<button class="k-primary btn_sty02" id="search" >조회</button>
			</td>
		</tr>
	</table>
</div>


<div style="width: 15%; float: left;">
	<div id="grid" class="resizegrid"><span class="gridTitle">권한명</span></div>
	
	<script>
	    /**
	     * 데이터 소스설정
	     * 그룹코드 그리드 url 및 스키마모델 정의
	     **/
	    var ds = {
	        transport : {
				 read    : {url: "/role/getRoleList.ajax?${_csrf.parameterName}=${_csrf.token}"}
	        },
	        schema : {
	            model : {
	                id : "role_id",
	                fields : {
	                	  mb_id : {}        /* 회사코드   VARCHAR(20) */
	                    , role_id : {}      /* 권한ID     VARCHAR(50) */
	                    , role_nm : {}      /* 권한명     VARCHAR(50) */
	            		, login_autr_type : {}    /* 로그인 인증 초기 설정 VARCHAR(1)  */
	                    , in_emp_cd : {}    /* 입력자사번 VARCHAR(20) */
	                    , in_dtm : {}       /* 입력일시   DATETIME    */
	                    , up_emp_cd : {}    /* 수정자사번 VARCHAR(20) */
	                    , up_dtm : {}       /* 수정일시   DATETIME    */
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
	        columns : [
	            {
	                field: "role_nm",
	                title: "권한명",
	                width: 160,
					attributes :{
						style : "text-align : center"
					}
	            }
	        ],
			editable: false,
	        dataBound: onChange,
	        change: onChange
	    };
	    
	    /**
	     *인라인 그리드 생성
	     **/
	    genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);

	    function onChange(e) {
	    	var item = this.dataItem(this.select());
	    	
	    	if(item != null) {
	    		$("#role_id").val(item.role_id);
	    		$("#role_nm").val(item.role_nm);
	    		
	    		gridListSrch();
	    	}else {
	    		$("#gridList .k-grid-content tbody").empty();
	    	}
	    }
	</script>
	<!-- 권한관리 영역 div end  -->
</div>

<div style="width: 83%; float: right;">
	<span class="gridTitle" style="display:block;">권한 할당 사용자</span>
	<span class="gridSubTitle"></span>
	<div class="bt_right2" style="display: inline-block;float:right;margin-bottom:10px;">
		<input type="hidden" id="role_id" >
		<input type="hidden" id="role_nm" >
		
		<button class="k-primary de_autr_type" onclick="deleteUserRole()">권한삭제</button>
		<button class="k-primary in_autr_type" onclick="userRoleRegi()">권한등록</button>
		
	</div>
	<div id="gridList" class="resizegrid" style="clear:both; margin-bottom: 20px;"></div>
	
	<script>
	    /**
	     * 데이터 소스설정
	     * 그룹코드 그리드 url 및 스키마모델 정의
	     **/

	 	var ds = {
	 		transport: {
	 			read: {url: "/userRole/getUserRoleList.ajax?${_csrf.parameterName}=${_csrf.token}"}
	 		},
	 		schema: {
	 			data : "results",
	 			model: {
	 				id: "emp_cd",
	 				fields: {
	 					   mb_id : {}        /* 회사코드   VARCHAR(20) */
	 				     , emp_cd : {}       /* 사원코드   VARCHAR(20) */
	 				     , role_id : {}      /* 권한ID     VARCHAR(50) */
	 				     , scd : {}
	 				     , jikgub : {}
	 				     , jikchk : {}
	 				     , empsta : {}
	 				     , scdpath : {}
	 				     , snmpath : {}
	 				     , concurrent_gubun : {}
	 				     , concurrent_idx : {}
	 				     , in_emp_cd : {}    /* 입력자사번 VARCHAR(20) */
	 				     , in_dtm : {}       /* 입력일시   DATETIME    */
	 				     , up_emp_cd : {}    /* 수정자사번 VARCHAR(20) */
	 				     , up_dtm : {}       /* 수정일시   DATETIME    */
	 				}
	 			}
	 		},
	 		requestEnd : function(e) {
	 			if (e.type != undefined && e.type != "read") {
	 				srch();
	 			}
	 		}
	 	}; //dataSource

	 	var gridpt = {
	 		dataSource: ds,
			filterable: false,
			columns: [
				{ 
					template: '<a href="javascript:;" onclick="removeChkAll();"><input type="checkbox" name="VALUE_ARR" value="#=emp_cd#" /></a>',
					attributes:{"class":"col-center"},
					headerTemplate: '<input type="checkbox" id="check-all" name="checkall"/><label for="check-all"> </label>',
					width: 90
				}, {
					field : "emp_cd",
					title : "사원코드",
					hidden : true
				}, {
					field : "scd",
					title : "조직코드",
					hidden : true
				}, {
					field : "emp_nm",
					title : "성명",
					template : function(e) {
						var emp_cd = e.emp_cd;
						var emp_nm = e.emp_nm;
						
						if(genexon.nvl(emp_cd, "") != "" && genexon.nvl(emp_cd, "") != null) {
							return genexon.nvl(e.emp_nm, "")+"("+genexon.nvl(e.emp_cd, "")+")";
						}else {
							return "";
						}
					}, 
					width : 100,
					attributes :{
						style : "text-align : center"
					}
				}, {
					field : "concurrent_gubun",
					title : "겸직",
					width : 80,
					template: function(e) {
						var concurrent_gubun = e.concurrent_gubun;
						
						if(genexon.nvl(concurrent_gubun, "") == "Y") {
							return "겸직";
						}else {
							return ""
						}
					},
					attributes :{
						style : "text-align : center"
					}
				}, {
					field : "snmpath",
					title : "소속",
					width : 200,
					attributes :{
						style : "text-align : center;"
					}
				}, {
					field : "jikchk_nm",
					title : "직책",
					width : 90,
					attributes :{
						style : "text-align : center"
					}
				}, {
					field : "jikgub_nm",
					title : "직급",
					width : 90,
					attributes :{
						style : "text-align : center"
					}
				}, {
					field : "empsta",
					title : "재직구분",
					width : 80,
					attributes : {
						style : "text-align : center"
					}
				}
			],editable: false,
			dataBound: function (e) {
				var gridId = e.sender.element.context.id;
				//gridContentIncision(gridId,20);
			},
			pageable: true
		};

		genexon.initKendoUI_grid_inlineEdit("#gridList", gridpt, ds);
	</script>
	<!-- 메뉴별 권한설정 영역 div end -->
</div>
</body> 
</html>