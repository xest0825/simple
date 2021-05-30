<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<ul id="imageTable" class="main_box01">
	<li>
		<c:choose>
			<c:when test="${empty resultList }">
				<img alt='image1' id='image1' name='image' class='imgsty01'>
			</c:when>
			<c:otherwise>
				<c:if test="${fn:length(resultList) eq 1 }">
					<img id='image1' name='image' src="${resultList[0].file_url }" class="imgsty01" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
				</c:if>
				<c:if test="${fn:length(resultList) eq 2 }">
					<img id='image1' name='image' src="${resultList[0].file_url }" class="imgsty02" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image2' name='image' src="${resultList[1].file_url }" class="imgsty02" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
				</c:if>
				<c:if test="${fn:length(resultList) eq 3 }">
					<img id='image1' name='image' src="${resultList[0].file_url }" class="imgsty03" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image2' name='image' src="${resultList[1].file_url }" class="imgsty03" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image3' name='image' src="${resultList[2].file_url }" class="imgsty03" <c:if test="${resultList[2].link_url ne ''}">onclick="goLinkPage('${resultList[2].link_url }')" style="cursor: pointer;"</c:if>>
				</c:if>
				<c:if test="${fn:length(resultList) eq 4 }">
					<img id='image1' name='image' src="${resultList[0].file_url }" class="imgsty04" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image2' name='image' src="${resultList[1].file_url }" class="imgsty04" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image3' name='image' src="${resultList[2].file_url }" class="imgsty04" <c:if test="${resultList[2].link_url ne ''}">onclick="goLinkPage('${resultList[2].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image4' name='image' src="${resultList[3].file_url }" class="imgsty04" <c:if test="${resultList[3].link_url ne ''}">onclick="goLinkPage('${resultList[3].link_url }')" style="cursor: pointer;"</c:if>>
				</c:if>
				<c:if test="${fn:length(resultList) eq 5 }">
					<img id='image1' name='image' src="${resultList[0].file_url }" class="imgsty06" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image2' name='image' src="${resultList[1].file_url }" class="imgsty06" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image3' name='image' src="${resultList[2].file_url }" class="imgsty06" <c:if test="${resultList[2].link_url ne ''}">onclick="goLinkPage('${resultList[2].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image4' name='image' src="${resultList[3].file_url }" class="imgsty06" <c:if test="${resultList[3].link_url ne ''}">onclick="goLinkPage('${resultList[3].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image5' name='image' src="${resultList[4].file_url }" class="imgsty03" <c:if test="${resultList[4].link_url ne ''}">onclick="goLinkPage('${resultList[4].link_url }')" style="cursor: pointer;"</c:if>>
				</c:if>
				<c:if test="${fn:length(resultList) eq 6 }">
					<img id='image1' name='image' src="${resultList[0].file_url }" class="imgsty06" <c:if test="${resultList[0].link_url ne ''}">onclick="goLinkPage('${resultList[0].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image2' name='image' src="${resultList[1].file_url }" class="imgsty06" <c:if test="${resultList[1].link_url ne ''}">onclick="goLinkPage('${resultList[1].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image3' name='image' src="${resultList[2].file_url }" class="imgsty06" <c:if test="${resultList[2].link_url ne ''}">onclick="goLinkPage('${resultList[2].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image4' name='image' src="${resultList[3].file_url }" class="imgsty06" <c:if test="${resultList[3].link_url ne ''}">onclick="goLinkPage('${resultList[3].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image5' name='image' src="${resultList[4].file_url }" class="imgsty06" <c:if test="${resultList[4].link_url ne ''}">onclick="goLinkPage('${resultList[4].link_url }')" style="cursor: pointer;"</c:if>>
					<img id='image6' name='image' src="${resultList[5].file_url }" class="imgsty06" <c:if test="${resultList[5].link_url ne ''}">onclick="goLinkPage('${resultList[5].link_url }')" style="cursor: pointer;"</c:if>>
				</c:if>
			</c:otherwise>
		</c:choose>
	</li>
</ul>