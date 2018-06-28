package com.kh.ws.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kh.ws.model.vo.User;

public class UserMapSingletone {
	private static Map<String,String> userMap;//userId,userName맵

	public static Map<String, String> getUserMap() {
		if(userMap==null){
			userMap = new HashMap<>();
			List<User> userList = UserListSingletone.getInstance().getUserList();
			for (User user : userList) {
				userMap.put(user.getUserId(), user.getUserName());
			}
			System.out.println("userMap="+userMap);
		}
		return userMap;
	}
	
	
	
	
}
