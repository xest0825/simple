<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 03. 12
	화면 설명 : 사용자계정관리
######################################################################################### 
 -->
<html>
<head>
<script type="text/javascript">
$(document).ready(function() {
	
	//화면 최초로딩시 조회처리
	srch();

	// 조직찾기 팝업
	$('#bt_srch_org').bind('click', function(e){ 
		genexon.popOrgSearch(["srch_scd", "srch_snm"], $("#view_auth").val());
	});	

	// 소속 X 버튼
    genexon.addInitButton('srch_snm', ['', 'srch_scd']);

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

	grid.dataSource.read({
		srch_scd : $("#srch_scd").val()
	   ,srch_emp_value : $("#srch_emp_value").val()
	   ,srch_empsta : $("#srch_empsta").val()
	   ,pwd_intzn_type : $("#pwd_intzn_type").val()
	   ,acct_lock_type : $("#acct_lock_type").val()
	   ,login_autr_type : $("#login_autr_type").val()
	});
}

// 개별 체크박스 선택, 선택해제 시 전체선택 체크박스 해제
function removeChkAll() {
	$("#check-all").prop("checked", false);
}

// 비밀번호 초기화
function initPwd() {

	var obj = new Object();
	obj.models = new Array();
	obj.VALUE_ARR = new Array();
	var LoginVO = new Object();
	var seq_arr = new Array();
	var message = "";

	$("input[name=VALUE_ARR]:checked").each(function() {
		seq_arr.push($(this).val());
		LoginVO = new Object();
		LoginVO.emp_cd = $(this).val();
		LoginVO.pwd_intzn_type = 'Y';
		obj.models.push(LoginVO);
	});
	
	if(seq_arr.length == 0) {
		genexon.alert("info", "비밀번호 초기화", "비밀번호 초기화할 사용자를 선택해주세요");
		
		return;
	}else {
		message = "선택한 사용자의 비밀번호 초기화됩니다.<br><br>진행하시겠습니까?";
	}
	
	genexon.confirm("비밀번호 초기화", message, function(result) {
		if(result) {
			$.ajax({
				url: "/login/updateLogin.ajax?${_csrf.parameterName}=${_csrf.token}",
				contentType: "application/json; charset=UTF-8",
				type: "POST",
				dataType: "json",
				data: JSON.stringify(obj),
				success: function(result) {
					genexon.alert("success", "비밀번호 초기화", "정상적으로 처리되었습니다.");
					srch();
				},
				error: function(xhr, status, error) {
					genexon.alert("error", "비밀번호 초기화", xhr.responseJSON.errmsg);
				}
			});
		}
	});
}

// 계정잠금
function accountLock() {

	var obj = new Object();
	obj.models = new Array();
	obj.VALUE_ARR = new Array();
	var LoginVO = new Object();
	var seq_arr = new Array();
	var message = "";

	$("input[name=VALUE_ARR]:checked").each(function() {
		seq_arr.push($(this).val());
		LoginVO = new Object();
		LoginVO.emp_cd = $(this).val();
		LoginVO.acct_lock_type = 'Y';
		obj.models.push(LoginVO);
	});
	
	if(seq_arr.length == 0) {
		genexon.alert("info", "계정잠금", "계정잠금할 사용자를 선택해주세요");
		
		return;
	}else {
		message = "선택한 사용자의 계정이 잠금됩니다.<br><br>진행하시겠습니까?";
	}
	
	genexon.confirm("계정잠금", message, function(result) {
		if(result) {
			$.ajax({
				url: "/login/updateLogin.ajax?${_csrf.parameterName}=${_csrf.token}",
				contentType: "application/json; charset=UTF-8",
				type: "POST",
				dataType: "json",
				data: JSON.stringify(obj),
				success: function(result) {
					genexon.alert("success", "계정잠금", "정상적으로 처리되었습니다.");
					srch();
				},
				error: function(xhr, status, error) {
					genexon.alert("error", "계정잠금", xhr.responseJSON.errmsg);
				}
			});
		}
	});
}

// 계정잠금 해제
function accountLockout() {

	var obj = new Object();
	obj.models = new Array();
	obj.VALUE_ARR = new Array();
	var LoginVO = new Object();
	var seq_arr = new Array();
	var message = "";

	$("input[name=VALUE_ARR]:checked").each(function() {
		seq_arr.push($(this).val());
		LoginVO = new Object();
		LoginVO.emp_cd = $(this).val();
		LoginVO.acct_lock_type = 'N';
		obj.models.push(LoginVO);
	});
	
	if(seq_arr.length == 0) {
		genexon.alert("info", "계정잠금 해제", "계정잠금 해제할 사용자를 선택해주세요");
		
		return;
	}else {
		message = "선택한 사용자의 계정이 잠금 해제됩니다.<br><br>진행하시겠습니까?";
	}
	
	genexon.confirm("계정잠금 해제", message, function(result) {
		if(result) {
			$.ajax({
				url: "/login/updateLogin.ajax?${_csrf.parameterName}=${_csrf.token}",
				contentType: "application/json; charset=UTF-8",
				type: "POST",
				dataType: "json",
				data: JSON.stringify(obj),
				success: function(result) {
					genexon.alert("success", "계정잠금 해제", "정상적으로 처리되었습니다.");
					srch();
				},
				error: function(xhr, status, error) {
					genexon.alert("error", "계정잠금 해제", xhr.responseJSON.errmsg);
				}
			});
		}
	});
}

// 2factor인증
function loginAutr() {

	var obj = new Object();
	obj.models = new Array();
	obj.VALUE_ARR = new Array();
	var LoginVO = new Object();
	var seq_arr = new Array();
	var message = "";

	$("input[name=VALUE_ARR]:checked").each(function() {
		seq_arr.push($(this).val());
		LoginVO = new Object();
		LoginVO.emp_cd = $(this).val();
		LoginVO.login_autr_type = 'SMS_Y';
		obj.models.push(LoginVO);
	});
	
	if(seq_arr.length == 0) {
		genexon.alert("info", "2factor인증", "2factor인증할 사용자를 선택해주세요");
		
		return;
	}else {
		message = "선택한 사용자의 계정이 2factor인증됩니다.<br><br>진행하시겠습니까?";
	}
	
	genexon.confirm("2factor인증", message, function(result) {
		if(result) {
			$.ajax({
				url: "/login/updateLogin.ajax?${_csrf.parameterName}=${_csrf.token}",
				contentType: "application/json; charset=UTF-8",
				type: "POST",
				dataType: "json",
				data: JSON.stringify(obj),
				success: function(result) {
					genexon.alert("success", "2factor인증", "정상적으로 처리되었습니다.");
					srch();
				},
				error: function(xhr, status, error) {
					genexon.alert("error", "2factor인증", xhr.responseJSON.errmsg);
				}
			});
		}
	});
	
}

// 2factor인증 해제
function loginUnAutr() {

	var obj = new Object();
	obj.models = new Array();
	obj.VALUE_ARR = new Array();
	var LoginVO = new Object();
	var seq_arr = new Array();
	var message = "";

	$("input[name=VALUE_ARR]:checked").each(function() {
		seq_arr.push($(this).val());
		LoginVO = new Object();
		LoginVO.emp_cd = $(this).val();
		LoginVO.login_autr_type = 'SMS_N';
		obj.models.push(LoginVO);
	});
	
	if(seq_arr.length == 0) {
		genexon.alert("info", "2factor인증 해제", "2factor인증 해제할 사용자를 선택해주세요");
		
		return;
	}else {
		message = "선택한 사용자의 계정이 2factor인증이 해제됩니다.<br><br>진행하시겠습니까?";
	}
	
	genexon.confirm("2factor인증 해제", message, function(result) {
		if(result) {
			$.ajax({
				url: "/login/updateLogin.ajax?${_csrf.parameterName}=${_csrf.token}",
				contentType: "application/json; charset=UTF-8",
				type: "POST",
				dataType: "json",
				data: JSON.stringify(obj),
				success: function(result) {
					genexon.alert("success", "2factor인증 해제", "정상적으로 처리되었습니다.");
					srch();
				},
				error: function(xhr, status, error) {
					genexon.alert("error", "2factor인증 해제", xhr.responseJSON.errmsg);
				}
			});
		}
	});
	
}

//[엑셀다운로드]
function excelDown(){

	var data = {
		srch_scd : $("#srch_scd").val()
	   ,srch_emp_value : $("#srch_emp_value").val()
	   ,srch_empsta : $("#srch_empsta").val()
	   ,pwd_intzn_type : $("#pwd_intzn_type").val()
	   ,acct_lock_type : $("#acct_lock_type").val()
	   ,login_autr_type : $("#login_autr_type").val()
	};
	
	genexon.excelDown("#excelForm", data);
}

</script>
</head>
<body>
<form id="excelForm" name="excelForm" method="post" action="/login/getLoginListExcel.ajax?${_csrf.parameterName}=${_csrf.token}">
</form>
	<div class="search">
		<table class="ta_sty01">
			<tr>
				<td>
					<input type="hidden" name="srch_scd" id="srch_scd" readonly="readonly" />
					<input type="text" class="k-textbox" name="srch_snm" id="srch_snm" readonly="readonly" style="background:#F8F8F8" placeholder="소속"/>
					<button class="k-primary2 btn_sty01 ml5" id="bt_srch_org">검색</button>
				
					<input type="text" class="k-textbox" name="srch_emp_value" id="srch_emp_value" style="width: 150px;" onKeyPress="if(event.keyCode==13)srch();" placeholder="성명/사원번호"/>
				
					<input type="text" class="kddl" name="srch_empsta" id="srch_empsta" ddcode="EMPSTA" optionLabel="재직구분"/>
				
					<input type="text" class="kddl" name="pwd_intzn_type" id="pwd_intzn_type" ddcode="PWD_INTZN_TYPE" optionLabel="초기화여부"/>
				
					<input type="text" class="kddl" name="acct_lock_type" id="acct_lock_type" ddcode="ACCT_LOCK_TYPE"  optionLabel="잠김여부"/>
				
					<input type="text" class="kddl" name="login_autr_type" id="login_autr_type" ddcode="LOGIN_AUTR_TYPE" optionLabel="인증여부"/>
				
					<button class="kbtn k-primary btn_sty02" onclick="javascript:srch();" id="srch" name="srch">조회</button>
					<button class="kbtn k-primary btn_sty03 do_autr_type" type="button" class="k-primary" id="bt_excel_download" onclick="excelDown()">엑셀다운로드</button>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="bt_left" >
		<div class="bt_orange_S" onclick="initPwd()">비밀번호 초기화</div>
		<div class="bt_orange_S" onclick="accountLock()">계정잠금</div>
		<div class="k-primary btn_sty03 mb7" onclick="accountLockout()">계정잠금 해제</div>
		<div class="k-primary btn_sty03 mb7" onclick="loginAutr()">2factor인증</div>
		<div class="k-primary btn_sty03 mb7" onclick="loginUnAutr()">2factor인증 해제</div>
	</div>
	
	<div id="grid" class="resizegrid"></div>
	
	<script>
	    /**
	     * 데이터 소스설정
	     * 그룹코드 그리드 url 및 스키마모델 정의
	     **/
	    var ds = {
	        transport : {
				 read    : {url: "/login/getLoginList.ajax?${_csrf.parameterName}=${_csrf.token}"}
	        },
	        schema : {
	            model : {
	                id : "emp_cd",
	                fields : {
		                  mb_id : {}            /* 회사코드           VARCHAR(20)  */
		                , login_id : {}         /* 사용자 ID          VARCHAR(20)  */
		                , emp_cd : {}           /* 사번               VARCHAR(20)  */
		                , emp_nm : {}           /* 사원명 */
		                , empsta : {}           /* 재직여부        VARCHAR(20)   */
		                , pwd_intzn_type : {}   /* 비밀번호초기화여부 VARCHAR(1)   */
		                , acct_lock_type : {}   /* 계정잠김여부       VARCHAR(1)   */
		                , login_autr_type : {}  /* 2tactor 인증여부   VARCHAR(1)   */
		                , user_pwd : {}         /* 사용자 비밀번호    VARCHAR(430) */
		                , trns_user_pwd : {}    /* 임시 비빌번호      VARCHAR(430) */
		                , pwd_err_nbtm : {}     /* 비밀번호 오류횟수  BIGINT       */
		                , pwd_chg_dt : {}       /* 비밀번호 변경일자  VARCHAR(8)   */
		                , login_dtm : {}
		                , memo : {}             /* 메모               VARCHAR(200) */
		                , in_emp_cd : {}        /* 입력자사번         VARCHAR(20)  */
		                , in_dtm : {}           /* 입력일시           DATETIME     */
		                , up_emp_cd : {}        /* 수정자사번         VARCHAR(20)  */
		                , up_dtm : {}           /* 수정일시           DATETIME     */
		                , scdpath : {}
		                , snmpath : {}
		                , snmpath1 : {}
		                , snmpath2 : {}
		                , snmpath3 : {}
		                , snmpath4 : {}
		                , snmpath5 : {}
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
	        columns : [{ 
	                template: '<a href="javascript:;" onclick="removeChkAll();"><input type="checkbox" name="VALUE_ARR" value="#=emp_cd#" /></a>',
	                attributes:{"class":"col-center"},
	                headerTemplate: '<input type="checkbox" id="check-all" name="checkall"/><label for="check-all"> </label>',
	                width: 90
				},
				{
	                field: "emp_cd",
	                title: "이름",
	                width: 150,
	                template : function(e) {
	        			var emp_cd = e.emp_cd;
	        			var emp_nm = e.emp_nm;

	        			if (genexon.nvl(emp_cd, "") == "" || genexon.nvl(emp_cd, "") == null) {
	        				return "";
	        			} else {
	        				return genexon.nvl(emp_nm, "") + "(" + genexon.nvl(emp_cd, "") + ")";
	        			}
	        		},
					attributes :{
						style : "text-align : center"
					}
	            },
	            {
	                field: "snmpath",
	                title: "소속",
	                width: 250,
					attributes :{
						style : "text-align : center;"
					}
	            },
	            {
	                field: "empsta",
	                title: "재직구분",
	                width: 100,
					attributes :{
						style : "text-align : center"
					}
	            },
	            {
	                field: "pwd_intzn_type",
	                title: "비밀번호 초기화여부",
	                width: 100,
					attributes :{
						style : "text-align : center"
					}
	            },
	            {
	                field: "acct_lock_type",
	                title: "계정 잠김여부",
	                width: 100,
					attributes :{
						style : "text-align : center"
					}
	            },
	            {
	                field: "login_autr_type",
	                title: "2factor인증 사용여부",
	                width: 100,
	                template: "#=#",
	                template:kendo.template("#if (login_autr_type_nm != null) {# #=login_autr_type_nm# #} else {#  #}#"),
					attributes :{
						style : "text-align : center"
					}
	            },
	            {
	                field: "login_dtm",
	                title: "최근접속현황",
	                width: 150,
					attributes :{
						style : "text-align : center"
					}
	            }
	        ],
			editable: false,
			dataBound: function (e) {
				var gridId = e.sender.element.context.id;
				//gridContentIncision(gridId,20);
			}
	    };
	    
	    /**
	     *인라인 그리드 생성
	     **/
	    genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);

	</script>
</body> 
</html>