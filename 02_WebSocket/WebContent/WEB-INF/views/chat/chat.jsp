<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello, ws</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
<style>
/*채팅창 최상위 .chat*/
#chat-container{
	width:500px;
	margin:0 auto;
}

/*HEADER*/
header{
	display: flex;
    justify-content: space-between;
    border-bottom: .5px solid rgba(0, 0, 0, 0.5);
    background-color: #a1c0d6;
}
.header-col{
	align-self: center;
}
.header-col a.btn-back img{
	width:45px;
	
}
.header-col h3{

}
.header-col a.btn-menu img{
	width:45px;
}
/*CHAT*/
#chat{
	background-color: #a1c0d6;
	
	height:600px;
	padding-top:10px
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
/* 구분자 : 입장/퇴장 메세지 */
.divider{
	text-align: center;
    font-size: 12px;
    color: rgba(0, 0, 0, 0.5);
	margin-top:20px;
	margin-bottom:10px;
	border-top:0.5px solid;
}
.divider span{
    padding: 0.1em 0.5em;
	line-height: 0;
    position: relative;
    top: -0.6em;
    background: #a1c0d6;/*바탕화면과 동일한 컬러*/
}

/* TYPE */
.type{
	display: flex;
    justify-content: space-around;
    padding: 5px;
    background: #eeeeee;
}
.type-col{
	position: relative;
}
.type-col a.btn-plus img{
	width:40px;
}
.type-col input{
	width: 440px;
    height: 40px;
    border-radius: 18px;
    border: .7px solid rgba(0, 0, 0, 0.3);
}
.type-col a.btn-send{
    position: absolute;
    right: 3px;
    top: 1.5px;
}
.type-col a.btn-send img{
	width:40px;
	background-color: #ffe934;
	border-radius: 50%;
}
</style>
</head>
<body>
	<div id="chat-container">
		<header>
			<div class="header-col">
				<a href="#" class="btn-back">
					<img src="${pageContext.request.contextPath }/images/back.png" alt="뒤로가기" />
				</a>
			</div>
			<div class="header-col">
				<h3 class="header">Hello, WebSocket</h3>
			</div>
			<div class="header-col">
				<a href="#" class="btn-menu">
					<img src="${pageContext.request.contextPath }/images/menu.png" alt="메뉴" />
				</a>
			</div>
		</header>
		<div id="chat">
		  <!-- <div class="date-divider">
		    <span class="date-divider__text">Wednesday, August 2, 2017</span>
		  </div> -->
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
				<a href="#" class="btn-plus">
					<img src="${pageContext.request.contextPath }/images/plus.png" alt="뒤로가기" />
				</a>
			</div>
			<div class="type-col">
 				<input type="text" id="msg" onkeyup="enterKey(event);" />
				<a href="javascript:send();" class="btn-send">
					<img src="${pageContext.request.contextPath }/images/send.png" alt="뒤로가기" />
				</a>
			</div>
			
		</div>
	</div>
<script>
var host = location.host;//localhost이거나, 서버컴퓨터 ip주소를 담아둠.
var ws = new WebSocket('ws://'+ host +'${pageContext.request.contextPath}/helloWebSocket.chat');

//웹 소켓을 통해 연결이 이루어 질 때 동작할 메소드
ws.onopen = function(event){
	onOpen(event);
};

// 서버로부터 메시지를 전달 받을 때 동작하는 메소드
ws.onmessage = function(event){
	onMessage(event);
}

// 서버에서 에러가 발생할 경우 동작할 메소드
ws.onerror = function(event){
	onError(event);
}

// 서버와의 연결이 종료될 경우 동작하는 메소드
ws.onclose = function(event){
	onClose(event);
}

function onOpen(e){
	//채팅시작메세지
	$("#chat").append("<div class='divider'><span>[${userId}]로 접속하셨습니다.</span></div>");

}
function onMessage(e){
	console.log(e.data);

	var msgArr = e.data.split("§");
	var type = msgArr[0];
	var sender = msgArr[1];
	var msg = msgArr[2];
	var date = new Date(Number(msgArr[3]));
	var time = getTimeStr(date);

	if(type==="message"){
		/* 받은 메세지 */
		var html = '<div class="chat-msg chat-msg-to-me">';
		html += '<img src="${pageContext.request.contextPath }/images/default-avatar.png" class="chat-msg-avatar">';
	    html += '<div class="chat-msg-center">';
	    html += '<h3 class="chat-msg-userid">'+sender+'</h3>';
	    html += '<span class="chat-msg-body">'+msg+'</span>';
	    html += '</div>';
	    html += '<span class="chat-msg-time">'+time+'</span>';
	  	html += '</div>';
	  	$("#chat").append(html);
	}
	else if(type==="welcome"){
		$("#chat").append("<div class='divider'><span>["+sender+"]님이 입장하셨습니다.</span></div>");
	}
	else if(type==="adieu"){
		$("#chat").append("<div class='divider'><span>["+sender+"]님이 퇴장하셨습니다.</span></div>");
	}
}
function onError(e){
	
}
function onClose(e){
	
}
function send(){
	var msg = $("#msg").val().trim();
	console.log(msg);
		
	if(msg.length==0) return;

	var date = new Date();
	var time = getTimeStr(date);
	
	/*전송할 메세지 */
	var html = '<div class="chat-msg chat-msg-from-me">';
	html += '<span class="chat-msg-time">'+time+'</span>';
	html += '<span class="chat-msg-body">'+msg+'</span>';
	html += '</div>';
	
	$("#chat").append(html);

	//서버전송
	ws.send("message§${userId}§"+msg+"§"+date.getTime());

	//input#msg 초기화
	$("#msg").val("");
}
//엔터키를 누를 경우 메세지 보내기
function enterKey(e){
	if(e.keyCode == 13 || window.event.keyCode == 13)
		send();
}
function getTimeStr(date){
	var hh = date.getHours();
	var mm = date.getMinutes();
	hh = hh<10?"0"+hh:hh;
	mm = mm<10?"0"+mm:mm;
	return hh+":"+mm;
}
</script>
</body>
</html>