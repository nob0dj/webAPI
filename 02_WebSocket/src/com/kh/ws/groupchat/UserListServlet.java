package com.kh.ws.groupchat;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.Session;

import com.google.gson.Gson;
import com.kh.ws.common.UserMapSingletone;

/**
 * Servlet implementation class UserListServlet
 */
@WebServlet("/groupChat/getUserList.chat")
public class UserListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String chatRoomId = request.getParameter("chatRoomId");
		Map<String,Session> participants = GroupChatRoomServer.getChatRoomMap().get(chatRoomId);
		
		response.setContentType("application/json; charset=UTF-8");
		//간단버젼(참여아이디만 전송)
		//new Gson().toJson(participants.keySet(), response.getWriter());
		
		//접속여부 포함버젼
		Map<String, Boolean> map = new HashMap<>();
		Map<String,String> userMap = UserMapSingletone.getUserMap();
		for (String s : participants.keySet()) {
			//접속자id=>접속자이름
			//접속중=>true, 미접속=>false
			map.put(userMap.get(s),participants.get(s)!=null);
		}
		new Gson().toJson(map, response.getWriter());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
