package com.kh.ws.chat;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;


@ServerEndpoint(value="/chat/helloWebSocket", configurator=ChatConfigurator.class)
public class HelloWebSocket {
	private File uploadFile = null;
    private String fileName = null;
    private FileOutputStream fos = null;
    final static String filePath="C:\\Users\\nobodj\\Dropbox\\Coding\\Git\\webAPI\\02_WebSocket\\WebContent\\upload\\chat";
    
	//현재접속한 userId와 WebSocketSession을 매핑해 관리할 static필드(동기화처리 필수) 
	private static Map<String,Session> clients = Collections.synchronizedMap(new HashMap<>());
	
	@OnOpen
	public void onOpen(EndpointConfig config, Session session) throws IOException{
		//접속리스트에 새로 연결 요청이 들어온 사용자를 추가한다.
		String userId = (String)config.getUserProperties().get("userId");
		clients.put(userId, session);
		
		//세션에 userId를 담아서 onClose등에서 사용할 수 있게함.
		session.getUserProperties().put("userId", userId);
		
		System.out.println("현재접속자("+clients.size()+") : "+clients);
		
		//접속사실을 이 채팅방의 클라이언트들에게 알림
		onMessage("welcome§"+userId, session);
	}
	
	/**
	 * api참조 <a href=https://docs.oracle.com/javaee/7/api/index.html?javax/websocket/package-summary.html>https://stackoverflow.com/questions/1082050/linking-to-an-external-url-in-javadoc</a>
	 * String, byte[] 등이 메소드 파라미터로 사용가능함.
	 * 
	 * 파일관련 참고 :
	 * 파일업로드시 클라이언트늩 3종류의 메세지를 서버에 보낸다.
	 * 1. 파일명 전송 - 서버:파일업로드 준비
	 * 2. 파일전송(arraybuffer) - onFile메소드 호출(파일을 분할전송함)
	 * 3. 전송완료메세지  - 서버:다른 클라이언트에게 전송
	 *  
	 * @param msg
	 * @param session
	 * @throws IOException
	 */
	@OnMessage
	public void onMessage(String msg, Session session) throws IOException{
		System.out.println("[서버가 받은 메세지] : "+msg);
		String[] msgArr = msg.split("§");
		String type = msgArr[0];//welcome | adieu | message | file
		
		if("upload".equals(type)){
			
			if(!"end".equals(msgArr[2])){
				fileName = msgArr[2];//파일명을 필드변수 fileName에 담아둠.
				uploadFile = new File(filePath+File.separator+fileName);
				fos = new FileOutputStream(uploadFile);
				return;//다른 클라이언트에 전송하지 않고 종료.
			}
			else {
				System.out.println(fileName+" 파일전송완료!");
				
				msgArr[2] = fileName;
				msg = String.join("§", msgArr);//[2]의 end를 파일명으로 변경후 다시 csv문자열로 join, 다른 클라이언트에 전송함.
				
			}
		}
		
		if("download".equals(type)){
			
	        String fileName = msgArr[2];
	        System.out.println("파일다운로드요청 : " + fileName);

	        // 파일 객체 생성
	        File file = new File(filePath+File.separator+fileName);

	        // 파일을 담을 바이트 배열(inputstream에 전달해서 데이터를 담음.)
	        byte[] fileBytes = new byte[(int)file.length()];
	        
	        // 파일로 연결된 스트림 생성
	        BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
	        
	        // 바이트 배열에 파일 저장
	        bis.read(fileBytes);

	        //바이트 배열을 ByteBuffer(최종적으로 필요한 타입)에 담는다
	        ByteBuffer buf = ByteBuffer.wrap(fileBytes);

	        // ByteBuffer 를 클라이언트로 보낸다.
	        session.getBasicRemote().sendBinary(buf);
			
	        return;
		}
		
		/*하나의 업무가 실행하는 동안 사용자변경이 일어나서는 안된다.
		즉, NullPointerException을 방지하기 위해 동기화처리*/
		synchronized (clients) {
			Collection<Session> sessionList = clients.values();
			
			for(Session client : sessionList) 
				
				//메세지를 작성한 본인을 제외하고, 메세지를 보냄.
				if(!client.equals(session))
					client.getBasicRemote().sendText(msg);
		}
	}
	/**
	 * 파일업로드 처리 onMessage 메소드
	 * @param file
	 * @param last
	 * @param session
	 */
	@OnMessage
	public void onFile(ByteBuffer file, boolean last, Session session) throws IOException {
//        System.out.println("Binary Data");      
//        System.out.println("file="+file);
        
        while(file.hasRemaining()) {         
        	System.out.print(".");
        	fos.write(file.get());

        }

    }
	 
	@OnError
	public void onError(Throwable e){
		// 데이터 전달 과정에서 에러가 발생할 경우 수행하는 메소드
		//e.printStackTrace();
	}
	
	@OnClose
	public void onClose(Session session) throws IOException{
		String userId = (String)session.getUserProperties().get("userId");
		onMessage("adieu§"+userId, session);
		clients.remove(userId);
		
		System.out.println("현재접속자("+clients.size()+") : "+clients);
	}

	public static Map<String,Session> getClients() {
		return clients;
	}
}
