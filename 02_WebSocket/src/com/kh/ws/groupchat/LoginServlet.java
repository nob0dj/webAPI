package com.kh.ws.groupchat;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kh.ws.common.UserListSingletone;
import com.kh.ws.model.vo.User;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/chat/login.chat")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private int LOGINOK = 1;
    private int WRONGPASSWORD = 0;
    private int NOID = -1;
    
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");
		
		List<User> userList = UserListSingletone.getInstance().getUserList();
		User loginUser = null;
		int flag = NOID;
		
		
		for(User u : userList){
			if(u.getUserId().equals(userId)){
				flag = WRONGPASSWORD;
				if(u.getPassword().equals(password)){
					flag = LOGINOK;
					loginUser = u;
				}
				break;
			}
		}
		
		if(flag==LOGINOK){
			//System.out.println("loginUser="+loginUser);
			request.getSession().setAttribute("loginUser", loginUser);
			response.sendRedirect(request.getContextPath()+"/chat/groupChat.chat");
		}
		else {
			String msg = "";
			if(flag==WRONGPASSWORD){
				msg = "패스워드가 틀렸습니다.";
			}
			else if(flag==NOID){
				msg = "존재하지 않는 아이디입니다.";
			}
			request.setAttribute("msg", msg);
			request.setAttribute("loc", "/");
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
				   .forward(request, response);
			
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
