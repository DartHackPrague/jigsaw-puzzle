class Score implements Comparable, Hashable {
  int value;
  Player player;
  
  Score(this.value, this.player);

  int compareTo(Score other) => this.value.compareTo(other.value);
  
  static int compare(int source1, int source2) => source1.compareTo(source2);
  
  String toString() => "[$value, $player]";
  
  String get name() => player.name;
  
  int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((player == null) ? 0 : player.hashCode());
    result = prime * result + ((value == null) ? 0 : value.hashCode());
    return result;
  }
  
  bool equals(Score other) => value == value;
}
