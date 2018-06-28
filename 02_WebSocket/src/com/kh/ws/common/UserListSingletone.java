package com.kh.ws.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.kh.ws.model.vo.User;


/**
 * 어플리케이션에서 반복적으로 행해지는 업무로직에 대해 싱글톤패턴 처리함.
 * 
 * @author nobodj
 *
 */
public class UserListSingletone {
	private static UserListSingletone instance;
	private List<User> userList;
	
	
	private UserListSingletone(){
		userList = new ArrayList<>();
		userList.add(new User("honggd", "홍길동", "1234"));
		userList.add(new User("sinsa", "신사임당", "1234"));
		userList.add(new User("dangoon", "단군", "1234"));
		userList.add(new User("sesese", "세종대왕", "1234"));
		userList.add(new User("yeon", "연산군", "1234"));
		userList.add(new User("jung_master", "정조", "1234"));
		userList.add(new User("taeyo", "태종", "1234"));
		userList.add(new User("miss_hwang", "황진이", "1234"));
		userList.add(new User("young", "영조", "1234"));
		userList.add(new User("nononon","논개", "1234"));
	}
	
	public static UserListSingletone getInstance(){
		if(instance==null){
			instance = new UserListSingletone();
		}
		return instance;
	}

	public List<User> getUserList() {
		return userList;
	}

	
}
