interface Button {
  void drawB();
  void click();
  boolean validCursor(int x, int y);
}

abstract class GameButton implements Button {
  int x, y, h, w;
  boolean active;
  GameButton(int x, int y, int h, int w) {
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.active = false;

    buttons.add(this);
  }

  boolean isActive() {
    return this.active;
  }

  boolean validCursor(int x, int y) {
    return this.x < x && x < this.x + w
      && this.y < y && y < this.y + h
      && this.active;
  }

  void switchButton() {
    this.active = !this.active;
  }
}

abstract class ImageButton extends GameButton {
  PImage img;
  ImageButton(int x, int y, PImage img) {
    super(x, y, img.width, img.height);
    this.img = img;
  }

  void drawB() {
    image(img, x, y);
  }
}

abstract class TextButton extends GameButton {
  Text text;
  color buttonColor;

  TextButton(int x, int y, String text, int h, int w, color buttonColor) {
    super(x, y, h, w);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = buttonColor;
  }

  TextButton(int x, int y, String text, int h, int w) {
    super(x, y, h, w);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = 255;
  }

  TextButton(int x, int y, String text) {
    super(x, y, 20, 40);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = 255;
  }

  void drawB() {
    fill(buttonColor);
    rect(x, y, w, h);
    this.text.ispisiText();
  }
}

class StartButton extends TextButton {
  StartButton(int x, int y) {
    super(x, y, "Započni igru", 20, 90);
  }

  void click() {
    display.changeDisplayState(screenState.PLAY);
  }
}

class GoToSelectButton extends TextButton {
  GoToSelectButton(int x, int y) {
    super(x, y, "Izaberi level", 20, 80);
  }

  void click() {
    display.changeDisplayState(screenState.LEVEL_SELECT);
  }
}

class ResetButton extends ImageButton {
  ResetButton(int x, int y) {
    super(x, y, loadImage("dummy.png"));
  }

  void click() {
    startLevel();
  }
}

class SelectLevelButton extends ImageButton {
  String level;

  // u konstruktoru se predaje naziv levela bez ekstenzije
  // a u lokalnu varijablu se sprema naziv s ekstenzijom .tmx
  SelectLevelButton(int x, int y, String level) {
    super(x, y, loadImage(level + ".png"));
    this.level = level + ".tmx";
  }

  void click() {
    setNextLevel(this.level);
    display.changeDisplayState(screenState.PLAY);
  }

  void moveButton(int x, int y) {
    this.x = x;
    this.y = y;
  }
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

  void drawB() {
    if (drawLevel)
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

  void drawB() {
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

  void drawB() {
    print(drawLevel);
    if (drawLevel)
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

  void drawB() {
    if (drawLevel)
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
