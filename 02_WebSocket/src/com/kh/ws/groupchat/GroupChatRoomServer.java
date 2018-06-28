package com.kh.ws.groupchat;

import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;

//@pathParam뒤에 확장자 붙여 사용할 수 없음.
@ServerEndpoint(value="/chat/{chatRoomId}", 
		 configurator=GroupChatConfigurator.class)
public class GroupChatRoomServer {
	
	//현재접속한 WebSocketSession과 userId를 관리할 static필드(동기화처리 필수) 
	private static Map<String, Map<String, Session>> chatRoomMap;

	public static Map<String, Map<String, Session>> getChatRoomMap() {
		if(chatRoomMap==null) chatRoomMap = Collections.synchronizedMap(new HashMap<>());
		return chatRoomMap;
	}
	
	private Map<String, Session> currentChatRoom;
	private String currentUser;

	@OnOpen
	public void onOpen(EndpointConfig config, 
					   Session session,
					   @PathParam("chatRoomId") String chatRoomId) throws IOException{
		
		//현재채팅방 사용자맵에 웹소켓session을 추가함.
		currentUser = (String)config.getUserProperties().get("userId");
		currentChatRoom = chatRoomMap.get(chatRoomId);
		
		session.getUserProperties().put("currentUser",(String)config.getUserProperties().get("userId"));
	    session.getUserProperties().put("currentChatRoom",chatRoomMap.get(chatRoomId));
		
		
		//현재 채팅방에 등록된 사용자라면, 해당 아이디에 session등록
		if(currentChatRoom.containsKey(currentUser)) currentChatRoom.put(currentUser, session);
		else System.out.println("올바르지 않은 접근 시도!");
		
		stat();
		
		//다른사용자에게 접속메세지 보냄(json문자열처리)
		Map<String,Object> map = new HashMap<>();
		map.put("type", "message");
		map.put("msg", "["+currentUser+"]님이 접속했습니다.");
		map.put("sender", currentUser);
		map.put("time", new Date().getTime());
		onMessage(new Gson().toJson(map),session);
	}
	
	

	@OnMessage
    public void onMessage(String msg, Session session) throws IOException {
		System.out.println("onMessage:"+msg);
		
		/*하나의 업무가 실행하는 동안 사용자변경이 일어나서는 안된다.
		즉, NullPointerException을 방지하기 위해 동기화처리*/
		synchronized (currentChatRoom) {
			Collection<Session> clients =  currentChatRoom.values();
			
			for(Session client : clients) 
				
				//메세지를 작성한 본인을 제외하고, 메세지를 보냄.
				if(client!=null && !client.equals(session))
					client.getBasicRemote().sendText(msg);
		}
	}
	
	@OnError
	public void onError(Throwable e){
		// 데이터 전달 과정에서 에러가 발생할 경우 수행하는 메소드
		//e.printStackTrace();
	}
	
	@OnClose
	public void onClose(Session session) throws IOException{
		String currentUser = (String)session.getUserProperties().get("currentUser");
	    Map<String, Session> currentChatRoom = (Map<String, Session>)session.getUserProperties().get("currentChatRoom");
		
		//현재 userId에 할당된 WebSocketSession 제거
		currentChatRoom.put(currentUser,null);
		
		stat();
	}
	
	/** 
	 * 현재채팅방 접속현황
	 */
	private void stat() {
		System.out.println("어플리케이션에 등록된 채팅방개수 : "+chatRoomMap.size()+" => "+chatRoomMap);
		System.out.println("현재 채팅방 사용자("+currentChatRoom.size()+") : "+currentChatRoom);
		
		Set<String> keySet = currentChatRoom.keySet();
		int cnt = 0;
		String connetedUsers = "";
		for (String key : keySet) {
			if(currentChatRoom.get(key)!=null){
				cnt++;
				connetedUsers += key+" ";
			}
		}
		System.out.println("현재 채팅방 접속자("+cnt+") : "+connetedUsers);
		
	}
	
}
