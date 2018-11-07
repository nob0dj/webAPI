/* 
* 브라우져 지원확인
*/
if (!window.indexedDB) {
    window.alert("Your browser doesn't support a stable version of IndexedDB. Such and such feature will not be available.")
}

/*
* 관련변수명 선언
*/
// In the following line, you should include the prefixes of implementations you want to test.
window.indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
// DON'T use "var indexedDB = ..." if you're not in a function.
// Moreover, you may need references to some window.IDB* objects:
window.IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction || window.msIDBTransaction;
window.IDBKeyRange = window.IDBKeyRange || window.webkitIDBKeyRange || window.msIDBKeyRange
// (Mozilla has never prefixed these objects, so we don't need window.mozIDB*)


/*
 * 데이터베이스 오픈
 */
//open(dbname, 버젼정보(정수))
//두번째인자 version을 생략하면, 자동으로 1이 부여됨.
var dbName = "test";
var request = window.indexedDB.open(dbName, 1);
console.log(request);//IDBOpenDBRequest

request.onerror = function(event) {
    alert("Database error: " + event.target.errorCode);
    console.dir(e);
};

request.onsuccess = function(event) {
    db = request.result;
    console.log("success : ", db);//IDBDatabase
};

const memberData = [
    { memberId: "kangdw", name: "강동원", email: "kangdw@company.com" },
    { memberId: "yuk", name: "육완순", email: "yuk@home.org" },
    { memberId: "honggd", name: "홍길동", email: "honggd@naver.com" },
    { memberId: "gdgdgd", name: "홍길동", email: "gdgdgd@naver.com" }
];

//db를 새로 생성하거나, version정보가 바뀌었을 경우에 호출되는 이벤트
request.onupgradeneeded = function(event) { 
    db = request.result;
    console.log("upgradeneeded : ", db);//IDBDatabase

    // Create an objectStore to hold information about our members. We're
    // going to use "ssn" as our key path because it's guaranteed to be
    // unique - or at least that's what I was told during the kickoff meeting.
    var objectStore = db.createObjectStore("members", { keyPath: "memberId" });

    // Create an index to search members by name. We may have duplicates
    // so we can't use a unique index.
    objectStore.createIndex("idx_name", "name", { unique: false });

    // Create an index to search members by email. We want to ensure that
    // no two members have the same email, so use a unique index.
    objectStore.createIndex("idx_email", "email", { unique: true });

    // Use transaction oncomplete to make sure the objectStore creation is 
    // finished before adding data into it.
    objectStore.transaction.oncomplete = function(event) {
        // Store values in the newly created objectStore.
        var memberObjectStore = db.transaction("members", "readwrite").objectStore("members");
        memberData.forEach( member => {
            memberObjectStore.add(member);
        });
    };
};

/**
 * 회원생성자함수
 */
function Member(memberId, name, email){
    this.memberId = memberId;
    this.name = name;
    this.email = email;
}

/**
 * 트랜잭션 객체를 리턴하는 함수
 * 트랜잭션 모드
 * 1. readonly
 * 2. readwrite
 * 3. versionchange
 */
function getTransaction(objectStore, mode){
    return db.transaction(objectStore, mode);
}

/**
 * 회원 전체조회
 */
function selectAll(){
    var transaction = getTransaction("members","readonly");
    var objectStore = transaction.objectStore("members");

    //리턴된 행 카운팅변수
    //(주의)onsuccess함수 안에 위치하면, cursor.continue()호출시 매번 초기화된다.
    var cnt = 0;

    objectStore.openCursor().onsuccess = function(event) {
        var cursor = event.target.result;
        if (cursor) {
            addDataRow(new Member(cursor.key, cursor.value.name, cursor.value.email));
            cnt++;
            cursor.continue();
        }
        else {
            if(cnt==0)
                addDataRow();
            else
                console.log("No more entries!");
        }
    };
}

function selectByIndex(indexName, search){
    // console.log(indexName, search);

    var transaction = getTransaction("members","readonly");
    var objectStore = transaction.objectStore("members");
    var index = objectStore.index(indexName);

    //1.인덱스가 unique한 경우
    if(indexName === 'idx_email'){

        //검색키워드로 인덱스 검색(한건 조회)
        index.get(search).onsuccess = function(event) {
            var member = event.target.result;
            if(member==undefined)
                addDataRow();
            else
                addDataRow(member);
        };
    }
    //2.인덱스가 not unique한 경우
    else {
        var cnt = 0;
        // cursor 오픈시에 검색조건(범위)를 제공한다.
        // Only match search keyword => 정확히 키워드가 매칭하는 경우만 검색
        var singleKeyRange = IDBKeyRange.only(search);

        // Using a normal cursor to grab whole customer record objects
        index.openCursor(singleKeyRange).onsuccess = function(event) {
            var cursor = event.target.result;
            if (cursor) {
                addDataRow(new Member(cursor.key, cursor.value.name, cursor.value.email));
                cnt++;
                cursor.continue();
            }
            if(cnt==0)
                addDataRow();
        };
    }

}

/*
* memberId로 한명 검색하기
*/
function selectOne(memberId){
    var transaction = getTransaction("members","readonly");
    var objectStore = transaction.objectStore("members");
    var request = objectStore.get(memberId);
    request.onerror = () => {
        //errer handling!
    };
    //request.result를 리턴할 수 없다.
    //request.result를 리턴할 경우 다음 예외 발생!
    //Uncaught DOMException: Failed to read the 'result' property from 'IDBRequest': The request has not finished.
    request.onsuccess = ()=> {
        // console.log(request.result);
        
        var m = request.result;
        if(m == undefined){
            alert("해당하는 회원이 존재하지 않습니다.");
            return;
        }        
        $("#memberId").attr("readonly","readonly").val(m.memberId);
        $("#name").val(m.name);
        $("#email").val(m.email);
    };
}



/**
 * 회원추가
 */
function insertMember(member){
    // console.log(member);

    var transaction = getTransaction("members","readwrite");
    var objectStore = transaction.objectStore("members");
    var request = objectStore.add(member);//전달된 객체와 objectStore의 객체구조가 동일해야 한다.(필드명 주의)
    request.onsuccess = function(event) {
        console.log("Successfully Added!", member)
    }
}

/**
 * 회원정보 수정
 * 단, keyPath로 사용된 memberId는 수정할 수 없다.
 */
function updateMember(member){
    console.log(member);
    var transaction = getTransaction("members","readwrite");
    var objectStore = transaction.objectStore("members");
    var request = objectStore.put(member);
    request.onsuccess = function(event) {
        console.log("Successfully Updated!", member);
    }
}

/**
 * 회원정보 삭제
 */
function deleteMember(memberId){
    var transaction = getTransaction("members","readwrite");
    var objectStore = transaction.objectStore("members");
    var request = objectStore.delete(memberId);
    request.onsuccess = function(event) {
        console.log("Successfully Deleted!", memberId);
    }
}