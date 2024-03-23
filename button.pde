interface Button {
  void draw();
  void click();
  boolean validCursor(int x, int y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

abstract class GameButton implements Button {
  int x, y, h, w;
  GameButton(int x, int y, int h, int w){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    
    buttons.add(this);
  }
  
  boolean validCursor(int x, int y){
    return this.x < x && x < this.x + w && this.y < y && y < this.y + h;
  }
}

abstract class ImageButton extends GameButton {
  PImage img;
  ImageButton(int x, int y, PImage img){
    super(x, y, img.width, img.height);
    this.img = img;
  }
  
  void draw(){
    image(img, x, y);
  }
}

abstract class TextButton extends GameButton {
  Text text;
  color buttonColor;
  
  TextButton(int x, int y, String text, int h, int w, color buttonColor){
    super(x, y, h, w);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = buttonColor;
  }
  
  TextButton(int x, int y, String text, int h, int w){
    super(x, y, h, w);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = 255;
  }

  TextButton(int x, int y, String text){
    super(x, y, 20, 40);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = 255;
  }

  void draw() {
    fill(buttonColor);
    rect(x, y, w, h);
    this.text.ispisiText();
  }
}

class StartButton extends TextButton {
  StartButton(int x, int y){
    super(x, y, "Započni igru", 20, 90);
  }

  void click(){
    display.state = screenState.PLAY;
  }
}

class GoToSelectButton extends TextButton {
  GoToSelectButton(int x, int y){
    super(x, y, "Izaberi level", 20, 80);
  }

  void click(){
    display.changeDisplayState(screenState.LEVEL_SELECT);
  }
}


class ResetButton extends ImageButton {
  ResetButton(int x, int y){
    super(x, y, loadImage("dummy.png"));
  }

  void click(){
    startLevel();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

interface LevelButton extends Button {
  void setLevelRef(int x, int y);
}

interface CarButton extends LevelButton {
  void setCarPos(int x, int y);
  void setCarDirection(Direction dir);
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
