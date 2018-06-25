package com.kh.api.sse;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.kh.api.common.UserListSingleton;
import com.kh.api.model.vo.User;

/**
 * Servlet implementation class UserLoginServlet
 */
@WebServlet("/sse/login.do")
public class UserLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserLoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1.인코딩처리
		request.setCharacterEncoding("utf-8");
		//2.파라미터 핸들링
		String userId = request.getParameter("userId");
		//3.업무로직
		//로그인은 약식으로 존재하는 아이디를 입력하면, 로그인되게 함.
		List<User> list = UserListSingleton.getInstance().getUserList();
		
		for (User u : list) {
			
			if(u.getUserId().equals(userId)){
				//중복로그인방지
				ServletContext context = getServletContext();
				List<HttpSession> sessionList = (List<HttpSession>)context.getAttribute("sessionList");
				if(sessionList != null){
					for(HttpSession s : sessionList){
						User sessionUser = (User)s.getAttribute("userLoggedIn");
						if(userId.equals(sessionUser.getUserId())){
							s.invalidate();
							break;
							//sessionList를 반복문 중간에 sessinList를 수정하기 때문에 반드시 break문을 써줄것.
							//그렇지 않으면,java.util.ConcurrentModificationException 발생함. 
						}
					}
				}
				
				//존재하는 세션이 있다면, 해당세션을 리턴.
				//존재하는 세션이 없다면, 새로 세션을 생성해서 리턴함.
				HttpSession session = request.getSession();
				//세션에 User객체를 속성값으로 바인딩함 => User.valueBound() 호출됨.
				session.setAttribute("userLoggedIn", u);
				response.sendRedirect(request.getContextPath()+"/ServerSentEvents/loggedIn.jsp");
				return;//return 처리하지 않으면, IllegalStateException유발.
			}	
		}
		
		response.sendRedirect(request.getContextPath()+"/ServerSentEvents/login.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
