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
		  <!-- 테스트메세지 -->
		  <%-- <div class="chat-msg chat-msg-from-me">
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
		  </div>--%>
		</div> 
		<!-- end of #chat -->
		
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
<script>
//전역변수선언
var imgExt = ["png","jpg","jpeg","gif","tiff"];//사진확장자 검사용 배열
var d;//파일전송간 여러함수에서 사용할 date변수를 전역에 선언함.
var downloadFileName; //다운로드할 파일명을 저장해 두었다가, 다운로드된 arraybuffer타입에 파일명으로 지정.

//웹소켓시작
var host = location.host;//localhost이거나, 서버컴퓨터 ip주소를 담아둠.
var ws = new WebSocket('ws://'+ host +'${pageContext.request.contextPath}/chat/helloWebSocket');

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

	// 파일다운로드의 경우 ArrayBuffer로 전송됨.
	if(e.data instanceof ArrayBuffer){
        // ArrayBuffer타입의 e.data를 DataView의 매개변수로 넘겨준다.
        // DataView는 플랫폼의 바이트 정렬 방법과 관계없이 ArrayBuffer에서 다양한 형태의 데이터를 읽고 쓰기 위한 저수준 인터페이스를 제공함.
        var dataView = new DataView(e.data);
        // DataView 를 넘겨줘서 Blob객체생성
        var blob = new Blob([dataView]);
        // blob를 파일로 저장한다.
        saveFile(blob);
		return;
	}

	var msgArr = e.data.split("§");
	var type = msgArr[0];
	var sender = msgArr[1];
	var msg = msgArr[2];
	var longTime = msgArr[3];
    var time = getTimeStr(new Date(Number(longTime)));//반드시 캐스팅할것. 

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
	else if(type==="upload"){
	    var ext = msg.substring(msg.lastIndexOf(".")+1).toLowerCase();
	    //console.log("ext="+ext);
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
	scrollDown();
}
function onError(e){
	//alert("WebSocket Error Occured!");
}
function onClose(e){
	//alert("WebSocket Connection Closed!");
}
function send(){
	var msg = $("#msg").val().trim();
	console.log(msg);
		
	if(msg.length==0) return;

	//현재시각정보를 00:00형식으로 생성.
	var d = new Date();
	var time = getTimeStr(d);
	
	/*내 화면에 출력할 전송메세지 */
	var html = '<div class="chat-msg chat-msg-from-me">';
	html += '<span class="chat-msg-time">'+time+'</span>';
	html += '<span class="chat-msg-body">'+msg+'</span>';
	html += '</div>';
	
	$("#chat").append(html);

	//서버전송
	//ws.send("message§${userId}§"+msg);
	ws.send("message§${userId}§"+msg+"§"+d.getTime());

	//input#msg 초기화
	$("#msg").val("");

	//최신내용을 계속 보여주게 스크롤처리함.
	scrollDown();
}



/**
 * 엔터키를 누를 경우 메세지 보내기
 */
function enterKey(e){
	if(e.keyCode == 13 || window.event.keyCode == 13)
		send();
}
/**
 * 메세지 송수신 시 시각정보(예:17:35)를 매개변수 date객체로부터 리턴함
 */
function getTimeStr(date){
	var hh = date.getHours();
	var mm = date.getMinutes();
	hh = hh<10?"0"+hh:hh;
	mm = mm<10?"0"+mm:mm;
	return hh+":"+mm;
}
/**
 * 우측상단 메뉴번튼 클릭이벤트핸들러
 * 접속자명단을 비동기 통신으로 가져옴.
 */
function menuOpen() {
    $("#menu-sidebar").css("right","0px");
    $("#menu-overlay").show().css("opacity",1);

    //접속자명단 가져오기
    $.ajax({
		url : "${pageContext.request.contextPath}/chat/userList.chat",
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


/**
 * 파일선택함수
 */
function openFile(){
	//input:file태그가 아닌 +(플러스)버튼으로 클릭이벤트를 발생시킴.
	$("#uploadFile").click();	
}
/**
 * 파일전송여부 확인함수
 */
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
	//1.업로드할 file명 전송
	d = new Date();
    ws.send('upload§${userId}§'+file.name+"§"+d.getTime());
    
    var reader = new FileReader();
    var rawData = new ArrayBuffer();

	
    reader.readAsArrayBuffer(file);
    
    reader.onload = function(e) {
        rawData = e.target.result;//BinaryData
		//2.파일전송
        ws.send(rawData);
        
        date = new Date();
        //3. 전송완료 알림(다른 클라이언트에서 전송하는 것은 이 마지막 단계)
        ws.send('upload§${userId}§end§'+date.getTime());//전송완료 알림

        //전송파일 내화면 출력하기
        //파일의 이미지여부에 따라 분기함.
      	//사진파일인경우, 다른 FileReader를 이용해, 읽어온후 이미지를 출력함.
        var ext = file.name.substring(file.name.lastIndexOf(".")+1).toLowerCase();
    	var bool = imgExt.indexOf(ext)>-1;//사진확장자 검사
    	if(bool) readFileAsDataURL(file); 
    	else writeHTML(false,file.name);
    }
}

/**
 * 파일전송후 전송된 파일이름(이미지파일인 경우에는 이미지태그)를 출력하는 함수
 * 시각정보는 최초 파일을 업로드한 시각정보를 공유함(전역변수 d)
 */
function writeHTML(bool, data){
	/*내페이지에 작성하기*/
	var html = '<div class="chat-msg chat-msg-from-me">';
	html += '<span class="chat-msg-time">'+getTimeStr(d)+'</span>';
	if(bool)//사진파일인경우
    	html += '<img src="'+data+'" class="chat-msg-img">';
    else
    	html += '<span class="chat-msg-body">'+data+'</span>';
	html += '</div>';
	
	$("#chat").append(html);
	
	//최신내용을 계속 보여주게 스크롤처리함.
	scrollDown();
	
}

/**
 * 전송한 파일이 이미지파일인 경우, 채팅창 내가보낸메세지에 img로 출력하기 위함.
 * 파일이 전송되는 데 시간이 걸리므로, 내컴퓨터 파일을 읽어다가 화면에 뿌림.
 */
function readFileAsDataURL(f){
	var reader = new FileReader();
	reader.readAsDataURL(f);
	
	reader.onload = function(e){
		writeHTML(true,e.target.result);
	};
}

/**
 * 파일다운로드 요청함수
 */
function fileDownload(fileName){
	console.log(fileName+"다운로드 요청");
	//전역변수 downloadFileName에 파일명을 저장해둠.
	downloadFileName = fileName;
	ws.send("download§${userId}§"+fileName);
}

function saveFile(blob) {
    var link = document.createElement('a');

    //생성한 blob객체에 가상의 url을 부여함.
    link.href = window.URL.createObjectURL(blob);
    console.log(link.href);//blob:http://localhost:9090/b3b8e322-5b59-4582-b62c-efb41d05787c
    
    //a태그의 download속성은 해당주소로의 이동이 아닌 파일 다운로드를 명시함.
    //속성값은 파일명으로 등록됨(생략시, 현재파일명을 사용함.)
    link.download = downloadFileName;

    link.click();
};
function scrollDown() {      /* 최신글로 이동 */
    
    $('#chat').scrollTop($("#chat").prop('scrollHeight'));
}

</script>
</body>
</html>