package com.kh.ws.groupchat;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;
import javax.websocket.server.ServerEndpointConfig.Configurator;

import com.kh.ws.model.vo.User;

/**
 * Configurator 란
 * 사용자 연결을 위한 websocket 객체를 생성할 때 기본적으로 설정할 정보들을 작성하는 클래스
 * 
 * Configurator 클래스를 상속 받을 경우, modifyHandshake() 메소드를 오버라이드함.
 * HttpSession에 접근 처리가 가능함.
 *  
 *	1. HandshakeRequet : HttpServletRequest 역할. 하지만, casting불가함(runtime에 ClassCastException유발)
 *	2. HandshakeResponse : HttpServletResponse 역할.
 * 
 */
public class GroupChatConfigurator extends Configurator{

	@Override
    public void modifyHandshake(ServerEndpointConfig config, 
                                HandshakeRequest request, 
                                HandshakeResponse response){
	 
		User loginUser = (User)((HttpSession)request.getHttpSession()).getAttribute("loginUser");
        
        config.getUserProperties().put("userId",loginUser.getUserId());
        
        System.out.println("config : "+config.getUserProperties());

	}
	
}






