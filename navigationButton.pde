// interface Button je u datoteci levelButton

// Konstante za visinu i sirinu gumba
int defaultTextButtonH = 30;
int defaultTextButtonW = 110;

// Apstraktna klasa gumbi za prijelaz između raznih displayeva
abstract class NavigationButton implements Button {
  int x, y, h, w;
  boolean active;  // varijabla je true ako je gumb na ekranu i smije ga se kliknuti
  
  // Konstruktor
  NavigationButton(int x, int y, int h, int w) {
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.active = false;

    buttons.add(this);
  }

  // Vraca true ako je gumb aktivan
  boolean isActive() {
    return this.active;
  }

  // Vraca true ako je mis unutar gumba i gumb je aktivan
  boolean validCursor(int x, int y) {
    return this.x < x && x < this.x + w
      && this.y < y && y < this.y + h
      && this.active;
  }
  
  // Promijeni vrijednost varijable active na suprotnu
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

// Apstraktna klasa gumba na kojem pise tekst
abstract class TextButton extends NavigationButton {
  Text text;
  color buttonColor;

  // Najjednostavniji konstruktor
  TextButton(int x, int y, String text) {
    super(x, y, defaultTextButtonH, defaultTextButtonW);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = 255;
  }

  // Konstruktor s varijabilnom visinom i sirinom
  TextButton(int x, int y, String text, int h, int w) {
    super(x, y, h, w);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = 255;
  }
  
  // Konstruktor s varijabilnom bojom
  TextButton(int x, int y, String text, int h, int w, color buttonColor) {
    super(x, y, h, w);
    this.text = new Text(this.x + this.w / 2, this.y + this.h / 2, text);
    this.buttonColor = buttonColor;
  }

  // Crtaj gumb za navigaciju
  void render() {
    fill(buttonColor);
    //stroke(color(0, 0, 160));
    rect(x, y, w, h);
    this.text.ispisiText();
  }

  // Pomakni gumb za navigaciju na poziciju (x,y)
  void moveButton(int x, int y) {
    this.x = x;
    this.y = y;
    this.text.x = this.x + this.w / 2;
    this.text.y = this.y + this.h / 2;
  }
}

// Klasa gumba za pocetak igre
class StartButton extends TextButton {
  // Konstruktor
  StartButton(int x, int y) {
    super(x, y, "Započni igru");
  }

  // Na klik gumba pokreni level
  void click() {
    display.changeDisplayState(screenState.PLAY);
  }
}

// Klasa gumba za odabir levela
class GoToSelectButton extends TextButton {
  // Konstruktor
  GoToSelectButton(int x, int y) {
    super(x, y, "Izaberi level");
  }

  // Na klik gumba prebaci se na display za odabir levela
  void click() {
    display.changeDisplayState(screenState.LEVEL_SELECT);
  }
}

// Klasa gumba za reset levela
class ResetButton extends TextButton {
  // Konstruktor
  ResetButton(int x, int y) {
    super(x, y, "Resetiraj level");
  }

  // Na klik gumba ponovno pokreni level
  void click() {
    startLevelFlag = true;
  }
}

// Klasa gumbi za pojedine levele
class SelectLevelButton extends TextButton {
  String levelName;
  int levelNumber;

  // Konstruktor
  // - u konstruktoru se predaje naziv levela bez ekstenzije
  //   a u lokalnu varijablu se sprema naziv s ekstenzijom .tmx
  SelectLevelButton(int x, int y, String levelName, int levelNumber) {
    super(x, y, "level " + str(levelNumber+1));
    this.levelName = levelName + ".tmx";
    this.levelNumber = levelNumber;
  }

  // Na klik gumba prebaci se na odabrani level
  void click() {
    nextLevelName = this.levelName;
    //setNextLevel(this.levelName);
    currentLevelIndex = this.levelNumber;
    display.changeDisplayState(screenState.PLAY);
  }
}
