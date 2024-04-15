interface Button {
  void render();
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

class LightButton implements LevelButton {
  int x, y, w, h;
  PImage img;
  boolean lightColor;
  LightButton(int x, int y, int w, int h, boolean clr) {
    this.x=x;
    this.y=y;
    this.w = w;
    this.h = h;
    lightColor=clr;
    if (clr) img=loadImage("green.png");
    else img=loadImage("red.png");
  }

  void render() {
    image(img, x, y, w, h);
  }

  void click() {
    changeColor();
  }

  void changeColor() {
    lightColor=!lightColor;
    if (lightColor) this.img=loadImage("green.png");
    else this.img=loadImage("red.png");
  }

  boolean validCursor(int x, int y) {
    return this.x < x && x < this.x+w && this.y < y && y < this.y+h;
  }

  void setLevelRef(int x, int y) {
  }
}


class TurnButton implements LevelButton {
  int x, y, w, h, right, down;
  PImage leftSignImage, rightSignImage, forwardSignImage;
  Turn cur;
  Direction orient;
  TurnSign turnSign;
  TurnButton(TurnSign turnSign, int x, int y, int w, int h, Direction orient, Turn cur) {
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

  void render() {
    pushMatrix();
    translate(x+w/2, y+h/2);
    rotate(directionToAngle(orient));
    translate(-w/2, -h/2);
    imageMode(CORNER);
    tint(255, 64);
    for (Turn turn : turnSign.turns) {
      if (turn == Turn.LEFT) {
        image(leftSignImage, 0, 0);
      }
      if (turn == Turn.FORWARD) {
        image(forwardSignImage, 0, 0);
      }
      if (turn == Turn.RIGHT) {
        image(rightSignImage, 0, 0);
      }
    }
    noTint();
    if (cur == Turn.LEFT) {
      image(leftSignImage, 0, 0);
    }
    if (cur == Turn.FORWARD) {
      image(forwardSignImage, 0, 0);
    }
    if (cur == Turn.RIGHT) {
      image(rightSignImage, 0, 0);
    }
    popMatrix();
  }

  void setTurn(Turn newCur) {
    cur = newCur;
  }

  boolean validCursor(int x, int y) {
    return this.x < x && x < right && this.y < y && y < down;
  }

  void setLevelRef(int x, int y) {
  }

  void click() {
    turnSign.change();
  }
}


abstract class VisibleCarButton implements CarButton {
  int x, y, w, h, right, down;
  Car car;
  static final int ENLARGE = 3;

  VisibleCarButton(Car car) {
    this.car = car;
    w = car.getW();
    h = car.getH();
  }

  boolean validCursor(int x, int y) {
    return this.x - ENLARGE < x && x < right &&
      this.y - ENLARGE < y && y < down;
  }

  void setLevelRef(int x, int y) {
  }

  void setCarPos(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    right = x + w + ENLARGE * 2;
    down = y + h + ENLARGE * 2;
  }

  void setCarDirection(Direction dir) {
  }
}


class CarForwardButton extends VisibleCarButton {
  PImage img;
  CarForwardButton(Car car) {
    super(car);
    img = loadImage("start_car_button.png");
  }

  void render() {
    image(img, x, y);
  }

  void click() {
    car.start();
  }
}

class CarStartStopButton extends VisibleCarButton {
  PImage img;
  CarStartStopButton(Car car) {
    super(car);
    img = loadImage("startstop_car_button.png");
  }

  void render() {
    image(img, x, y);
  }

  void click() {
    if (car.started) {
      car.stop();
    } else {
      car.start();
    }
  }
}

// globalna funkcija za validaciju klika misem
void onClick(int x, int y) {
  for (Button button : buttons) {
    if (button.validCursor(x, y)) {
      button.click();
    }
  }
}
