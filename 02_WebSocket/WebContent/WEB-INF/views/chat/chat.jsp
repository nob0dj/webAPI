<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello, ws</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
<style>
/****** 채팅창 최상위 요소 *******/
#chat-container{
	width:500px;
	margin:0 auto;
	position:relative;
	overflow:hidden;
}

/****** HEADER ******/
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
/****** CHAT ******/
#chat{
	background-color: #a1c0d6;
	height:600px;
	padding-top:10px;
	overflow:auto;
}
/*채팅메세지 공통*/
/*채팅창은 .chat-msg-from-me와 .chat-msg-to-me로 이루어짐 */
.chat-msg{
	display: flex;
	align-items: flex-end;
    margin-bottom: 25px;
}
.chat-msg-time{
    font-size: 10px;
    color: rgba(0, 0, 0, 0.5);
    margin:0 5px;
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
	position:relative;
	display: flex;
    flex-direction: column;
}
.chat-msg-center h3{/*사용자아이디*/
	margin-top:0px;
	margin-bottom:5px;
	font-size: 13px;
}
.chat-msg-center a {/*파일저장버튼*/
	position:absolute;
	bottom:-20px;
	font-size:13px;
	text-decoration:none;
	color:#000;
}
.chat-msg-center a:hover{
	text-decoration:underline;
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

/****** TYPE ******/
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
    padding-left:10px
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

/****** MENU-SIDEBAR ******/
.menu-sidebar{
	position:absolute;
	right:-200px;
	width:200px;
	height:100%;
	z-index:100;
	background:#fff;
	transition:all 1s;
	border: .5px solid rgba(0, 0, 0, 0.3);
}
.menu-overlay{
	width:100%;
	height:100%;
	cursor:pointer;
	background-color:rgba(127,127,127,.6);
	position: absolute;
    z-index: 99;
    display:none;
    opacity:0;
}
/*닫기버튼*/
a#menu-close{
	text-decoration: none;
    display: flex;
    justify-content: flex-end;
    margin-right: 10px;
}
a#menu-close span{
	color:#000;
	font-size: 35px;
    font-weight: bold;
}
/* 접속자수 */
.menu-sidebar p{
	padding-left: 10px;
}
/* 접속사용자 리스트*/
.userList-container ul{
	list-style:none;
	padding:0;
}
.userList-container ul li{
	display:flex;
	padding: 3px;
}
.userList-container ul li h3{
	margin:0;
	align-self:center;
}
/* 파일관련 */
.chat-msg-img{
	max-width: 200px;
    max-height: 200px;
}

</style>
<script>
function menuOpen() {
    $("#menu-sidebar").css("right","0px");
    $("#menu-overlay").show().css("opacity",1);

    //접속자명단 가져오기
    $.ajax({
		url : "${pageContext.request.contextPath}/chat/getUserList.chat",
		success : function(data){
			console.log(data);
			var userList = data;
			var html = "";
			for(var i in userList){
				html += '<li><img src="${pageContext.request.contextPath }/images/default-avatar.png" class="chat-msg-avatar">';
				html += '<h3>'+userList[i]+'</h3></li>';
			}
			
			$(".userList-container ul").html(html);
			$("#menu-sidebar p span").text(userList.length);
		},
		error : function(){
			console.log("ajax처리실패!");
		}
	
    });
        
}
function menuClose() {
	$("#menu-sidebar").css("right","-200px");
    $("#menu-overlay").hide().css("opacity",0)
}

</script>
</head>
<body>
	<div id="chat-container">
		<!-- 파일업로드용-->
		<input type="file" id="uploadFile" style="display:none;" onchange="sendFileConfirm();"/>
		
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
				<a href="javascript:openFile(sendFileConfirm);" class="btn-plus">
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
<script>
var imgExt = ["png","jpg","jpeg","gif","tiff"];//사진확장자 검사용 배열
var date;//파일전송간 여러함수에서 사용할 date변수를 전역에 선언함.

var host = location.host;//localhost이거나, 서버컴퓨터 ip주소를 담아둠.
var ws = new WebSocket('ws://'+ host +'${pageContext.request.contextPath}/helloWebSocket.chat');

//파일전송용 속성지정
ws.binaryType = "arraybuffer";

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
	var date = new Date(Number(msgArr[3]));//반드시 casting
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
	else if(type==="file"){
	    var ext = msg.substring(msg.lastIndexOf(".")+1).toLowerCase();
	    console.log("ext="+ext);
		var bool = imgExt.indexOf(ext)>-1;//사진확장자 검사
	    
		var html = '<div class="chat-msg chat-msg-to-me">';
		html += '<img src="${pageContext.request.contextPath }/images/default-avatar.png" class="chat-msg-avatar">';
	    html += '<div class="chat-msg-center">';
	    html += '<h3 class="chat-msg-userid">'+sender+'</h3>';

	    if(bool)//사진파일인경우
	    	html += '<img src="${pageContext.request.contextPath }/upload/chat/'+msg+'" class="chat-msg-img">';
	    else
	    	html += '<span class="chat-msg-body">'+msg+'</span>';

		html += '<a href="javascript:fileDownload(\''+msg+'\')">저장</a>';
	    html += '</div>';
	    html += '<span class="chat-msg-time">'+time+'</span>';
	  	html += '</div>';
	  	$("#chat").append(html);
	}

	//최신내용을 계속 보여주게 스크롤처리함.
	$("#chat").scrollTop($("#chat").height());
}
function onError(e){
	alert("WebSocket Error Occured!");
}
function onClose(e){
	console.log("WebSocket Connection Closed!");
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

	//최신내용을 계속 보여주게 스크롤처리함.
	$("#chat").scrollTop($("#chat").height());
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
/**
 * 파일선택함수
 */
function openFile(){
	//input:file태그가 아닌 +(플러스)버튼으로 클릭이벤트를 발생시킴.
	$("#uploadFile").click();	
}
function sendFileConfirm(){

	if(confirm("["+$("#uploadFile")[0].files[0].name+"]파일을 전송하시겠습니까?")) 
		sendFile();
}




/**
 * 웹소켓 통해 파일전송 함수
 * 
 * 파일은 3가지 전송단계를 거침
 * 1. 업로드할 file명 전송
 * 2. 파일전송
 * 3. 전송완료 알림(다른 클라이언트에서 전송하는 것은 이 마지막 단계)
 * 
 * 또, FileReader를 두가지 방식으로 사용함.
 * 1. readAsArrayBuffer => 파일 전송용.
 * 2. readAsDataURL => 내 채팅창에 전송한 파일(이미지)을 보여주기 위함. 
 * 
 */
function sendFile() {
    var file = $("#uploadFile")[0].files[0];
    ws.send('file§${userId}§'+file.name+"§"+new Date().getTime());
    
    var reader = new FileReader();
    var rawData = new ArrayBuffer();
   
    reader.onload = function(e) {
        rawData = e.target.result;//BinaryData
        ws.send(rawData);
        
        date = new Date();
        ws.send('file§${userId}§end§'+date.getTime());//전송완료 알림

        //화면 출력시, 파일의 이미지여부에 따라 분기함.
      	//사진파일인경우, 다른 FileReader를 이용해, 읽어옴.
        var ext = file.name.substring(file.name.lastIndexOf(".")+1).toLowerCase();
    	var bool = imgExt.indexOf(ext)>-1;//사진확장자 검사
    	if(bool) readFileAsDataURL(file); 
    	else writeHTML(false,file.name);
    	
    }

	reader.readAsArrayBuffer(file);
	
}

function writeHTML(bool, data){
	/*내페이지에 작성하기*/
	var html = '<div class="chat-msg chat-msg-from-me">';
	html += '<span class="chat-msg-time">'+getTimeStr(date)+'</span>';
	if(bool)//사진파일인경우
    	html += '<img src="'+data+'" class="chat-msg-img">';
    else
    	html += '<span class="chat-msg-body">'+data+'</span>';
	html += '</div>';
	
	$("#chat").append(html);
	
	//최신내용을 계속 보여주게 스크롤처리함.
	$("#chat").scrollTop($("#chat").height());
	
}

function readFileAsDataURL(f){
	var reader = new FileReader();
	reader.readAsDataURL(f);
	
	reader.onload = function(e){
		writeHTML(true,e.target.result);
	};
	
}
</script>
</body>
</html>