//footer
// $(function(){

// 	$('.sele p').click(function(e){
// 		if($(".sele p").hasClass("on") == true){
// 			$('.sele ul').hide();
// 			$('.sele p').removeClass('on');
// 		}else{
// 			$('.sele ul').show();
// 			$('.sele p').addClass('on');
// 		};
// 	});

// 	$('.sele li').click(function(){
// 		$('.sele ul').hide();
// 		$('.sele p').removeClass('on');
// 	});

// })
// 계열사 사이트 슬라이드


//top



$(function(){

	$(".nav>li").mouseenter( function() {
		$(".nav>li").stop().animate(300);
		$(".mainsnb").slideDown(300);
	});
	$(".mainsnb").mouseleave( function() {
		$(".nav>li").find('span').stop().animate({'opacity':0}, 100);
		$(".mainsnb").stop(true, true).slideUp(300);
	});
}); // nav메뉴


$(function(){
	$('.m_mbtn').click(function(e){
		$('.m_menu_wrap').show();
		$('body').addClass("scrollOff");
	});

	$('.close').click(function(){
		$('.m_menu_wrap').hide();
	});
	$('.blaind').click(function(e){
		$('.m_menu_wrap').hide();
		$(this).hide(); //블라인드 부분을 클릭하면 모바일메뉴, 블라인드가 사라짐
		$('body').removeClass("scrollOff");
	});

	$('.m_mbtn').on({
		click:function(){blaind();} // 블라인드 기능
	});

	$('.close').click(function(){
		$('.blaind').fadeOut(0,function(){
			$(this).hide();
		});
	});
	function blaind(){
		$('.blaind').fadeTo(0,0.5);
	};

})

$(function(){
	$('.m_list > li').click(function(event){
		$('.m_list > li').removeClass('on');
		$(this).addClass('on');
	});
});

// 모바일메뉴


$(function(){

	$('.callclose').click(function(e){
		if($(".callclose").hasClass("on") == true){
			$('.callwrap').hide();
			$('.callclose').removeClass('on');
		}else{
			$('.callwrap').show();
			$('.callclose').addClass('on');
			$('.m_menu_wrap').hide(); //상담신청 창을 열면 모바일 메뉴가 사라짐
			$('.blaind').hide(); //상담신청 창이 열리면 블라인드 부분도 사라짐
		};
	});

	$('.callclose.on').click(function(){
		$('.callwrap').hide();
		$('.callclose').removeClass('on');
	});

	$('.m_mbtn').click(function(e){
		$('.callclose + .callwrap').hide();
		$('.callclose.on').removeClass('on');
	}) //모바일 메뉴를 클릭하면 상담신청 창이 사라짐
}) // 모바일 상담신청


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

  /* ==================== POPUP ==================== */ 


function popupOpenClose(popup) {
  
  /* Add div inside popup for layout if one doesn't exist */
  if ($(".wrapper").length == 0){
    $(popup).wrapInner("<div class='wrapper'></div>");
  }
  
  /* Open popup */
  $(popup).show();

  /* Close popup if user clicks on background */
  $(popup).click(function(e) {
    if ( e.target == this ) {
      if ($(popup).is(':visible')) {
        $(popup).hide();
      }
    }
  });

  /* Close popup and remove errors if user clicks on cancel or close buttons */
  $(popup).find("button[name=close]").on("click", function() {
    if ($(".formElementError").is(':visible')) {
      $(".formElementError").remove();
    }
    $(popup).hide();
  });
}

$(document).ready(function () {
  $("[data-js=open1]").on("click", function() {
    popupOpenClose($(".popup1"));
  });
});


$(document).ready(function () {
  $("[data-js=open2]").on("click", function() {
    popupOpenClose($(".popup2"));
  });
});

$(document).ready(function () {
  $("[data-js=open3]").on("click", function() {
    popupOpenClose($(".popup3"));
  });
});

