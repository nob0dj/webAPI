<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WebSocket</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
<style>
div.input-container{display:none;}
</style>
</head>
<body>
	<div id="container" align="center">
		<h2>WebSocket</h2>
		<a href="javascript:$('.input-container').show();">Hello, WebSocket</a>
		<div class="input-container">
			<input type="text" id="userId" placeholder="접속아이디" /> <button onclick="goChat();">접속</button>
		</div>
		<br />
		<a href="chat/groupChat.do">그룹채팅</a>		
	</div>
<script>
function goChat(){
	
	var userId = $("#userId").val().trim();
	if(userId.length!=0)
		location.href = "${pageContext.request.contextPath}/chat/chat.do?userId="+userId;
}
</script>
</body>
</html>