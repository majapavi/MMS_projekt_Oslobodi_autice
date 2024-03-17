interface Button {
  void draw();
  void click();
  boolean validCursor(int x, int y);
}

interface LevelButton extends Button {
  void setLevelRef(int x, int y);
}

interface CarButton extends LevelButton {
  void setCarPos(int x, int y);
  void setCarDirection(Direction dir);
}

abstract class ImageButton implements Button {
  int x, y, right, down;
  PImage img;
  ImageButton(int x, int y, String filename){
    this.x = x;
    this.y = y;
    img = loadImage(filename);
    right = x + img.width;
    down = y + img.height;
  }
  
  void draw(){
    image(img, x, y);
  }

  boolean validCursor(int x, int y){
    return this.x < x && x < right && this.y < y && y < down;
  }
}

// Aplikacijski gumb sa tekstom
abstract class TextButton implements Button {
  int x, y, right, down, h, w;
  Text text;
  color buttonColor;
  
  TextButton(int x, int y, String text){
    this.x = x;
    this.y = y;
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    h = 50;
    w = 80;
    right = x + w;
    down = y + h;
    buttonColor = 256;
  }
  
  void draw() {
    fill(buttonColor);
    rect(x, y, w, h);
    this.text.ispisiText();
  }

  boolean validCursor(int x, int y){
    return this.x < x && x < right && this.y < y && y < down;
  }
}

class StartButton extends TextButton {
  StartButton(int x, int y){
    super(x, y, "START");
  }

  void click(){
    display.mode = screenState.PLAY;
  }
}

class ResetButton extends ImageButton {
  ResetButton(int x, int y){
    super(x, y, "dummy.png");
  }

  void click(){
    startLevel();
  }
}


abstract class InvisibleCarButton implements CarButton {
  int x, y, w, h, right, down;
  Car car;
  InvisibleCarButton(Car car){
    this.car = car;
    w = int(car.w);
    h = int(car.h);
  }
  
  void draw(){
  }

  boolean validCursor(int x, int y){
    return this.x < x && x < right && this.y < y && y < down;
  }

  void setLevelRef(int x, int y){
  }

  void setCarPos(int x, int y){
    this.x = x;
    this.y = y;
    right = x + w;
    down = y + h;
  }

  void setCarDirection(Direction dir){
  }
}


class CarForwardButton extends InvisibleCarButton {
  CarForwardButton(Car car){
    super(car);
  }

  void click(){
   car.fastForwardFlag=true; //auto na klik ide ravno dok se ne sudari/izađe iz ekrana
  }
}
