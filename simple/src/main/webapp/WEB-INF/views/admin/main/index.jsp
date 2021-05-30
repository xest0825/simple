<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!-- ********** 좌측 메뉴 디자인 ********** -->
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link href="/resources/css/style.css" rel="stylesheet">
<script type="text/javascript" src="/resources/js/jquery/plugins.js"></script>
<script type="text/javascript" src="/resources/js/common/appUi-custom.js"></script>
<!-- ********** 좌측 메뉴 디자인 ********** -->
<script type="text/javascript" src="/resources/js/common/tab.js"></script>

<style>
#sessionChkModal {
	display : none;
}
#tabLeft, #tabRight{
	position : absolute;
	z-index : 999;
	background-color : #000;
	margin : 0px;
	display : none;
}
#tabLeft{
	clear : both;
	width : 60px;
}
#tabRight{
	clear : both;
	width : 80px;
}
.insucom span.k-dropdown-wrap{
	margin-right:0px;
	height: 24px !important;
}
.insucom span.k-input{
	font-size: 12px !important;
}
</style>


</head>
<body>
	<c:if test="${DBGubun eq 'dev' }">
		<img src="/resources/images/common/ic_promer.png" class="bypro">
	</c:if>
	<div id="wrap">
		<div id="headerwrap">
			<nav class="gb_gnb">
				<div class="fl">
					<img src="/resources/images/common/ic_1.png" class="mr10"> 
					${session.emp_nm} 님
					<span>(최종 로그인시간 ${session.login_time}) [<span onclick="javascript:sessionExt();" style="cursor: pointer; ">
																<span id="sessionTimer"></span> 연장
															</span>]
					</span>
				</div>
				<div class="fr">
					<div id="changeConcurrent" class="fl insucom" style="padding:5px 15px 0 15px;width:108px"><a href="#" onclick="changeConcurrent()">겸직자 권한변경</a></div>
 					<div class="fl insucom" style="padding:0px;">
						<input type="text" class="kddl" name="insco_homepage" id="insco_homepage" ddcode="INSCO_HOMPAGE" optionLabel="제휴사 홈페이지 바로가기" 
							condDt="use_yn:Y" style="width: 160px;font-size:11px;margin:0px;margin-top: -2px;" />
					</div>
					
					<button class="fl gb022" onclick="Logout();">로그아웃</button>
				</div>
			</nav>
			<nav class="gnb">
				<a href="/index.go"><%-- <img src="${session.logo_url}"> --%><img src="/resources/images/common/logo_hlf.png"></a>
				<div id="topmenu"></div>
			</nav>
		</div><!-- // id="hederwrap" -->
		<div id="tab_bro" class="top_tab">
			<p class="top_tab_2" id="menu_title"></p>
			<div>
				<div style="overflow:hidden;">
					<ul id="tablist" class="top_tab_1">
						<a href="#"><li class="t_sel pr25" id="tabLeft" onClick="javascript:moveTab(50)">&lt;</li></a>
						<a href="#"><li class="t_sel pr25" id="tabRight" onClick="javascript:moveTab(-50)">&gt;</li></a>
					</ul>
				</div>
			</div>
		</div>
		
	</div>
	
	<div id="container">
		<nav role="navigation" class="menu">
			<div class="depth2">
				<button class="hamburger open-panel nav-toggle" style="
						padding-top: 0px;
						padding-right: 0px;
						padding-bottom: 0px;
						padding-left: 0px;
						border-left-width: 0px;
						border-top-width: 0px;
						border-right-width: 0px;
						border-bottom-width: 0px;"></button>
				<ul id="left_nav" style="padding-bottom: 30px;"></ul>
			</div><!-- //class="depth2" -->
		</nav><!-- //role="navigation" class="menu" -->
		<form id="mainFrm" name="mainFrm" method="post">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		</form><!-- // mainFrm -->
		<div class="new-wrapper" style="height: 100%;position:absolute;">
			<div class="content" id="contents" style="padding: 0px;"></div>
			<div id="footer">
				<%-- <p>${session.copy_right}</p> --%>
				<p>Copyright @ 2021 한화생명금융서비스, All Rights Reserved.</p>
		
			</div>
		</div>
	</div><!-- //id="container" -->
	
	<input type="hidden" id="parameterName" value="${_csrf.parameterName}" />
	<input type="hidden" id="token" value="${_csrf.token}" />
		
<script type="text/javascript">
$(document).ready(function() {
	var menuJSON = "";
	
	$.ajax({
		type : "post",
		async : false,
		url : "/menu/getMenuList.ajax",
		data : {"${_csrf.parameterName}" : "${_csrf.token}"},
		dataType : "JSON",
		success : function(result) {
			menuJSON = result.results;
			// console.log('menuJSON===>');
			// console.log(menuJSON);
		},
		error: function(request, status, error){
			
		}
	});
	
	var parentTagItem;
	
	for(var i=0; i<menuJSON.length; i++) {
		var r = menuJSON[i];
		if(r.lv == 1) {//최상위 메뉴
			if(r.isleaf == 1){
				$("#topmenu").append("<a href='#' id='"+r.resource_id+"' class=\'"+r.resource_id+"\ nor' onclick='javascript:selMainMenu(\""+r.resource_id+"\")'>"+r.resource_name+"</a>");
				
				$("#"+r.resource_id).attr("PRNT_RESOURCE_ID" ,r.prnt_resource_id );
        		$("#"+r.resource_id).attr("RESOURCE_ID"  ,r.resource_id  );
                $("#"+r.resource_id).attr("RESOURCE_NAME",r.resource_name);
                
                $("#"+r.resource_id).attr("RESOURCE_URL" ,r.resource_url );
                $("#"+r.resource_id).attr("MENU_PATH"    ,r.menu_path    );
                $("#"+r.resource_id).css("cursor", "pointer");
                
                if(r.resource_url != "NONE") {
                	$("#"+r.resource_id).on("click", function() {
    	        		var RESOURCE_ID   = $(this).attr("RESOURCE_ID"  );
    	                var RESOURCE_NAME = $(this).attr("RESOURCE_NAME");
    	                var RESOURCE_URL  = $(this).attr("RESOURCE_URL" );
    	                var MENU_PATH     = $(this).attr("MENU_PATH"    );
    	                if(RESOURCE_ID == undefined )  return;
    	        		if(RESOURCE_ID == "SP_200"){
    	        		    window.open("https://www.factfinder.me");
    	        		}else if(RESOURCE_ID == "IT_100") {
    	        			window.open(RESOURCE_URL, "_blank");
    	        		}else {
    	                	addTab(RESOURCE_ID,RESOURCE_NAME,RESOURCE_URL,MENU_PATH, 'Y');
    	        		}
    	        	});
                }
			}else{
				var addTabHtml = "";
				
				//$("#topmenu").append("<a href='#' class=\'"+r.resource_id+"\ nor' onclick='javascript:selMainMenu(\""+r.resource_id+"\"); leafMenuOpen(\""+r.resource_id+"\")'>"+r.resource_name+"</a>");
				$("#topmenu").append("<a href='#' class=\'"+r.resource_id+"\ nor' onclick='javascript:selMainMenu(\""+r.resource_id+"\")'>"+r.resource_name+"</a>");
			}
		
			$("#left_nav").append("<li id=\'"+r.resource_id+"\' style='display:none;'></li>")
			$("."+r.resource_id).on("click", function(){
				$("#menu_title").html($(this).text()+" <img src='/resources/images/common/ic_4.png'/>")
				$(this).parent().children().each(function(idx){
					$(this).addClass("nor");
					$(this).removeClass("sel");
				});
				
				$(this).removeClass("nor");
				$(this).addClass("sel");
			});
		}else if(r.lv == 2) {
			$("#"+r.prnt_resource_id).addClass("menulist_"+r.lv);
			if(r.isleaf == 1){
				$("#"+r.prnt_resource_id).append("<a id='"+r.resource_id+"' href='#'>"+r.resource_name+"</a><ul id="+r.resource_id+"_"+r.lv+" ></ul>");
			}else{
				$("#"+r.prnt_resource_id).append("<a id='"+r.resource_id+"' href='#'><img src='/resources/images/common/left_plus.png' class='fl'>&nbsp;"+r.resource_name+"</a><ul id="+r.resource_id+"_"+r.lv+" ></ul>");
			}
    	}else if(r.lv == 3) {
    		$("#"+r.prnt_resource_id+"_"+(r.lv-1)).append("<li id='"+r.resource_id+"' class='menulist_"+r.lv+"'><a id='over3'>- "+r.resource_name+"<a></li>");
    		$(".menulist_3 a").not("#over3").remove();
    	}
		
		if(r.lv != 1 && r.resource_url != "NONE" && r.resource_url != "" && r.resource_id != undefined) {
			if(r.resource_id.indexOf("BB_") == 0) {
        		$("#"+r.resource_id).attr("PRNT_RESOURCE_ID" ,'BD_000' );
        		$("#"+r.resource_id).attr("RESOURCE_ID"  , 'BB_0'  );
                $("#"+r.resource_id).attr("RESOURCE_NAME", '게시판');
    		} else {
    			if(r.lv == 3) {
    				parentTagItem = $("#"+r.prnt_resource_id+"_"+(r.lv-1));
    			}else {
    				parentTagItem = $("#"+r.prnt_resource_id);
    			}
    			
    			parentTagItem.find("#"+r.resource_id).attr("PRNT_RESOURCE_ID" ,r.prnt_resource_id );
				parentTagItem.find("#"+r.resource_id).attr("RESOURCE_ID"  ,r.resource_id  );
				parentTagItem.find("#"+r.resource_id).attr("RESOURCE_NAME",r.resource_name);
    		}
			
			parentTagItem.find("#"+r.resource_id).attr("RESOURCE_URL" ,r.resource_url );
			parentTagItem.find("#"+r.resource_id).attr("MENU_PATH"    ,r.menu_path    );
			parentTagItem.find("#"+r.resource_id).css("cursor", "pointer");
            
			parentTagItem.find("#"+r.resource_id).on("click", function() {
        		var RESOURCE_ID   = $(this).attr("RESOURCE_ID"  );
                var RESOURCE_NAME = $(this).attr("RESOURCE_NAME");
                var RESOURCE_URL  = $(this).attr("RESOURCE_URL" );
                var MENU_PATH     = $(this).attr("MENU_PATH"    );
                if(RESOURCE_ID == undefined )  return;
        		if(RESOURCE_ID == "SP_200"){
        		    window.open("https://www.factfinder.me");
        		}else {
                	addTab(RESOURCE_ID,RESOURCE_NAME,RESOURCE_URL,MENU_PATH, 'Y');
        		}
        	});
		}
	}
	
	resizecontents();
    
    $("#contents").kendoTabStrip({
        dataTextField: "text",
        dataContentField: "content",
        dataSource: tabList,
        animation: {
            close: {
                duration: 250, // (millisec)
                effects: "fadeOut"
            },
           open: {
               duration: 250, // (millisec)
               effects: "fadeIn"
           }
       }
    });
    $(".k-tabstrip-items").hide();
    
    //보험사 바로가기 변경 시
    $("#insco_homepage").data("kendoDropDownList").bind("change", goInsco);

    // 메인페이지
	addMain("${session.role_id}", "${session.mb_id}");
    
	resizecontainer();
	
	$(window).resize(function() { 
		tapSize();
	});

	// 권한사원변경(슈퍼관리자, 관리자)
	var loginRole = "${session.role_id}";
 	if(loginRole.indexOf("ROLE_0") == -1 && loginRole.indexOf("ROLE_1") == -1) {
 		if("${session.demo_user}" != null && "${session.demo_user}" != "") {
	 		$("#changeEmp").text("권한복구");
 		} else {
	 		$("#changeEmp").remove();
 		}
 	} else {
 		if("${session.demo_user}" != null && "${session.demo_user}" != "") {
	 		$("#changeEmp").text("권한복구");
		} else {
 	 		$("#changeEmp").text("권한사원변경");
 		}
 	}

	if("${session.error_message}" != null && "${session.error_message}" != "") {
		alert("${session.error_message}");
	}
	
 	// 겸직자 권한변경(겸직자)
	var concurrentRole = "${session.concurrent_gubun}";
 	if(concurrentRole > 1) {
 	} else {
 		$("#changeConcurrent").remove();
 	}
});
 
// 세션 연장
function sessionExt() {
	sessionExtension("${_csrf.parameterName}=${_csrf.token}")
}

// 세션 만료
function sessionExp() {
	sessionExpiration("${_csrf.parameterName}=${_csrf.token}")
}

// 권한사원변경
function changeEmp() {
	var gubun = $("#changeEmp").text();
	if(gubun == "권한복구"){
		$.ajax({
			 type : 'POST',
	         url : '/index.go?${_csrf.parameterName}=${_csrf.token}',
	         data : "mb_id=${session.mb_id}&user_id=${session.demo_user}&concurrent_idx=1",
	         complete : function(){
	        	 parent.location.reload(true);
	         }
		});
	}else{
		genexon.PopWindowOpen({ pID    : "change_empRole"
	        , pTitle : "권한사원 변경"
	        , pURL   : "/insa/popup/empSrchRolePop.pop?${_csrf.parameterName}=${_csrf.token}"
	        , pWidth : 1200
	        , pHeight: 520
	        , pModal : true
	        , resizable : true
	      });
	}
}

// 겸직자 권한변경
function changeConcurrent() {
	genexon.PopWindowOpen({ pID    : "change_concurrent"
        , pTitle : "겸직자 권한변경"
        , pURL   : "/userRole/empSrchConcurrentPop.pop?${_csrf.parameterName}=${_csrf.token}"
        , data   : { emp_cd : "${session.emp_cd}" }
        , pWidth : 450
        , pHeight: 320
        , pModal : true
        , resizable : true
      });
}

// 비밀번호변경
function changeAccountPwd() {
	genexon.PopWindowOpen(
	{ pID    : "change_account_pwd"
    , pTitle : "비밀번호 변경"
    , pURL   : "/system/userAccountManage/passwordPop.pop?${_csrf.parameterName}=${_csrf.token}"
    , pWidth : 500
    , pHeight: 220
    , pModal : true
    , resizable : true
    });
}

/* 보험사바로가기 */
function goInsco(e) {
	if(e.sender.selectedIndex != 0) {
		window.open($("#insco_homepage").val());
	}
}

//하위메뉴 오픈
function leafMenuOpen(resource_id) {
	$("#left_nav").find("#"+resource_id).children().eq(0).trigger("click");
}

</script>
<script type="text/javascript" src="/resources/js/common/leftmenu.js"></script>
</body> 
</html>
