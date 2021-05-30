function resizecontents(){
// 자동높이 조절 (두번호출됨.)
// 탭을 다시 선택해도 resize가 일어남.
	var height0 = window.innerHeight;
    var height2 = height0 - ($("#headerwrap").height()+$("#tab_bro").height()+$("#footer").height());
    height2 -= $("#contents").css("padding-top").replace("px", "");	//너무 크게 잡혀서 안의 내용물의 크기와는 관계없이 html에 스크롤이 생겨 contents의 padding-top 값 만큼 더 빼줌
    $("#contents").css("min-height", height2); /*contents의 최소 높이를 tab panel 높이로 지정 */

    return height2;
}

/* 아이프레임 크기 조절 */
function resizeIfm(ifmID){
	var height2 = resizecontents();
    
    if (height2 <= 300)
    {
    	height = document.getElementById(ifmID).contentWindow.document.body.scrollHeight;
		document.getElementById(ifmID).style.height = height+"px";
    }
    else
    {
    	$("#"+ifmID).height(height2);
    }
    
}

function resizecontainer(){
	var height0 = window.innerHeight;
    var height2 = height0 - ($("#headerwrap").height()+$("#tab_bro").height()/*+$("#footer").height()*/);

    $("#container").css("height", height2); /*contents의 최소 높이를 tab panel 높이로 지정 */
}

function resizeGrid(){
	var height = top.$("#left_nav").outerHeight() - (top.$("#headerwrap").outerHeight()+top.$("#tab_bro").outerHeight()+top.$("#footer").outerHeight()) - ($(".resizegrid").closest("body").outerHeight() - $(".resizegrid").outerHeight());
	var extraheight = 0;
	$(".resizegrid").children().not(".k-grid-content").each(function(){
		extraheight += $(this).outerHeight();
    });
	
	$(".resizegrid").height(height+"px");
	$(".resizegrid").find(".k-grid-content").height((height - extraheight)+"px");
	
	
	// class resizegrid 리사이즈하는 부분
	$(".resizegrid").each(function() {
		var windowHeight = $(window).height();
		var top = $(this).offset().top;

		var result = windowHeight - top - 66;

		$(this).css('max-height', result);
	});
	// class k-auto-scrollable도 같이 리사이즈하는 부분
	
	$(".resizegrid").find(".k-grid-content").each(function() {
		var windowHeight = $(window).height();
		var top = $(this).offset().top;

		var result = windowHeight - top - 103;
		$(this).css('height', result);
	});
	
	//틀고정한 부분
	$(".resizegrid").find(".k-grid-content-locked").each(function() {
		var windowHeight = $(window).height();
		var top = $(this).offset().top;

		var result = windowHeight - top - 103;
		$(this).css('height', result - 15);
	});
}

/**
 * grid 안 내용이 길 경우 ...으로 줄여서 표시(마우스오버시 툴팁표시)
 * @param gridId 선택한 그리드 ID
 * @param incisionNum 표시할 문자열의 길이
 * @param selColArr 선택한 컬럼배열(hidden컬럼 포함)
 * @return 
 */
function gridContentIncision(gridId, incisionNum, selColArr){
	var tdLen = 0;
	$('#'+gridId).find('.k-grid-content, .k-grid-content-locked').each(function(){//locked설정을 하면 테이블이 나뉨
		$(this).find('tr').each(function(row){
			$(this).find('td').each(function(index){
				index += tdLen;
				if( selColArr==undefined || selColArr.indexOf(index)!==-1){	//선택한 열들만 적용이 되도록(선택한 열이 없으면  모든 열에 적용)
					var $td = $(this);
					var content = $td.text().trim();
					if(content.length > incisionNum ) {
						if(row>1){
							var tooltip = "<div class='tooltip'>"
								+"..." + content.substring(content.length, content.length - incisionNum)
								+"<span class='tooltiptext'>"+content+"</span>"
								+"</div>";
							var result = $td.html().replace(genexon.stringToTag(content),tooltip);
							$td.html(result);
							$td.css("overflow", "visible");
						}else{
							var tooltip = "<div class='tooltip_under'>"
								+"..." + content.substring(content.length, content.length - incisionNum)
								+"<span class='tooltiptext_under'>"+content+"</span>"
								+"</div>";
							var result = $td.html().replace(genexon.stringToTag(content),tooltip);
							$td.html(result);
							$td.css("overflow", "visible");
						}
					}
				}
			})
		})
		tdLen += $(this).find('tr').eq(0).find('td').length;
	})
}