<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<html>
<head>
<style type="text/css">
.main_box01 {
	width: 100%;
	display: block; /*margin:0 auto ;*/
	height: 300px;
}

.main_box01 li {
	width: 300px;
	height: 300px;
	background: #f6f6f6;
	float: left;
	margin-right: 25px;
	box-sizing: border-box;
	border: 1px solid #fff;
	border-radius: 2px;
}

.imgsty01 {border-radius: 2px; width: 300px; height: 300px;}
.imgsty02 {border-radius: 2px; width: 300px; height: 150px;}
.imgsty03 {border-radius: 2px; width: 300px; height: 100px;}
.imgsty04 {border-radius: 2px; width: 145px; height: 150px;}
.imgsty06 {border-radius: 2px; width: 145px; height: 100px;}
</style>
<script type="text/javascript">
function goLinkPage(link_url) {
	var url = link_url.replace(/#|http:\/\//g, "");
	
	if(genexon.nvl(link_url, "") == "") {
		return;
	}else {
		if(link_url.indexOf("https") != -1) {
			window.open(link_url, "_blank");
		}else {
			link_url = "http://"+link_url;
			window.open(link_url, "_blank");
		}
	}
}
</script>
</head>
<body>
	<ul class="main_box01">
		<li>
			<c:if test="${fn:length(resultList) eq 1 }">
				<img src="${resultList[0].file_url }" class="imgsty01" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
			</c:if>
			<c:if test="${fn:length(resultList) eq 2 }">
				<img src="${resultList[0].file_url }" class="imgsty02" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[1].file_url }" class="imgsty02" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
			</c:if>
			<c:if test="${fn:length(resultList) eq 3 }">
				<img src="${resultList[0].file_url }" class="imgsty03" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[1].file_url }" class="imgsty03" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[2].file_url }" class="imgsty03" <c:if test="${resultList[2].link_url ne ''}">onclick="goLinkPage('${resultList[2].link_url }')" style="cursor: pointer;"</c:if>>
			</c:if>
			<c:if test="${fn:length(resultList) eq 4 }">
				<img src="${resultList[0].file_url }" class="imgsty04" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[1].file_url }" class="imgsty04" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[2].file_url }" class="imgsty04" <c:if test="${resultList[2].link_url ne ''}">onclick="goLinkPage('${resultList[2].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[3].file_url }" class="imgsty04" <c:if test="${resultList[3].link_url ne ''}">onclick="goLinkPage('${resultList[3].link_url }')" style="cursor: pointer;"</c:if>>
			</c:if>
			<c:if test="${fn:length(resultList) eq 5 }">
				<img src="${resultList[0].file_url }" class="imgsty06" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[1].file_url }" class="imgsty06" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[2].file_url }" class="imgsty06" <c:if test="${resultList[2].link_url ne ''}">onclick="goLinkPage('${resultList[2].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[3].file_url }" class="imgsty06" <c:if test="${resultList[3].link_url ne ''}">onclick="goLinkPage('${resultList[3].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[4].file_url }" class="imgsty03" <c:if test="${resultList[4].link_url ne ''}">onclick="goLinkPage('${resultList[4].link_url }')" style="cursor: pointer;"</c:if>>
			</c:if>
			<c:if test="${fn:length(resultList) eq 6 }">
				<img src="${resultList[0].file_url }" class="imgsty06" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[1].file_url }" class="imgsty06" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[2].file_url }" class="imgsty06" <c:if test="${resultList[2].link_url ne ''}">onclick="goLinkPage('${resultList[2].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[3].file_url }" class="imgsty06" <c:if test="${resultList[3].link_url ne ''}">onclick="goLinkPage('${resultList[3].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[4].file_url }" class="imgsty06" <c:if test="${resultList[4].link_url ne ''}">onclick="goLinkPage('${resultList[4].link_url }')" style="cursor: pointer;"</c:if>>
				<img src="${resultList[5].file_url }" class="imgsty06" <c:if test="${resultList[5].link_url ne ''}">onclick="goLinkPage('${resultList[5].link_url }')" style="cursor: pointer;"</c:if>>
			</c:if>
		</li>
	</ul>
</body>