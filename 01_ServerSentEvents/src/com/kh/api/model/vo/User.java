package com.kh.api.model.vo;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

public class User implements HttpSessionBindingListener {
	private String userId;
	private String userName;
	private String userAddr;
	
	public User() {}

	public User(String userId, String userName, String userAddr) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.userAddr = userAddr;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserAddr() {
		return userAddr;
	}

	public void setUserAddr(String userAddr) {
		this.userAddr = userAddr;
	}

	@Override
	public String toString() {
		return "[userId=" + userId + ", userName=" + userName + ", userAddr=" + userAddr + "]";
	}

	@Override
	public void valueBound(HttpSessionBindingEvent event) {
		System.out.println(userName+"님이 로그인했습니다.");
		//컨텍스트(어플리케이션) 객체 가져오기
		ServletContext context = event.getSession().getServletContext();
		List<User> list = (List<User>)context.getAttribute("loggedInUserList");
		if(list == null) list = new ArrayList<>();
		//리스트에 이 User객체를 등록.
		list.add(this);
		//loggedInUserList속성이 등록되지 않은 경우 대비, 속성으로 재등록함.
		context.setAttribute("loggedInUserList", list);
		
		//중복로그인을 방지하기 위해서 sessionList 속성을 생성해서 관리함.
		List<HttpSession> sessionList = (List<HttpSession>)context.getAttribute("sessionList");
		if(sessionList == null) sessionList = new ArrayList<>();
		sessionList.add(event.getSession());
		context.setAttribute("sessionList", sessionList);
	}

	@Override
	public void valueUnbound(HttpSessionBindingEvent event) {
		System.out.println(userName+"님이 로그아웃했습니다.");
		ServletContext context = event.getSession().getServletContext();
		List<User> list = (List<User>)context.getAttribute("loggedInUserList");
		list.remove(this);//이 객체를 제거함.
		
		//중복로그인 방지
		List<HttpSession> sessionList = (List<HttpSession>)context.getAttribute("sessionList");
		sessionList.remove(event.getSession());
	}
	
	
	
	
}