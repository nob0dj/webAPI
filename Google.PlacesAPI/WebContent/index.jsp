<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Google - PlacesAPI</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>

</head>
<body>
	<h1>Google - PlacesAPI</h1>
	<button id="btn1">client단 실행(X)</button>
	&nbsp;&nbsp;&nbsp;
	<button id="btn2">server단 실행</button>
	
	
<script>
$(function(){
	$("#btn1").click(function(){
		var param = {
				query: "서울대입구역%20맛집",
				key: "AIzaSyB0ApB7OngxuXN4NkaYwXBGF9-oUaGM47k"
		}
		$.ajax({
			url: "https://maps.googleapis.com/maps/api/place/textsearch/json",
			data: param,
			dataType:'json',
			success: function(data){
				console.log(data);
			},
			error: function (xhr, ajaxOptions, thrownError) {
		        alert(xhr.status);
		        alert(thrownError);
			}	
		})
	});
	
	$("#btn2").click(function(){
		$.ajax({
			url: "${pageContext.request.contextPath}/textSearch",
			dataType: "json",
			success: function(data){
				console.log(data);
			},
			error: function (xhr, ajaxOptions, thrownError) {
		        alert(xhr.status);
		        alert(thrownError);
			}	
		})
	});
});
</script>	
</body>
</html>