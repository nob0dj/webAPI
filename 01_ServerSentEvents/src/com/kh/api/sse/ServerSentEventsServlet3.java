package com.kh.api.sse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.kh.api.common.UserListSingleton;
import com.kh.api.model.vo.User;

/**
 * Servlet implementation class ServerSentEventsServlet
 */
@WebServlet("/sse/test3.do")
public class ServerSentEventsServlet3 extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServerSentEventsServlet3() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("/sse/test2.do 요청!");
		response.setContentType("text/event-stream");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
//		println메소드 사용하지 말것. \n 줄바꿈 처리때문에 오작동함.

		List<User> list = UserListSingleton.getInstance().getUserList();
		String jsonStr = new Gson().toJson(list);
		out.write("retry:10000\n");
		out.write("data:"+jsonStr+"\n\n");
		out.flush();
		out.close();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
