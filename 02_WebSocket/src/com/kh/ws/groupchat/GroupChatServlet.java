package com.kh.ws.groupchat;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.Session;

import com.kh.ws.common.UserListSingletone;
import com.kh.ws.common.UserMapSingletone;
import com.kh.ws.model.vo.User;

/**
 * Servlet implementation class GroupchatServlet
 */
@WebServlet("/chat/groupChat.chat")
public class GroupChatServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GroupChatServlet() {
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
		//내가 등록된 채팅방목록 가져오기
		String userId = ((User)request.getSession().getAttribute("loginUser")).getUserId();

		//내가 속한 채팅방맵객체 : chatRoomId={userId1, userId2}
		Map<String,Set<String>> myChatRoomMap = new HashMap<>();
		//현재 application 전체맵 가져오기
		Map<String, Map<String,Session>> chatRoomMap = GroupChatRoomServer.getChatRoomMap();
		
		//해당맵을 열람해서 본인아이디가 속한 채팅방과 참여자 정보를 myChatRoomList에 담는다.
		Set<String> keySet = chatRoomMap.keySet();
		for (String chatRoomId : keySet) {
			Map<String,Session> participants = chatRoomMap.get(chatRoomId);
			
			if(participants.containsKey(userId)){
				//사용자가 속한 채팅방id와 참여자를 map에 담음.
				myChatRoomMap.put(chatRoomId, participants.keySet());				
			}
		}
		
		request.setAttribute("userMap", UserMapSingletone.getUserMap());
		request.setAttribute("myChatRoomMap", myChatRoomMap);
		request.setAttribute("userList", UserListSingletone.getInstance().getUserList());
		request.getRequestDispatcher("/WEB-INF/views/chat/groupChat.jsp")
			   .forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
