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
    List<int> listSorted = new List<int>();
    for (int i = 0; i < amount; ++i)
    {
      listSorted.add(i);
    }
    shuffle(listSorted);
    //listSorted.forEach((element) => print(element));
    for (int i = 0; i < pieces.length; i++) {
      pieces[i].setActPlace(listSorted[i]);
      print("i=${i}:${listSorted[i]}");
    }
  }
  void shuffle(List<int> list) {
    int len = list.length - 1;
    for (int i = 0; i < len; i++) {
      int index = (Math.random() * (len - i)).toInt() + i;
      int tmp = list[i];
      list[i] = list[index];
      list[index] = tmp;
    }
  }

  void insertDivs(Piece el, ImageElement img){
    int i=el.getOrigPlace();
    int a=el.getActPlace();
    StringBuffer sb=new StringBuffer();
    sb.add(document.query("#board").innerHTML);
    var sqrt=Math.sqrt(amount);
    var div="<div id='piece_${i}'></div>";
    sb.add(div);
    print(img.width);
    document.query("#board").innerHTML = sb.toString();
    Element elm=document.query("#piece_${i}");
    elm.style.position="absolute";
    var leftPosition=a*((img.width)/sqrt).toInt();
    if (a>(sqrt-1)){
      leftPosition=a%sqrt*((img.width)/sqrt).toInt();
    }
    var topPosition=(a~/sqrt)*((img.height)/sqrt).toInt();
    var left=i*((img.width)/sqrt).toInt();
    if (i>(sqrt-1)){
      left=i%sqrt*((img.width)/sqrt).toInt();
    }
    elm.style.left="${leftPosition}px";
    var top=(i~/sqrt)*((img.height)/sqrt).toInt();
    elm.style.top="${topPosition}px";
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
    randomizePlaces();
    pieces.forEach((element) => insertDivs(element,img));
    
    
  }
}

void main() {
  Jigsaw puzzle = new Jigsaw();
  puzzle.ready();
}
