//ObjectStore생성시, autoIncrement를 통해서 회원 고유번호를 부여하기
var dbName = 'kh';
var request = indexedDB.open(dbName, 1);

request.onerror = function(event) {
    alert("Database error: " + event.target.errorCode);
    console.dir(e);
};

request.onsuccess = function(event) {
    db = request.result;
    console.log("success : ", db);//IDBDatabase
};

request.onupgradeneeded = event => {

    var db = event.target.result;

    // Create another object store called "names" with the autoIncrement flag set as true.    
    var objStore = db.createObjectStore("member", { autoIncrement : true });

    // Because the "names" object store has the key generator, the key for the name value is generated automatically.
    // The added records would be like:
    // 1 = "강동원"
    // 2 = "육완순"
    memberData.forEach(member => {
        objStore.add(member.name);
    });
};