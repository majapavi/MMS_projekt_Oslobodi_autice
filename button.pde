interface Button {
  void draw();
  void click();
  boolean validCursor(int x, int y);
}

interface LevelButton extends Button {
  void setLevelRef(int x, int y);
}

interface CarButton extends LevelButton {
  void setCarPos(int x, int y, int w, int h);
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

class LightButton implements LevelButton {
  int x,y,w,h;
  PImage img;
  boolean lightColor;
  LightButton(int x, int y, int w, int h, boolean clr){
      this.x=x;
      this.y=y;
      this.w = w;
      this.h = h;
      lightColor=clr;
      if(clr) img=loadImage("green.png");
      else img=loadImage("red.png");
  }
  
  void draw(){
    image(img, x, y, w, h);
  }

  void click(){
    changeColor();
  }
  
  void changeColor(){
    lightColor=!lightColor;
    if(lightColor) this.img=loadImage("green.png");
    else this.img=loadImage("red.png"); 
  }
  
  boolean validCursor(int x, int y){
    return this.x < x && x < this.x+w && this.y < y && y < this.y+h;
  }
  
  void setLevelRef(int x, int y){
    
  }
}


class TurnButton implements LevelButton {
  int x, y, w, h, right, down;
  PImage leftSignImage, rightSignImage, forwardSignImage;
  Turn cur;
  Direction orient;
  TurnSign turnSign;
  TurnButton(TurnSign turnSign, int x, int y, int w, int h, Direction orient, Turn cur){
    this.turnSign = turnSign;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.orient = orient;
    right = x + w;
    down = y + h;
    this.cur = cur;
    leftSignImage = loadImage("leftsign.png");
    forwardSignImage = loadImage("upsign.png");
    rightSignImage = loadImage("rightsign.png");
  }

  void draw(){
    pushMatrix();
    translate(x+w/2,y+h/2);
    rotate(directionToAngle(orient));
    translate(-w/2,-h/2);
    imageMode(CORNER);
    tint(255, 64);
    for (Turn turn : turnSign.turns){
      if (turn == Turn.LEFT){
        image(leftSignImage, 0, 0);
      }
      if (turn == Turn.FORWARD){
        image(forwardSignImage, 0, 0);
      }
      if (turn == Turn.RIGHT){
        image(rightSignImage, 0, 0);
      }
    }
    noTint();
    if (cur == Turn.LEFT){
      image(leftSignImage, 0, 0);
    }
    if (cur == Turn.FORWARD){
      image(forwardSignImage, 0, 0);
    }
    if (cur == Turn.RIGHT){
      image(rightSignImage, 0, 0);
    }
    popMatrix();
  }

  void setTurn(Turn newCur){
    cur = newCur;
  }

  boolean validCursor(int x, int y){
    return this.x < x && x < right && this.y < y && y < down;
  }

  void setLevelRef(int x, int y){
  }

  void click(){
    turnSign.change();
  }
}


abstract class VisibleCarButton implements CarButton {
  int x, y, w, h, right, down;
  Car car;
  VisibleCarButton(Car car){
    this.car = car;
    w = int(car.w);
    h = int(car.h);
  }
  
  boolean validCursor(int x, int y){
    return this.x < x && x < right && this.y < y && y < down;
  }

  void setLevelRef(int x, int y){
  }

  void setCarPos(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    right = x + w;
    down = y + h;
  }

  void setCarDirection(Direction dir){
  }
}


class CarForwardButton extends VisibleCarButton {
  PImage img;
  CarForwardButton(Car car){
    super(car);
    img = loadImage("start_car_button.png");
  }

  void draw(){
    image(img, x, y);
  }

  void click(){
    car.start();
  }
}

class CarStartStopButton extends VisibleCarButton {
  PImage img;
  CarStartStopButton(Car car){
    super(car);
    img = loadImage("startstop_car_button.png");
  }

  void draw(){
    image(img, x, y);
  }

  void click(){
    if (car.started){
      car.stop();
    } else {
      car.start();
    }
  }
}
