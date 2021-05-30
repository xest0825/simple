<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<html>
<head>
<script type="text/javascript">
$(document).ready(function() 
{
	$("#search_word").bind("change",  srch);
	$("#subtree").height($("#grid").height());
});

/**
 * 조회
 */
function srch()
{
	var grid = $("#grid").data("kendoGrid");
	var search_word = $("#search_word").val(); 
	grid.dataSource.read({search_word:search_word});
}

// 첨부파일 아이콘
function iconUploadEditor(container, options) {

	// LV2 메뉴만 아이콘을 지정
	if(options.model.lv == '2') {
		$('<input type="file" name="menu_icon" id="menu_icon" />').appendTo(
				container).kendoUpload(
				{
					multiple : false,
					async : {
						saveUrl : "/system/infoUrl.ajax",
						removeUrl : "/system/deleteUrl.ajax",
						autoUpload : true
					},
					remove : function(e) {
						e.data = {
							FILE_NO : options.model.menu_icon_no
						}
					},
					validation : {
						allowedExtensions : [ ".jpg", ".png" ]
					},
					showFileList : true,
					localization : {
						select : "선택",
						remove : "삭제",
						dropFilesHere : "18X18 사이즈",
						uploadSelectedFiles : "파일선택",
						statusUploading : "전송중",
						statusUploaded : "전송 완료",
						statusFailed : "전송 실패",
						headerStatusUploading : "파일 처리중",
						headerStatusUploaded : "완료"
					},
					success : function(data) {
						if (data.response.FILEVO != undefined) {
							options.model.set("menu_icon",
									data.response.FILEVO.FILE_URL);
							options.model.set("menu_icon_no",
									data.response.FILEVO.FILE_NO);
						} else {
							options.model.set("menu_icon",
							"/resources/images/gnx/logo.png");
						}
					}
				});
	} else {
		$('<span>현재 메뉴는 아이콘을 지정할 수 없습니다.</span>').appendTo(container);
	}
}

</script>

</head>
<body>
     <!-- Content //-->
    <div class="search">    
          <table class="se">
				<tr>
					<td><input type="text" class="k-textbox" name="search_word" id="search_word"  placeholder="메뉴ID/메뉴명" style="width: 600px" />
					<button class="k-primary btn_sty01" onclick="javascript:srch();" id="srch" name="srch">검색</button></td>                        
				</tr>   
          </table>                
   </div><!--// search -->	        
        
	<!--// 그리드 상단에 타이틀이 없을경우 간격조절라인 -->
	<hr style="display:block;height:20px;">
	
	<!-- grid start -->
	<div id="grid" class="resizegrid" style="float:left; width:75%; background-color:#fff;"></div>

	<script type="text/x-kendo-template" id="arrow-Template">
		#var lv = lv;#
		#for(var i=1; i < lv; i++){#
			　
		#}#
		<img src="/resources/images/common/menu_arrow.png" alt="메뉴" />&nbsp;#:resource_name#
	</script>
	
	<script  type="text/javascript">

		// 메뉴 아이콘
		var menuIconPic = "<img src=\"#=kendo.toString(menu_icon)#\" alt=\"메뉴 아이콘\" id=\"viewArea\" style=\"width:36px; height:36px; background:rgb(38, 39, 52);\" onerror=\"this.style.display='none'\" />";

		/**
		* 그룹코드 그리드 필드 정의
		**/
		var gridpt = 
		{
			 toolbar: [{name:"create",text:"추가"}]
			,columns:[
						
		{
				field : "resource_id",
				title : "메뉴ID",
				width : 60,
				attributes : {
					"class" : "col-center"
				}
			}, {
				field : "resource_name",
				title : "메뉴명",
				width : 130,
				attributes : {
					"class" : "col-left"
				},
				template : $("#arrow-Template").html()
			}, {
				field : "prnt_resource_id",
				title : "부모메뉴ID",
				width : 60,
				attributes : {
					"class" : "col-center"
				}
			}, {
				field : "resource_url",
				title : "리소스URL",
				width : 180,
				attributes : {
					"class" : "col-left"
				}
			}, {
				field : "resource_pattern",
				title : "리소스패턴",
				width : 170,
				attributes : {
					"class" : "col-left"
				}
			}, {
				field : "menu_icon",
				title : "메뉴아이콘",
				width : 80,
				attributes : {
					"class" : "col-center"
				},
				editor : iconUploadEditor,
				template : menuIconPic
			}, {
				field : "cls_resource_id",
				title : "마감그룹코드",
				template : "#=cls_resource_nm#",
				width : 70,
				attributes : {
					"class" : "col-center"
				},
				ddcode:"cl_step_cd",
				editor:genexon.GridEditor_ddl,
				values:{
						ddcode:"ERP_CL_STEP_CD",
						optionLabel : "- 선택 -"
						},
			}, {
				field : "menu_gbn_cd",
				title : "메뉴구분",
				template : "#=menu_gbn_nm#",
				width : 50,
				attributes : {
					"class" : "col-center"
				}
			}, {
				field : "bookmark_use_yn",
				title : "즐겨찾기 ",
				width : 55,
				attributes : {
					"class" : "col-center"
				}
			}, {
				field : "sort_no",
				title : "정렬순서",
				width : 55,
				attributes : {
					"class" : "col-right"
				}
			}, {
				command : {
					text : "수정",
					click : showDetails
				},
				title : " ",
				width : 80,
				attributes : {
					"class" : "col-center"
				}
			} ],
			editable : {
				mode : "popup",
				confirmation : "데이타가 삭제 됨니다. \n삭제하시겠습니까?",
				createAt : "top",
				window : {
					title : "메뉴관리",
					width : 500
				}

			},
			edit : function(e) {

				var updateButton = "<a class=\"k-button k-button-icontext k-grid-update\" href=\"#\"><span class=\"k-icon k-update\"></span>저장</a>";
				var deleteButton = "<a class=\"k-button k-button-icontext k-grid-delete\" href=\"javascript:gridRemoveRow();\"><span class=\"k-icon k-delete\"></span>삭제</a>";
				var cancelButton = "<a class=\"k-button k-button-icontext k-grid-cancel\" href=\"#\"><span class=\"k-icon k-cancel\"></span>취소</a>";

				var buttonDiv = e.container.find("div .k-edit-buttons");
				buttonDiv.html("");
				buttonDiv.append(updateButton);

				var resource_url = e.container.find("input[name=resource_url]");
				var resource_name = e.container.find("input[name=resource_name]");
				var resource_pattern = e.container.find("input[name=resource_pattern]");
				var detail = e.container.find(".k-edit-buttons");
				
				var bookmark_use_yn = e.container.find("input[name=bookmark_use_yn]");
				bookmark_use_yn.attr("class", "kddl");
				bookmark_use_yn.attr("ddcode", "USE_YN");
				bookmark_use_yn.attr("optionLabel", "- 선택 -");
				genexon.initKendoUI_ddl(bookmark_use_yn);
				
				var menu_gbn_cd = e.container.find("input[name=menu_gbn_cd]");
				menu_gbn_cd.attr("class", "kddl");
				menu_gbn_cd.attr("ddcode", "MENU_GBN_CD");
				menu_gbn_cd.attr("optionLabel", "- 선택 -");
				genexon.initKendoUI_ddl(menu_gbn_cd);

				resource_url.css("width", 280);
				resource_name.css("width", 280);
				resource_pattern.css("width", 280);
				detail.css("width", 480);

				if (!e.model.isNew()) {
					var resource_id = e.container.find("input[name=resource_id]");
					resource_id.prop("disabled", true);
					resource_id.addClass("k-state-disabled");
					buttonDiv.append(deleteButton);
				}

				buttonDiv.append(cancelButton);

			},
			pageable : true,
			dataBound : function() {
			}

		};

		/**
		 * 데이터 소스설정
		 * 그룹코드 그리드 url 및 스키마모델 정의
		 **/
		var ds = {
			transport : {
				/*read    : {url: "/menu/getResourcesList.ajax"}
				,update  : {url: "/menu/updateMenu.ajax",dataType: "json",type: "POST",data:{"${_csrf.parameterName}" : "${_csrf.token}"}} 
				,destroy : {url: "/menu/deleteMenu.ajax",dataType: "json",type: "POST",data:{"${_csrf.parameterName}" : "${_csrf.token}"}} 
				,create  : {url: "/menu/insertMenu.ajax",dataType: "json",type: "POST",data:{"${_csrf.parameterName}" : "${_csrf.token}"}}*/
				read : {
					url : "/menu/getResourcesList.ajax?${_csrf.parameterName}=${_csrf.token}"
				},
				update : {
					url : "/menu/updateResources.ajax?${_csrf.parameterName}=${_csrf.token}"
				},
				destroy : {
					url : "/menu/deleteResources.ajax?${_csrf.parameterName}=${_csrf.token}"
				},
				create : {
					url : "/menu/insertResources.ajax?${_csrf.parameterName}=${_csrf.token}"
				}
			},
			schema : {
				data : "results",
				model : {
					id : "resource_id",
					fields : {
						lv : {},
						resource_id : {
							validation : {
								required : true,
								validationMessage : "필수항목"
							}
						},
						resource_name : {
							validation : {
								required : true,
								validationMessage : "필수항목"
							}
						},
						prnt_resource_id : {},
						cls_resource_id : {},
						cls_resource_nm : {},
						menu_gbn_cd : {
							validation : {
								required : true,
								validationMessage : "필수항목"
							}
						},
						menu_gbn_nm : {},
						resource_url : {
							validation : {
								required : true,
								validationMessage : "필수항목"
							}
						},
						resource_pattern : {
							validation : {
								required : true,
								validationMessage : "필수항목"
							}
						},
						bookmark_use_yn : {
							validation : {
								required : true,
								validationMessage : "필수항목"
							}
						},
						sort_no : {
							type : "number",
							validation : {
								required : true,
								min : 1,
								max : 999,
								validationMessage : "1~999허용"
							}
						},
						menu_icon_no : {},
						menu_icon : {}
					}
				}
			},
			batch : true,
			requestEnd : function(e) {
				if (e.type != undefined && e.type != "read") {
					srch();

				}
				treeds.read();
			}
		};

		/**
		 *인라인 그리드 생성
		 **/
		genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);
		$(".k-hierarchy-cell.k-header").text("맵");

		/**
		 *인라인 그리드 리드
		 **/
		var grid = $("#grid").data("kendoGrid");
		grid.dataSource.read();

		function showDetails(arg) {
			var tr = $(event.target).closest("tr");
			grid.select(tr);
			grid.editRow(tr);
		}

		function gridRemoveRow() {
			var grid = $("#grid").data("kendoGrid");
			var row = grid.select();

			grid.removeRow(row);
		}
     	

     
	</script>
	<!-- grid end -->
	
	<!-- tree start -->
	<div  id="subtree"  style="float:right; width:22%; /* min-width:250px;  */background-color:#f8f8f8;border:1px solid #dddddd; padding:10px 2px 5px 5px;overflow-y:scroll ;margin-top:30px;"></div>    
	<script  type="text/javascript">
	var treeds = new kendo.data.HierarchicalDataSource(
		{
			transport: 
			{
				read:
				{
					url: "/menu/getChildrenResourcesList.ajax",
					dataType: "json",
					type: "POST",data:{"${_csrf.parameterName}" : "${_csrf.token}"}
				}
		        
			},
			schema:
			{
			    data : "results"
			   ,model:
				{
					id: "resource_id",
					hasChildren: "ISLEAF_OUT"
				}
			}
		});

		$("#subtree").kendoTreeView(
		{
			loadOnDemand: true,
			dataSource: treeds,
			dataTextField: "resource_name"
		});
		
	</script>
	<!-- tree end -->
</body> 
</html>