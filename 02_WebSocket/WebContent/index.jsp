<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.kh.ws.common.UserListSingletone, java.util.*, com.kh.ws.model.vo.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	List<User> list = UserListSingletone.getInstance().getUserList();
	pageContext.setAttribute("list", list);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WebSocket</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
<style>
div.input-container{display:none;}
div#user-cheatsheet ul{list-style:none; padding:10px 0 0 0 ; color:lightgray;}
</style>
</head>
<body>
	<h2>Hello WebSocket</h2>
	<ol>
		<li>
			<a href="javascript:$('.input-container:eq(0)').show();$('#userId').focus();">Hello, WebSocket</a>
			<div class="input-container">
				<input type="text" id="userId" placeholder="접속아이디" /> <button onclick="goChat();">접속</button>
			</div>			
		</li>
		<li>
			<a href="javascript:void(0);" onclick="$('.input-container:eq(1)').show().find(':text').focus();">그룹채팅</a>
			<div class="input-container">
				<form action="groupChat/login.chat" method="post">
	                <input type="text" name="userId" placeholder="아이디" required/> <br /> 
	                <input type="password" name="password" placeholder="비밀번호" required/><br />
	                <button type="submit">로그인</button>
	            </form>
	            <div id="user-cheatsheet">
	            	<ul>
	            	<c:forEach items="${list }" var="u">
	            		<li>${u.userId } : ${u.password }</li>
	            	</c:forEach>
	            	</ul>
	            </div>
			</div>		
		</li>
	</ol>		
<script>
function goChat(){
	
	var userId = $("#userId").val().trim();
	if(userId.length!=0)
		location.href = "${pageContext.request.contextPath}/chat/chatRoom.chat?userId="+userId;
}
</script>
</body>
</html>