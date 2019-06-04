package com.kh.google.api.places;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

/**
 * Servlet implementation class PlacesFindPlaceServlet
 */
@WebServlet("/textSearch")
public class TextSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TextSearchServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String query ="서울대입구역%20맛집";
		String key = "AIzaSyBME11nYqKlQwklGguNmf_JsOnXxNt6Cm4";
		String urlStr = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
					  + "query="+query+"&"
					  + "key="+key;
		
		
		URL url = new URL(urlStr);  
		
		String line = ""; 
		StringBuilder jsonStr = new StringBuilder();
		
		//url객체.openStream(): 해당 URL에 접속후 Stream객체로 반환함.
		BufferedReader bf = new BufferedReader(new InputStreamReader(url.openStream())); 
		while((line=bf.readLine())!=null){ 
			jsonStr.append(line); 
		}
		
		response.getWriter().append(jsonStr);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
