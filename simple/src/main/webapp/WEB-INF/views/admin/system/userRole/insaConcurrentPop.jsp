<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 : lakhyun.kim
	최초작성일자 : 2019. 03. 27
	화면 설명 : 인사수정 > 겸직조회 팝업
######################################################################################### 
 -->
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<script type="text/javascript">
$(document).ready(function(){
	srch();
});

function srch() {
	var grid = $("#grid").data("kendoGrid");
	grid.dataSource.read({
		emp_cd : $("#emp_cd").val()
	});
}

// 겸직정보 저장
function updateUserRole() {
	
	genexon.confirm("확인창", "겸직정보를 저장하시겠습니까?", function(result) {
		if(result){
			var grid = $("#grid").data("kendoGrid")
			  , parameterMap = grid.dataSource.transport.parameterMap;
			
			var currentData = grid.dataSource.data();
			var updatedRecords = [];
			var newRecords = [];
			
			for (var i = 0; i < currentData.length; i++) {
				if (currentData[i].isNew()) {
					// 새로운 row
					newRecords.push(currentData[i].toJSON());
				} else if (currentData[i].dirty) {
					// 수정 row
					updatedRecords.push(currentData[i].toJSON());
				}
			}
			
			// 삭제 row
			var deletedRecords = [];
			for (var i = 0; i < grid.dataSource._destroyed.length; i++) {
				deletedRecords.push(grid.dataSource._destroyed[i].toJSON());
			}
			
			var data = {};
			$.extend(data, parameterMap({ updated : updatedRecords }));

			$.ajax({
				url : "/userRole/updateUserRole.ajax?${_csrf.parameterName}=${_csrf.token}",
				data : genexon.getJSONString(data),
				type : "POST",
				contentType : "application/json;charset=UTF-8",
				dataType : 'json',
				error : function() {
					genexon.alert("error", "결과", "저장중 에러가 발생했습니다.");
				},
				success : function() {
					alert("정상처리되었습니다.");
		
					grid.dataSource._destroyed = [];
					grid.dataSource.read({
						emp_cd : $("#emp_cd").val()
					});
				}
			});
		}
	});
}
</script>
</head>
<body>
  <input type="hidden" id="emp_cd" name="emp_cd" value ="${UserRoleVO.emp_cd}" /> 
  
	<div class="content">
		<div class="bg_con">
			<div id="grid" class="resizegrid"></div>
			
			<div class="bt_right" style="display: inline-block;">
				<div class="bt_glay2_S" onclick="javascript:genexon.PopWindowClose2('#insa_ConcurrentPop');">취소</div>
				<div class="bt_glay2_S" onclick="javascript:updateUserRole();">저장</div>
			</div>
		</div>
	</div>
    <script  type="text/javascript">
        
   	var gridpt = {
               columns:[
            	   	    {field: "concurrent_idx", title: "겸직구분", width: 120, hidden : true}
            	   	   ,{field: "emp_cd", title: "사원코드", width: 120, hidden : true}
            	   	   ,{field: "scd", title: "조직코드", width: 120, hidden : true}
                       ,{field: "emp_nm", title: "사원명", width: 120,
                    	   template : function(e) {
	  							var emp_cd = e.emp_cd;
	   							var emp_nm = e.emp_nm;
	   							
	   							if(genexon.nvl(emp_cd, "") != "" && genexon.nvl(emp_cd, "") != null) {
	   								return genexon.nvl(e.emp_nm, "")+"("+genexon.nvl(e.emp_cd, "")+")";
	   							}else {
	   								return "";
								}
							} 
                       }
                       ,{field: "snmpath", title: "소속",width: 260
                          , attributes :{
                  			style : "text-align : left; padding-left : 10px;"
                  			}
                       	}
                       ,{field: "jikchk", title: "직책", width: 120, editor: dropDownListEditor}
                       ,{field: "jikgub", title: "직급", width: 120, editor: dropDownListEditor}
                       ,{field: "role_id", title: "권한", width: 120, template : "#=role_nm#", editor: dropDownListEditor}
                       ]
			,pageable: false
			,editable: true
			,dataBound : function(e){
				var gridId = e.sender.element.context.id;
				//gridContentIncision(gridId,20);
				// 주 권한 제외
                e.sender.tbody.find("tr").each(function(idx, element) {
                    if( $(this).children().first().text() == '1'){
                    	$(this).remove();
                    }
                })
			},
   		};

   	var ds  =  {
   	        transport: {
   	        	read: {url:"/userRole/getUserRoleList.ajax?${_csrf.parameterName}=${_csrf.token}",
   	        			data :{
   	        				emp_cd : $("#emp_cd").val()
   	        			}
   	        	}
   	        },
	 		batch: true,
	 		schema: {
	 			data : "results",
	 			model: {
	 				id: "emp_cd",
	 				fields: {
	 					  emp_cd : {}
	 				    , concurrent_idx : {}
	 				    , scd : {}
	 					, emp_nm : {editable: false}
	 					, snmpath : {editable: false}
	 					, jikchk : {}
	 					, jikgub : {}
	 					, role_nm : {}
	 					, role_id : {}
	 				}
	 			}
	 		}
   	    };

    // dropDownList editor
    function dropDownListEditor(container, options) {
    	
    	var field = options.field
    	$('<input required type="text" name="' + field + '" class="kddl" ddcode="' + field + '" />').appendTo(container);
    	
    	var input = container.find("input[name='" + field + "']");
		genexon.initKendoUI_ddl(input);
		
		input.data("kendoDropDownList").bind('change', function(e) {
			var ddlItem = this.dataItem();
			
			if(field == 'jikchk') {
				options.model.jikchk = ddlItem.TEXT;
			} else if(field == 'jikgub') {
				options.model.jikgub = ddlItem.TEXT;
			} else if(field == 'role_id') {
				options.model.role_nm = ddlItem.role_nm;
			}
		});
    }
    
   	genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);
	</script>
</body> 
</html>