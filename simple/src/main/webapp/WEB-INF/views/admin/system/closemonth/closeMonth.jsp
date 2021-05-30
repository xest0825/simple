<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 : yumi.jeon
	최초작성일자 : 2019. 04. 24
	화면 설명 : ERP마감관리
######################################################################################### 
 -->
<html>
<head>
<script type="text/javascript">

$(document).ready(function() {
	$("#srch_com_ym").data("kendoDropDownList").bind("dataBound", srch); //화면 최초로딩시 조회처리
	$("#srch_com_ym").data("kendoDropDownList").bind("change", srch);
});

/**
 * 조회
 */
function srch() {
	var grid = $("#grid").data("kendoGrid");
	
	grid.dataSource.read({
		com_ym : $("#srch_com_ym").val()
	});
}

//마감월 생성
function createMonth() {
	genexon.confirm("마감월 생성", "마감월 생성을 수행합니다.\r\n진행하시겠습니까?", function(result) {
		if(result) {
			var ds = genexon.initKendoUI_dataSource ({
				mode:"CRUD"
                ,transport:{
					create: {url: "/system/closemonth/callCreatemonth.ajax?${_csrf.parameterName}=${_csrf.token}"}
				},
				schema: {
					data : "results",
					model: {
						id: "com_ym",
						fields: {
							com_ym: {}
                			,cl_step_cd: {}
						}
					}
				},
				sync:function(e) {
					$(".t_sel" , parent.document).find('.t_rel_sel').click();
					genexon.alert("info", "마감월 생성", "마감월 생성을 완료하였습니다.");
				},
				requestStart: function(e) {
					kendo.ui.progress($("body"), true);
				},
				requestEnd: function(e) {
					kendo.ui.progress($("body"), false);
				}
			});

			
			ds.add(new kendo.data.Model({
				com_ym : $("#srch_com_ym").val()
			}));
			
			ds.sync();
		}
	});
}

//해당 마감 관련 페이지 이동
function movePage(cls_resource_id){
	$.ajax({
		 url :"/menu/getResourcesView.ajax?${_csrf.parameterName}=${_csrf.token}" 
		,data : { resource_id : cls_resource_id }
		,success:function(data){
			var rsc = data.result;
			parent.addTab(rsc.resource_id, rsc.resource_name, rsc.resource_url, rsc.menu_path);
		}
	    ,error: function(xhr,status, error){
	    	genexon.alert("error", "", "에러발생");
	    }
	}); // end ajax
}
</script>
</head>
<body>
     <!-- Content //-->
     <div class="search">    
            <table class="se">
				<tr>
					<td>
						<input type="text" class="kddl" name="srch_com_ym" id="srch_com_ym" ddcode="SY_COM_YM" condDt="search_word:ERP_COM_YM" style="width: 150px" />
                    </td>
                    <c:if test="${menuRole.role_id eq 'ROLE_0' }">
                    	<!-- 앞으로 마감월 생성은 sum계정만 가능하도록하고 이외의 마감월 생성은 스케쥴러에서 생성하는걸로 변경 20.01.22 KIMDONGUK-->
	                    <td>
							<button type="button" class="kbtn k-primary" onclick="javascript:createMonth();">마감월 생성</button>
						</td>
					</c:if>
              </tr>
            </table>
     </div><!--// search -->
     	        
   <!--// 그리드 상단에 타이틀이 없을경우 간격조절라인 -->
    <hr style="display:block;height:20px;">
   
	<!-- grid start -->
	<div id="grid" class="resizegrid" style="height:630px; background-color:#fff; "></div>
	<script  type="text/javascript">

	    /**
	     * 데이터 소스설정
	     * 그룹코드 그리드 url 및 스키마모델 정의
	     **/
	    var ds  =  {
	        transport: {
	        	read    : {url: "/system/closeMonth/getCloseMonthList.ajax?${_csrf.parameterName}=${_csrf.token}"},
	        	update    : {url: "/system/closeMonth/updateCloseMonth.ajax?${_csrf.parameterName}=${_csrf.token}"}
	        },
	        schema: {
	        	model: {
	        		id: "cl_step_cd",
	        		fields: {
	        			com_ym: {editable: false, validation: {required: true, validationMessage:"필수항목"}},
	        			cl_step_cd: {editable: false, validation: {required: true, validationMessage:"필수항목"}},
	        			cl_state_cd: {validation: {required: true, validationMessage:"필수항목"}},
	        			cl_step_nm: {editable: false},
	        			cl_state_nm: {editable: false},
	        			up_dtm: {editable: false},
	        			close_state_dtm: {editable: false},
	        			mb_id: {editable: false},
	        			cls_resource_id: {editable: false}
	        		}
	        	}
	        },
	        batch: true,
	        requestEnd: function(e) {
	        	if(e.type != undefined && e.type != "read") {
			        srch();
			    }
			}
	    };
	    
		/**
		* 그룹코드 그리드 필드 정의
		**/
		var gridpt = {
				columns:[
					{
						field: "com_ym",
						title: "마감월"
					},
					{
						field: "cl_step_cd",
						template:"<a href='javascript:;' onclick='movePage(\"#=cls_resource_id#\");'>[#=cl_step_cd#] #=cl_step_nm#</a>",
						title: "마감항목"
					},
					{
						field: "cl_state_cd",
						template:"[#=cl_state_cd#] #=cl_state_nm#",
						ddcode:"cl_state_cd",
						editor:genexon.GridEditor_ddl,
						values:{ddcode:"ERP_CL_STATE_CD"},
						title: "마감상태"
					},
					{
						field: "up_dtm",
						template:"#=up_dtm# (#=up_emp_cd#)",
						title: "마감변경시간"
					},
					{
						field: "close_state_dtm",
						template:"#if(close_state_dtm!=null){# #=close_state_dtm# (#=close_state_emp_cd#)#}#",
						title: "마감완료시간"
					},
					{
						command: [{ name: "close", text: "마감", iconClass: "none", className:"closeTd", click : onClose },
									{ name: "edit", text: "수정", iconClass: "none" }],
						title: "관리",
						width: 150,
						attributes:{"class" : "col-center"}
					}
				],
				editable: {
					mode:"popup",
					window :{title:"마감관리"}
				},
				edit: function(e) {
			    
			            var updateButton = "<a class=\"k-button k-button-icontext k-grid-update\" href=\"#\"><span class=\"k-icon k-update\"></span>저장</a>";
			            var cancelButton = "<a class=\"k-button k-button-icontext k-grid-cancel\" href=\"#\"><span class=\"k-icon k-cancel\"></span>취소</a>";
			     
			            var buttonDiv = e.container.find("div .k-edit-buttons");
			            buttonDiv.html("");
			            buttonDiv.append(updateButton); 
			            
			            if (!e.model.isNew())
			            {
			                var COM_YM = e.container.find("input[name=com_ym]");
			                COM_YM.prop("disabled",true);
			                COM_YM.addClass("k-state-disabled");
			                
			                
			                var CL_STEP_CD = e.container.find("input[name=cl_step_cd]");
			                CL_STEP_CD.prop("disabled",true);
			                CL_STEP_CD.addClass("k-state-disabled");
			                
			                var UP_DTM = e.container.find("input[name=up_dtm]");
			                UP_DTM.prop("disabled",true);
			                UP_DTM.addClass("k-state-disabled");
			                
			                
			                var CLOSE_STSTE_DTM = e.container.find("input[name=close_state_dtm]");
			                CLOSE_STSTE_DTM.prop("disabled",true);
			                CLOSE_STSTE_DTM.addClass("k-state-disabled");
			            }
			            
			            buttonDiv.append(cancelButton); 
			            
			},
			dataBound: function (e) {
				this.dataItem(this.select());
				e.sender.tbody.find("tr").each(function(idx, element){
					if($(this).find("td").eq(2).text().indexOf('CLS')>-1){						
						$(this).find(".k-button.closeTd").remove();
					}
				})
			},
			pageable: true
		};

        
        /**
        *그리드 생성
        **/
    	genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);
        
    	// 마감
    	function onClose(e){
   			var selectedItem =this.dataItem($(e.target).closest("tr"));
   		  	
   		 	// 직전달까지만 마감이 가능하도록
   			var date = new Date();
   			date.setMonth(date.getMonth()-1);
   			var year = date.getFullYear();
   			var month = date.getMonth()+1;
   			var preMonth = year + '' + (month < 10 ? "0"+month : month);

   			/* if(preMonth>$("#srch_com_ym").val()){
   				genexon.alert("error", "마감오류", "이전달까지만 마감이 가능합니다.");
   			}else{ */
   				var title = selectedItem.cl_step_nm;
   				var table_type = selectedItem.cl_step_cd;
   				
   				genexon.confirm(title +" 재적용", "["+$("#srch_com_ym").val()+"] 업적년월 " + title + " 데이타가 삭제 됩니다!<br><br>재적용 하시겠습니까?", function(result) {
	   				if(result){
	   			        var ds = genexon.initKendoUI_dataSource ({
	   			        	mode:"CRUD",
	   			        	transport:{create: {url: "/system/closemonth/insertcopymonth.ajax?${_csrf.parameterName}=${_csrf.token}"} },
	   			        	schema: {
	   			        		data : "results",
	   			        		model: {
	   			        			id: "com_ym",
	   			        			fields: {
	   			        				com_ym: {},
	   			        				cl_step_cd: {}
	   			        			}
	   			        		}
	   			        	},
	   			        	sync:function(e){
	   			        		genexon.alert("info",title+" 재적용", "정상적으로 재적용되었습니다.");
	   			        		srch();
	   			        	},
	   			        	requestStart:function(e){kendo.ui.progress($("body"), true);},
	   			        	requestEnd:function(e){kendo.ui.progress($("body"), false);}
						});
	   			        
	   			        ds.add(new kendo.data.Model({com_ym:$("#srch_com_ym").val(),table_type:table_type}));
	   			        ds.sync();
	   			    }
   				});	
   			//}
    	} 
	</script>
	<!-- grid end -->   
</body> 
</html>