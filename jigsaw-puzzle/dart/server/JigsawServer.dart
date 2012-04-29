
final HOST = "127.0.0.1";
final PORT = 8080;

final LOG_REQUESTS = true;

Map<String, Puzzle> puzzles;

void main() {
  HttpServer server = new HttpServer();
  puzzles = new Map<String, Puzzle>();
  Puzzle puzzle1 = new Puzzle("Mountains", "http://www.kleine-saechsische-schweiz.de/bilder/schauwerkstatt/bastei_1.jpg");
  Puzzle puzzle2 = new Puzzle("Desert", "http://www.molossia.org/pictures/desert4.jpg");
  
  puzzle1.addScore(new Score(1, new Player("player1")));
  puzzle1.addScore(new Score(4, new Player("player1")));
  puzzle1.addScore(new Score(2, new Player("player1")));
  puzzle1.addScore(new Score(3, new Player("player1")));
  puzzle1.addScore(new Score(7, new Player("player1")));
  puzzle1.addScore(new Score(10, new Player("player1")));
  puzzle1.addScore(new Score(6, new Player("player1")));
  puzzle1.addScore(new Score(9, new Player("player1")));
  puzzle1.addScore(new Score(5, new Player("player1")));
  puzzle1.addScore(new Score(8, new Player("player1")));
  
  puzzles[puzzle1.id] = puzzle1;
  puzzles[puzzle2.id] = puzzle2;
  
  server.addRequestHandler((HttpRequest request) => true, requestReceivedHandler);
  server.listen(HOST, PORT);
}


void requestReceivedHandler(HttpRequest request, HttpResponse response) {
  if (LOG_REQUESTS) {
    print("Request: ${request.method} ${request.uri}");
  }
  
  String resp = null;
  String requestUri = request.uri.toLowerCase();
  
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
      }     
  } else if (requestUri.startsWith("/getscores")) {
    print("here");
      String puzzleId = UrlReader.getPuzzleId(requestUri);
      resp = puzzles[puzzleId].getTopScores();
      
  } else if (requestUri.startsWith("/getpuzzle")) {
    
  } else if (requestUri.startsWith("/listpuzzles")) {
     resp = HttpResponseUtil.listPuzzles();
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
