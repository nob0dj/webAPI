# WebSocket
[webSocket 으로 개발하기 전에 알고 있어야 할 것들](http://adrenal.tistory.com/20)
기존의 양방향 통신 방법
* polling
* long polling
* streaming
* websocket(HTML5표준)

javax.websocket패키지를 이용함. 이는 예전에는 javaee버젼에 포함된 패키지로, tomcat라이브러리중 websocket-api.jar에 있음.


## 구현기능
1. 그룹채팅
2. 접속자목록 실시간확인
3. 현재접속중인 사용자에게 쪽지(DM) 보내기
4. 채팅아이디 중복방지 필터

## 1. 그룹채팅

@index.jsp

    <script
        src="https://code.jquery.com/jquery-3.4.1.min.js"
        integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
        crossorigin="anonymous"></script>
    <style>
    div.input-container{display:none;}
    div#user-cheatsheet ul{list-style:none; padding:10px 0 0 0 ; color:lightgray;}
    </style>
    </head>
    <body>
        <h2><a href="javascript:$('.input-container:eq(0)').show().find('#userId').focus();">Hello WebSocket</a></h2>
        <div class="input-container">
            <input type="text" id="userId" placeholder="접속아이디" /> <button onclick="goChat();">접속</button>
        </div>		
    <script>
    function goChat(){
        
        var userId = $("#userId").val().trim();
        if(userId.length!=0)
            location.href = "${pageContext.request.contextPath}/chat/chatRoom.chat?userId="+userId;
    }
    </script>




@com.kh.ws.chat.ChatRoomServlet

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
        //이후 ChatConfig클래스의 modifyHandshake메소드에서 
		//HandShakeRequest => HttpSession 세션속성  => EndServerPointConfig의 userProperties에 저장됨.
		HttpSession session = request.getSession();
		String userId = request.getParameter("userId");
        
        session.setAttribute("userId", userId);		
		request.getRequestDispatcher("/WEB-INF/views/chat/chatRoom.jsp").forward(request, response);
	}


@/WEB-INF/views/chat/chatRoom.jsp


    <script
        src="https://code.jquery.com/jquery-3.4.1.min.js"
        integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
        crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">


    <script>
    var host = location.host;//localhost이거나, 서버컴퓨터 ip주소를 담아둠.
    var ws = new WebSocket('ws://'+ host +'${pageContext.request.contextPath}/chat/helloWebSocket');

    //웹 소켓을 통해 연결이 이루어 질 때 동작할 메소드
    ws.onopen = function(e){
        console.log("open!");
    };

    // 서버로부터 메시지를 전달 받을 때 동작하는 메소드
    ws.onmessage = function(e){
        console.log("message!:"+e.data);
    }

    // 서버에서 에러가 발생할 경우 동작할 메소드
    ws.onerror = function(event){
        console.log("error!");
    }
    // 서버와의 연결이 종료될 경우 동작하는 메소드
    ws.onclose = function(event){
        console.log("close!");
    }
    </script>


@com.kh.ws.chat.HelloWebSocket
`/chat/helloWebSocket`요청을 처리할 webSocket ServerEndPoint설정

`Session객체.getBasicRemte()`는 RemoteEndpoint.Basic내부인터페이스를 리턴함. 커넥션에 대한 동기화를 보장하며, 읽기/쓰기 업무처리함.
또, IOException을 던지므로 예외처리 할것. 

**처음 작성해야할 메소드목록을 확인시킨후, onOpen, onMessage만 상세 작성후 확인하도록 한다. 모두 작성후 확인하기에는 시간이 너무 오래걸리고, 학생들이 지루해함**

    @ServerEndpoint(value="/chat/helloWebSocket", configurator=HelloWebSocketConfigurator.class)
    public class HelloWebSocket {
        //현재접속한 userId와 WebSocketSession을 매핑해 관리할 static필드(동기화처리 필수) 
    //    public static Map<String,Session> clients = Collections.synchronizedMap(new HashMap<>());
        public static Map<String,Session> clients = new HashMap<>();

        @OnOpen
        public void onOpen(EndpointConfig config, Session session) {
            //접속리스트에 새로 연결 요청이 들어온 사용자를 추가한다.
            String userId = (String)config.getUserProperties().get("userId");
            clients.put(userId, session);

            //세션에 userId를 담아서 onClose등에서 사용할 수 있게함.
            session.getUserProperties().put("userId", userId);

            System.out.println("현재접속자("+clients.size()+") : "+clients);
            
            //다른사용자에게 접속메세지 보냄(json문자열처리)
            Map<String,Object> map = new HashMap<>();
            map.put("type", "welcome");
            map.put("msg", "님이 입장했습니다.");
            map.put("sender", userId);
            map.put("time", new Date().getTime());
            onMessage(new Gson().toJson(map),session);
        }
        
        @OnMessage
        public void onMessage(String msg, Session session) {
            System.out.println("[서버가 받은 메세지} : "+msg);
            Map<String, Object> map = new Gson().fromJson(msg, Map.class);
            String type = (String)map.get("type");
            
            //하나의 업무가 실행하는 동안 사용자변경이 일어나서는 안된다. 즉, NullPointerException을 방지하기 위해 동기화처리
            synchronized (clients) {
                Collection<Session> sessionList = clients.values();
                
                for(Session client : sessionList) {            	 
                    //메세지를 작성한 본인을 제외하고, 메세지를 보냄.
                    //adieu메세지 전송시는 해당세션을 제외해야한다.
                    if("adieu".equals(type) && client.equals(session))
                        continue;
                    
                        try {
                            client.getBasicRemote().sendText(msg);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                }
                    
            }
        }
        
        @OnError
        public void onError(Throwable e){
            // 데이터 전달 과정에서 에러가 발생할 경우 수행하는 메소드
            //e.printStackTrace();
        }
        
        @OnClose
        public void onClose(Session session) {
            String userId = (String)session.getUserProperties().get("userId");
            //다른사용자에게 접속메세지 보냄(json문자열처리)
            Map<String,Object> map = new HashMap<>();
            map.put("type", "adieu");
            map.put("msg", "님이 퇴장했습니다.");
            map.put("sender", userId);
            map.put("time", new Date().getTime());
            onMessage(new Gson().toJson(map),session);
            clients.remove(userId);
            
            System.out.println("현재접속자("+clients.size()+") : "+clients);
        }

    }



@com.kh.ws.chat.HelloWebSocketConfigurator
작성후 HelloWebSocket @ServerEndPoint 어노테이션에 등록해둘것.

    /**
    * Configurator 란 사용자 연결을 위한 websocket 객체를 생성할 때 기본적으로 설정할 정보들을 작성하는 클래스
    * 
    * Configurator 클래스를 상속 받을 경우, modifyHandshake() 메소드를 오버라이드함. HttpSession에 접근할 수
    * 있음
    * 
    * 1. HandshakeRequet : HttpServletRequest 역할. 하지만, casting불가함 
    * 2. HandshakeResponse : HttpServletResponse 역할.
    * 
    */
    public class HelloWebSocketConfigurator extends Configurator {

        @Override
        public void modifyHandshake(ServerEndpointConfig config, 
                                    HandshakeRequest request, 
                                    HandshakeResponse response) {

            String userId = (String) ((HttpSession) request.getHttpSession()).getAttribute("userId");
            config.getUserProperties().put("userId", userId);

            System.out.println("config : userId=" + config.getUserProperties().get("userId"));
        }

    }


@/WEB-INF/views/chat/chatRoom.jsp
부트스트랩 컴포넌트중 jumbotron, list - flush, badge 가져와서 사용함.
[jumbotron](https://getbootstrap.com/docs/4.1/components/jumbotron/)
[list#flush](https://getbootstrap.com/docs/4.1/components/list-group/#flush)
[badge](https://getbootstrap.com/docs/4.1/components/badge/#contextual-variations)


부트스트랩 get started에서 cdn 가져오기
**단, jquery slim버젼은 ajax를 사용할 수 없으므로, jquery 일반버젼을 사용하도록 한다.**

    <script
        src="https://code.jquery.com/jquery-3.4.1.min.js"
        integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
        crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">


    <div class="jumbotron jumbotron-fluid">
	  <div class="container">
		<h1 class="display-4">Websocket Chatroom</h1>
		<p class="lead">This is a modified jumbotron that occupies the entire horizontal space of its parent.</p>
	  </div>
	</div>
	
	<section id="chat-container">	
		<div id="msg-container">
			<ul class="list-group list-group-flush">
			  <!-- <li class="list-group-item">Cras justo odio</li>
			  <li class="list-group-item">Dapibus ac facilisis in</li>
			  <li class="list-group-item">Morbi leo risus</li>
			  <li class="list-group-item">Porta ac consectetur ac</li>
			  <li class="list-group-item">Vestibulum at eros</li> -->
			</ul>
		</div>
		
		<div class="input-group mb-3" >
		  <input type="text" class="form-control" id="msg">
		  <div class="input-group-append">
			<button class="btn btn-outline-secondary" type="button" id="send">Send</button>
		  </div>
		</div>
	</section>


스타일 추가

    <style>
    #chat-container{
        width: 600px;
        margin: 0 auto;
        padding: 10px;
    }
    #msg-container {	
        height: 600px;
        overflow-y: scroll;
    }
    </style>

    <script>

        // 서버로부터 메시지를 전달 받을 때 동작하는 메소드
        ws.onmessage = function(e){
            console.log("message!:"+e.data);
            var o = JSON.parse(e.data);
            var html = '<li class="list-group-item"><span class="badge badge-dark">'+o.sender+'</span> '+o.msg+'</li>';
            $("#msg-container ul").append(html);
        }

        ....


        $(function(){
            $("#send").click(function(){
                var o = {
                        type:"message",
                        msg: $("#msg").val(),
                        sender: "<%=userId%>",
                        time: Date.now()
                }
                var s = JSON.stringify(o);
                ws.send(s);
                
                $("#msg").val('').focus();
            });
            
            $("#msg").keyup(function(e){
                if(e.key == 'Enter'){
                    $("#send").trigger('click');
                }
            });
            
        });
    </script>


## 2. 접속자목록 실시간확인

@/chat/chatRoom.jsp

    <style>
    ...
    #btn-userList{
        margin: 10px 100px;
    }
    </style>


    <button type="button" class="btn btn-success btn-small" id="btn-userList">현재사용자확인</button>
	
    <section id="chat-container">....	

    <script>
    $(function(){
        ...
        $("#btn-userList").click(function(){
            $.ajax({
                url: "${pageContext.request.contextPath}/chat/userList.chat",
                dataType: "json",
                success: function(data){
                    var len = data.length;
                    alert(data+" ("+len+"명)");
                }
            });
        });
        
    });
    </script>

@com.kh.ws.UserListServlet


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, Session> clients = HelloWebSocket.clients;
		Set<String> userList = clients.keySet();
		
		//System.out.println("userList@UserListServlet="+userList);
		
		response.setContentType("application/json; charset=UTF-8");
		new Gson().toJson(userList, response.getWriter());
	}






## 3. 현재접속중인 사용자에게 쪽지(DM) 보내기
접속중이 특정상대에게 쪽지(DM)을 보낸다.(단, 접속중인 상태에서만 가능함.)

@chatRoom.jsp
dm관련 섹션을 추가한다.
[select 첫번째 컴포넌트](https://getbootstrap.com/docs/4.1/components/input-group/#custom-select)


    <section id="chat-container">    
        ...
        <hr style="margin:30px 0" />

		<!-- dm관련 섹션 -->		
		<div id="dm-container" class="input-group mb-3">
			<div class="input-group-prepend">
			  <label class="input-group-text" for="dm-client">DM</label>
			</div>
			<select class="custom-select" id="dm-client">
				<option value="" disabled selected>접속자 목록</option>
			</select>
		</div>
		<div class="input-group mb-3">
			<input type="text" class="form-control" id="dm-msg">
			<div class="input-group-append">
				<button class="btn btn-outline-secondary" type="button"
					id="dm-send">DM-Send</button>
			</div>
		</div>

    </section>


접속자 목록 가져와서 `select>option`태그 작성하기
기존의 서블릿 `/chat/userList.chat`에 요청해서 처리한다.

    //dm전송을 위한 접속자 명단 가져오기
	$("#dm-client").focus(function(){
		$.ajax({
			url: "${pageContext.request.contextPath}/chat/userList.chat",
			dataType: "json",
			success: function(data){
				console.log(data);
				$("#dm-client").html('<option value="" disabled>접속자 목록</option>');				
				
				for(var i in data){
					$("#dm-client").append('<option value="'+data[i]+'">'+data[i]+'</option>');
				}
			}
		});
	});


DM전송
dm객체는 receiver속성을 추가하고, json문자열로 서블릿 전송한다.

	//dm전송
	$("#dm-send").click(function(){
		if($("#dm-msg").val().trim().length == 0 ||
		   $("#dm-client option:selected").val() == ""){
			console.log("dm is not gonna sent!");
			return;
		}
		
		
		var dm = {
				type:"dm",
				msg: $("#dm-msg").val(),
				sender: "<%=userId%>",
				receiver: $("#dm-client option:selected").val(),
				time: Date.now()
		}
		
		$.ajax({
			url: "${pageContext.request.contextPath}/chat/sendDM.chat",
			data: {dm: JSON.stringify(dm)},
			dataType: "json",
			success: function(data){
				console.log(data.result);
			}, 
			complete: function(){
				//dm input태그 초기화
				$("#dm-msg").val('');
			}
		});
	});


@com.kh.ws.SendDMServlet

    @WebServlet("/chat/sendDM.chat")
    public class SendDMServlet extends HttpServlet {
        ...

        /**
        * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
        */
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            //1.encoding
            request.setCharacterEncoding("utf-8");
            response.setContentType("application/json; charset=utf-8");
            
            //2.parameter handling
            String dm = request.getParameter("dm");
            Map<String, Object> dmMap = new Gson().fromJson(dm, Map.class);
            System.out.println("dm@servlet="+dmMap);
            
            
            //3.business logic: 해당 사용자를 찾아서 메세지 전송
            String result = "";
            Map<String, Session> clients = HelloWebSocket.clients;
            Set<String> userList = clients.keySet();
            
            if(userList.contains(dmMap.get("receiver"))) {
                Session dmReceiver = clients.get(dmMap.get("receiver"));
                dmReceiver.getBasicRemote().sendText(dm);
                result = "DM을 성공적으로 전송했습니다.";
            }
            else {
                result = "해당 사용자가 현재 접속중이 아닙니다.";
            }
            
            //4.결과 전송
            Map<String, String> resultMap = new HashMap<>();
            resultMap.put("result", result);
            new Gson().toJson(resultMap, response.getWriter());
        }

        ...
    }






## 4.(생략) 채팅아이디 중복방지 필터
@com.kh.ws.filter.DuplicateIdCheckFilter
사용자 요청 url  `/chat/chatRoom.chat`에 대해 중복 아이해 검사



    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		Map<String, Session> clients = HelloWebSocket.clients;
		Set<String> userSet = clients.keySet();
		
		//사용자 요청아이디를 HttpServletRequest에서 가져온다.
		String userId = ((HttpServletRequest)request).getParameter("userId");
		
		//현재 사용자 목록에서 존재여부 확인
		boolean isUsable = !userSet.contains(userId);
		System.out.printf("[%s]사용가능여부@DuplicateIdCheckFilter=%s", userId, isUsable);
		
		if(userId == null || !isUsable){
			request.setAttribute("msg", "사용할 수 없는 아이디입니다.");
			request.setAttribute("loc", "/");
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
				   .forward(request, response);
			return;
		}
		
		
		// pass the request along the filter chain
		chain.doFilter(request, response);
	}



