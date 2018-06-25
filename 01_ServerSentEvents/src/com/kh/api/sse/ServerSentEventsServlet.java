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
@WebServlet("/sse/test1.do")
public class ServerSentEventsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServerSentEventsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("/sse/test1.do 요청!");
		response.setContentType("text/event-stream");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
//		println메소드 사용하지 말것. \n 줄바꿈 처리때문에 오작동함.
		//out.write(":주석입니다. 전달되지 않음.\n");
		//out.write("id: "+System.currentTimeMillis()+"\n");//EventSource객체에 부여할 아이디
		out.write("retry:5000\n");//재요청대기시간 ms단위로 작성
		//out.write("data: 서버에서 보낸 데이터\n\n");
		
		for (int i = 0; i < 10; i++) {
			out.write("data: ["+i+"] : "+ System.currentTimeMillis() +"\n\n");
			out.flush();
			
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		
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
