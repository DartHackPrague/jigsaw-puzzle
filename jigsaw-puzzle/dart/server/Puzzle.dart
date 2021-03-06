class Puzzle implements Hashable {
	
	Set<Score> scores;
	String id;
	String url; 
	int width;
	int height;
	
	Puzzle(this.id, this.url, this.width, this.height) {
	 this.scores = new Set<Score>();
	}
	
	void addScore(Score score) {
	  // do not add same score for same player twice
	  for (var oldScore in scores) {
	    // is there something like an equals method in Dart?
	    if (oldScore.value == score.value && oldScore.name == score.name) {
	      return;
	    }
	  }
	  
		scores.add(score);
	}

	String getTopScores([int number=100]) {
	  print("${scores}");
		List<Score> sorted = new List.from(scores);
		sorted.sort((Score score1, Score score2) => -score1.compareTo(score2));
		int returnSize = number > scores.length ? scores.length : number;
		StringBuffer buff = new StringBuffer();
		
		buff.add("{");
	  List<Score> cutted = sorted.getRange(0, returnSize);
	   for (int i = 0; i < cutted.length; i++) {
	     buff.add("\"${cutted[i].value}\":\"${cutted[i].player.name}\"");
	     if (i + 1 < cutted.length) {
	       buff.add(",");       
	     }
	   }
	  buff.add("}");
	  return buff.toString();
	}
		
	int hashCode() => 17 * id.hashCode();
}
	