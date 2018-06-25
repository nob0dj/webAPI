<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Web API - Server Sent Event</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
<style>
div.area{width:500px; min-height:200px; padding:10px; border:1px solid gray;}
table, th, td{border:1px solid;}
</style>
</head>
<body>
	<h2>Web API - Server Sent Event</h2>
	<ul style="list-style:none">
		<li><a href="https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events">MDN API</a></li>
	</ul>
	<h3>EventSource Object</h3>
	<ul>
		<li>onopen : When a connection to the server is opened</li>
		<li>onmessage : When a message is received</li>
		<li>onerror	: When an error occurs</li>
	</ul>
	<button id="start1">start</button>
	<button id="end1">end</button> 
	<br /><br />
	<div id="area1" class="area" ></div>
	<script>
	window.onload=function(){
		var start1 = document.getElementById("start1");
		var end1 = document.getElementById("end1");
		var source;
		
		start1.addEventListener("click", function(){
			if (window.EventSource) {
				console.log("sse 사용가능!")
			  source = new EventSource('${pageContext.request.contextPath}/sse/test1.do');
			  
			  
			  source.addEventListener("open", function(e){
				console.log("onopen event!");  
				document.getElementById("area1").innerHTML += "--- Server Sent Events opened ---<br>";
			  });
			  
			  source.addEventListener("message", function(e){
				console.log("onmessage event!");
				console.log(e);
				document.getElementById("area1").innerHTML += e.data+"<br>";
				
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
			
		end1.addEventListener("click",function(){
			console.log("connection closing...");
			source.close();
		});
	}
	
	</script>
	
	<hr />
	<h3>ServerSentEvent - JSON데이터처리</h3>
	
	<button id="start2">start</button>
	<button id="end2">end</button> 
	<br /><br />
	<div id="area2" class="area" ></div>
	<script>
	$(function(){
		var source;
		$("#start2").click(function(){
			if (window.EventSource) {
			  console.log("sse 사용가능!")
			  source = new EventSource('${pageContext.request.contextPath}/sse/test2.do');
			  
			  //jquery사용하지 말것. 이벤트 처리 오류 발생
			  source.addEventListener("open",function(e){
				console.log("onopen event!");  
				$("#area2").html("--- Server Sent Events opened ---<br>");
			  });
			  
			  //$(source).on("message", function(e){
			  source.addEventListener("message",function(e){
				console.log("onmessage event!");
				console.log(e.data);
				//json파싱
				var obj = JSON.parse(e.data);
				var table = $("<table></table>");
				var html = "<tr><th>아이디</th><td>"+obj.userId+"</td></tr>";
				html += "<tr><th>이름</th><td>"+obj.userName+"</td></tr>";
				html += "<tr><th>주소</th><td>"+obj.userAddr+"</td></tr>";
				$("#area2").html(table.html(html));
				
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
		
		$("#end2").click(function(){
			console.log("connection closing...");
			source.close();
		});
	});
	</script>
	
	<hr />
	
	<h3>@실습문제 : JSON데이터처리</h3>
	<p>회원목록 전체를 sse를 통해 화면에 출력하되, 10초마다 갱신될 수 있도록 하세요.</p>
	<button id="start3">start</button>
	<button id="end3">end</button> 
	<br /><br />
	<div id="area3" class="area" ></div>
	<script>
	$(function(){
		var source;
		$("#start3").click(function(){
			if (window.EventSource) {
			  source = new EventSource('${pageContext.request.contextPath}/sse/test3.do');
			  
			  source.addEventListener("open",function(e){
				console.log("onopen event!");  
			  });
			  
			  //$(source).on("message", function(e){
			  source.addEventListener("message",function(e){
				console.log("onmessage event!");
				console.log(e.data);
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
				
				$("#area3").html(table);
				
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
		
		$("#end3").click(function(){
			console.log("connection closing...");
			source.close();
		});
	});
	</script>
	
	
</body>
</html>