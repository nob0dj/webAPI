package com.kh.api.common;

import java.util.ArrayList;
import java.util.List;

import com.kh.api.model.vo.User;

/**
 * 어플리케이션에서 반복적으로 행해지는 업무로직에 대해 싱글톤패턴 처리함.
 * 
 * @author nobodj
 *
 */
public class UserListSingleton {
	private static UserListSingleton instance;
	private List<User> userList;
	
	private UserListSingleton(){
		userList = new ArrayList<>();
		userList.add(new User("honggd", "홍길동", "서울시 동작구"));
		userList.add(new User("sinsa", "신사임당", "서울시 관악구"));
		userList.add(new User("dangoon", "단군", "경기도 평택"));
		userList.add(new User("sesese", "세종대왕", "서울 서초구"));
		userList.add(new User("yeon", "연산군", "서울시 강북구"));
		userList.add(new User("jung_master", "정조", "경기도 남양주시"));
		userList.add(new User("taeyo", "태종", "경기도 일산"));
		userList.add(new User("miss_hwang", "황진이", "대전시 유성구"));
		userList.add(new User("young", "영조", "경기도 구리시"));
		userList.add(new User("nononon","논개", "서울시 마포구"));
	}
	
	public static UserListSingleton getInstance(){
		if(instance==null){
			instance = new UserListSingleton();
		}
		return instance;
	}

	public List<User> getUserList() {
		return userList;
	}

	
}
