package com.kh.ws.groupchat;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletContext;
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
		
		//1.파라미터핸들링
		String[] users = request.getParameterValues("user");
		Map<String, Session> participants = new HashMap<>();
		for (String userId : users) {
			participants.put(userId, null);//아직 할당되지 않은 WebsocketSession을 null처리
		}
		System.out.println("채팅참여자 : "+participants);
		
		String chatRoomId = getRandomChatRoomId(20);
		System.out.println("charRoomId="+chatRoomId);
		
		//2.뷰모델 처리
		//채팅방맵 구하기 : chatRoomId => {userId=WebSocketSession}
		Map<String, Map<String, Session>> chatRoomMap = GroupChatRoomServer.getChatRoomMap();
		chatRoomMap.put(chatRoomId,participants);
		
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
