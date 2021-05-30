<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 04. 25
	화면 설명 : 액션 로그 조회 페이지
######################################################################################### 
 -->
<html>
<head>
<script type="text/javascript">
$(document).ready(function(e){
	$(window).resize(function() {
		$("div.search").css("max-width", "none");
		$("div.search").css("width", "100%");
	});
	
	/******* 버튼 및 dropDown 이벤트 ******/
	//조회
 	$('#search').bind('click', function(e){
 		srch();
 	});
	
	//날짜검색 datePicker 및 마스킹처리
	//시작일자
	$("#srch_term_start_value").kendoDatePicker();
 	$('#srch_term_start_value').kendoMaskedTextBox({
		mask : "0000-00-00"
	});
 	
 	//종료일자
 	$("#srch_term_end_value").kendoDatePicker();
 	$('#srch_term_end_value').kendoMaskedTextBox({
		mask : "0000-00-00"
	});
 	
 	//최초 로딩 시 시작일자 종료일자에 당월 1일, 당월 당일 날짜 세팅
 	$("#srch_term_start_value").val(genexon.getYyyymm(new Date(), "-")+"-"+"01");
 	$("#srch_term_end_value").val(genexon.getYymmdd(new Date(), "-"));
 	
 	//시작일자 종료일자 관련
 	genexon.compareSrchTerm("srch_term_start_value", "srch_term_end_value")
 	
 	//화면 최초 로딩 시 조회
 	srch();
});

function srch(){
	var grid = $("#grid").data("kendoGrid");
	
	grid.dataSource.options.transport.read.data = {
    	json_string : genexon.getSearchParameterToJsonString()
	};
    
    grid.pager.page(1);
}
</script>
</head>
<body>
	<input type="hidden" name="sort_column" id="sort_column" value="seq desc"/>
	<div class="search" style="width: 100%;">
		<table class="se">
			<tr>
				<td>				
					<input type="text" class="k-textbox" name="srch_emp_value" id="srch_emp_value" style="width: 200px;" onKeyPress="if(event.keyCode==13)srch();" placeholder="이름/사번" />
			
					<input type="text" id="srch_term_start_value" name="srch_term_start_value" style="width: 150px;" /> ~ 
					<input type="text" id="srch_term_end_value" name="srch_term_end_value" style="width: 150px;" />
									
					<button class="k-primary btn_sty02" id="search">조회</button>
				</td>
			</tr>
		</table>
	</div>
	
	<!--// 그리드 상단에 타이틀이 없을경우 간격조절라인 -->
	<hr style="display:block; height:20px; ">
	
	<div id="grid" class="resizegrid"></div>
	<script type="text/javascript">
		/**
		 * 데이터 소스설정
		 * 그룹코드 그리드 url 및 스키마모델 정의
		 **/
		 //인사발령관리
		var ds = {
			transport : {
				read : {
					url : "/logs/getErrorLogList.ajax?${_csrf.parameterName}=${_csrf.token}",
					data: function() {
						return {
							json_string : genexon.getSearchParameterToJsonString()
						}
					}
				}
			},
			schema : {
				model : {
					fields : {
						mb_id: {},
						seq: {},
						emp_cd: {},
						error_url: {},
						error_query_string: {},
						error_status: {},
						error_class: {},
						error_msg: {},
						error_trace: {},
						error_ip: {},
						in_dtm: {}
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
		//인사발령관리
		var gridpt = {
			columns : [
				{
					field : "seq",
					title : "번호",
					width : 80,
				},
				{
					field : "emp_cd",
					title : "이름",
					width : 200,
					template: function(e) {
						var emp_cd = e.emp_cd;
						var emp_nm = e.emp_nm;
						
						if(genexon.nvl(emp_cd, "") == "" || genexon.nvl(emp_cd, "") == null) {
							return "";
						}else {
							return genexon.nvl(emp_nm, "")+"("+genexon.nvl(emp_cd, "")+")";
						}
					}
				},
				{
					field : "snmpath",
					title : "소속",
					width : 300,
					attributes : {
						style : "text-align : center;"
					}
				},
				{
					field: "error_url",
					title: "에러 URL",
					width: 200
				},
				{
					field: "error_query_string",
					title: "전달 파라미터",
					width: 150,
					attributes : {"style" : "overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"},
					hidden: true
				},
				{
					field: "error_status",
					title: "에러 상태 코드",
					width: 100
				},
				{
					field: "error_class",
					title: "에러 발생 클래스",
					width: 100,
					attributes : {"style" : "overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"},
					hidden: true
				},
				{
					field: "error_trace",
					title: "에러 추적 메세지",
					width: 150,
					attributes : {"style" : "overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"},
					hidden: true
				},
				{
					field: "in_dtm",
					title: "입력 시간",
					width: 250
				},
				{
					field: "error_ip",
					title: "아이피",
					width: 150,
					template: function(e) {
						var error_ip_arr = e.error_ip.split(".");
						
						return error_ip_arr[0] + "." + error_ip_arr[1] + "." + "*.*";
					}
				}
			],
			pageable : true,
			dataBound: function (e) {
				var gridId = e.sender.element.context.id;
				//gridContentIncision(gridId,20);
			}
		};
		
		genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds);
	</script>
</body>
</html>