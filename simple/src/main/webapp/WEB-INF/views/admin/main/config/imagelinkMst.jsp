<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 29
	화면 설명 : 메인화면설정 > 이미지 링크 유형 설정
######################################################################################### 
 -->
<html>
<head>
<script type="text/javascript">
$(document).ready(function(e){
	srch();
});

function srch() {
	var grid = $("#grid").data("kendoGrid");
	
	grid.dataSource.read({
		json_string : genexon.getSearchParameterToJsonString()
	});
	grid.pager.page(1);
}

function goRegiPop(e) {
	var seq = "";
	var title = "";
	
	var selectedItem = null;
	
	if(e != undefined) {
		selectedItem = this.dataItem($(e.target).closest("tr"));
		seq = selectedItem.seq;
		title = "이미지 링크 유형 수정";
	}else {
		title = "이미지 링크 유형 추가";
	}
	
	genexon.PopWindowOpen({
		pID : "imagelinkRegiPop",
		pTitle: title,
		pURL : "/main/config/imagelinkRegi.pop?${_csrf.parameterName}=${_csrf.token}",
		data : {
			seq: seq
		},
		pWidth : "40%",
		pHeight : "60%",
		pModal : true,
		resizeable : true,
		maximize: false,
		callbackFunc: srch
	});
}
</script>
</head>
<body>
	<div class="search">
		<table class="se">
			<tr>
				<td>
					<input type="text" class="k-textbox" name="search_word" id="search_word" style="width: 150px;" placeholder="보드제목">&nbsp;
					<button type="button" class="k-primary btn_sty02" onclick="javascript:srch();">조회</button>
       			</td>
       		</tr>
		</table>
	</div><!--// search -->
	
	<hr style="display:block; height:5px;"><!--// 그리드 상단에 타이틀이 없을경우 간격조절라인 -->
	
	<div class="bt_right">
		<button type="button" class="bt_orange_S" onclick="javascript:goRegiPop();">추가</button>
	</div>
       
	<hr style="display:block; height:5px;"><!--// 그리드 상단에 타이틀이 없을경우 간격조절라인 -->
	
	<div id="grid" class="resizegrid" style="background-color:#fff; width:100%;"></div>
       <script type="text/javascript">
		var dataSource = {
			transport: {
				read  : {
					url: "/main/config/getImagelinkMstList.ajax?${_csrf.parameterName}=${_csrf.token}"
				},
				destroy : {
					url: "/main/config/deleteImagelinkMstList.ajax?${_csrf.parameterName}=${_csrf.token}"
				},
				data: function() {
					return {
						json_string : genexon.getSearchParameterToJsonString()
					}
				}
			},
			schema: {
				model: {
					id:"seq",
					fields: {
						mb_id : {},
						seq : {},
						title : {},
						image_link_type : {},
						image_link_type_nm : {}
	   				}
	   			}
	   		}
		};
	                
	    var gridpt = {
	    		columns: [
	    			{
	    				field: "seq",
	    				title: "번호",
	    				width: 80
	    			},
	    			{
	    				field: "title",
	    				title: "이미지 보드 제목",
	    				width: 80
	    			},
	    			{
	    				field: "image_link_type_nm",
	    				title: "이미지 보드 유형",
	    				width: 80
	    			},
	    			{
	    				title: "변경",
	    				command: [
	    					{ name: "edit", text: "수정", click: goRegiPop },
	    					{ name: "Delete", text: "삭제", 	click: function(e) {genexon.deleteConfirm(e);}}
	    				],
	    				width: 200
	    			}
	    		],
				pageable: true
	    };
	    
	    //kendo grid셋팅
	    genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, dataSource);
	</script>
</body>
</html>