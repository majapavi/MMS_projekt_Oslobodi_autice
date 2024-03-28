boolean DEBUG_COLLISION = false;

enum Direction {
  UP, RIGHT, DOWN, LEFT
}

Direction getDirection(String name){
  if (name.startsWith("u")){
    return Direction.UP;
  }
  if (name.startsWith("r")){
    return Direction.RIGHT;
  }
  if (name.startsWith("d")){
    return Direction.DOWN;
  }
  if (name.startsWith("l")){
    return Direction.LEFT;
  }
  return Direction.UP;
}

Direction oppositeDirection(Direction dir){
  switch (dir){
    case UP: return Direction.DOWN;
    case RIGHT: return Direction.LEFT;
    case DOWN: return Direction.UP;
    case LEFT: return Direction.RIGHT;
    default: return Direction.UP;
  }
}

Direction leftTurnDirection(Direction dir){
  switch (dir){
    case UP: return Direction.LEFT;
    case RIGHT: return Direction.UP;
    case DOWN: return Direction.RIGHT;
    case LEFT: return Direction.DOWN;
    default: return Direction.UP;
  }
}

Direction rightTurnDirection(Direction dir){
  switch (dir){
    case UP: return Direction.RIGHT;
    case RIGHT: return Direction.DOWN;
    case DOWN: return Direction.LEFT;
    case LEFT: return Direction.UP;
    default: return Direction.UP;
  }
}

float directionToAngle(Direction dir){
  switch (dir){
    case UP: return 0;
    case RIGHT: return PI/2;
    case DOWN: return PI;
    case LEFT: return 3*PI/2;
    default: return 0;
  }
}

enum Turn {
  LEFT, RIGHT, FORWARD
}

Turn getTurn(String name){
  if (name.startsWith("l")){
    return Turn.LEFT;
  }
  if (name.startsWith("r")){
    return Turn.RIGHT;
  }
  return Turn.FORWARD;
}

Direction applyTurn(Turn t, Direction dir){
  switch (t){
    case LEFT: return leftTurnDirection(dir);
    case RIGHT: return rightTurnDirection(dir);
    case FORWARD: return dir;
    default: return dir;
  }
}

interface Collideable {
  int getX();
  int getY();
  int getW();
  int getH();
  boolean canCollide();
}


boolean pointInCollideable(int x, int y, Collideable b){
  return (b.getX() <= x && x <= b.getX() + b.getW()
       && b.getY() <= y && y <= b.getY() + b.getH());
}

boolean collides(Collideable a, Collideable b){
  if (!a.canCollide() || !b.canCollide()) return false;

  if (a.getX() > b.getX() + b.getW()) return false;
  if (b.getX() > a.getX() + a.getW()) return false;
  if (a.getY() > b.getY() + b.getH()) return false;
  if (b.getY() > a.getY() + a.getH()) return false;
  return true;
}

boolean inside(Collideable a, Collideable b){
  if (!a.canCollide() || !b.canCollide()) return false;

  if (!pointInCollideable(a.getX(), a.getY(), b)) return false;
  if (!pointInCollideable(a.getX() + a.getW(), a.getY(), b)) return false;
  if (!pointInCollideable(a.getX(), a.getY() + a.getH(), b)) return false;
  if (!pointInCollideable(a.getX() + a.getW(), a.getY() + a.getH(), b)) return false;
  return true;
}

class Car implements Collideable {
  Level level;
  int x, y, w, h;
  float preciseX, preciseY;
  int tileX, tileY, tileW, tileH;
  int ordNumber;
  PImage img;
  float speed = 150; // brzina u pikselima po sekundi
  ArrayList<CarButton> buttons;
  Direction orient;
  TurnLogic turnLogic;
  Turn turn;
  float angle;
  float turningAngle;
  boolean finish;
  boolean started = false, animateFlag = false; 
  Wall currentWall;
  Light currentLight;
  TurnSign currentSign = null;
  boolean currentSignFlag = false;
  PVector animatedFrom, animatedTo;
  float angleFrom, angleTo;
  Car(Level level, StringDict attrib, int number){
    this.level = level;
    x = level.centerX(int(attrib.get("x")));
    y = level.centerY(int(attrib.get("y")));
    preciseX = x;
    preciseY = y;
    w = 16;
    h = 30;
    orient = getDirection(attrib.get("orientation"));
    angle = directionToAngle(orient);
    tileX = level.pxToTileX(x);
    tileY = level.pxToTileY(y);
    tileW = level.pxToTileX(w);
    tileH = level.pxToTileY(h);
    ordNumber=number;
    img = carImage;

    buttons = new ArrayList<CarButton>();
    if (attrib.get("action").equals("forward")){
      buttons.add(new CarForwardButton(this));
    } else if (attrib.get("action").equals("drive")){
      start();
    } else if (attrib.get("action").equals("stop")){
      buttons.add(new CarStartStopButton(this));
    }
    updateButtons();

    finish = false;
    String tmp = attrib.get("turn");
    if (tmp == null) turn = Turn.FORWARD;
    else turn = getTurn(tmp);
    tmp = attrib.get("logic");
    if (tmp == null){
      turnLogic = new ForwardTurn(turn);
    } else if (tmp.startsWith("f")){
      turnLogic = new ForwardTurn(turn);
    } else if (tmp.startsWith("v")){
      turnLogic = new VariableTurn(turn);
    } else if (tmp.startsWith("s")){
      turnLogic = new StackTurn(turn);
    } else if (tmp.startsWith("q")){
      turnLogic = new QueueTurn(turn);
    }
    turn = turnLogic.read();

    for (Wall wall : level.walls){
      if(collides(this,wall)){
        currentWall=wall;
        break;
      } else currentWall=null;
    }
    for (Light light : level.lights){
      if(collides(this,light)){
        currentLight=light;
        break;
      } else currentLight = null;
    }
  }
  
  void draw(){
    if (DEBUG_COLLISION){
      color(255, 255, 255);
      rect(getX(), getY(), getW(), getH());
    }
    if(!animateFlag){
      pushMatrix();
      translate(x,y);
      rotate(angle);
      imageMode(CENTER);
      image(img, 0, 0, w, h);
      if (turn == Turn.LEFT){
        image(level.leftArrowImage, 0, 0, w, h);
      } else if (turn == Turn.RIGHT){
        image(level.rightArrowImage, 0, 0, w, h);
      } else if (turn == Turn.FORWARD){
        image(level.upArrowImage, 0, 0, w, h);
      }
      imageMode(CORNER);
      popMatrix();
    }
    if(animateFlag){
      pushMatrix();
      if(orient==Direction.UP && turn==Turn.LEFT){
        translate(animatedFrom.x-level.tileWidth,animatedFrom.y);
        translate(level.tileWidth*cos(turningAngle),level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if(orient==Direction.UP && turn==Turn.RIGHT){
        translate(animatedFrom.x+level.tileWidth,animatedFrom.y);
        translate(-level.tileWidth*cos(turningAngle),-level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if(orient==Direction.LEFT && turn==Turn.RIGHT){
        translate(animatedFrom.x,animatedFrom.y-level.tileWidth);
        translate(-level.tileWidth*cos(turningAngle),-level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if(orient==Direction.RIGHT && turn==Turn.LEFT){
        translate(animatedFrom.x,animatedFrom.y-level.tileWidth);
        translate(level.tileWidth*cos(turningAngle),level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if(orient==Direction.DOWN && turn==Turn.LEFT){
        translate(animatedFrom.x+level.tileWidth,animatedFrom.y);
        translate(level.tileWidth*cos(turningAngle),level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if(orient==Direction.RIGHT && turn==Turn.RIGHT){
        translate(animatedFrom.x,animatedFrom.y+level.tileWidth);
        translate(-level.tileWidth*cos(turningAngle),-level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if(orient==Direction.DOWN && turn==Turn.RIGHT){
        translate(animatedFrom.x-level.tileWidth,animatedFrom.y);
        translate(-level.tileWidth*cos(turningAngle),-level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      if(orient==Direction.LEFT && turn==Turn.LEFT){
        translate(animatedFrom.x,animatedFrom.y+level.tileWidth);
        translate(level.tileWidth*cos(turningAngle),level.tileWidth*sin(turningAngle));
        rotate(turningAngle);
      }
      imageMode(CENTER);
      image(img,0,0,w,h);
      if (turn == Turn.LEFT){
        image(level.leftArrowImage, 0, 0, w, h);
      } else if (turn == Turn.RIGHT){
        image(level.rightArrowImage, 0, 0, w, h);
      } else if (turn == Turn.FORWARD){
        image(level.upArrowImage, 0, 0, w, h);
      }
      imageMode(CORNER);
      popMatrix();
    }
  }
  
  void update(float dt){
    if (animateFlag) animateTurn(dt);
    else turn = turnLogic.read();
    x = int(preciseX);
    y = int(preciseY);
    
    if (currentWall == null){
      for (Wall wall : level.walls){
        if(collides(this,wall)){ // usli smo u raskrsce
          currentWall = wall;
          
          if (wall.forbidden && applyTurn(turn, orient) == wall.forbiddenDirection)
            continue;

          turnLogic.next();
          if(turn==Turn.FORWARD) break;
          
          animatedFrom = new PVector(getX()+getW()/2, getY()+getH()/2);
          if((orient==Direction.UP && turn==Turn.LEFT)||
             (orient==Direction.LEFT && turn==Turn.RIGHT))
              animatedTo = new PVector(getX()-level.tileWidth,getY()-level.tileHeight);
          if((orient==Direction.UP && turn==Turn.RIGHT)||
             (orient==Direction.RIGHT && turn==Turn.LEFT))
              animatedTo = new PVector(getX()+level.tileWidth,getY()-level.tileHeight);
          if((orient==Direction.DOWN && turn==Turn.LEFT)||
             (orient==Direction.RIGHT && turn==Turn.RIGHT))
              animatedTo = new PVector(getX()+level.tileWidth,getY()+level.tileHeight);
          if((orient==Direction.DOWN && turn==Turn.RIGHT)||
             (orient==Direction.LEFT && turn==Turn.LEFT))
              animatedTo = new PVector(getX()-level.tileWidth,getY()+level.tileHeight);
          animateFlag = true;
          turningAngle = angle;
         }
      }
    } else if(currentWall!=null){
      if (!collides(this, currentWall)){ // izasli smo iz raskrsca
        currentWall = null;
      }
    }
    
    if (started && currentLight == null && !animateFlag){
      fastForward(dt);
    }

    updateButtons();

    if(outOfBounds()){
      finish=true;
    }

    currentLight = null; // resetiraj za slijedeci put
    if (!currentSignFlag){
      currentSign = null;
    }
    currentSignFlag = false;
  }

  int getX(){
    return x - getW() / 2;
  }

  int getY(){
    return y - getH() / 2;
  }

  int getW(){
    if (orient == Direction.UP || orient == Direction.DOWN)
      return w;
    return h;
  }

  int getH(){
    if (orient == Direction.UP || orient == Direction.DOWN)
      return h;
    return w;
  }

  boolean canCollide(){
    return !finish;
  }

  private void updateButtons(){
    for (CarButton button : buttons){
      button.setCarPos(getX(), getY(), getW(), getH());
    }
  }

  ArrayList<CarButton> getButtons(){
    return buttons;
  }

  boolean finished(){
    return finish;
  }
  
  boolean outOfBounds(){
    if(y + h < 0) return true;
    if(y > height) return true;
    if(x > width) return true;
    if(x + w < 0) return true;
    return false;
  }
  
  void collideAction(Collideable obj){
    if (obj instanceof Car){
      lives-=0.5;
      if(lives==0){
        println("GUBITAK");
        exit();
      }
      level.crashed(this);
      started = false;
    } else if (obj instanceof Pjesak || obj instanceof Hazard){
        lives-=1;
        if(lives==0){
          println("Izgubili ste sve zivote!");
          exit();
        }
        level.crashed(this);
        started = false;
    } else if (obj instanceof TurnSign){
      currentSignFlag = true;
      if (currentSign == null){
        TurnSign turnSign = (TurnSign) obj;
        if (turnSign.orient == orient){
          turnLogic.write(turnSign.getNew());
        }
        currentSign = turnSign;
      }
    } else if (obj instanceof Light){
      currentLight = (Light) obj;
    }
  }
  
  void animateTurn(float dt){
    if(turn==Turn.LEFT){
      turningAngle -= dt * speed / level.tileWidth; 
      if(orient==Direction.UP && turningAngle<=-PI/2){
        afterTurn();
        return;
      }
      if(orient==Direction.RIGHT && turningAngle<=0){
        afterTurn();
        return;
      }
      if(orient==Direction.DOWN && turningAngle<=PI/2){
        afterTurn();
        return;
      }
      if(orient==Direction.LEFT && turningAngle<=PI){
        afterTurn();
        return;
      }
    }
    if(turn==Turn.RIGHT){
      turningAngle += dt * speed / level.tileWidth; 
      if(orient==Direction.UP && turningAngle>=PI/2){
        afterTurn();
        return;
      }
      if(orient==Direction.RIGHT && turningAngle>=PI){
        afterTurn();
        return;
      }
      if(orient==Direction.DOWN && turningAngle>=3*PI/2){
        afterTurn();
        return;
      }
      if(orient==Direction.LEFT && turningAngle>=2*PI){
        afterTurn();
        return;
      }
    }
    
    return;
  }
  
  void afterTurn(){
    preciseX=animatedTo.x + getW() / 2;
    preciseY=animatedTo.y + getH() / 2;
    orient=applyTurn(turn,orient);
    angle=directionToAngle(orient);
    turn=Turn.FORWARD;
    // zakomentirati prethodnu liniju za super Koraljku :)
    animateFlag = false;
    turningAngle=0;
    return;    
  }

  void fastForward(float dt){
    PVector displace = new PVector(0, -1);
    displace.rotate(directionToAngle(orient));
    displace.mult(speed * dt);
    preciseX += displace.x;
    preciseY += displace.y;
  }

  void start(){
    started = true;
  }

  void stop(){
    started = false;
  }
}
