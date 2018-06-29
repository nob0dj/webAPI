package com.kh.ws.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kh.ws.model.vo.User;

/**
 * UserMapSingtone클래스는 별도의 객체생성없이 싱글톤으로 운영할 수 있도록
 * userMap static 필드를 추가함.
 * 
 * @author nobodj
 *
 */
public class UserMapSingletone {
	private static Map<String,String> userMap;//userId,userName맵

	public static Map<String, String> getUserMap() {
		if(userMap==null) userMap = new HashMap<>();
		
		//매번 최신화된 정보를 리턴함.
		List<User> userList = UserListSingletone.getInstance().getUserList();
		for (User user : userList) {
			userMap.put(user.getUserId(), user.getUserName());
		}
		//System.out.println("userMap="+userMap);
		
		return userMap;
	}
	
	
	
	
}
