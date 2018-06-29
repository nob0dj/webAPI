package com.kh.ws.groupchat;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.Session;

/**
 * Servlet implementation class LeaveGroupChatServlet
 */
@WebServlet("/groupChat/leaveGroupChat.chat")
public class LeaveGroupChatServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LeaveGroupChatServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String chatRoomId = request.getParameter("chatRoomId");
		String userId = request.getParameter("userId");
		Map<String, Map<String,Session>> chatRoomMap = GroupChatRoomServer.getChatRoomMap();
		Map<String,Session> participants = chatRoomMap.get(chatRoomId);
		
		//사용자 제거
		participants.remove(userId);
		
		//채팅방의 사용자가 2명이 안되면, 채팅방을 삭제함.
		if(participants.size()<2)
			chatRoomMap.remove(chatRoomId);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
