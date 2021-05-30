function leftmenuctl(){
	var leftparent = $('#left_nav > li > a');
	for(var i=0;i<leftparent.length;i++){
		
		$(leftparent[i]).next().slideToggle('fast');
		$(leftparent[i]).addClass('active');
		
		if ($(leftparent[i]).attr('class') == 'active'){
			$(leftparent[i]).find("img").attr("src","/resources/images/common/left_minus.png");
		}else{
			$(leftparent[i]).find("img").attr("src","/resources/images/common/left_plus.png");
			
		}
	}
	
	navctl();
}

function navctl(){
	$("html").toggleClass("openNav");
	$(".nav-toggle").toggleClass("active");
}

function selMainMenu(RESOURCE_ID) {
	$("#left_nav").children("li").each(function(idx) {
		if($(this).attr("id") == RESOURCE_ID) {
			$(this).show();
		}else {
			$(this).hide();
		}
	});
}

$(document).ready(function () {
	//좌측 메뉴 접은? 상태일 때 대메뉴 클릭시 펼쳐지도록
	$("#topmenu > a").click(function(e) {
		var tabID = $(this).attr("id");
		
		//tabID가 없는(하위메뉴가 없는) 데이터 클릭 시 햄버거 버튼 보이고, 하위메뉴가 없는 대메뉴 클릭시는 햄버거 버튼 숨기도록
		if(tabID == "BD_000" || tabID ==  "MA_000" || tabID ==  "IT_100" || tabID == "GP_100") {
			$("button.hamburger").css("display", "none");
		}else {
			$("button.hamburger").css("display", "block");
		}
		
		if($(".hamburger").attr('class').indexOf('active') == -1 && (tabID != "BD_000" && tabID != "IT_100" && tabID != "GP_100")) {
			$(".hamburger").trigger("click");
		}else if($(".hamburger").attr('class').indexOf('active') >= 0 && (tabID == "BD_000" || tabID ==  "MA_000" || tabID ==  "IT_100" || tabID == "GP_100")) {
			$(".hamburger").trigger("click");
		}
	});
	
	$('.nav-toggle').on({click:function(e) {
		e.preventDefault();
		
		if($(this).attr('class').indexOf('active')){
			navctl();
		}else{
			leftmenuctl();
		}
	}});
	
	$('#left_nav > li > a').on({click:function(){
		$(this).next().slideToggle();
		if ($(this).attr('class') == 'active'){
			$(this).find("img").attr("src","/resources/images/common/left_plus.png");
			$(this).removeClass('active');
		}else{
			$(this).find("img").attr("src","/resources/images/common/left_minus.png");
			$(this).addClass('active');
		}
	}});
	
	// nav메뉴
	$(".nav>li").on({mouseenter:function() {
		$(".nav>li").stop().animate(300);
		$(".mainsnb").slideDown(300);
	}});
	$(".mainsnb").on({mouseleave:function() {
		$(".nav>li").find('span').stop().animate({'opacity':0}, 100);
		$(".mainsnb").stop(true, true).slideUp(300);
	}});

	$('.m_mbtn').on({click:function(e){
		$('.m_menu_wrap').show();
		$('body').addClass("scrollOff");
	}});

	$('.close').on({click:function(){
		$('.m_menu_wrap').hide();
	}});
	$('.blaind').on({click:function(e){
		$('.m_menu_wrap').hide();
		$(this).hide(); //블라인드 부분을 클릭하면 모바일메뉴, 블라인드가 사라짐
		$('body').removeClass("scrollOff");
	}});

	$('.m_mbtn').on({
		click:function(){blaind();} // 블라인드 기능
	});

	$('.close').on({click:function(){
		$('.blaind').fadeOut(0,function(){
			$(this).hide();
		});
	}});
	function blaind(){
		$('.blaind').fadeTo(0,0.5);
	};
	
	$('.m_list > li').on({click:function(event){
		$('.m_list > li').removeClass('on');
		$(this).addClass('on');
	}});
	
	// 모바일메뉴(모바일 상담신청)
	$('.callclose').on({click:function(e){
		if($(".callclose").hasClass("on") == true){
			$('.callwrap').hide();
			$('.callclose').removeClass('on');
		}else{
			$('.callwrap').show();
			$('.callclose').addClass('on');
			$('.m_menu_wrap').hide(); //상담신청 창을 열면 모바일 메뉴가 사라짐
			$('.blaind').hide(); //상담신청 창이 열리면 블라인드 부분도 사라짐
		};
	}});

	$('.callclose.on').on({click:function(){
		$('.callwrap').hide();
		$('.callclose').removeClass('on');
	}});

	$('.m_mbtn').on({click:function(e){
		$('.callclose + .callwrap').hide();
		$('.callclose.on').removeClass('on');
	}}); //모바일 메뉴를 클릭하면 상담신청 창이 사라짐
	
	var currentPosition = parseInt($("#slidemenu").css("top"));
    $(window).scroll(function() {
        var position = $(window).scrollTop(); // 현재 스크롤바의 위치값을 반환합니다.
        $("#slidemenu").stop().animate({"top":position+currentPosition+"px"},600);
    });
    
    //화면 최초 로딩 시 중메뉴가 접힌상태로 보이고 좌측 네비게이션은 들어간 상태로 보이도록 수정 - 20.11.30
	//leftmenuctl();		//최초로딩 시 중메뉴 펼쳐지도록
    navctl();				//최초로딩 시 좌측 네비게이션 들어간 상태로
});


//content
//map list

$(document).on('click','.tab_list>li', function(event) {
	$('.tab_list>li:first').removeClass('on');
	$('.tab_list>li').removeClass('on');
	$(this).addClass('on');
});


$(document).on('click','.list_lt>li', function(event) {
	$(this).addClass('on');
});


//map
function initialize( x,y, val, num) {
	var listSize = $('.list_lt > li ').length;
	for(var i =0; i<listSize;i++){
		$('.list_lt  li ').eq(i).removeClass('on');
	}
	$('.list_lt > li ').eq(num).addClass('on');
var markerTitle	= val;				// 현재 위치 마커에 마우스를 오버을때 나타나는 정보
	var markerMaxWidth	= 300;						// 마커를 클릭했을때 나타나는 말풍선의 최대 크기

	// 말풍선 내용
	var contentString = '<div>' +
	'<h2>'+val+' </h2>'+
	//'<a href="http://www.daegu.go.kr" target="_blank">http://www.daegu.go.kr</a>'+ //링크도 넣을 수 있음
	'</div>';


var myLatlng = new google.maps.LatLng(x, y); //좌표값

var mapOptions = {
		zoom: 17,
		center: myLatlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	var map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);

	var marker = new google.maps.Marker({
		position: myLatlng,
		map: map,
		title: markerTitle
	});

	var infowindow = new google.maps.InfoWindow(
		{
			content: contentString,
			maxWidth: 300
		}
	);

	google.maps.event.addListener(marker, 'click', function() {
		infowindow.open(map, marker);
	});

}