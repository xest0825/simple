<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!--
#########################################################################################
	작성자 :  lakhyun.kim
	최초작성일자 : 2019.03.21
	화면 설명 :  게시판 관리
######################################################################################### 
 -->
<html>
<head>
<style>
.auth_listView_header{
	margin-top:5px;
}
.k-tabstrip-items .k-link, .k-panelbar .k-tabstrip-items .k-link {
    display: inline-block;
    border-bottom-width: 0;
    padding: .0em .92em;
    height: 20px;
}
input[type=checkbox]
{
  /* Double-sized Checkboxes */
  -ms-transform: scale(1.5); /* IE */
  -moz-transform: scale(1.5); /* FF */
  -webkit-transform: scale(1.5); /* Safari and Chrome */
  -o-transform: scale(1.5); /* Opera */
  padding: 8px;
}
</style>
<script type="text/javascript">
$(document).ready(function(){
	srch();
	
	// 설정 저장
    $('#bt_save').click(function(){
    	save();
    });
	
	// ajax 배열 넘길때 넣어줌
    jQuery.ajaxSettings.traditional = true;
 	
 	$('#bt_search').bind('click', function(e){
 		srch()
 	})
 	
    $("#tabstrip").kendoTabStrip({
        animation:  {
            open: {
                effects: "fadeIn"
            }
        }
    });
 	
	// 상세보기 권한 추가
	$("#btnAddViewAutr").click(function(){
		$("#viewAutrGroup").copyOptions("#viewAutr","selected");
		$("#viewAutrGroup").removeOption(/./, true);
	}).css("cursor","pointer");
	// 상세보기 권한 삭제
	$("#btnRemoveViewAutr").click(function(){
		$("#viewAutr").copyOptions("#viewAutrGroup","selected");
		$("#viewAutr").removeOption(/./, true);
	}).css("cursor","pointer");
	
	// 글쓰기 권한 추가
	$("#btnAddWriteAutr").click(function(){
		$("#writeAutrGroup").copyOptions("#writeAutr","selected");
		$("#writeAutrGroup").removeOption(/./, true);
	}).css("cursor","pointer");
	// 글쓰기 권한 삭제
	$("#btnRemoveWriteAutr").click(function(){
		$("#writeAutr").copyOptions("#writeAutrGroup","selected");
		$("#writeAutr").removeOption(/./, true);
	}).css("cursor","pointer");
	
	// 수정삭제 권한 추가
	$("#btnAddModifyAutr").click(function(){
		$("#modifyAutrGroup").copyOptions("#modifyAutr","selected");
		$("#modifyAutrGroup").removeOption(/./, true);
	}).css("cursor","pointer");
	// 수정삭제 권한 삭제
	$("#btnRemoveModifyAutr").click(function(){
		$("#modifyAutr").copyOptions("#modifyAutrGroup","selected");
		$("#modifyAutr").removeOption(/./, true);
	}).css("cursor","pointer");
	
	// 삭제 권한 추가
	$("#btnAddDeleteAutr").click(function(){
		$("#deleteAutrGroup").copyOptions("#deleteAutr","selected");
		$("#deleteAutrGroup").removeOption(/./, true);
	}).css("cursor","pointer");
	// 삭제 권한 삭제
	$("#btnRemoveDeleteAutr").click(function(){
		$("#deleteAutr").copyOptions("#deleteAutrGroup","selected");
		$("#deleteAutr").removeOption(/./, true);
	}).css("cursor","pointer");
 	

});
	
// 조회
function srch() {

	var grid = $("#grid").data("kendoGrid");

	 
	grid.dataSource.read({
		  use_yn : $('#use_yn').val()
		, folder_type : $("#folder_type").val()
		, search_word : $("#search_word").val()
	});
	
	
}

// 저장
function save() {
    	
    if($("#board_no").val() == "") {
    	genexon.alert("error", "저장 전 확인", "게시판을 클릭해주세요");
    	return;
    }

	$('select[name="viewAutr"] option').prop("selected", true);
	$('select[name="writeAutr"] option').prop("selected", true);
	$('select[name="modifyAutr"] option').prop("selected", true);
	$('select[name="deleteAutr"] option').prop("selected", true);
	    
   	$.ajax({
		 url :"/system/boardmanagement/insertBoardConfig.ajax?${_csrf.parameterName}=${_csrf.token}" // 게시판 설정 저장
		,type:"POST"
		,data:{
  			board_no : $("#board_no").val(),
  			// 게시판 설정
			apnd_use_type : $("input:checkbox[id='apnd_use_type']").is(":checked")?"Y":"N",
			atch_file_use_type : $("input:checkbox[id='atch_file_use_type']").is(":checked")?"Y":"N",
			share_sns_use_type : $("input:checkbox[id='share_sns_use_type']").is(":checked")?"Y":"N",
			/* sidelink_use_type : $("input:checkbox[id='sidelink_use_type']").is(":checked")?"Y":"N", */
			nw_bult_appt_prid : $("input[id='nw_bult_appt_prid']").val(),
			/* dsp_main_type :$("input:checkbox[id='dsp_main_type']").is(":checked")?"Y":"N",
	    	dsp_main_position : $("select[id='dsp_main_position']").val(), */
	    	// 권한 설정
	    	writeAutr : $('select[name="writeAutr"]').val() == null ? "" : $('select[name="writeAutr"]').val(),
	    	modifyAutr : $('select[name="modifyAutr"]').val() == null ? "" : $('select[name="modifyAutr"]').val(),
	    	viewAutr : $('select[name="viewAutr"]').val() == null ? "" : $('select[name="viewAutr"]').val(),
	    	deleteAutr : $('select[name="deleteAutr"]').val() == null ? "" : $('select[name="deleteAutr"]').val()
		}
		,dataType:"json"
		,success : function(response){
				genexon.alert("success", "", "정상 처리되었습니다.");
				location.reload(); 
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});
}

// 등록
function goRegi(e) {
	var selectedItem = null;
	if (e != undefined) {
		selectedItem = this.dataItem($(e.target).closest("tr"));
	}//end if


	if (selectedItem != null) {
		parent.addTab('AD_410_' + selectedItem.board_no, '게시판 설정',
				'/board/boardRegi.go?board_no=' + (selectedItem.board_no),
				'시스템 관리 > 게시판 관리 > 게시판 설정');
	} else {
		parent.addTab('AD_410_0', '게시판 설정',
				'/board/boardRegi.go',
				'시스템 관리 > 게시판 관리 > 게시판 설정');
	}
}

function onDelete(e) {
	if (genexon.confirm("삭제하시겠습니까?")) {
		var selectedItem = this.dataItem($(e.target).closest("tr"));
		var grid = $("#grid").data("kendoGrid").dataSource;
		grid.remove(selectedItem);
		grid.sync();
	}
}// end of onDelete()

// 추가 버튼실행시 실행
function gridAddRow(e) {
	var selectedItem = this.dataItem($(e.target).closest("tr"));
	var parent_board_no = selectedItem.board_no;
	var grid = $("#grid").data("kendoGrid");
	grid.addRow();
	var firstItem = $('#grid').data().kendoGrid.dataSource.data()[0];
	firstItem.set('parent_board_no',parent_board_no);
	
}

function getBoardInfo(paramJ){
	 $.ajax({
		 url :"/board/board/getBoardInfo.ajax?${_csrf.parameterName}=${_csrf.token}" 
        ,data: paramJ
		,success:function(data){//
			onInit(data);
		}
	    ,error: function(xhr,status, error){
	    	genexon.alert("error", "", "에러발생");

	    }
	});
}

$.fn.copyOptions = function(to, which)
{
	var w = which || "selected";
	if($(to).size() == 0) return this;
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return this;
			var o = this.options;
			var oL = o.length;
			for(var i = 0; i<oL; i++)
			{
				if(w == "all" || (w == "selected" && o[i].selected))
				{
					$(to).addOption(o[i].value, o[i].text);
				}
			}
		}
	);
	return this;
};

$.fn.removeOption = function()
{
	var a = arguments;
	if(a.length == 0) return this;
	var ta = typeof(a[0]);
	var v, index;
	// has to be a string or regular expression (object in IE, function in Firefox)
	if(ta == "string" || ta == "object" || ta == "function" )
	{
		v = a[0];
		// if an array, remove items
		if(v.constructor == Array)
		{
			var l = v.length;
			for(var i = 0; i<l; i++)
			{
				this.removeOption(v[i], a[1]);
			}
			return this;
		}
	}
	else if(ta == "number") index = a[0];
	else return this;
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return;
			// clear cache
			if(this.cache) this.cache = null;
			// does the option need to be removed?
			var remove = false;
			// get options
			var o = this.options;
			if(!!v)
			{
				// get number of options
				var oL = o.length;
				for(var i=oL-1; i>=0; i--)
				{
					if(v.constructor == RegExp)
					{
						if(o[i].value.match(v))
						{
							remove = true;
						}
					}
					else if(o[i].value == v)
					{
						remove = true;
					}
					// if the option is only to be removed if selected
					if(remove && a[1] === true) remove = o[i].selected;
					if(remove)
					{
						o[i] = null;
					}
					remove = false;
				}
			}
			else
			{
				// only remove if selected?
				if(a[1] === true)
				{
					remove = o[index].selected;
				}
				else
				{
					remove = true;
				}
				if(remove)
				{
					this.remove(index);
				}
			}
		}
	);
	return this;
};

$.fn.addOption = function()
{
	var add = function(el, v, t, sO)
	{
		var option = document.createElement("option");
		option.style.height = "24px";
		option.value = v, option.text = t;
		// get options
		var o = el.options;
		// get number of options
		var oL = o.length;
		if(!el.cache)
		{
			el.cache = {};
			// loop through existing options, adding to cache
			for(var i = 0; i < oL; i++)
			{
				el.cache[o[i].value] = i;
			}
		}
		// add to cache if it isn't already
		if(typeof el.cache[v] == "undefined") el.cache[v] = oL;
		el.options[el.cache[v]] = option;
		if(sO)
		{
			option.selected = true;
		}
	};

	var a = arguments;
	if(a.length == 0) return this;
	// select option when added? default is true
	var sO = true;
	// multiple items
	var m = false;
	// other variables
	var items, v, t;
	if(typeof(a[0]) == "object")
	{
		m = true;
		items = a[0];
	}
	if(a.length >= 2)
	{
		if(typeof(a[1]) == "boolean") sO = a[1];
		else if(typeof(a[2]) == "boolean") sO = a[2];
		if(!m)
		{
			v = a[0];
			t = a[1];
		}
	}
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return;
			if(m)
			{
				for(var item in items)
				{
					add(this, item, items[item], sO);
				}
			}
			else
			{
				add(this, v, t, sO);
			}
		}
	);
	return this;
};

$.fn.selectOptions = function(value, clear)
{
	var v = value;
	var vT = typeof(value);
	// handle arrays
	if(vT == "object" && v.constructor == Array)
	{
		var $this = this;
		$.each(v, function()
			{
      				$this.selectOptions(this, clear);
    			}
		);
	};


	var c = clear || false;
	// has to be a string or regular expression (object in IE, function in Firefox)
	if(vT != "string" && vT != "function" && vT != "object") return this;
	this.each(
		function()
		{

			if(this.nodeName.toLowerCase() != "select") return this;
			// get options
			var o = this.options;
			// get number of options
			var oL = o.length;


			for(var i = 0; i<oL; i++)
			{
				if(v.constructor == RegExp)
				{


					if(o[i].value.match(v))
					{
						o[i].selected = true;
					}
					else if(c)
					{
						o[i].selected = false;
					}
				}
				else
				{


					if(o[i].value == v)
					{
						o[i].selected = true;
					}
					else if(c)
					{
						o[i].selected = false;
					}
				}
			}
		}
	);
	return this;
};  
/**
 * 모든 항목을 선택한다.
 */

$.fn.selectAll = function() {
		this.each(function() {
			if (this.nodeName.toLowerCase() != "select")
				return this;
			// get options
			var o = this.options;
			// get number of options
			var oL = o.length;
			for (var i = 0; i < oL; i++) {
				o[i].selected = true;
			}
		});
		return this;
};

function onInit(param){
	
	var boardInfo = param.BoardManagementVO;
	var board_nm = boardInfo.BoardView.board_nm;
	var bulbdDesc = boardInfo.BoardView.board_discription;
	var boardPath = boardInfo.BoardView.board_path;
	var board_no = boardInfo.BoardView.board_no;
	var parentbulbdNo = boardInfo.BoardView.parent_board_no;
	/* var dsp_main_position = boardInfo.BoardView.dsp_main_position; */
	$("#board_no").val(board_no);
	$("#board_nm").val(board_nm);
	$("#parent_board_no").val(parent_board_no);
	
	document.getElementById("apnd_use_type").checked = false;
	document.getElementById("atch_file_use_type").checked = false;
	document.getElementById("share_sns_use_type").checked = false;
	$("#nw_bult_appt_prid").val('');
	/* document.getElementById("dsp_main_type").checked = false;
	$("select[id='dsp_main_position']").val(''); */
	
	for(i = 0; i < boardInfo.BoardConfigList.length; i++){
		
		// 덧글(코멘트) 사용가능여부
		if(boardInfo.BoardConfigList[i].board_config_cd == 'APND_USE_TYPE' && boardInfo.BoardConfigList[i].board_config_val ==  'Y') {
			document.getElementById("apnd_use_type").checked = true;
		}
		
		// 첨부파일 사용 유무
		if(boardInfo.BoardConfigList[i].board_config_cd == 'ATCH_FILE_USE_TYPE' && boardInfo.BoardConfigList[i].board_config_val == 'Y') {
			document.getElementById("atch_file_use_type").checked = true;
		}
		
		// 공유(sns) 사용 유무
		if(boardInfo.BoardConfigList[i].board_config_cd == 'SHARE_SNS_USE_TYPE' && boardInfo.BoardConfigList[i].board_config_val == 'Y') {
			document.getElementById("share_sns_use_type").checked = true;
		}
		
		/* if(boardInfo.BoardConfigList[i].board_config_cd == 'sidelink_use_type' && boardInfo.BoardConfigList[i].board_config_val == 'Y') {
			document.getElementById("sidelink_use_type").checked = true;
		} */
		
		if(boardInfo.BoardConfigList[i].board_config_cd == 'NW_BULT_APPT_PRID' ) {
			document.getElementById("nw_bult_appt_prid").value = boardInfo.BoardConfigList[i].board_config_val;
		}
		
		/* if (boardInfo.BoardConfigList[i].board_config_cd == 'DSP_MAIN_TYPE' && boardInfo.BoardConfigList[i].board_config_val == 'Y') {
			document.getElementById("dsp_main_type").checked = true;		
		}
		if(boardInfo.BoardConfigList[i].board_config_cd == 'DSP_MAIN_POSITION' && boardInfo.BoardConfigList[i].board_config_val != '') {
			$("select[id='dsp_main_position']").val(boardInfo.BoardConfigList[i].board_config_val);
		} */
		
	}
	var str1 = "";
	for( i = 0; i < boardInfo.RoleList.length; i++){
		str1 += '<option value="' + boardInfo.RoleList[i].role_id +'" style="height:24px;">' + boardInfo.RoleList[i].role_nm + '</option>'
	}
	var writeAutr = []; // DCD 01
	for( i = 0; i < boardInfo.BoardWriteAuthSetView.length; i++){
		writeAutr.push(boardInfo.BoardWriteAuthSetView[i].role_id);
	}
	$("#writeAutr").empty();
	$("#writeAutrGroup").empty();
	$("#writeAutr").removeOption(/./, true);
	$("#writeAutrGroup").append(str1);
	$("#writeAutrGroup").selectOptions(writeAutr);
	$("#writeAutrGroup").copyOptions("#writeAutr","selected");
	$("#writeAutrGroup").removeOption(/./, true);
	var modifyAutr = []; // DCD 02
	for( i = 0; i < boardInfo.BoardModifyAuthSetView.length; i++){
		modifyAutr.push(boardInfo.BoardModifyAuthSetView[i].role_id);
	}
	$("#modifyAutr").empty();
	$("#modifyAutrGroup").empty();
	$("#modifyAutr").removeOption(/./, true);
	$("#modifyAutrGroup").append(str1);
	$("#modifyAutrGroup").selectOptions(modifyAutr);
	$("#modifyAutrGroup").copyOptions("#modifyAutr","selected");
	$("#modifyAutrGroup").removeOption(/./, true);
	var viewAutr = []; // DCD 03
	for( i = 0; i < boardInfo.BoardViewAuthSetView.length; i++){
		viewAutr.push(boardInfo.BoardViewAuthSetView[i].role_id);
	}
	$("#viewAutr").empty();
	$("#viewAutrGroup").empty();
	$("#viewAutr").removeOption(/./, true);
	$("#viewAutrGroup").append(str1);
	$("#viewAutrGroup").selectOptions(viewAutr);
	$("#viewAutrGroup").copyOptions("#viewAutr","selected");
	$("#viewAutrGroup").removeOption(/./, true);
	
	var deleteAutr = []; // DCD 04
	for( i = 0; i < boardInfo.BoardDeleteAuthSetView.length; i++){
		deleteAutr.push(boardInfo.BoardDeleteAuthSetView[i].role_id);
	}
	$("#deleteAutr").empty();
	$("#deleteAutrGroup").empty();
	$("#deleteAutr").removeOption(/./, true);
	$("#deleteAutrGroup").append(str1);
	$("#deleteAutrGroup").selectOptions(deleteAutr);
	$("#deleteAutrGroup").copyOptions("#deleteAutr","selected");
	$("#deleteAutrGroup").removeOption(/./, true);

} // end of onInit()
</script>

</head>
<body>
		
	  <div class="search">    
            <table class="se">
                <tr>
                    <td>
                    <input type="text" class="kddl" name="folder_type" id="folder_type" ddcode="FOLDER_TYPE" optionLabel="폴더/게시판"/>
                    <input type="text" class="kddl" name="use_yn" id="use_yn" ddcode="USE_YN" optionLabel="사용여부"/>
                    <input type="text" class="k-textbox" name="search_word" id="search_word" 
							   placeholder="게시판이름" onKeyPress="if(event.keyCode==13)srch();" style="width:200px;"/>
							   <button class="k-primary btn_sty01" onclick="javascript:srch();" id="bt_search" name="bt_search">검색</button>
					</td>
              </tr>          
            </table>                
     </div><!--// search -->

    <!--// 그리드 상단에 타이틀이 없을경우 간격조절라인 -->
  	<hr style="display:block;height:20px;">

	<script type="text/x-kendo-template" id="arrow-Template">
		#var lv = lv;#
		#for(var i=1; i < lv; i++){#
			　
		#}#
		<img src="/resources/images/common/menu_arrow.png" alt="조직" />&nbsp;#:board_nm#
	</script>

	<!-- // grid start -->
	<div id="grid" style="height:300px;"></div>
	<!-- grid end // -->   
	
   <h3 id="bd_label" style="margin-bottom:0px;margin-top:20px;font-size:26px;"> (게시판명) </h3>
    
    <input type="hidden" name="board_no" id="board_no"/><!-- 게시판번호 -->
	<input type="hidden" name="parent_board_no" id="parent_board_no"/><!-- 부모게시판번호 -->
	<input type="hidden" name="isNew" id="isNew" value="N"/><!-- 신규여부 -->
    
	<div style="float:left; width:49%; margin-top:20px;border-right:2px dashed #ddd;padding-right:1.5em;">
		<input type="hidden" id="board_no" name="board_no"/>
	    <h2 style="margin-bottom:10px;font-size:16px;color:#003399;"> 게시판 설정</h2>
		<span style="font-size:14px;color:#000;">■ 게시판 설정</span>
		<hr style="display:block;height:8px;">
		<table class="ta_sample2">
		<colgroup>
			<col width="25%">
			<col width="75%">
		</colgroup>
			<tbody>
				<tr>
					<th>기능 사용</th>
					<td style="margin-left:10px;padding-top:10px;padding-bottom:10px;">
						<strong>덧글 :&nbsp;&nbsp;</strong><input type="checkbox" name="apnd_use_type" id="apnd_use_type"/>&nbsp;<label for="apnd_use_type">사용</label>&nbsp;&nbsp;&nbsp;&nbsp;
						<br/><br/>
						<strong>파일첨부 :&nbsp;&nbsp;</strong><input type="checkbox" name="atch_file_use_type" id="atch_file_use_type"/>&nbsp;<label for="atch_file_use_type">사용</label>&nbsp;
						<!-- <br/><br/>
						<strong>사이드링크 :&nbsp;&nbsp;</strong><input type="checkbox" name="sidelink_use_type" id="sidelink_use_type"/>&nbsp;<label for="sidelink_use_type">사용</label> -->
						</td>
				</tr>
				<tr style="display:none">
					<th>최근 글 표시</th>
					<td style="padding-left:10px;"><input type="text" class="k-textbox" style="width: 50px;" name="nw_bult_appt_prid" id="nw_bult_appt_prid">&nbsp;일<br/>
						<strong>공유기능 :&nbsp;&nbsp;</strong><input type="checkbox" name="share_sns_use_type" id="share_sns_use_type"/>&nbsp;<label for="share_sns_use_type">사용</label>&nbsp;
						</td>
				</tr>
				<!-- <tr>
					<th>메인화면 순번</th>
					<td style="padding-left:10px;">
						<strong>화면 표시 :&nbsp;&nbsp;</strong> <input type="checkbox" name="dsp_main_type" id="dsp_main_type">&nbsp;<label for="dsp_main_type">사용</label>
						&nbsp;&nbsp;
						<select name ="dsp_main_position" id="dsp_main_position">
							<option value="">순번</option>
							<option value=1>1</option>
							<option value=2>2</option>
							<option value=3>3</option>
						</select>
					</td>										
				</tr> -->
			</tbody>
		</table>
	</div>
	
	<div style="float:right; width:49%;margin-top:20px;">
		<h2 style="font-size:16px;color:#003399;display: inline-block;float: left;"> 권한 설정</h2>
		
		<hr style="display:block;height:5px;">
		<div id="tabstrip" style="border: 0px; background:#fff;">
		<hr/>
			<ul style="margin-top: -10px;text-align:right;">
				
				<li class="k-state-active">조회</li>
				<li>글쓰기</li>
				<li>수정</li>
				<li>삭제</li>
			</ul>
			
			<!-- 조회 -->
			<div id="tab1" style="background-color:#fff;">
				<div id="tab1_left" class="auth_tab_left_div" style="float:left;width:43%">							
					<div class="auth_listView_header" style="margin-bottom: 5px;">
						<span style="font-size:14px;">■ 권한 그룹 목록</span>
						
					</div>
					<select size="20" name="viewAutrGroup" id="viewAutrGroup" multiple="multiple" style="width:100%; height:150px;" >
					</select>
				</div>
				<div id="tab1_center" class="auth_tab_center_div" style="float:left;width:14%;text-align:center;margin-top:70px;">

					<button type="button"  id="btnAddViewAutr" class="k-primary btn_sty03" style="font-size:11px;padding:4px 8px">설정 ▶</button><br />
					<hr style="display:block;height:5px;">
					<button type="button"  id="btnRemoveViewAutr" class="k-primary btn_sty03" style="font-size:11px;padding:4px 8px">◀ 취소</button>
				</div>
				<div id="tab1_right" class="auth_tab_right_div" style="float:right;width:43%">
					<div class="auth_listView_header"  style="margin-top: 5px; margin-bottom: 5px;">
						<span style="font-size:14px;">■ 설정된 그룹</span>
					</div>
					<select size="20" name="viewAutr" id="viewAutr" multiple="multiple" style="width:100%; height:150px;" >
	             	</select>
				</div>
			</div>
			<!-- 글쓰기 -->
			<div id="tab2" style="background-color:#fff;">
				<div id="tab2_left" class="auth_tab_left_div" style="float:left;width:43%">
					<div class="auth_listView_header" style="margin-bottom: 5px;">
						<span style="font-size:14px;">■ 권한 그룹 목록</span>
					</div>
					<select size="20" name="writeAutrGroup" id="writeAutrGroup" multiple="multiple" style="width:100%; height:150px;" >
					</select>
				</div>
				<div id="tab2_center" class="auth_tab_center_div" style="float:left;width:14%;text-align:center;margin-top:70px;">
					
					<button type="button"  id="btnAddWriteAutr" class="k-primary btn_sty03" style="font-size:11px;padding:4px 8px">설정 ▶</button><br />
					<hr style="display:block;height:5px;">
					<button type="button"  id="btnRemoveWriteAutr" class="k-primary btn_sty03" style="font-size:11px;padding:4px 8px">◀ 취소</button>
				</div>
				<div id="tab2_right" class="auth_tab_right_div" style="float:right;width:43%">
					<div class="auth_listView_header" style="margin-top: 5px; margin-bottom: 5px;">
						<span style="font-size:14px;">■ 설정된 그룹</span>
					</div>
					<select size="20" name="writeAutr" id="writeAutr" multiple="multiple" style="width:100%; height:150px;" >
	             	</select>
				</div>
			</div>
			<!-- 수정 -->
			<div id="tab3" style="background-color:#fff;">
				<div id="tab3_left" class="auth_tab_left_div" style="float:left;width:43%">
					<div class="auth_listView_header" style="margin-bottom: 5px;">
						<span style="font-size:14px;">■ 권한 그룹 목록</span>
					</div>
					<select size="20" name="modifyAutrGroup" id="modifyAutrGroup" multiple="multiple" style="width:100%; height:150px;" >
					</select>
				</div>
				<div id="tab3_center" class="auth_tab_center_div" style="float:left;width:14%;text-align:center;margin-top:70px;">
					
					<button type="button"  id="btnAddModifyAutr" class="k-primary btn_sty03" style="font-size:11px;padding:4px 8px">설정 ▶</button><br />
					<hr style="display:block;height:5px;">
					<button type="button"  id="btnRemoveModifyAutr" class="k-primary btn_sty03" style="font-size:11px;padding:4px 8px">◀ 취소</button>
				</div>
				<div id="tab3_right" class="auth_tab_right_div" style="float:right;width:43%">
					<div class="auth_listView_header" style="margin-top: 5px; margin-bottom: 5px;">
						<span style="font-size:14px;">■ 설정된 그룹</span>
					</div>
					<select size="20" name="modifyAutr" id="modifyAutr" multiple="multiple" style="width:100%; height:150px;" >
	             	</select>
				</div>
			</div>
			<!-- 삭제 -->
			<div id="tab4" style="background-color:#fff;">
				<div id="tab4_left" class="auth_tab_left_div" style="float:left;width:43%">
					<div class="auth_listView_header" style="margin-bottom: 5px;">
						<span style="font-size:14px;">■ 권한 그룹 목록</span>
					</div>
					<select size="20" name="deleteAutrGroup" id="deleteAutrGroup" multiple="multiple" style="width:100%; height:150px;" >
					</select>
				</div>
				<div id="tab4_center" class="auth_tab_center_div" style="float:left;width:14%;text-align:center;margin-top:70px;">
					
					<button type="button"  id="btnAddDeleteAutr" class="k-primary btn_sty03" style="font-size:11px;padding:4px 8px">설정 ▶</button><br />
					<hr style="display:block;height:5px;">
					<button type="button"  id="btnRemoveDeleteAutr" class="k-primary btn_sty03" style="font-size:11px;padding:4px 8px">◀ 취소</button>
				</div>
				<div id="tab4_right" class="auth_tab_right_div" style="float:right;width:43%">
					<div class="auth_listView_header" style="margin-top: 5px; margin-bottom: 5px;">
						<span style="font-size:14px;">■ 설정된 그룹</span>
					</div>
					<select size="20" name="deleteAutr" id="deleteAutr" multiple="multiple" style="width:100%; height:150px;" >
	             	</select>
				</div>
			</div><!-- end of div#tab4 -->
		</div><!-- end of tapstrip -->
		<div style="clear: both;"></div>
		
		<button type="button"  class="kbtn k-primary btn_sty02" style="float:right;margin-top:10px;" id="bt_save">저장</button>	
	</div><!--  endof lower right panel -->	
	
	<script  type="text/javascript">
		
		/* 데이터 소스설정 */
		var ds = {
			transport : {
				create  : { url : "/board/board/insertBoard.ajax?${_csrf.parameterName}=${_csrf.token}"},
				read    : { url : "/system/boardmanagement/getBoardManagementList.ajax?${_csrf.parameterName}=${_csrf.token}"},
				update  : { url : "/board/board/updateBoard.ajax?${_csrf.parameterName}=${_csrf.token}"},
				destroy : { url : "/board/board/deleteBoard.ajax?${_csrf.parameterName}=${_csrf.token}"}
			},
			schema : {
				model : {
					id : "board_no",
					fields : {
						lv : {},
						board_no : {},
						board_nm : {required:true,validationMessage : "필수항목"},
						board_discription : {},
						parent_board_no : {},
						use_yn : {required:true,validationMessage : "필수항목"},
						folder_type : {required:true,validationMessage : "필수항목"},
						sort_no : {type:"number"}
					}
				}
			},
			requestEnd : function(e) {
				if (e.type != undefined && e.type != "read") {
					srch();
				}
			}
		};

		
		/* 게시판 그리드 필드 정의 */
		var gridpt = {

			columns : 
			[	
				{
					field : "board_no",
					title : "게시판번호",
					width : 60
				},
				{
					field : "mb_id",
					title : "회원사ID",
					width : 60,
					hidden:true
				}, 				
				{
					field : "board_nm",
					title : "게시판명",
					width : 200,
					attributes : {
						"class" : "col-left"
					},
					template: $("#arrow-Template").html()
				}, 
				{
					field : "board_path",
					title : "게시판경로",
					width : 200,
					hidden: true
				}, 
				{
					field : "board_discription",
					title : "설명",
					width : 100,
				}, 
				{
					field : "parent_board_no",
					title : "부모게시판",
					width : 50,
					attributes : {
						"class" : "col-center"
					}
				},			
				{
					field : "folder_type",
					title : "폴더구분",
					width : 50,
					/* template : "#=folder_type_nm#", */
					attributes : {
						"class" : "col-center"
					}
				},				
				{
					field : "item_cnt",
					title : "등록글수",
					width : 50,
					attributes : {
						"class" : "col-center"
					}
				}, 
				{
					field : "reply_cnt",
					title : "답글수",
					width : 50,
					attributes : {
						"class" : "col-center"
					},
					hidden: true
				}, 
				{
					field : "comment_cnt",
					title : "댓글수",
					width : 50,
					attributes : {
						"class" : "col-center"
					}
				}, 
				/*{
					field : "abl_atch_cnt",
					title : "첨부허용수",
					width : 50,
					attributes : {
						"class" : "col-center"
					},
					hidden : true
				},*/
				{
					field : "sort_no",
					title : "정렬순서",
					width : 50,
					attributes : {
						"class" : "col-center"
					},
				},				
				{
					field : "use_yn",
					title : "사용여부",
					width : 50,
					attributes : {
						"class" : "col-center"
					}
				}, 
				{
					field : "in_dtm",
					title : "생성일",
					width : 60,
					attributes : {
						"class" : "col-center"
					}
				}, 
				{
					command: 
					[	{ name: "creat", text: "추가"  , click: gridAddRow } /* , click: gridAddRow */
                
            		]
					, title: "하위게시판추가"
					, width: 70
            		, attributes:{"class":"col-center"}
            	},
				{
					command : 
					[   { name: "edit",     text: "수정" }, 
			            { name : "destroy", text : "삭제", click : onDelete, className : "delBtn"	} 
		            ],
					title : "변경",
					width : 110,
					attributes : {
						"class" : "col-center"
					}
				}

			],
			editable : {
				mode : "inline",
				confirmation : "게시글을 포함한 데이터가 삭제됩니다. \n삭제하시겠습니까?"
			},
			edit : function(e) {

				e.model.dirty = true;
				var board_no = e.container.find("input[name=board_no]");
				board_no.prop("disabled",true);
				board_no.addClass("k-state-disabled");

				
				var item_cnt = e.container.find("input[name=item_cnt]");
				item_cnt.prop("disabled",true);
				item_cnt.addClass("k-state-disabled");
				
				var reply_cnt = e.container.find("input[name=reply_cnt]");
				reply_cnt.prop("disabled",true);
				reply_cnt.addClass("k-state-disabled");
				
				var comment_cnt = e.container.find("input[name=comment_cnt]");
				comment_cnt.prop("disabled",true);
				comment_cnt.addClass("k-state-disabled");
				
				var in_dtm = e.container.find("input[name=in_dtm]");
				in_dtm.prop("disabled",true);
				in_dtm.addClass("k-state-disabled");
				
				
				if (!e.model.isNew()) { 
					// 수정인 경우
					var folder_type = e.container.find("input[name=folder_type]");
					folder_type.removeClass("k-textbox").removeClass("k-input");
					folder_type.attr("ddcode", "FOLDER_TYPE");
					folder_type.attr("height", "auto");
					folder_type.attr("optionLabel", "폴더구분");
					folder_type.attr("listWidth", "80px");
					genexon.initKendoUI_ddl(folder_type);
					
					var use_yn = e.container.find("input[name=use_yn]");
					use_yn.removeClass("k-textbox").removeClass("k-input");
					use_yn.attr("ddcode", "USE_YN");
					use_yn.attr("height", "auto");
					use_yn.attr("optionLabel", "사용여부");
					use_yn.attr("listWidth", "80px");
					genexon.initKendoUI_ddl(use_yn);
					
				} else {
					// 추가인 경우
					var parent_board_no = e.container.find("input[name=parent_board_no]");
					parent_board_no.prop("readonly", true);
					parent_board_no.addClass("k-state-disabled");
					
					var folder_type = e.container.find("input[name=folder_type]");
					folder_type.removeClass("k-textbox").removeClass("k-input");
					folder_type.attr("ddcode", "FOLDER_TYPE");
					folder_type.attr("height", "auto");
					folder_type.attr("listWidth", "80px");
					folder_type.attr("id", "folderynddl");
					genexon.initKendoUI_ddl(folder_type);
					$('#folderynddl').data("kendoDropDownList").select(1);
					e.model.folder_type = $('#folderynddl').val();
					
					var use_yn = e.container.find("input[name=use_yn]");
					use_yn.removeClass("k-textbox").removeClass("k-input");
					use_yn.attr("ddcode", "USE_YN");
					use_yn.attr("height", "auto");
					use_yn.attr("listWidth", "80px");
					use_yn.attr("id", "useynddl");
					genexon.initKendoUI_ddl(use_yn);
					$('#useynddl').data("kendoDropDownList").select(0);
					e.model.use_yn = $('#useynddl').val();

				}

			},
			save : function(e) {

				var board_nm = e.container.find("input[name=board_nm]");
				var folder_type = e.container.find("input[name=folder_type]");
				var use_yn = e.container.find("input[name=use_yn]");
				var parent_board_no = e.container.find("input[name=parent_board_no]");

				if(board_nm.val() == ""){
					genexon.alert("error", "게시판관리", "게시판명을 입력하세요.");
					board_nm.data("kendoDropDownList").open();
					e.preventDefault();
					return;
				}
				if(folder_type.val() == ""){
					genexon.alert("error", "게시판관리", "폴더여부가 선택되지 않았습니다.");
					folder_type.data("kendoDropDownList").open();
					e.preventDefault();
					return;
				}
				if(use_yn.val() == ""){
					genexon.alert("error", "게시판관리", "사용여부가 선택되지 않았습니다.");
					use_yn.data("kendoDropDownList").open();
					e.preventDefault();
					return;
				}
				if(parent_board_no.val() == "") {
					genexon.alert("error", "게시판관리", "부모게시판이 선택되지 않았습니다.");
					e.preventDefault();
					return;
				}
			},
			dataBound : function(e){
                e.sender.tbody.find("tr").each(function(idx, element) {
                    if( $(this).children().first().text() == '0'){
                    	$(this).find(".k-button.delBtn").remove();
                    }
                })
			},
			change : onChange,
			pageable : true,
			pageSize : false
		};

		/* 인라인 그리드 생성 */
		genexon.initKendoUI_grid_inlineEdit("#grid", gridpt, ds, "300px");

		function gridRemoveRow() {
			var grid = $("#grid").data("kendoGrid");
			var row = grid.select();

			grid.removeRow(row);
		}
		
       function onChange(arg) {
    		var selectedItem =this.dataItem(this.select()[0]);
       
	       	var mb_id = selectedItem.mb_id;
	       	var board_no = selectedItem.board_no;
			var board_nm = selectedItem.board_nm;
			var board_path = selectedItem.board_path;
			var parent_board_no = selectedItem.parent_board_no;
				
			if(board_no !== "" && board_nm !== "")
			{
				$("#bd_no").val(board_no);
				$("#bd_label").text(board_no + "-" +board_nm + " ("+board_path+")" );
				var param = {};
				param.mb_id = mb_id;
				param.board_no = board_no;
				param.parent_board_no = parent_board_no;
				getBoardInfo(param);
			}
			else
			{
				$("#board_no").val("");
				$("#bd_label").text("");
			}
			//var grid_sub = $("#gridsub").data("kendoGrid");
			//grid_sub.dataSource.read({BD_NO: bd_no});
			
        }
       
		/* SUB 그리드 필드 정의 */
	   	var gridptSub = 
	   	{
	
	   		columns: [
	   					 {field: "mb_id", title: "회사ID",  width: "100px", hidden:true}
	   					,{field: "board_no", title: "게시판번호",  width: "100px", hidden:true}
	   					,{field: "board_config_cd", title: "설정코드",width: "100px"
	   						, attributes :{ "class" : "col-center"}, hidden:true}
	   					,{field: "board_config_nm", title: "설정코드",width: "100px", attributes :{ "class" : "col-center"}}
	   					,{field: "board_config_nm", title: "설명",width: "200px", attributes :{ "class" : "col-left"}}
	   					,{field: "board_config_val", title: "설정값",width: "80px", attributes :{ "class" : "col-center"}}
	   					,{field: "sort_no", title: "정렬순서",width: "80px", attributes :{ "class" : "col-center"}}
	   					,{field: "use_yn", title: "사용여부",width: "80px" 
	   					},
	   					{command: [{ name: "edit", text: "수정" }] , title: "변경", width: "80px",
	   						attributes :{"class" : "col-center"}
	   					}
	   				  ]
	   		,editable:
	   				{
	   					 mode:"inline" 
	   					,createAt:"top" 
	   					,confirmation: "선택하신 행을 삭제하시겠습니까??"
	   					
	   				}
	   		,edit: 
	   				function(e)
	   				{
	   						
							var board_config_nm = e.container.find("input[name=board_config_nm]");
							board_config_nm.prop("disabled",true);
							board_config_nm.addClass("k-state-disabled");
							
							var use_yn = e.container.find("input[name=use_yn]");
							use_yn.removeClass("k-textbox").removeClass("k-input");
							use_yn.attr("ddcode", "USE_YN");
							use_yn.attr("height", "auto");
							use_yn.attr("listWidth", "80px");
							use_yn.attr("id", "useynddl");
							genexon.initKendoUI_ddl(use_yn);
							
	   						if (!e.model.isNew()) 
	   						{ // 새로생성된 모델이 아니라면 

	   						}
	   						else 
	   						{ // 새로생성된 모델이라면	        		    		

	   						}
	   				}
	   	};      	
	   					
	   	/* sub그리드 데이터소스 정의 */
	   	var dsSub  =  
	   	{	
	   		transport: 
	   				{
	   					read     : { url: "/system/boardmanagement/getBoardConfigList.ajax?${_csrf.parameterName}=${_csrf.token}"}
	   					,update  : { url: "/system/boardmanagement/updateBoardConf.ajax?${_csrf.parameterName}=${_csrf.token}"}
	   		        }
	   		,schema:
	           		{   
	   					data : "results",
	   					model: 
	   					{
	   						id: "board_config_cd",
	   						fields: 
	   								{
	   							board_no: { validation: {required: true, validationMessage:"필수항목"}},
	   									board_config_cd : { validation: {required: true, validationMessage:"필수항목"}},
	   									board_config_nm: { validation: {required: true, validationMessage:"필수항목"}},
	   									use_yn : {},
	   									sort_no: {type: "number",  validation: {required: true, min: 1, max:999, validationMessage:"1~999허용"}}
	   								}
	               		}
	           }
	   		,batch: true
	   	};   
	
	    /* 인라인 그리드 생성 */
	   	//genexon.initKendoUI_grid_inlineEdit("#gridsub", gridptSub, dsSub, "300px");       
	</script>

</body> 
</html>