boolean DEBUG_COLLISION = false;
// staviti na true za prikaz crvenog pravokutnika oko auta - detekcija sudaranja

// Mogući smjerovi u kojima auto vozi
enum Direction {
  UP, RIGHT, DOWN, LEFT
}

// Vrati smjer u kojem auto vozi
Direction getDirection(String name) {
  if (name.startsWith("u")) {
    return Direction.UP;
  }
  if (name.startsWith("r")) {
    return Direction.RIGHT;
  }
  if (name.startsWith("d")) {
    return Direction.DOWN;
  }
  if (name.startsWith("l")) {
    return Direction.LEFT;
  }
  return Direction.UP;
}

// Vrati suprotan smjer
Direction oppositeDirection(Direction dir) {
  switch (dir) {
  case UP:
    return Direction.DOWN;
  case RIGHT:
    return Direction.LEFT;
  case DOWN:
    return Direction.UP;
  case LEFT:
    return Direction.RIGHT;
  default:
    return Direction.UP;
  }
}

// Vrati smjer za lijevo skretanje
Direction leftTurnDirection(Direction dir) {
  switch (dir) {
  case UP:
    return Direction.LEFT;
  case RIGHT:
    return Direction.UP;
  case DOWN:
    return Direction.RIGHT;
  case LEFT:
    return Direction.DOWN;
  default:
    return Direction.UP;
  }
}

// Vrati smjer za desno skretanje
Direction rightTurnDirection(Direction dir) {
  switch (dir) {
  case UP:
    return Direction.RIGHT;
  case RIGHT:
    return Direction.DOWN;
  case DOWN:
    return Direction.LEFT;
  case LEFT:
    return Direction.UP;
  default:
    return Direction.UP;
  }
}

// Vrati kut rotacije ovisno o smjeru
float directionToAngle(Direction dir) {
  switch (dir) {
  case UP:
    return 0;
  case RIGHT:
    return PI/2;
  case DOWN:
    return PI;
  case LEFT:
    return 3*PI/2;
  default:
    return 0;
  }
}

// Moguća skretanja
enum Turn {
  LEFT, RIGHT, FORWARD
}

// Vrati skretanje prema imenu
Turn getTurn(String name) {
  if (name.startsWith("l")) {
    return Turn.LEFT;
  }
  if (name.startsWith("r")) {
    return Turn.RIGHT;
  }
  return Turn.FORWARD;
}

// Primijeni dobiveno skretanje u odnosu na dobiveni smjer
Direction applyTurn(Turn t, Direction dir) {
  switch (t) {
  case LEFT:
    return leftTurnDirection(dir);
  case RIGHT:
    return rightTurnDirection(dir);
  case FORWARD:
    return dir;
  default:
    return dir;
  }
}

// Klasa objekata koji postoje u levelu
interface Collideable {
  // (x,y) je pozicija objekta
  int getX();
  int getY();

  // w = sirina, h = visina objekta
  int getW();
  int getH();

  // Vraca true kada je moguce sudariti se s objektom
  boolean canCollide();
}

// Vraca true ukoliko je pozicija (x,y) "unutar" objekta s kojim se moguce sudariti
boolean pointInCollideable(int x, int y, Collideable b) {
  return (b.getX() <= x && x <= b.getX() + b.getW()
    && b.getY() <= y && y <= b.getY() + b.getH());
}

// Vraca true ukoliko se objekt a sudario s objektom b
// - koristi se za zidove (tj raskrsca) i semafore
boolean collides(Collideable a, Collideable b) {
  if (!a.canCollide() || !b.canCollide()) return false;

  if (a.getX() > b.getX() + b.getW()) return false;
  if (b.getX() > a.getX() + a.getW()) return false;
  if (a.getY() > b.getY() + b.getH()) return false;
  if (b.getY() > a.getY() + a.getH()) return false;
  return true;
}

class Car implements Collideable {
  // Popis varijabli
  // ---------------
  Level level;                     // level u kojem se auto nalazi
  int x, y, w, h;                  // pozicija, sirina i visina auta
  float preciseX, preciseY;        // preciznija pozicija
  float speed = 150;               // brzina u pikselima po sekundi
  ArrayList<CarButton> carButtons; // lista gumbiju autica, zasad samo 1 gumb preko cijelog autica
  Direction orient;                // orijentacija auta
  TurnLogic turnLogic;             // logika za skretanje
  String turnLogicLetter;          // slovo za logiku skretanja - moguca F, V, S, Q
  Turn turn;                       // enum za skretanje
  float angle;
  float turningAngle;
  boolean finish;                  // vrijednost mu je true ako je izvan ekrana
  boolean started = false;         // vrijednost je true kada je auto pokrenut/u pokretu
  boolean animateFlag = false;     // vrijednost je true kada auto skrece
  Wall currentWall;                // trenutni zid (raskrce) s kojim se auto moze sudariti
  Light currentLight;              // trenutni semafor koji moze stopirati auto
  TurnSign currentSign = null;     // trenutni znak na cesti koji moze okrenuti smjer kretanja auta
  boolean currentSignFlag = false; // vrijednost je true kada je znak na cesti aktivan???
  PVector animatedFrom, animatedTo; // vektori pocetka i kraja animacije skretanja

  // Konstruktor
  // -----------
  Car(Level level, StringDict attrib) { //, int number){
    this.level = level;
    x = level.centerX(int(attrib.get("x")));
    y = level.centerY(int(attrib.get("y")));
    preciseX = x;
    preciseY = y;
    w = 16;
    h = 30;
    orient = getDirection(attrib.get("orientation"));
    angle = directionToAngle(orient);

    carButtons = new ArrayList<CarButton>();  // trenutno uvijek velicine 1

    // Izrada gumba obzirom na vrstu autica
    if (attrib.get("action").equals("forward")) {
      carButtons.add(new CarForwardButton(this));
    } else if (attrib.get("action").equals("drive")) {
      start();
    } else if (attrib.get("action").equals("stop")) {
      carButtons.add(new CarStartStopButton(this));
    }

    //updateButtons();  // postavlja koordinate svih gumbiju na koordinate autica
    finish = false;

    // Postavljanje varijabli za skretanje
    String tmp = attrib.get("turn");
    if (tmp == null) turn = Turn.FORWARD;
    else turn = getTurn(tmp);

    // Postavljanje varijabli za logiku skretanja
    tmp = attrib.get("logic");
    if (tmp == null) {
      turnLogic = new ForwardTurn(turn);
      turnLogicLetter = "F";
    } else if (tmp.startsWith("f")) {
      turnLogic = new ForwardTurn(turn);
      turnLogicLetter = "F";
    } else if (tmp.startsWith("v")) {
      turnLogic = new VariableTurn(turn);
      turnLogicLetter = "V";
    } else if (tmp.startsWith("s")) {
      turnLogic = new StackTurn(turn);
      turnLogicLetter = "S";
    } else if (tmp.startsWith("q")) {
      turnLogic = new QueueTurn(turn);
      turnLogicLetter = "Q";
    }
    turn = turnLogic.read();

    // Ukoliko je autic tocno ispred raskrsca, registriraj zid
    for (Wall wall : level.walls) {
      if (collides(this, wall)) {
        currentWall = wall;
        break;
      } else currentWall = null;
    }

    // Ukoliko je autic tocno pokraj semafora, registriraj ga
    for (Light light : level.lights) {
      if (collides(this, light)) {
        currentLight = light;
        break;
      } else currentLight = null;
    }
  }
  // kraj konstruktora
  // -----------------

  // Funkcija za crtanje autica na ekran
  // ------------
  void render() {
    // Dio za debugiranje sudaranja autica s ostalim objektima
    // - na vrhu datoteke postaviti na true da se crta crveni pravokutnik ispod auta
    if (DEBUG_COLLISION) {
      color(255, 255, 255);
      rect(getX(), getY(), getW(), getH());
    }
    
    // Sve transformacije izmedju pushMatrix() i popMatrix() se odnose samo na ovaj objekt
    pushMatrix();
    imageMode(CENTER);
    
    // Kad auto vozi ravno, postavi ga na poziciju i u pravo usmjerenje
    if (!animateFlag) {
      translate(x, y);
      rotate(angle);
    }
    // Kad auto skrece na raskrizju
    if (animateFlag) {
      if (orient==Direction.UP && turn==Turn.LEFT) {
        translate(animatedFrom.x-level.tileWidth, animatedFrom.y);
        translate(level.tileWidth*cos(turningAngle), level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if (orient==Direction.UP && turn==Turn.RIGHT) {
        translate(animatedFrom.x+level.tileWidth, animatedFrom.y);
        translate(-level.tileWidth*cos(turningAngle), -level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if (orient==Direction.LEFT && turn==Turn.RIGHT) {
        translate(animatedFrom.x, animatedFrom.y-level.tileWidth);
        translate(-level.tileWidth*cos(turningAngle), -level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if (orient==Direction.RIGHT && turn==Turn.LEFT) {
        translate(animatedFrom.x, animatedFrom.y-level.tileWidth);
        translate(level.tileWidth*cos(turningAngle), level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if (orient==Direction.DOWN && turn==Turn.LEFT) {
        translate(animatedFrom.x+level.tileWidth, animatedFrom.y);
        translate(level.tileWidth*cos(turningAngle), level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if (orient==Direction.RIGHT && turn==Turn.RIGHT) {
        translate(animatedFrom.x, animatedFrom.y+level.tileWidth);
        translate(-level.tileWidth*cos(turningAngle), -level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if (orient==Direction.DOWN && turn==Turn.RIGHT) {
        translate(animatedFrom.x-level.tileWidth, animatedFrom.y);
        translate(-level.tileWidth*cos(turningAngle), -level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if (orient==Direction.LEFT && turn==Turn.LEFT) {
        translate(animatedFrom.x, animatedFrom.y+level.tileWidth);
        translate(level.tileWidth*cos(turningAngle), level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
    }
    
    // Nacrtaj autic; uz prethodne translate i rotate fje ce bit na pravom mjestu
    image(carImage, 0, 0, w, h);
    
    // Nacrtaj strelicu na auticu obzirom na predvidjeni smjer kretanja
    Turn head = turnLogic.read();
    if (head == Turn.LEFT) {
      image(level.leftArrowImage, 0, 0, w, h);
    } else if (head == Turn.RIGHT) {
      image(level.rightArrowImage, 0, 0, w, h);
    } else if (head == Turn.FORWARD) {
      image(level.upArrowImage, 0, 0, w, h);
    }
    
    // Za tipove StackTurn i QueueTurn nacrtaj sljedeci smjer
    int i = 0;
    for (Turn t : turnLogic.getTail()) {
      if (t == Turn.LEFT) {
        image(level.leftArrowImage, 0, h + h/2*i, w, h);
      } else if (t == Turn.RIGHT) {
        image(level.rightArrowImage, 0, h + h/2*i, w, h);
      } else if (t == Turn.FORWARD) {
        image(level.upArrowImage, 0, h + h/2*i, w, h);
      }
      i++;
    }
    turnLogic.writeHead(head);
    
    // Prikaz slova ovisno o vrsti autica - F/V/S/Q
    /***
    fill(255, 0, 0);
    textSize(22);
    text(turnLogicLetter, 0, 16);
    ***/
    
    imageMode(CORNER);
    popMatrix();
  }
  // kraj render()
  // -------------

  void update(float dt) {
    if (animateFlag) animateTurn(dt);
    else turn = turnLogic.read();
    x = int(preciseX);
    y = int(preciseY);

    if (currentWall == null) {
      for (Wall wall : level.walls) {
        if (collides(this, wall)) { // usli smo u raskrsce
          currentWall = wall;

          if (wall.forbidden && applyTurn(turn, orient) == wall.forbiddenDirection)
            continue;

          turnLogic.next();
          if (turn==Turn.FORWARD) break;

          animatedFrom = new PVector(getX()+getW()/2, getY()+getH()/2);
          if ((orient==Direction.UP && turn==Turn.LEFT)||
            (orient==Direction.LEFT && turn==Turn.RIGHT))
            animatedTo = new PVector(getX()-level.tileWidth, getY()-level.tileHeight);
          if ((orient==Direction.UP && turn==Turn.RIGHT)||
            (orient==Direction.RIGHT && turn==Turn.LEFT))
            animatedTo = new PVector(getX()+level.tileWidth, getY()-level.tileHeight);
          if ((orient==Direction.DOWN && turn==Turn.LEFT)||
            (orient==Direction.RIGHT && turn==Turn.RIGHT))
            animatedTo = new PVector(getX()+level.tileWidth, getY()+level.tileHeight);
          if ((orient==Direction.DOWN && turn==Turn.RIGHT)||
            (orient==Direction.LEFT && turn==Turn.LEFT))
            animatedTo = new PVector(getX()-level.tileWidth, getY()+level.tileHeight);
          animateFlag = true;
          turningAngle = angle;
        }
      }
    } else if (currentWall!=null) {
      if (!collides(this, currentWall)) { // izasli smo iz raskrsca
        currentWall = null;
      }
    }

    if (started && currentLight == null && !animateFlag) {
      fastForward(dt);
    }

    updateButtons();

    if (outOfBounds()) {
      finish=true;
    }

    currentLight = null; // resetiraj za slijedeci put
    if (!currentSignFlag) {
      currentSign = null;
    }
    currentSignFlag = false;
  }

  int getX() {
    return x - getW() / 2;
  }

  int getY() {
    return y - getH() / 2;
  }

  int getW() {
    if (orient == Direction.UP || orient == Direction.DOWN)
      return w;
    return h;
  }

  int getH() {
    if (orient == Direction.UP || orient == Direction.DOWN)
      return h;
    return w;
  }

  boolean canCollide() {
    return !finish;
  }

  private void updateButtons() {
    for (CarButton button : carButtons) {
      button.setCarPos(getX(), getY(), getW(), getH());
    }
  }

  ArrayList<CarButton> getButtons() {
    return carButtons;
  }

  boolean finished() {
    return finish;
  }

  boolean outOfBounds() {
    if (y + h / 2 < 0) return true;
    if (y - h / 2 > level.pxHeight) return true;
    if (x - w / 2 > level.pxWidth) return true;
    if (x + w / 2 < 0) return true;
    return false;
  }

  void collideAction(Collideable obj) {
    if (obj instanceof Car) {
      lives-=0.5;
      if (lives==0) {
        println("GUBITAK");
        display.changeDisplayState(screenState.START);
      }
      level.crashed(this);
      started = false;
    } else if (obj instanceof Pjesak || obj instanceof Hazard) {
      lives-=1;
      if (lives==0) {
        println("Izgubili ste sve zivote!");
        display.changeDisplayState(screenState.START);
      }
      level.crashed(this);
      started = false;
    } else if (obj instanceof TurnSign) {
      currentSignFlag = true;
      if (currentSign == null) {
        TurnSign turnSign = (TurnSign) obj;
        if (turnSign.orient == orient) {
          turnLogic.write(turnSign.getNew());
        }
        currentSign = turnSign;
      }
    } else if (obj instanceof Light) {
      Light light = (Light) obj;
      if (light.orient == orient)
        currentLight = (Light) obj;
    }
  }

  void animateTurn(float dt) {
    if (turn==Turn.LEFT) {
      turningAngle -= dt * speed / level.tileWidth;
      if (orient==Direction.UP && turningAngle<=-PI/2) {
        afterTurn();
        return;
      }
      if (orient==Direction.RIGHT && turningAngle<=0) {
        afterTurn();
        return;
      }
      if (orient==Direction.DOWN && turningAngle<=PI/2) {
        afterTurn();
        return;
      }
      if (orient==Direction.LEFT && turningAngle<=PI) {
        afterTurn();
        return;
      }
    }
    if (turn==Turn.RIGHT) {
      turningAngle += dt * speed / level.tileWidth;
      if (orient==Direction.UP && turningAngle>=PI/2) {
        afterTurn();
        return;
      }
      if (orient==Direction.RIGHT && turningAngle>=PI) {
        afterTurn();
        return;
      }
      if (orient==Direction.DOWN && turningAngle>=3*PI/2) {
        afterTurn();
        return;
      }
      if (orient==Direction.LEFT && turningAngle>=2*PI) {
        afterTurn();
        return;
      }
    }

    return;
  }

  void afterTurn() {
    preciseX=animatedTo.x + getW() / 2;
    preciseY=animatedTo.y + getH() / 2;
    orient=applyTurn(turn, orient);
    angle=directionToAngle(orient);
    animateFlag = false;
    turningAngle=0;
    return;
  }

  void fastForward(float dt) {
    PVector displace = new PVector(0, -1);
    displace.rotate(directionToAngle(orient));
    displace.mult(speed * dt);
    preciseX += displace.x;
    preciseY += displace.y;
  }

  void start() {
    started = true;
  }

  void stop() {
    started = false;
  }
}
