#source('Piece.dart');
class Jigsaw{
  List<Piece> pieces; 
  List<int> randomPlaces;
  Jigsaw(){
    
    
  }
  /*
  * Will intiate the pieces
  */
  void createPieces(int amount){
    for (int i=1;i<=amount;i++){
      pieces.add(new Piece(i));
    }
  }
  void randomizePlaces(){
    
    
  }
  
}

void main() {
  print("Hello World");
}
