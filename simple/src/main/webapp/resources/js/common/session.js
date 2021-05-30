/* 세션 유지 시간 제어 변수 */
var sHour; // 시간 지정 시간
var sMinute; // 시간 지정 분
var sSecond; // 초단위로 환산
var sTimerchecker = null;

// 세션 연장
function sessionExtension(data) {
	if(data != null && data != "" && data != undefined) {
		$("#sessionChkModal").kendoWindow({
			title : "로그인 연장",
			resizable : false
		}).data("kendoWindow").close();
		
		$.ajax({
			type : "post",
			url : "/main/sessionExtension.ajax?"+data,
			dataType : "JSON",
			success : function(e) {
				var sessionTime = e.SESSION_TIME;

				clearInterval(sTimerchecker);
				
				sMinute = sessionTime;
				sHour = sessionTime / 60;
				sSecond = sMinute * 60;
				
				sTimerchecker = setInterval(initTimer, 1000);
			}
		});
 	}
}

// 세션 만료
function sessionExpiration(data) {
	if(data != null && data != "" && data != undefined) {
		$("#sessionChkModal").kendoWindow().data("kendoWindow").close();
		clearInterval(sTimerchecker);
		Logout();
	}
}

/* 세션 타이머 초기화 */
initTimer = function() {
	rHour = parseInt(sSecond / 60 / 60);
	rMinute = parseInt((sSecond / 60) % 60);
	rSecond = sSecond % 60;
	
	if(sSecond > 0) {
		sessionTimer.innerHTML = '<span></span>'+ genexon.lpad(rHour, 2, "0") + ":" + genexon.lpad(rMinute, 2, "0") + ":" + genexon.lpad(rSecond, 2, "0");
		sSecond--;
	}
    
	// sSecond로 if문에 조건을 걸면 우측 상단의 시계가 1분 1초일때 modal창이 켜져서 계산되는 값으로
	if(rHour == 0 && rMinute == 1 && rSecond == 0) {
		$("#sessionChkModal").kendoWindow({
			title : "로그인 연장",
			resizable : false
		}).data("kendoWindow").center().open();
	}
    
	//타이머 0시 0분 0초면 로그아웃 시킴
	if(rHour == 0 && rMinute == 0 && rSecond <= 0) {
		sessionExp();
	}
}

function Logout(){
	window.location.href="/logout.do";
}