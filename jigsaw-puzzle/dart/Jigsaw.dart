#import("dart:html");
//#import("dart:dom");
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
  
  void ready(){
    pieces=new List<Piece>();
    createPieces(16);
    pieces.forEach((element) => print(element.getOrigPlace()));
    
   
    document.query("#board").innerHTML = "<div id='piece_1' style='position:absolute; width: 50px; height:50px; background: url(\"img/img.jpg\") 300px 550px;''></div>";
    ImageElement img= new Element.tag("img");
    img.src="img/img.jpg";
    
   
    // HTMLElement sourceImage= (HTMLElement)(document.query("#sourceImage"));
   //int srcImgHeight= ((HTMLImageElement)sourceImage).height();
    print(img.height);
  }
}

void main() {
  Jigsaw puzzle = new Jigsaw();
  puzzle.ready();
}
