#import('../Score.dart');

main() {
	ScoreTest test = new ScoreTest();
	
	test.runSimpleTest();
}


class ScoreTest {
	
	void runSimpleTest() {
		Score score1 = new Score(1, "Player");
		Score score2 = new Score(1, "Player");
		Expect.isTrue(score1.compareTo(score2) == 0);
		
		
		score1 = new Score(1, "Player");
		score2 = new Score(2, "Player");
		Expect.isTrue(score1.compareTo(score2) < 0);
		
		score1 = new Score(2, "Player");
		score2 = new Score(1, "Player");
		Expect.isTrue(score1.compareTo(score2) > 0);
	}
	

}