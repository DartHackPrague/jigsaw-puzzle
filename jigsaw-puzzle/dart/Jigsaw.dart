#import("dart:html");
//#import("dart:dom");
#source('Piece.dart');
//#source('JigsawClent.dart');
class Jigsaw{
  List<Piece> pieces; 
  List<int> randomPlaces;
  int amount=16;
  int posStart;
  int posEnd;
  int boardTop;
  int boardLeft;
  ImageElement img;
  bool listen;
  Date startTime;
  Date endTime;
  int interval;
  int maxTime;
  int totalTime;
  int totalScore;
  bool enabled;
  String image;
  String responceStr;
  
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
      //print("i=${i}:${listSorted[i]}");
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
    pieces[i].setX(leftPosition);
    var topPosition=(a~/sqrt)*((img.height)/sqrt).toInt();
    pieces[i].setY(topPosition);
    var left=i*((img.width)/sqrt).toInt();
    if (i>(sqrt-1)){
      left=i%sqrt*((img.width)/sqrt).toInt();
    }
    elm.style.left="${leftPosition}px";
    var top=(i~/sqrt)*((img.height)/sqrt).toInt();
    elm.style.top="${topPosition}px";
    elm.style.width="${((img.width)/sqrt).toInt()}px";
    elm.style.height="${(((img.height)/sqrt)).toInt()}px";
    elm.style.background="url(\'${img.src}\') ${-left}px ${-top}px";
    elm.style.display="block";
    elm.draggable=true;
  }
  int getPosition(int x, int y, ImageElement img){
    int pozice;
    x-=boardLeft;
    y-=boardTop;
    pozice=((x~/(img.width~/Math.sqrt(amount))))+(((y~/(img.height~/Math.sqrt(amount))))*Math.sqrt(amount));
    return pozice;
  }
  int getActualPosition(int position){
    for (int i = 0; i < pieces.length; i++) {
      if(pieces[i].getActPlace()==position){
        return(i);
      } 
    }
  }
  String getImage(){
    print(image);
    return image;
  }
  void setImage(String source){
    image=source;
    img.src=source;
  }
  int getDifficulty(){
    return amount;
  }
  void setDifficulty(int diff){
    amount=diff;
    restart();
  }
  bool checkPositions(){
    for (int i = 0; i < pieces.length; i++) {
      if(!pieces[i].isCorrect()){
        return false;
      } 
    }   
    return true;
  }
  void eventListener(UIEvent e){
    //eventP=event;
    if (listen==true){
      e.preventDefault(); 
      e.stopPropagation(); 
      
      int pos=getPosition(e.pageX,  e.pageY, img); 
      
      //print(posStart);
      
      document.query("#piece_${getActualPosition(posStart)}").style.top="${e.pageY-boardTop-(img.height~/(Math.sqrt(amount)*2))}px";
      document.query("#piece_${getActualPosition(posStart)}").style.left="${e.pageX-boardLeft-(img.width~/(Math.sqrt(amount)*2))}px";
    }
    
      //return false;
  }
  void updateTime(){
    Date time=new Date.now();
    document.query("#gTime").innerHTML="${time.difference(startTime).inSeconds}";
    totalTime=time.difference(startTime).inSeconds;
    totalScore=countScore();
    document.query("#gScore").innerHTML="${totalScore}";
    if (totalScore<=0){
      document.query("#gTime").style.color="red";
    }
  }
  int countScore(){
    int score=(amount*maxTime)-(totalTime*amount);
    if (score<0){
      score=0;
    }
    return score;
  }
  int getScore(){
    return totalScore;
  }
  bool restart(){
    pieces=new List<Piece>();
    createPieces(amount);
    randomizePlaces();
    document.query("#board").innerHTML="";
    pieces.forEach((element) => insertDivs(element,img));
    boardLeft= document.query("#board").$dom_offsetLeft;
    boardTop=document.query("#board").$dom_offsetTop;
    startTime=new Date.now();
    window.clearInterval(interval);
    interval=window.setInterval(f() => updateTime(), 1000);
    enabled=true;
  }
  void ready(){
    img= new Element.tag("img");
    setImage("img/img.jpg");
    maxTime=300;
    pieces=new List<Piece>();
    createPieces(amount);
    randomizePlaces();
    pieces.forEach((element) => insertDivs(element,img));
    boardLeft= document.query("#board").$dom_offsetLeft;
    boardTop=document.query("#board").$dom_offsetTop;
    //document.query("#board").on.mouseMove.add((e){
    //  print(getPosition(e.pageX, e.pageY, img));      
    //});
    //startTime=new Date.now();
    //interval=window.setInterval(f() => updateTime(), 1000);
    enabled=false;
    document.query("#difficulty").on.change.add((event){
      SelectElement el=document.query("#difficulty");
      print(el.selectedIndex);
      switch (el.selectedIndex){
        case 0:
          setDifficulty(4);
          break;
        case 1:
          setDifficulty(49);
          break;
        case 2:
          setDifficulty(100);
          break;
      }
    });
    document.query("#restart").on.click.add((event) {restart();});
    document.query("#help").on.click.add((event) {
      DivElement board=document.query("#board");
      String inText= board.innerHTML;
      board.innerHTML="<div id='helpImage'></div>";
      DivElement helpImage=document.query("#helpImage");
      helpImage.style.position="absolute";
      helpImage.style.top="0px";
      helpImage.style.left="0px";
      helpImage.style.background="url('${getImage()}')";
      helpImage.style.width="${img.width}px";
      helpImage.style.height="${img.height}px";
      window.setTimeout(f() => board.innerHTML=inText, 3000);
    });
    document.query("#prev").on.click.add((event) {
      //ImageElement el= document.query("#thumbnail");
      //el.src="";
      SpanElement sel = document.query("#pictureLabel");
      sel.innerHTML="prev label";
      print("prev");
    });
    document.query("#next").on.click.add((event) {
      //ImageElement el= document.query("#thumbnail");
      //el.src="";
      SpanElement sel = document.query("#pictureLabel");
      sel.innerHTML="next label";
      print("next");
    });
    document.query("#board").on.mouseDown.add((event) { 
      if (enabled==true){
        event.preventDefault(); 
        event.stopPropagation(); 
        listen=true;
        posStart=getPosition(event.pageX,  event.pageY, img).toInt(); 
        document.query("#piece_${getActualPosition(posStart)}").style.top="${event.pageY-boardTop-(img.height~/(Math.sqrt(amount)*2))}px";
        document.query("#piece_${getActualPosition(posStart)}").style.left="${event.pageX-boardLeft-(img.width~/(Math.sqrt(amount)*2))}px";
        document.query("#piece_${getActualPosition(posStart)}").style.zIndex="1000";
        //print("#piece_${posStart}");
        //print("#piece_${getActualPosition(posStart)}");
      }
      return false;
      });
    
    
    document.query("#board").on.mouseUp.add((event) { 
      if (enabled==true){
        event.preventDefault(); 
        event.stopPropagation();
        listen=false;
        document.query("#board").on.mouseMove.remove(eventListener);
        
        posEnd=getPosition(event.pageX,  event.pageY, img);
        //print(posEnd);
        document.query("#piece_${getActualPosition(posStart)}").style.zIndex="0";
        document.query("#piece_${getActualPosition(posStart)}").style.top="${pieces[getActualPosition(posEnd)].getY()}px";
        document.query("#piece_${getActualPosition(posStart)}").style.left="${pieces[getActualPosition(posEnd)].getX()}px";
        document.query("#piece_${getActualPosition(posEnd)}").style.top="${pieces[getActualPosition(posStart)].getY()}px";
        document.query("#piece_${getActualPosition(posEnd)}").style.left="${pieces[getActualPosition(posStart)].getX()}px";
        pieces[getActualPosition(posStart)].swichPlace(pieces[getActualPosition(posEnd)]);
        //print("ended");
        if (checkPositions()==true){
          endTime=new Date.now();
          print("Puzzle vyřešeny!");
          window.clearInterval(interval);
          enabled=false;
          };
      }
      return false;
      });
    

    document.query("#board").on.mouseMove.add(eventListener);
  }
  
  
  String getPuzzlesList(){
    XMLHttpRequest req = new XMLHttpRequest(); // create a new XHR

    var url = "http://localhost:8080/listpuzzles";
    
    req.open("GET", url); // POST to send data

    req.on.readyStateChange.add((Event e) {
    if (req.readyState == XMLHttpRequest.DONE &&
    (req.status == 200 || req.status == 0)) {
      responceStr=(req.responseText);
    }
    });

    req.send(""); // kick off the request to the server
    return responceStr;  
  }

  
}



void main() {
  Jigsaw puzzle = new Jigsaw();
  puzzle.ready();
  
  
  print(puzzle.getPuzzlesList());
}
