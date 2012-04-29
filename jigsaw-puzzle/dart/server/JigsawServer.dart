
final HOST = "127.0.0.1";
final PORT = 8080;

final LOG_REQUESTS = true;

Map<String, Puzzle> puzzles;

void main() {
  HttpServer server = new HttpServer();
  puzzles = PersitenceEngine.load();
  print("$puzzles");
  
  server.addRequestHandler((HttpRequest request) => true, requestReceivedHandler);
  server.listen(HOST, PORT);
}

void requestReceivedHandler(HttpRequest request, HttpResponse response) {
  bool modification = false;
  
  if (LOG_REQUESTS) {
    print("Request: ${request.method} ${request.uri}");
  }
  
  String resp = null;
  String requestUri = request.uri.toLowerCase();
  try {
  if (requestUri.startsWith("/addpuzzle")) {
    Iterator it = request.queryParameters.getKeys().filter((key) => key.toUpperCase() == "URL").iterator();
    if (it.hasNext()) {
      String uri2 = new Uri.fromString(request.queryParameters[it.next()]).toString();
      print("decoded url: ${uri2}");
    } else {
      print("No URL found");      
    } 
  } else if (requestUri.startsWith("/addscore")) {
      String puzzleId = UrlReader.getPuzzleId(requestUri);
      String playerId = UrlReader.getPlayerId(requestUri);
      String score = UrlReader.getScore(requestUri);
      
      resp = "ok - player $playerId has the score $score at the puzzle $puzzleId";
      if (puzzles[puzzleId] == null) {
        resp = "puzzle not found";
        HttpResponseUtil.resourceNotFound(response);
      } else {
        puzzles[puzzleId].addScore(new Score(Math.parseInt(score), new Player(playerId)));
        modification = true;
      }     
  } else if (requestUri.startsWith("/getscores")) {
      String puzzleId = UrlReader.getPuzzleId(requestUri);
      resp = puzzles[puzzleId].getTopScores(); 
  } else if (requestUri.startsWith("/listpuzzles")) {
     resp = HttpResponseUtil.listPuzzles();
  }
  } catch (Exception ex) {
    print(ex);
  }
  
  if (modification) {
    PersitenceEngine.store(puzzles.getValues());
  }
  
  response.headers.set(HttpHeaders.CONTENT_TYPE, "text/html; charset=UTF-8");
  response.outputStream.writeString("$resp");
  response.outputStream.close();
}

class HttpResponseUtil {
 
  static String listPuzzles() {
    Map<String, String> jsonMap = {};
    puzzles.forEach((k, v) => jsonMap[k] = v.url);
    return JSON.stringify(jsonMap);
  }
  
  static void resourceNotFound(HttpResponse resp) {
    resp.statusCode = 404;
  }
}

class UrlReader {
  static RegExp puzzleExp = const RegExp(@"/puzzle/([a-zA-Z0-9]*)");
  static RegExp playerExp = const RegExp(@"/player/([a-zA-Z0-9]*)");
  static RegExp scoreExp = const RegExp(@"/score/([0-9]*)");
 
  static String getPuzzleId(String url) => getString(url, puzzleExp);
  static String getPlayerId(String url) => getString(url, playerExp);
  static String getScore(String url) => getString(url, scoreExp);
 
  static String getString(String url, RegExp exp) {
    Match m = exp.firstMatch(url);
    return m == null ? null : m.group(1);    
  }
}
