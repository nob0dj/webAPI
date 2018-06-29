package com.kh.ws.groupchat;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.Session;

/**
 * Servlet implementation class GroupChatRoomServlet
 */
@WebServlet("/chat/groupChatRoom.chat")
public class GroupChatRoomServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GroupChatRoomServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//로그인하지 않은 경우, 다시 인덱스페이지로 리다이렉트시킴.
		if(request.getSession().getAttribute("loginUser")==null){
			response.sendRedirect(request.getContextPath());
			return;
		}
		
		String chatRoomId = request.getParameter("chatRoomId");
		
		if(chatRoomId==null){
			//1.파라미터핸들링
			String[] users = request.getParameterValues("user");
			//컬렉션개체로 변환
			//신규참여자를 컬렉션set개체로 변환.(배열=>list=>set)
			Set<String> newParticipantsSet = new HashSet<>(Arrays.asList(users));
			
			//동일한 참여자를 가진 기존채팅방 존재여부검사
			boolean alreadyExist = false;
			//채팅방맵 구하기 : chatRoomId={userId=WebSocketSession}
			Map<String, Map<String, Session>> chatRoomMap = GroupChatRoomServer.getChatRoomMap();
			Set<String> keySet = chatRoomMap.keySet();
			
			for (String k : keySet) {
				//기존채팅방의 참여자정보를 keyset메소드를 이용해 set객체로 생성
				Set<String> existingParticipantsSet = chatRoomMap.get(k).keySet();
//				System.out.println("existingSet="+existingParticipantsSet);
//				System.out.println("newSet="+newParticipantsSet);
				
				if(existingParticipantsSet.size()==newParticipantsSet.size() 
				&&  existingParticipantsSet.containsAll(newParticipantsSet)){
					alreadyExist = true;
					chatRoomId = k;//기존채팅방id를 대입함.
					break;
				}
			}
			
			if(!alreadyExist){
				Map<String, Session> participants = new HashMap<>();
				for (String userId : users) {
					participants.put(userId, null);//아직 할당되지 않은 WebsocketSession을 null처리
				}
				
				//20자리 임의의 문자열 생성
				chatRoomId = getRandomChatRoomId(20);

				//기존chatRoomMap에 현재채팅방 추가
				chatRoomMap.put(chatRoomId,participants);
			}
		
		}
		
		
		//2.뷰모델 처리  
		request.setAttribute("chatRoomId", chatRoomId);
		request.getRequestDispatcher("/WEB-INF/views/chat/groupChatRoom.jsp")
			   .forward(request, response);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	/**
	 * 인자로 전달될 길이의 임의의 문자열을 생성하는 메소드
	 * 영대소문자/숫자의 혼합.
	 * 
	 * @param len
	 * @return
	 */
	private String getRandomChatRoomId(int len){
		Random rnd =new Random();
		StringBuffer buf =new StringBuffer();
		for(int i=0;i<len;i++){
			//임의의 참거짓에 따라 참=>영대소문자, 거짓=> 숫자
		    if(rnd.nextBoolean()){
		    	boolean isCap = rnd.nextBoolean();
		        buf.append((char)((int)(rnd.nextInt(26))+(isCap?65:97)));
		    }else{
		        buf.append((rnd.nextInt(10))); 
		    }
		}
		return buf.toString();

	}

}
