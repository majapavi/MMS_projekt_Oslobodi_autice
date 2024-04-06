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

abstract class ImageButton extends NavigationButton {
  PImage img;
  ImageButton(int x, int y, PImage img) {
    super(x, y, img.width, img.height);
    this.img = img;
  }

  void render() {
    image(img, x, y);
  }
}

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
    super(x, y, 20, 40);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = 255;
  }

  void render() {
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
  String levelName;
  int levelNumber;

  // u konstruktoru se predaje naziv levela bez ekstenzije
  // a u lokalnu varijablu se sprema naziv s ekstenzijom .tmx
  SelectLevelButton(int x, int y, String levelName, int levelNumber) {
    super(x, y, loadImage(levelName + ".png"));
    this.levelName = levelName + ".tmx";
    this.levelNumber = levelNumber;
  }

  void click() {
    setNextLevel(this.levelName);
    display.changeDisplayState(screenState.PLAY);
    currentLevel = this.levelNumber;
  }

  void moveButton(int x, int y) {
    this.x = x;
    this.y = y;
  }
}
