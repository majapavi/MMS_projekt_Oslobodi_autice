// Sucelje za sve moguce gumbe
interface Button {
  void render();
  void click();
  boolean validCursor(int x, int y);
}

// Sucelje koje obuhvaca sve klikabilne objekte u levelu
interface LevelButton extends Button {
  // Neiskoristena funkcija za pomicanje koordinata pocetka iscrtavanja levela
  //   -> sada se level crta od gornjeg lijevog ruba - (0,0)
  void setLevelRef(int x, int y);
}

// Sucelje za razlicite vrste gumbi za autice
interface CarButton extends LevelButton {
  void setCarPos(int x, int y, int w, int h);
}

// Klasa gumbi za semafore
class LightButton implements LevelButton {
  int x, y, w, h;
  PImage img;
  
  // true kada je zeleni, false kada je crveni
  boolean lightColor;  
  
  // Konstruktor
  LightButton(int x, int y, int w, int h, boolean clr) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    lightColor = clr;
    if (clr) img = loadImage("green.png");
    else img = loadImage("red.png");
  }

  // Crtaj semafore samo ako crtas level
  void render() {
    if(drawLevel)
      image(img, x, y, w, h);
  }

  // Prilikom klika promijeni boju semafora
  void click() {
    changeColor();
  }

  // Funkcija za promjenu boje semafora
  void changeColor() {
    lightColor = !lightColor;
    if (lightColor) this.img = loadImage("green.png");
    else this.img = loadImage("red.png");
  }

  // Vraca true kada je mis unutar gumba za semafor
  boolean validCursor(int x, int y) {
    return this.x < x && x < this.x+w && this.y < y && y < this.y+h;
  }

  // Neiskoristena funkcija
  void setLevelRef(int x, int y) {
  }
}

// Klasa gumbi od strelica na cesti koje mogu mijenjati smjer na klik
class TurnButton implements LevelButton {
  int x, y, w, h;
  int right, down;     // desni i donji rub strelice
  PImage leftSignImage, rightSignImage, forwardSignImage;
  Turn cur;            // trenutni smjer strelice na cesti
  Direction orient;    // orijentacija strelice
  TurnSign turnSign;   // drugi smjer strelice u koji se moze prebaciti  
  
  // Konstruktor
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

  // Crta strelicu na cesti
  void render() {
    // Sve transformacije izmedju pushMatrix() i popMatrix() se odnose samo na ovaj objekt
    pushMatrix();
    translate(x + w/2, y + h/2);
    rotate(directionToAngle(orient));
    translate(-w/2, -h/2);
    imageMode(CORNER);
    
    // postavlja transparentnost slike
    tint(255, 64);
    // crtaj strelicu drugog smjera
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
    
    // makni postavku transparentnosti slike
    noTint();
    // crtaj trenutni aktivan smjer strelice
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

  // Postavlja/mijenja trenutni smjer
  void setTurn(Turn newCur) {
    cur = newCur;
  }

  // Vraca true kada je mis unutar gumba strelice
  boolean validCursor(int x, int y) {
    return this.x < x && x < right && this.y < y && y < down;
  }

  // Promijeni smjer strelice na klik misa
  void click() {
    turnSign.change();
  }
  
  // Neiskoristena funkcija
  void setLevelRef(int x, int y) {
  }
}

// Apstraktna klasa gumba za autic
abstract class VisibleCarButton implements CarButton {
  int x, y, w, h;
  int right, down;     // desni i donji rub gumba
  Car car;
  static final int ENLARGE = 3;  // konstanta uvecanja gumba

  // Konstruktor
  VisibleCarButton(Car car) {
    this.car = car;
    w = car.getW();
    h = car.getH();
  }

  // Vraca true kada je mis unutar gumba autica
  boolean validCursor(int x, int y) {
    return this.x - ENLARGE < x && x < right &&
      this.y - ENLARGE < y && y < down;
  }

  // Postavi poziciju autica
  void setCarPos(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    right = x + w + ENLARGE * 2;
    down = y + h + ENLARGE * 2;
  }
  
  // Neiskoristena funkcija
  void setLevelRef(int x, int y) {
  }
}

// Klasa autica koji se pokrecu na klik
//   -> trenutno koristeni u svim levelima
class CarForwardButton extends VisibleCarButton {
  PImage img;
  
  // Konstruktor
  CarForwardButton(Car car) {
    super(car);
    img = loadImage("start_car_button.png");
  }

  // Nacrtaj slicicu koja oznacava vrstu autica
  void render() {
    image(img, x, y);
  }

  // Na klik misa, pokreni autic
  void click() {
    car.start();
  }
}

// Klasa autica koji se na klik mogu pokrenuti i zaustaviti
class CarStartStopButton extends VisibleCarButton {
  PImage img;
  
  // Konstruktor
  CarStartStopButton(Car car) {
    super(car);
    img = loadImage("startstop_car_button.png");
  }

  // Nacrtaj slicicu koja oznacava vrstu autica
  void render() {
    image(img, x, y);
  }

  // Na klik misa pokreni ili zaustavi autic
  void click() {
    if (car.started) {
      car.stop();
    } else {
      car.start();
    }
  }
}
