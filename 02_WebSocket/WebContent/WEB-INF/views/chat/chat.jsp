<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello, WebSocket</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
<style>
/*채팅창 최상위 .chat*/
.chat{
	background-color: #a1c0d6;
	width:500px;
	height:700px;
	margin:0 auto;
}
/*채팅메세지 공통*/
/*채팅창은 .chat-msg-from-me와 .chat-msg-to-me로 이루어짐 */
.chat-msg{
	display: flex;
	align-items: flex-end;
    margin-bottom: 10px;
}
.chat-msg-time{
    font-size: 10px;
    color: rgba(0, 0, 0, 0.5);
}
.chat-msg-body{
	padding: 10px 5px;
    border-radius: 5px;
}

/*내가쓴 메세지*/
.chat-msg-from-me{
	justify-content: flex-end;
	margin-right:10px;
}
.chat-msg-from-me .chat-msg-body{
	background-color: #ffe934;
	margin-left: 5px;
}

/*내게 온 메세지*/
.chat-msg-to-me{
	
}
.chat-msg-avatar{
	width: 40px;
    border-radius: 50%;
    background-color: rgb(128,174,207);
    margin: 0 10px;
    align-self: flex-start;
}
.chat-msg-to-me .chat-msg-body{
	background-color: #ffffff;
}
.chat-msg-center{/*사용자아이디+내게온메세지*/
	margin-right:5px;
	display: flex;
    flex-direction: column;
}
.chat-msg-center h3{/*사용자아이디*/
	margin-top:0px;
	margin-bottom:5px;
	font-size: 13px;
}


</style>
</head>
<body>
	<div class="chat">
	  <!-- <div class="date-divider">
	    <span class="date-divider__text">Wednesday, August 2, 2017</span>
	  </div> -->
	  <div class="chat-msg chat-msg-from-me">
	    <span class="chat-msg-time">17:55</span>
	    <span class="chat-msg-body">
	      Hello! This is a test message.
	    </span>
	  </div>
	  <div class="chat-msg chat-msg-to-me">
	    <img src="${pageContext.request.contextPath }/images/default-avatar.png" class="chat-msg-avatar">
	    <div class="chat-msg-center">
	      <h3 class="chat-msg-userid">LYNN</h3>
	      <span class="chat-msg-body">
	        And this is an answer.
	      </span>
	    </div>
	    <span class="chat-msg-time">19:35</span>
	  </div>
	</div>

</body>
</html>