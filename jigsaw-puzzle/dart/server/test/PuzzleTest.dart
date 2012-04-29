#library('testPuzzleTest');
#import('dart:io');
#import('dart:json');
#source('../Puzzle.dart');
#source('../Score.dart');
#source('../Player.dart');

main() {
  PuzzleTest test = new PuzzleTest();
  test.findsTopScores(); 
  test.filtersIfAPlayerHasTheSameScoreMoreThanOnce();
}

class PuzzleTest {
  
  void findsTopScores() {
    Puzzle puzzle1 = new Puzzle("test1");
    
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
    
    
    String jsonPart = puzzle1.getTopScores();
    print(jsonPart);
    //Expect.stringEquals("{\"1\":\"player1\",\"2\":\"player1\",\"3\":\"player1\",\"4\":\"player1\",\"5\":\"player1\",\"6\":\"player1\",\"7\":\"player1\",\"8\":\"player1\",\"9\":\"player1\",\"10\":\"player1\"}", jsonPart);
  }
  
  void filtersIfAPlayerHasTheSameScoreMoreThanOnce() {
    Puzzle puzzle1 = new Puzzle("test1");
    
    puzzle1.addScore(new Score(1, new Player("player1")));
    puzzle1.addScore(new Score(1, new Player("player1")));
   
    Expect.equals(1, puzzle1.getTopScores().length);
  }
  
}
