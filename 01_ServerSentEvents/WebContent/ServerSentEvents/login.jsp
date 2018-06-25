<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SSE - 로그인</title>
</head>
<body>
	<h2>로그인</h2>
	<form action="${pageContext.request.contextPath}/sse/login.do" method="post">
	<input type="text" name="userId" id="userId" placeholder="아이디"/>
	<input type="submit" value="LOGIN" />
	</form>
</body>
</html>