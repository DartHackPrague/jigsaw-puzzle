class Piece {
  int orgPlace;
  int actPlace;
  int x;
  int y;
  
  Piece(int origPlace){
    orgPlace=origPlace;
    
  }
  int getActPlace(){
    return actPlace;
  }
  int getOrigPlace(){
    return orgPlace;
    
  }
  void setActPlace(int place){
    actPlace=place;
  }
  void swichPlace(Piece piece){
    int place=this.getActPlace();
    this.setActPlace(piece.getActPlace());
    piece.setActPlace(place);
  }
  bool isCorrect(){
    if (orgPlace==actPlace){
      return true;
    }
    return false;  
  }
  
  
}