class PersitenceEngine {
	static final String storageFile = "/home/marek/git/jigsaw-puzzle/config/properties2.store";
	
	static void store(Collection<Puzzle> puzzlesToStore) {
		Map<String, String> puzzleUrlMap = {};
		Map<String, String> scoresMap = {};
		
		puzzlesToStore.forEach((p) => puzzleUrlMap[p.id] = p.url);
		puzzlesToStore.forEach((p) => scoresMap[p.id] = p.getTopScores(1000, true));
	
    	File file = new File(storageFile);
    	if (!file.existsSync()) {
			file.createSync();
			print("${file.fullPathSync()} created");
    	}
    	
    	OutputStream out;
    	try {
    		out = file.openOutputStream();
    		String puzzleToUrl = JSON.stringify(puzzleUrlMap);
    		out.writeString(puzzleToUrl); 
    		out.writeString("\n");
    		String puzzleToScores = JSON.stringify(scoresMap);
    		puzzleToScores = puzzleToScores.replaceAll("\\\"", "\"");
    		puzzleToScores = puzzleToScores.replaceAll("\"{", "{");
    		puzzleToScores = puzzleToScores.replaceAll("}\"", "}");
    		out.writeString(puzzleToScores); 
    	} finally {
    		if (out != null) {
    			out.close();
    		}
    	}
	}
	
	static Map load() {
		File file = new File(storageFile);
    	
    	if (!file.existsSync()) {
      		print("${file.fullPathSync()} does not exist");
    	 print("not found"); 
      		return {};
    	}
    	List<String> lines = file.readAsLinesSync();
    	Iterator<String> lIt = lines.iterator();
    	
    	Map<String, Puzzle> loadedPuzzles = {};
    	if (lIt.hasNext()) {
    		loadedPuzzles = loadPuzzles(lIt.next());
    	}
    	
    	if (loadedPuzzles.isEmpty()) {
    		return {};
    	}
  
    	if (lIt.hasNext()) {
    		loadedPuzzles = loadScores(lIt.next(), loadedPuzzles);
    	}
    	
    	return loadedPuzzles;
	}
	
	static Map<String, Puzzle> loadPuzzles(String puzzlesStr) {
		Map<String, String> readPs = JSON.parse(puzzlesStr);
		Map<String, Puzzle> loadedPs = {};
		
		readPs.forEach((k, v) => loadedPs[k.toLowerCase()] = new Puzzle(k, v));		
		return loadedPs;
	}
	
	static Map<String, Puzzle> loadScores(String scoresStr, Map<String, Puzzle> puzzles) {
		Map readScores = JSON.parse(scoresStr);
		readScores.forEach((k, v) => v.forEach((k2, v2) => puzzles[k.toLowerCase()].addScore(new Score(Math.parseInt(k2), new Player(v2)))));
		
		return puzzles;
	}
	
}
