var tabList=[];
/* 탭추가 */
function addTab(tabID,Name,URL,MenuPath,reloadYN){ // 메뉴를 눌러야 호출됨.

	if(reloadYN && $("#_"+tabID).length>0){
		// reloadYN이 true이고 <iframe> id가 _tabID인 iframe이 존재하는 경우
		$("#mainFrm").attr("target","_"+tabID);
		$("#mainFrm").attr("action",URL);
		$("#mainFrm").submit();
  	}
  	if( selectTab(tabID,Name,MenuPath) ) return;
  var tabStrip = $("#contents").data("kendoTabStrip");    
  
  $("#mainFrm").attr("target","_"+tabID);
  $("#mainFrm").attr("action",URL);
  
  var ifm = "<iframe id='_"+tabID+"' name='_"+tabID+"'"+ // " src='"+URL+"'"
            " class='ifmPgm' "+ 
            // .ifmPgm : genexon.js에서 menuID를 설정하는데 사용
            " menuID='"+tabID+"'"+
            " style='height:100%;width:100%;border: 0px;overflow:hidden;min-height:700px;' "+
            " scrolling=\"no\" "+ 
            //" scrolling=\"yes\" "+ 
            " targetURL='"+URL+"'"+ ">" +
            "</iframe> ";
            // 메뉴에 따라 스크롤이 필요한 화면도 존재 분기처리 또는 설정 필요
			// targetURL대신 src를 사용하면 css가 깨짐.

  tabStrip.append({id:tabID, text: Name, content: ifm}); 

  
  if(tabID == 'MA_000'){ // 메인인경우 종료 버튼 없음
	  $("#tablist").append('<a href="#"><li class="t_sel pr25" id="tab_'+tabID+'" onClick="javascript:selectTab(\''+tabID+'\',\''+Name+'\',\''+MenuPath+'\')">'+Name+"</li></a>");
  } else {
	  $("#tablist").append('<a href="#"><li class="t_nor" id="tab_'+tabID+'" onClick="javascript:selectTab(\''+tabID+'\',\''+Name+'\',\''+MenuPath+'\')">'+Name
			  //+'<button class="t_rel_nor" onClick="document.getElementById(\'_' + tabID +'\').contentDocument.location.reload();">reload</button>'
			  +'<button class="t_rel_nor" onClick="document.getElementById(\'_' + tabID +'\').contentDocument.location.href = document.getElementById(\'_' + tabID +'\').contentDocument.location.href;">reload</button>'
			  +'<button class="t_close_nor" onClick="javascript:closeTab(\''+tabID+'\',\''+Name+'\');" >Close</button>'
			  +"</li></a>");
  }

  $('#mainFrm').submit();
  
  tapSize();
  
  selectTab(tabID,Name,MenuPath);

}

/* 탭선택 */
// 탭리스트중에 탭을 선택하고, 특정 탭스트립의 화면을 출력	
function selectTab(tabID,Name,MenuPath) {
	//tabID가 없는(하위메뉴가 없는) 데이터 클릭 시 햄버거 버튼 보이고, 하위메뉴가 없는 대메뉴 클릭시는 햄버거 버튼 숨기도록
	if(tabID == "MA_000" || tabID == "BD_000" || tabID == "IT_100") {
		$("button.hamburger").css("display", "none");
	}else {
		$("button.hamburger").css("display", "block");
	}
	//#########################
	var topTabID = $(this).attr("id");
	if( ($(".hamburger").attr('class').indexOf('active') >= 0) && (topTabID == "ID_000" || topTabID == "JI_000" || topTabID == "IC_000" || topTabID == "PD_000" || topTabID == "IP_000" || topTabID == "IS_000") ){
		$(".hamburger").trigger("click");
	}
	
	// tablist 작업
	if($("#tab_"+tabID).length==0) return;
	else sessionExt();
 
	//탭이동버튼이 생겼을 때 클릭한 것이 보이도록 이동
	if($('#tabLeft').css('display')=='block'){
		var $thisTab = $('#tab_'+tabID);
		var tabDivWidth = $('#tab_bro>div>div').width()-140;//탭이 보이는 부분의 사이즈
		var distance = 0;	//선택한 탭 앞의 탭들의 사이즈 합
		var tabSize = 0;	//선택한 탭 사이즈
		var marginLeft = 0;	//적용할 margin-left 사이즈
		
		$('#tablist').find('li[id^="tab_"]').closest('a').each(function(index, item){
			if(('tab_'+tabID)==$(this).find('li').attr('id')){
				tabSize = $(this).width();
				return false;
			}
			
			distance += $(this).width();
		})
		
		if((window.innerWidth-140-tabSize)< $thisTab.offset().left || $thisTab.offset().top>110){
			//탭이 탭리스트 오른쪽에서 넘어가 안보일때
			marginLeft = -(tabSize+distance-tabDivWidth);
			$('#tablist').css('margin-left',marginLeft+'px');
		}else if($thisTab.offset().left<262){
			//탭이 탭리스트 왼쪽에서 넘어가 안보일때
			$('#tablist').css('margin-left',(-distance)+'px');
		}
	}
	
  
	if($("#tablist li").length>0){
		$("#tablist li").each(function(index){
			$(this).removeClass("sel");
		});
	}
  
	// tapStrip 작업
	var tabStrip = $("#contents").data("kendoTabStrip");
	var items = tabStrip.items();
  
	for(var i=0;i<items.length;i++) {
		var tname = items[i].innerText;
      
		if(items[i].innerText ==  undefined ) {
			tname = items[i].textContent;
		}
      
		if(tname ==  Name){
			tabStrip.select(items[i]);
		}
	}
  
	//addTab에서 resizeIfm()호출함
	resizeIfm("_"+tabID);
  
	/*즐겨찾기 버튼*/ //PASS(다음)
	/*$.ajax({
		url : "/menu/checkBookmark.ajax",
		type : "POST",
		data : {
			RESOURCE_ID : tabID
		},
		dataType : "json",
		success : function(result) {
			$("#MenuPath").find("#bookmarkbtn").remove();
		    $("#MenuPath").append('&nbsp;<img alt="bookmark" src="../images/bookmark_' + result.BookmarkVO.USE_YN + '.png" id="bookmarkbtn"'
		    		 			 +'onclick="javascript:bookmark(\'' + tabID + '\',\'' + result.BookmarkVO.USE_YN + '\');"'
		    		 			 +'style="cursor: pointer; width: 16px; height: 16px; vertical-align:text-bottom;">');
		}
	});*/
  
	$(".t_sel> .t_close_sel").removeClass("t_close_sel").addClass("t_close_nor");
	$(".t_sel> .t_rel_sel").removeClass("t_rel_sel").addClass("t_rel_nor");
	$(".t_sel").removeClass("t_sel").addClass("t_nor");
	
	if($("#tab_"+tabID).length>0) {
		$("#tab_"+tabID+"> .t_close_nor").removeClass("t_close_nor").addClass("t_close_sel");
		$("#tab_"+tabID+"> .t_rel_nor").removeClass("t_rel_nor").addClass("t_rel_sel");
		$("#tab_"+tabID).removeClass("t_nor").addClass("t_sel");
		if($("#tab_"+tabID).find(".t_sel").length === 0){
			$(".sel").addClass("nor").removeClass("sel");
			$("."+tabID).addClass("sel");
		}
		return true;
	}
	return false;
}

/* 탭닫기 */
function closeTab(tabID,Name){
	
	$("#MenuPath").text("");
	var tabStrip = $("#contents").data("kendoTabStrip");
	var items = tabStrip.items();
	var deletedIndex = 0;
	for(var i=0;i<items.length;i++){
		if(items[i].innerText ==  Name){
			tabStrip.remove("li:eq("+i+")");
			deletedIndex = i;
		}
	}
  
	if($("#tab_"+tabID).length>0) {  
		if($(".t_sel").attr("id")=="tab_"+tabID){	//선택한 탭을 지웠을 때	  
			var $tabs = $("#tablist").find("li[id^='tab_']");
			
			if($tabs.length > 0){
				if($tabs.length-2 >= deletedIndex){
					$tabs.eq(deletedIndex+1).trigger("click"); // 마지막이 아닌 탭을 지우고나서 선택되는 탭은 지운탭 바로 다음탭
				} else {
					deletedIndex = $tabs.length-2;
					$tabs.eq(deletedIndex).trigger("click"); // 마지막탭을 지우고 나서 선택되는 탭은 지운탭 바로 앞의 탭
				}
			}
		}

		var tabSize = $("#tab_"+tabID).closest("a").width();
		moveTab(tabSize);
		$("#tab_"+tabID).remove();  
	}

	tapSize();
	return false;
}

/* 메인화면탭 열기 */
function addMain(role_id, mb_id) {
	addTab('MA_000','메인','/main.go','메인');
	navctl();
}

/* 알림탭 열기 */
function showNotice(){
	addTab('NT_000','알림','/notification/notice.go','메인 > 알림');
}

/* 탭사이즈가 화면 초과시 처리 */
function tapSize(){
	  var listWidth = $('#menu_title').width();
	  var windowWidth = window.innerWidth;
	  var tabRightLeft = windowWidth-80;
	  $("#tab_bro>div").css("width",windowWidth-listWidth);
	  $("#tab_bro>div").css("margin-left",listWidth);
	  $("#tabLeft").css("left",tabRightLeft-60);
	  $("#tabRight").css("left",tabRightLeft);
	  $('#tablist').find('a').each(function(index, item){
		  listWidth += $(this).width();
	  })
	  
	  if(listWidth > windowWidth){
		 $("#tabLeft, #tabRight").css("display","block")
	  }else{
		 $("#tabLeft, #tabRight").css("display","none")
	  }
	  
}

/* 탭사이즈 화면 초과시 화살표 클릭 이벤트*/
function moveTab(direction){
	var marginLeft = parseInt($('#tablist').css("margin-left"))+direction;
	var listWidth = 0;
	$('#tablist').find('a').each(function(index, item){
		listWidth += $(this).width();
	 })

	 if(marginLeft>0){
		 $('#tablist').css("margin-left","0px");
	 }else if(listWidth<($("#tab_bro>div>div").width()-140-marginLeft)){
		 $('#tablist').css("margin-left",($("#tab_bro>div>div").width()-140-listWidth)+"px");
	 }else{
		$('#tablist').css("margin-left",marginLeft+"px");
	 }
}