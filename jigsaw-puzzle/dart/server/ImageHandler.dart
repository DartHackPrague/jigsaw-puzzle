mainxxx() {
  ImageHandler saver = new ImageHandler();
  List<int> array1 = [1, 0, 1, 1];
  String img = "blugb4.png";
  saver.saveImage(img, array1);
  
  
  List<int> array2 = saver.getImage("http://encyclopedia2.thefreedictionary.com/_/viewer.aspx?path=BCE&name=12105.jpg");
  
  Expect.listEquals(array1, array2);
}

class ImageHandler {
  static final String DIR = "img/";
  
  void saveImage(String fileName, List<int> content) {
     File file = new File("$DIR$fileName");
     if (file.existsSync()) {
       print("${file.fullPathSync()} already exists");
       return;
     }
     file.createSync();
     OutputStream out = null;
     try {
       out = file.openOutputStream();
       out.write(content);
     } finally {
       if (out != null)
         out.close();
     }
     print("finished");
  }
  
  List<int> getImage(String fileName) {
    //File file = new File("$DIR$fileName");
    File file = new File("$fileName");
    if (!file.existsSync()) {
      print("${file.fullPathSync()} does not exist");
      return new List<int>();
    }
    return file.readAsBytesSync(); 
  }
  
}
