<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//세션의 로그인한 사용자가 유효하지 않다면, 다시 loggin페이지로 리다이렉트함.
	if(session.getAttribute("userLoggedIn")==null)
		response.sendRedirect(request.getContextPath()+"/ServerSentEvents/login.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SSE - 로그인</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
<script>
function logout(){
	location.href = "${pageContext.request.contextPath}/sse/logout.do";
}
</script>
<style>
table, th, td{border:1px solid;}
</style>
</head>
<body>
	<h2>로그인</h2>
	${userLoggedIn.userName}님, 환영합니다. 
	<input type="button" value="LOGOUT" onclick="logout();" />
	<hr />
	<h3>현재 로그인한 사용자목록</h3>
	<button id="start">현재로그인한 사용자 목록보기</button> 
	<button id="end">그만보기</button>
	<div id="user-container"></div>
	<script>
	$(function(){
		var source;
		$("#start").click(function(){
			if (window.EventSource) {
			  source = new EventSource('${pageContext.request.contextPath}/sse/loggedInUserList.do');
			  
			  source.addEventListener("open",function(e){
				console.log("onopen event!");  
			  });
			  
			  source.addEventListener("message",function(e){
				console.log("onmessage event!");
				//json파싱
				var userArr = JSON.parse(e.data);
				var table = $("<table></table>");
				table.append("<tr><th>아이디</th><th>이름</th><th>주소</th></tr>");

				for(var i in userArr){
					var u = userArr[i];
					var html = "<tr><td>"+u.userId+"</td>";
					html += "<td>"+u.userName+"</td>";
					html += "<td>"+u.userAddr+"</td></tr>";
					table.append(html);
				}
				
				$("#user-container").html(table);
				
			  });
			  source.addEventListener("error", function(e){
				  
				  if (e.readyState == EventSource.CLOSED) {
					//CONNECTING:0, OPEN:1, CLOSED:2
				  	// Connection was closed.
			  		console.log("connection closed!");  
				  }
			  });
			  
			} else {
			  // Result to xhr polling :(
			}
		});
		
		$("#end").click(function(){
			console.log("connection closing...");
			source.close();
			$("#user-container").empty();
		});
	});
	</script>
</body>
</html>