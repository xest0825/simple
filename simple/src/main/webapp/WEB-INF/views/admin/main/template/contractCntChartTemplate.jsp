<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/resources/common/jstl-tld.jsp"%>
<!--
#########################################################################################
	작성자 : KIMDONGUK
	최초작성일자 : 2019. 09. 19
	화면 설명 : 보유계약 건수 차트형 템플릿
######################################################################################### 
 -->
<html>
<head>
<link rel="stylesheet" href="/resources/css/main.css" />
<style type="text/css">
.main_box01 {
	width: 100%;
	display: block;
	height: 300px;
	margin-left: 0px !important;
}

.overlay {
	font: 17px sans-serif;
	font-weight: bold;
	color: #000000;
	position: absolute;
	text-align: center;
	top: 89px;
	left: 114px;
	display: inline-block;
}
</style>
<script type="text/javascript">
$(document).ready(function(e){
	
})
</script>
</head>
<body>
	<ul class="main_box01">
		<li>
			<c:choose>
				<c:when test="${fn:contains(MainTemplateVO.template_code, 'FC_CNT') }">
					<p>보유계약 현황(FC)</p>
				</c:when>
				<c:when test="${fn:contains(MainTemplateVO.template_code, 'ORG_CNT') }">
					<p>보유계약 현황(조직)</p>
				</c:when>
				<c:when test="${fn:contains(MainTemplateVO.template_code, 'TOTAL_CNT') }">
					<p>보유계약 현황(회사)</p>
				</c:when>
			</c:choose>
			<span class="ttxt01">(단위 : 건)</span>
			<div style="height: 85%;">
				<div id="chart" style="height: 221px;"></div>
			</div>
			<script>
				var center;
				var radius;
			
				$("#chart").kendoChart({
					legend: {
						visible: true,
						position: "bottom"
					},
					seriesDefaults: {
	                    type: "donut",
	                    startAngle: 90,
	                    holeSize: 35,
	                    labels: {
	                        visible: true,
	                        position: "center",
	                        background: "transparent",
	                        font: "16px sans-serif",
	                        color: "#ffffff"
	                    },
                        background: "transparent"
	                },
	                chartArea: {
	                	background: "transparent"
	                },
	                series: [
	                	{
	                		size: 55,
	                		data: [
		                    	{
			                        category: "${resultList[1].cont_status}",	/* 정상 */
			                        value: ${resultList[1].cont_cnt},
			                        color: "#0063b8"
			                    },
			                    {
			                        category: "${resultList[2].cont_status}",	/* 연체 */
			                        value: ${resultList[2].cont_cnt},
			                        color: "#25b9f7"
			                    },
			                    {
			                        category: "${resultList[3].cont_status}",	/* 실효 */
			                        value: ${resultList[3].cont_cnt},
			                        color: "#9fd5f9"
			                    }
	                    	],
	                        visual: function(e) {
	                        	center = e.center;
	                        	radius = e.radius;

	                        	return e.createVisual();
	                        }
	                	}
	                ],
	                tooltip: {
	                    visible: true,
	                    template: "#= category # - #= value #",
	                    color: "white"
	                },
	                render: function(e) {
	                	var draw = kendo.drawing;
	                    var geom = kendo.geometry;
	                    var chart = e.sender;
	                    var text = "${resultList[0].cont_cnt}";

	                    var circleGeometry = new geom.Circle(center, radius);
	                    var bbox = circleGeometry.bbox();

	                    var text = new draw.Text(text, [0, 0], {
	                    	font: "bold 17px sans-serif"
	                    });

	                    draw.align([text], bbox, "center");
	                    draw.vAlign([text], bbox, "center");

	                    e.sender.surface.draw(text);
	                }
				});
			</script>
		</li>
	</ul>
</body>
</html>