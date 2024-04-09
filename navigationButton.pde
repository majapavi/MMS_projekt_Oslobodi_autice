// interface Button is in tab levelButton
abstract class NavigationButton implements Button {
  int x, y, h, w;
  boolean active;
  NavigationButton(int x, int y, int h, int w) {
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

// NEKORISTENA IMPLEMENTACIJA
//abstract class ImageButton extends NavigationButton {
//  PImage img;
//  ImageButton(int x, int y, PImage img) {
//    super(x, y, img.width, img.height);
//    this.img = img;
//  }

//  void render() {
//    image(img, x, y);
//  }
//}

int defaultTextButtonH = 30;
int defaultTextButtonW = 110;

abstract class TextButton extends NavigationButton {
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
    super(x, y, defaultTextButtonH, defaultTextButtonW);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = 255;
  }

  void render() {
    fill(buttonColor);
    //stroke(color(0, 0, 160));
    rect(x, y, w, h);
    this.text.ispisiText();
  }

  void moveButton(int x, int y) {
    this.x = x;
    this.y = y;
    this.text.x = this.x + this.w / 2;
    this.text.y = this.y + this.h / 2;
  }
}

class StartButton extends TextButton {
  StartButton(int x, int y) {
    super(x, y, "Započni igru");
  }

  void click() {
    display.changeDisplayState(screenState.PLAY);
  }
}

class GoToSelectButton extends TextButton {
  GoToSelectButton(int x, int y) {
    super(x, y, "Izaberi level");
  }

  void click() {
    display.changeDisplayState(screenState.LEVEL_SELECT);
  }
}

class ResetButton extends TextButton {
  ResetButton(int x, int y) {
    super(x, y, "Resetiraj level");
  }

  void click() {
    startLevel();
  }
}

class SelectLevelButton extends TextButton {
  String levelName;
  int levelNumber;

  // u konstruktoru se predaje naziv levela bez ekstenzije
  // a u lokalnu varijablu se sprema naziv s ekstenzijom .tmx
  SelectLevelButton(int x, int y, String levelName, int levelNumber) {
    super(x, y, "level "+str(levelNumber+1));
    this.levelName = levelName + ".tmx";
    this.levelNumber = levelNumber;
  }

  void click() {
    setNextLevel(this.levelName);
    display.changeDisplayState(screenState.PLAY);
    currentLevel = this.levelNumber;
  }
}
