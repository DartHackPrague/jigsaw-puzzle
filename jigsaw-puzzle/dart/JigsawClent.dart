//#import('dart:html');
#import("dart:io");
class JigsawClent {
  
  
  String getPuzzlesList(){
    XMLHttpRequest req = new XMLHttpRequest(); // create a new XHR

    var url = "http://localhost:8080/listpuzzles";
    String responceStr="";
    req.open("GET", url); // POST to send data

    req.on.readyStateChange.add((Event e) {
    if (req.readyState == XMLHttpRequest.DONE &&
    (req.status == 200 || req.status == 0)) {
    onSuccess(req); // called when the POST successfully completes
    }
    });

    req.send(""); // kick off the request to the server
    }

    // print the raw json response text from the server
    onSuccess(XMLHttpRequest req) {
      responceStr=(req.responseText); // print the received raw JSON text
    }
 return responceStr; 
}
