class Player implements Hashable {
  
  String name;
  
  Player(this.name);
  
  int hashCode() {
    return name.hashCode();
  }
}
