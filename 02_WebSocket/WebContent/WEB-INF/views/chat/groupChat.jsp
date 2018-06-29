<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WebSocket-GroupChat</title>
<script src="${pageContext.request.contextPath }/js/jquery-3.2.1.min.js"></script>
</head>
<body>
	<h2><span style="color:gray;">${loginUser.userName }</span>님, 환영합니다.</h2>
	<h3>나의 채팅방목록</h3>
	<!-- 1. 현재 속해있는 채팅방이 없는 경우 -->
	<c:if test="${empty myChatRoomMap }">
	<p>속해있는 채팅방이 없습니다.</p>
	</c:if>
	
	<!-- 2. 현재 속해있는 채팅방이 있는 경우 -->
	<c:if test="${not empty myChatRoomMap }">
	<select id="myChatRoomList">
		<option value="" selected disabled>채팅방선택</option>
		<!-- forEach를 통한 map객체 제어 -->
		<c:forEach items="${myChatRoomMap }" var="v">
		<option value="${v.key}">
			<!-- v.value는 set객체이고, 이를 userMap의 키로 사용해서 사용자이름을 가져옴. -->
			<c:set value="(${v.value.size() })" var="size"/><!-- el에서 +를 이용한 문자열 더하기연산불가(concat사용해야함) -->
			<c:forEach items="${v.value}" var="userId" varStatus="vs">
				${userMap[userId]}${!vs.last?", ":size}
			</c:forEach>
		</option>
		</c:forEach>
	</select>
	<button onclick="goChat();">GO</button>
	<button onclick="leaveChat();">LEAVE</button>
	
	</c:if>
	
	<hr />
	<h3>친구목록</h3>
	<form id="newChatFrm" action="${pageContext.request.contextPath }/chat/groupChatRoom.chat" method="post">
		<ul style="list-style:none;">
			<c:forEach items="${userList}" var="u" varStatus="vs">
			<c:if test="${u!=loginUser }">
			<li>
				<input type="checkbox" name="user" id="user${vs.count}" value="${u.userId}" />
				<label for="user${vs.count }">${u.userName }</label>
			</li>	
			</c:if>
			<!-- 채팅참여자에 포함시키기 위해서 form에 추가, checkbox가 아니므로 무조건 전송됨 -->
			<c:if test="${u==loginUser }">
				<input type="hidden" name="user" value="${u.userId}" />
			</c:if>
			</c:forEach>
		</ul>
	</form>
	<button onclick="goNewChat();">새 채팅 시작하기</button>
<script>
function leaveChat(){
	var chatRoomId = $("#myChatRoomList").val();
	if(chatRoomId=="") return;

	$.ajax({
		url:"${pageContext.request.contextPath}/chat/leaveGroupChat.chat",
		data : {chatRoomId:chatRoomId, userId:"${loginUser.userId}"},
		type : "post",
		success : function(data){
			//페이지 리로딩
			history.go(0);
		},
		error : function(jqxhr,textStatus,errorThrown){
			console.log("ajax처리실패",jqxhr,textStatus,errorThrown);
			
		}


	});
		
}
function goChat(){
	var chatRoomId = $("#myChatRoomList").val();
	if(chatRoomId=="") return;
	location.href = "${pageContext.request.contextPath}/chat/groupChatRoom.chat?chatRoomId="+chatRoomId;
}
function goNewChat(){
	if($("[name=user]:checked").length==0){
		alert("한 명이상 선택하세요.");
		return;
	}
	$("#newChatFrm").submit();
}
</script>
</body>
</html>