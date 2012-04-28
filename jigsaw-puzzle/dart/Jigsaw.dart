#import("dart:html");
//#import("dart:dom");
#source('Piece.dart');
class Jigsaw{
  List<Piece> pieces; 
  List<int> randomPlaces;
  int amount=16;
  Jigsaw(){
    
    
  }
  /*
  * Will intiate the pieces
  */
  void createPieces(int amount){
    for (int i=0;i<amount;i++){
      pieces.add(new Piece(i));
    }
  }
  void randomizePlaces(){
    
    
  }
  void insertDivs(int i, ImageElement img){
    StringBuffer sb=new StringBuffer();
    sb.add(document.query("#board").innerHTML);
    var sqrt=Math.sqrt(amount);
    var div="<div id='piece_${i}'></div>";
    sb.add(div);
    print(img.width);
    document.query("#board").innerHTML = sb.toString();
    Element elm=document.query("#piece_${i}");
    elm.style.position="absolute";
    var left=i*((img.width)/sqrt).toInt();
    if (i>(sqrt-1)){
      left=i%sqrt*((img.width)/sqrt).toInt();
    }
    elm.style.left="${left}px";
    var top=(i~/sqrt)*((img.height)/sqrt).toInt();
    elm.style.top="${top}px";
    elm.style.width="${((img.width)/sqrt).toInt()}px";
    elm.style.height="${(((img.height)/sqrt)).toInt()}px";
    elm.style.background="url(\'img/img.jpg\') ${-left}px ${-top}px";
  }
  void ready(){
    ImageElement img= new Element.tag("img");
    img.src="img/img.jpg";
    print(img.height);
    pieces=new List<Piece>();
    createPieces(amount);
    pieces.forEach((element) => insertDivs(element.getOrigPlace(),img));
    
   
    //document.query("#board").innerHTML = "<div id='piece_1' style='position:absolute; width: 50px; height:50px; background: url(\"img/img.jpg\") 300px 550px;''></div>";
    
    
   
    // HTMLElement sourceImage= (HTMLElement)(document.query("#sourceImage"));
   //int srcImgHeight= ((HTMLImageElement)sourceImage).height();
    
  }
}

void main() {
  Jigsaw puzzle = new Jigsaw();
  puzzle.ready();
}
