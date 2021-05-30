<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 03. 06
	화면 설명 : 권한등록 팝업
######################################################################################### 
 -->
<html>
<head>
<script type="text/javascript">
$(document).ready(function() {

	//화면 최초로딩시 조회처리
	srch();

	var treeView = $("#treeview").data("kendoTreeView");
	//트리뷰 전체 펼치기
	$("#expandAllNodes").click(function() {
		treeView.expand(".k-item");
	});

	//트리뷰 전체 닫기
	$("#collapseAllNodes").click(function() {
		treeView.collapse(".k-item");
	});

	// 조직찾기 팝업
	$('#bt_srch_org').bind('click', function(e){
		genexon.popSearchWindow(["srch_scd", "srch_snm"], "org", "userRolePop");
	});	

	// 소속 X 버튼
    genexon.addInitButton('srch_snm', ['srch_snm', 'srch_scd']);

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
function srch()
{
	var grid = $("#grid").data("kendoGrid");

	grid.dataSource.read({
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

// 사용자 권한 등록/변경
function insertUserRole(e) {

	if($("#role_id").val() == null || $("#role_id").val() == "") {
		genexon.alert("info","권한 할당 사용자 등록","권한을 선택하세요.");
		return;
	}
	
	var obj = new Object();
	obj.models = new Array();
	obj.VALUE_ARR = new Array();
	var seq_arr = new Array();
	var message = "";
	var gridData = $("#grid").data("kendoGrid").dataSource.data();
	var role_nm = $("#role_nm").val();

	$("input[name=VALUE_ARR]:checked").each(function() {
		seq_arr.push($(this).val());
		UserRoleVO = new Object();
		UserRoleVO.emp_cd = $(this).val();
		UserRoleVO.role_id = $("#role_id").val();	// 등록 구분값

		// 겸직
		gridData.forEach(function(element, idx, elArr) {
			if(UserRoleVO.emp_cd == element.emp_cd) {
				UserRoleVO.concurrent_idx = element.concurrent_idx;
				UserRoleVO.scd = element.scd;
				UserRoleVO.jikgub = element.jikgub;
				UserRoleVO.jikchk = element.jikchk;
			}
		});
		
		obj.models.push(UserRoleVO);
	});
	
	if(seq_arr.length == 0) {
		genexon.alert("info", "권한 할당 사용자 등록", "등록할 권한 할당 사용자를 선택해주세요");
		
		return;
	}else {
		message = "선택한 권한 할당 사용자의 겸직을 포함한 기존 권한이 존재하는 경우 전부 삭제되고 [" + role_nm + "] 권한만 등록됩니다.<br><br>진행하시겠습니까?";
		obj.VALUE_ARR.push(seq_arr);
	}
	
	genexon.confirm("권한 할당 사용자 등록", message, function(result) {
		if(result) {
			$.ajax({
				url: "/userRole/insertUserRole.ajax?${_csrf.parameterName}=${_csrf.token}",
				contentType: "application/json; charset=UTF-8",
				type: "POST",
				dataType: "json",
				data: JSON.stringify(obj),
				success: function(result) {
					genexon.alert("success", "권한 할당 사용자 등록", "정상적으로 처리되었습니다.");
					genexon.PopWindowClose2('#userRolePop');
				},
				error: function(xhr, status, error) {
					genexon.alert("error", "권한 할당 사용자 등록", xhr.responseJSON.errmsg);
				}
			});
		}
	});
}
</script>
</head>
<body>
	<input type="hidden" id="role_id" name="role_id" value="${UserRoleVO.role_id}" />
	<input type="hidden" id="role_nm" name="role_nm" value="${UserRoleVO.role_nm}" />
	<!-- Content //-->
	<div class="content">
		<div class="bg_con">
			<div class="searchPop">
				<table class="ta_sty01">
					<tr>
						<td>
							<input type="hidden" name="srch_scd" id="srch_scd"readonly="readonly" />
							<input type="text" class="k-textbox"name="srch_snm" id="srch_snm" readonly="readonly"style="background: #F8F8F8" placeholder="소속" />
							<button class="k-primary2" id="bt_srch_org">검색</button>
						</td>
						<td>
							<input type="text" class="k-textbox"name="srch_emp_value" id="srch_emp_value" style="width: 250px;"onKeyPress="if(event.keyCode==13)srch();" placeholder="사원명/사원번호" />
						</td>
						<td>
							<input type="text" class="kddl" name="srch_jikchk"id="srch_jikchk" ddcode="JIKCHK" optionLabel="직책" />
						</td>
						<td>
							<input type="text" class="kddl" name="srch_jikgub"id="srch_jikgub" ddcode="JIKGUB" optionLabel="직급" />
						</td>
						<td>
							<input type="text" class="kddl" name="srch_empsta"id="srch_empsta" ddcode="EMPSTA" optionLabel="재직구분" />
						</td>
						<td class="line"></td>
						<td>
							<button class="k-primary btn_sty02" onclick="javascript:srch();"  id="srch" style="width: 100px">조회</button>
						</td>
						<td style="width:28%;text-align: right;">
							<input type="hidden" id="role_id" >
							<button class="k-primary btn_sty02" onclick="javascript:genexon.PopWindowClose2('#userRolePop');">취소</button>
							<button class="k-primary btn_sty02" onclick="javascript:insertUserRole();">저장</button>
						</td>
					</tr>
				</table>
			</div>

			<div style="float: left; width: 23%; border: 1px solid #ddd">
				<div id="" style="border-bottom: 1px solid #D9D9D9; padding: 5px; text-align: center">
					<div class="bt_glay2_S boardTreeViewOption" id="expandAllNodes">전체펼치기</div>
					<div class="bt_glay2_S boardTreeViewOption" id="collapseAllNodes">전체닫기</div>
				</div>
				<div id="treeview" style="height: 413px; overflow-y: auto;"></div>
			</div>

			<div id="grid" class="resizegrid" style="float: right; width: 75%; height: 420px;"></div>
			<!-- grid end -->
			
			<div class="bt_right" style="display: inline-block;">
				
			</div>
		</div>
		<!--end bg_con-->
	</div>

	<script type="text/x-kendo-template" id="myTemplate">
        #if(item.folder_yn == "Y"){#
            <input type="hidden" class="sf#=item.scd#" name="sf" value="#=item.scd#"><span>#=item.snm#</span>
        #}else{#
            <input type="hidden" class="sf#=item.scd#" name="sf" value="#=item.scd#"><span>&nbsp;#=item.snm#</span>
        #}#
  </script>

	<script type="text/javascript">
		var treeds = {
			transport : {
				read : {
					url : "/insa/org/getOrgTreeList.ajax?${_csrf.parameterName}=${_csrf.token}",
					dataType : "json",
					type : "POST",
					data : {
						srch_org_open_gbn : 'Y'
					}
				}
			},
			schema : {
				data : "results",
				model : {
					id : "scd",
					fields : {
						
					}
				}
			},
			requestEnd: function(e) {
				if(e.type == "read") {
					var results = e.response.results;
					var max_lv = e.response.max_lv * 1;
					
					var orgArr = results[0];
					var ordredLvOrgOList = new Array();
					var items = new Array();
					
					for(var i=1; i <= max_lv; i++) {
						$.each(orgArr, function(idx, item) {
							if(item != undefined && item.lv == i) {
								items.push(item);
								delete orgArr[idx];
							}
						});
						
						ordredLvOrgOList.push(items);
						items = new Array();
					}
						
					var bindResultData = new Array();

					for(var i = max_lv; i > 0; i--) {
						var j = i-1;
						
							$.each(ordredLvOrgOList[j], function(pIdx, pItem) {
								pItem.items = new Array();
								
								if(ordredLvOrgOList[i] != undefined) {
									$.each(ordredLvOrgOList[i], function(cIdx, cItem) {
										if(pItem.scd == cItem.pscd) {
											pItem.items.push(cItem);
										}
									});
								}
								
								bindResultData.length = 0;
								bindResultData.push(pItem);
							});
						}

					var treeView = $("#treeview").data("kendoTreeView");
					treeView.setDataSource(bindResultData);
				}
			}
		};
		
		treeDataSource = new kendo.data.DataSource(treeds);
		treeDataSource.read();

		$("#treeview").kendoTreeView({
			loadOnDemand: false,
			dataTextField : "snm",
			dataValueField : "scd",
			template : kendo.template($("#myTemplate").html()),
			selectable : true,
			autoScroll : true,
			select : function(e) {
				// 조건 초기화 후에 조직조회
				$("#srch_snm").val(null);
				$("#srch_scd").val(null);

				var dataItem = this.dataItem(e.node);
				$("#srch_scd").val(dataItem.scd);

				srch();
			},
			dataBound : function(e){
				var treeView = $("#treeview").data("kendoTreeView");
				var topElement = treeView.dataSource.get();
				if(topElement!=undefined){
					treeView.expand(treeView.findByUid(topElement.uid));
				}
			}// dataBound
		});
		function selectBoard(uid){
			var treeView = $("#treeview").data("kendoTreeView");
			treeView.select(treeView.findByUid(uid));
		}
	    /**
	     * 데이터 소스설정
	     * 그룹코드 그리드 url 및 스키마모델 정의
	     **/
	 	var ds = {
	 		transport: {
	 			read: {url: "/insa/getEmpSrchRoleList.ajax?${_csrf.parameterName}=${_csrf.token}"}
	 		},
	 		schema: {
	 			data : "results",
	 			model: {
	 				id: "emp_cd",
	 				fields: {
	 					   mb_id : {}        /* 회사코드   VARCHAR(20) */
	 				     , emp_cd : {}       /* 사원코드   VARCHAR(20) */
	 				     , role_id : {}      /* 권한ID     VARCHAR(50) */
	 				     , jikgub : {}
	 				     , jikchk : {}
	 				     , empsta : {}
	 				     , scdpath : {}
	 				     , snmpath : {}
	 				     , in_emp_cd : {}    /* 입력자사번 VARCHAR(20) */
	 				     , in_dtm : {}       /* 입력일시   DATETIME    */
	 				     , up_emp_cd : {}    /* 수정자사번 VARCHAR(20) */
	 				     , up_dtm : {}       /* 수정일시   DATETIME    */
	 				}
	 			}
	 		}
	 		,requestEnd : function(e) {
	 			if (e.type != undefined && e.type != "read") {
	 				srch();
	 			}
	 		}
	 	}; //dataSource

	 	var gridpt = {
	 		dataSource: ds,
	               filterable: false,
	                columns: [{ 
	                    template: '<a href="javascript:;" onclick="removeChkAll();"><input type="checkbox" name="VALUE_ARR" value="#=emp_cd#" /></a>',
	                    attributes:{"class":"col-center"},
	                    headerTemplate: '<input type="checkbox" id="check-all" name="checkall"/><label for="check-all"> </label>',
	                    width: 90
					},{
						field : "emp_nm",
						title : "사원이름",
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
						field : "",
						title : "겸직구분",
						width : 90,
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
					}],
					dataBound: function (e) {
	 					var gridId = e.sender.element.context.id;
	 					//gridContentIncision(gridId,20);
	 				},
	 				editable: false,
	 				pageable: true
	            };
	 	
		genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);
	</script>
</body> 
</html>