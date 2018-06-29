<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello, ws</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/style.css" />
</head>
<body>
	<div id="chat-container">
		<!-- 사이드메뉴바 -->
		<div class="menu-sidebar" id="menu-sidebar">
		  <a href="javascript:menuClose()" id="menu-close"><span style="font-size:30px;">&times;</span></a>
		  <p>접속자수 : <span id="userCount">0</span>명</p>
		  <div class="userList-container">
		  	<ul></ul>
		  </div>
		</div>
		<!-- 사이드메뉴바 overlay -->
		<div class="menu-overlay" onclick="menuClose()" id="menu-overlay"></div>
		<!-- end of 사이드메뉴바 -->
		
		<header>
			<div class="header-col">
				<a href="${pageContext.request.contextPath }" class="btn-back">
					<img src="${pageContext.request.contextPath }/images/back.png" alt="뒤로가기" />
				</a>
			</div>
			<div class="header-col">
				<h3 class="header">Hello, WebSocket</h3>
			</div>
			<div class="header-col">
				<a href="javascript:menuOpen();" class="btn-menu">
					<img src="${pageContext.request.contextPath }/images/menu.png" alt="메뉴" />
				</a>
			</div>
		</header>
		
		<div id="chat">
		  <!-- 테스트메세지 -->
		  <div class="chat-msg chat-msg-from-me">
		    <span class="chat-msg-time">17:55</span>
		    <span class="chat-msg-body">
		      안녕하세요, 내가 보낸 테스트메세지입니다.
		    </span>
		  </div>
		  <div class="chat-msg chat-msg-to-me">
		    <img src="${pageContext.request.contextPath }/images/default-avatar.png" class="chat-msg-avatar">
		    <div class="chat-msg-center">
		      <h3 class="chat-msg-userid">qwerty</h3>
		      <span class="chat-msg-body">
		        반갑습니다, 네게 보내는 메세지입니다.
		      </span>
		    </div>
		    <span class="chat-msg-time">19:35</span>
		  </div>
		</div><!-- end of #chat -->
		
		<div class="type">
			<div class="type-col">
				<a href="javascript:openFile();" class="btn-plus">
					<img src="${pageContext.request.contextPath }/images/plus.png" alt="뒤로가기" />
				</a>
			</div>
			<div class="type-col">
 				<input type="text" id="msg" onkeyup="enterKey(event);" />
				<a href="javascript:send();" class="btn-send">
					<img src="${pageContext.request.contextPath }/images/send.png" alt="뒤로가기" />
				</a>
			</div>
		</div><!-- end of .type -->
	</div>
</body>
</html>