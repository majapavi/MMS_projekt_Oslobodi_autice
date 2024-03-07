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
    w = car.w;
    h = car.h;
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
    car.forward();
  }
}
