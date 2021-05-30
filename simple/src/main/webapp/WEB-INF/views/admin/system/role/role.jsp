<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 02. 26
	화면 설명 : 권한 관리
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
	srch();
});

// 조회
function srch() {
	var grid = $("#grid").data("kendoGrid");
	grid.dataSource.read();
}

// 권한 추가
function addRow() {
	var grid = $("#grid").data("kendoGrid");
	grid.addRow();
}

// 메뉴별 권한설정 저장
function menuRoleRegi() {
	
	genexon.confirm("확인창", "메뉴별 권한설정을 저장하시겠습니까?", function(result) {
		if(result){
			var grid = $("#treelist").data("kendoGrid")
			  , parameterMap = grid.dataSource.transport.parameterMap;
			
			var currentData = grid.dataSource.data();
			var updatedRecords = [];
			var newRecords = [];
			
			for (var i = 0; i < currentData.length; i++) {
				if (currentData[i].isNew()) {
					// 새로운 row
					newRecords.push(currentData[i].toJSON());
				} else if (currentData[i].dirty) {
					if(currentData[i].role_id == null || currentData[i].role_id == "" || currentData[i].role_id == undefined) {
						currentData[i].role_id = $("#role_id").val();
					}
					// 수정 row
					updatedRecords.push(currentData[i].toJSON());
				}
			}
			
			// 삭제 row
			var deletedRecords = [];
			for (var i = 0; i < grid.dataSource._destroyed.length; i++) {
				deletedRecords.push(grid.dataSource._destroyed[i].toJSON());
			}
			
			// 로그인 인증 여부 수정
			updatedRecords.push({ role_id : $("#role_id").val()
				                 ,login_autr_type : $("#login_autr_type").val()});
			
			var data = {};
			$.extend(data, parameterMap({ updated : updatedRecords }));
			
			$.ajax({
				url : "/role/updateMenuRole.ajax?${_csrf.parameterName}=${_csrf.token}",
				data : genexon.getJSONString(data),
				type : "POST",
				contentType : "application/json;charset=UTF-8",
				dataType : 'json',
				error : function() {
					genexon.alert("error", "결과", "저장중 에러가 발생했습니다.");
				},
				success : function(data) {
					if(data.results == -1) {
						genexon.alert("error", "결과", "권한이 없습니다.");
					} else {
						genexon.alert("success", "결과", "정상처리되었습니다.");
					}
					grid.dataSource._destroyed = [];
					grid.dataSource.read({
						role_id : $("#role_id").val()
					});
				}
			});
		}
	});
}
</script>
</head>
<body>
<div style="width: 25%; float: left;">
	<div id="grid" class="resizegrid"></div>
	
	<script type="text/x-kendo-template" id="template">
		<div class="toolbar" >
			<button class="kbtn k-primary btn_sty03" onclick="javascript:addRow();">권한추가</button>
		</div>
	</script>
	<script>
	    /**
	     * 데이터 소스설정
	     * 그룹코드 그리드 url 및 스키마모델 정의
	     **/
	    var ds = {
	        transport : {
				 read    : {url: "/role/getRoleList.ajax?${_csrf.parameterName}=${_csrf.token}"}
				,update  : {url: "/role/updateRole.ajax?${_csrf.parameterName}=${_csrf.token}"} 
				,destroy : {url: "/role/deleteRole.ajax?${_csrf.parameterName}=${_csrf.token}"} 
				,create  : {url: "/role/insertRole.ajax?${_csrf.parameterName}=${_csrf.token}"} 
	        },
	        schema : {
	            model : {
	                id : "role_id",
	                fields : {
	                	  mb_id : {}        /* 회사코드   VARCHAR(20) */
	                    , role_id : {}      /* 권한ID     VARCHAR(50) */
	                    , replace_role_id : {}
	                    , role_nm : {
							validation : {
								required : true,
								validationMessage : "필수요소"
							}      /* 권한명     VARCHAR(50) */
	                    }
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
	                field: "replace_role_id",
	                title: "권한코드",
	                width: 80,
					attributes :{
						style : "text-align : center"
					}
	            },
	            {
	                field: "role_nm",
	                title: "권한명",
	                width: 160,
					attributes :{
						style : "text-align : center"
					}
	            },{
					command: [{ name: "edit", text : { edit : "수정", cancel : "취소", update : "저장"}, iconClass: "none"}
							 ,{ name: "Delete", text: "삭제", iconClass: "none", className: "deleteTd", click: onDelete}],
					filterable:false,
					width: 140
	            }
	        ],
			toolbar: kendo.template($("#template").html())
			,editable: {
				mode:"inline" 
			}
			,edit: function(e) {
                var replace_role_id = e.container.find("input[name=replace_role_id]");
                replace_role_id.prop("disabled", true);
                replace_role_id.addClass("k-state-disabled");
                replace_role_id.attr("readonly", true);

				if (!e.model.isNew()) { // 수정
					e.model.dirty = true;
	                e.model.role_id = "ROLE_" + replace_role_id.val();
				} else { // 추가
					replace_role_id.val("자동");
				}
			},
			cancel : function(e) {
				srch();
			},
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
	    		var treelist = $("#treelist").data("kendoGrid");

	    		$("#role_id").val("ROLE_" + item.replace_role_id);
	    		$("#login_autr_type").data("kendoDropDownList").value(item.login_autr_type);
	    		
	    		treelist.dataSource.read({
	        		role_id : $("#role_id").val()
	        	});
	    		
	    	}else {
	    		$("#treelist .k-grid-content tbody").empty();
	    	}
	    }
	    
	    function onDelete(e) {
			if(confirm("삭제하시겠습니까?")){
        		var selectedItem = this.dataItem($(e.target).closest("tr"));
        		var grid = $("#grid").data("kendoGrid").dataSource;
        		$.ajax({
        			url : "/role/deleteRole.ajax?${_csrf.parameterName}=${_csrf.token}"
        			,data : { role_id : "ROLE_" + selectedItem.replace_role_id }
        			,success : function(data){
        				if(data.results == -1) {
            				genexon.alert("error", "결과" , "해당 권한에 부여된 사원이 있을 경우 삭제할수없습니다.");
        				} else {
	        				genexon.alert("success", "결과" , "정상처리되었습니다.");
        				}
        				
        				srch();
        			}
        			,error :function(error){
        				genexon.alert("error", "결과" , "삭제할수없습니다.");
        			}
        		});
        	}
	    }
	</script>
	<!-- 권한관리 영역 div end  -->
</div>

<div style="width: 73%; float: right;">
	<span class="gridTitle">메뉴별 권한설정</span>
	<span class="gridSubTitle"></span>
	<div class="bt_right2" style="display: inline-block;float:right">
		<input type="hidden" id="role_id" >
		<input type="text" class="kddl" name="login_autr_type" id="login_autr_type" ddcode="LOGIN_AUTR_TYPE" style="margin-bottom:7px;" />
		<div class="bt_orange_S" onclick="menuRoleRegi()">저장</div>
	</div>
	<div id="treelist" class="resizegrid" style="clear:both; margin-bottom: 20px;"></div>
	<script type="text/x-kendo-template" id="arrow-Template">
		#var lv = lv;#
		#for(var i=1; i < lv; i++){#
			　
		#}#
		<img src="/resources/images/common/menu_arrow.png" alt="권한" />&nbsp;#:resource_name#
	</script>
	<script>
	    /**
	     * 데이터 소스설정
	     * 그룹코드 그리드 url 및 스키마모델 정의
	     **/

	 	var ds = {
	 		transport: {
	 			read: {url: "/role/getMenuRoleList.ajax?${_csrf.parameterName}=${_csrf.token}"}
	 		},
	 		batch: true,
	 		schema: {
	 			data : "results",
	 			model: {
	 				id: "resource_id",
	 				fields: {
	 				      role_id : {}
	 				    , resource_id : {}
	 				    , resource_name : {editable: false}
	 					, view_auth : {defaultValue: { view_auth: 1, view_auth_nm: "팀원"}}
	 					, se_autr_type : {editable: false}
	 					, in_autr_type : {editable: false}
	 					, up_autr_type : {editable: false}
	 					, de_autr_type : {editable: false}
	 					, lo_autr_type : {editable: false}
	 					, do_autr_type : {editable: false}
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
	                columns: [
                	{
	                     field : "role_id",
	                     title : "권한코드",
                         template: '<input name="role_id" value="#=role_id#" />',
	                     hidden : true
	                 }, {
	                     field : "resource_id",
	                     title : "메뉴ID",
                         template: '<input name="resource_id" value="#=resource_id#" />',
	                     hidden : true
	                 }, {
	                     field : "resource_name",
	                     title : "메뉴명",
	                	 template: $("#arrow-Template").html(),
	                     width : 250,
	                		attributes :{
	                			style : "text-align : left"
	                		}
	                 }, {
	                     field : "use_yn",
	                     title : "메뉴사용구분",
                         editor: dropDownListEditor,
                         template: "#=use_yn_nm#",
	                     width : 100,
	             		 attributes :{
	             			style : "text-align : center"
	             		}
	             	}, {
                         field : "view_auth",
                         title : "조회권한",
                         editor: dropDownListEditor,
                         template: "#=view_auth_nm#",
                         width : 90,
                 		attributes :{
                 			style : "text-align : center"
                 		}
	             	}, {
                         field : "se_autr_type",
                         title : "조회",
                         width : 90,
                         template: '<input type="checkbox" name="se_autr_type" #= se_autr_type == "Y" ? \'checked="checked"\' : "" # class="chkbx" />',
                 		attributes :{
                 			style : "text-align : center"
                 		}
	                 }, {
                         field : "in_autr_type",
                         title : "입력",
                         width : 90,
                         template: '<input type="checkbox" name="in_autr_type" #= in_autr_type == "Y" ? \'checked="checked"\' : "" # class="chkbx" />',
                 		attributes :{
                 			style : "text-align : center"
                 		}
	                 }, {
                         field : "up_autr_type",
                         title : "수정",
                         width : 90,
                         template: '<input type="checkbox" name="up_autr_type" #= up_autr_type == "Y" ? \'checked="checked"\' : "" # class="chkbx" />',
                 		attributes :{
                 			style : "text-align : center"
                 		}
	                 }, {
                         field : "de_autr_type",
                         title : "삭제",
                         width : 90,
                         template: '<input type="checkbox" name="de_autr_type" #= de_autr_type == "Y" ? \'checked="checked"\' : "" # class="chkbx" />',
                 		attributes :{
                 			style : "text-align : center"
                 		}
	                 }, {
	     				field : "lo_autr_type",
	     				title : "엑셀업로드",
	     				width : 90,
                        template: '<input type="checkbox" name="lo_autr_type" #= lo_autr_type == "Y" ? \'checked="checked"\' : "" # class="chkbx" />',
	     				attributes :{
	             			style : "text-align : center"
	     				}
	     			}, {
	     				field : "do_autr_type",
	     				title : "엑셀다운로드",
	     				width : 90,
                        template: '<input type="checkbox" name="do_autr_type" #= do_autr_type == "Y" ? \'checked="checked"\' : "" # class="chkbx" />',
	     				attributes :{
	             			style : "text-align : center"
	     				}
	     			}
	                ]
	 				, editable: true
	            }; //kendoTreeList
	            
	            // dropDownList editor
	            function dropDownListEditor(container, options) {
	            	
	            	var field = options.field
	            	$('<input required type="text" name="' + field + '" class="kddl" ddcode="' + field + '" />').appendTo(container);
	            	
	            	var input = container.find("input[name='" + field + "']");
					genexon.initKendoUI_ddl(input);
					
					input.data("kendoDropDownList").bind('change', function(e) {
						var ddlItem = this.dataItem();
						
						if(field == 'view_auth') {
							options.model.view_auth_nm = ddlItem.TEXT;
							
							var grid = $('#treelist').data('kendoGrid');

							// 선택된 row
				            var selectedRowData = grid.dataItem(grid.select());
							
							// 전체 row
							var currentData = grid.dataSource.data();
							
							for (var i = 0; i < currentData.length; i++) {
								// 선택 row의 하위메뉴
								if(currentData[i].prnt_resource_id == selectedRowData.resource_id) {
							        var IdataItem = grid.dataSource.at(i);
									
							        IdataItem.set("view_auth", ddlItem.VALUE);
							        IdataItem.set("view_auth_nm", ddlItem.TEXT);
							        IdataItem.set("dirty", true);
							        $("[data-uid=" + IdataItem.uid + "]").find("td").eq(4).text(ddlItem.TEXT).prepend("<span class='k-dirty'></span>");

									// 하위의 하위메뉴
									for (var j = 0; j < currentData.length; j++) {
										if(currentData[i].resource_id == currentData[j].prnt_resource_id) {
									        var JdataItem = grid.dataSource.at(j);
											
									        JdataItem.set("view_auth", ddlItem.VALUE);
									        JdataItem.set("view_auth_nm", ddlItem.TEXT);
									        JdataItem.set("dirty", true);
									        $("[data-uid=" + JdataItem.uid + "]").find("td").eq(4).text(ddlItem.TEXT).prepend("<span class='k-dirty'></span>");
										}
									}
								}
							}
							
						} else if(field == 'use_yn') {
							options.model.use_yn_nm = ddlItem.TEXT;
						}
					});
	            }

	            // 체크박스 editor
				$("#treelist").on("change", "input.chkbx", function(e) {
					var grid = $("#treelist").data("kendoGrid")
					       , dataItem = grid.dataItem($(e.target).closest("tr"))
						   , fieldName = $(e.target).closest("td").find("input").context.name;
		
					$(e.target).closest("td").prepend("<span class='k-dirty'></span>");
		
					if (this.checked) {
						dataItem[fieldName] = 'Y';
					} else {
						dataItem[fieldName] = 'N';
					}
					dataItem.dirty = true;
				});

		genexon.initKendoUI_grid_inlineEdit("#treelist", gridpt, ds);
	</script>
	<!-- 메뉴별 권한설정 영역 div end -->
</div>
</body> 
</html>