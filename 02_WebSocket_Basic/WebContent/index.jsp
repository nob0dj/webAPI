<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WebSocket</title>
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
<style>
div.input-container{display:none;}
div#user-cheatsheet ul{list-style:none; padding:10px 0 0 0 ; color:lightgray;}
</style>
</head>
<body>
	<h2><a href="javascript:$('.input-container:eq(0)').show().find('#userId').focus();">Hello WebSocket</a></h2>
	<div class="input-container">
		<input type="text" id="userId" placeholder="접속아이디" /> <button onclick="goChat();">접속</button>
	</div>		
<script>
function goChat(){
	
	var userId = $("#userId").val().trim();
	if(userId.length!=0)
		location.href = "${pageContext.request.contextPath}/chat/chatRoom.chat?userId="+userId;
}
</script>
</body>
</html>