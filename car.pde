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

  if (pointInCollideable(a.getX(), a.getY(), b)) return true;
  if (pointInCollideable(a.getX() + a.getW(), a.getY(), b)) return true;
  if (pointInCollideable(a.getX(), a.getY() + a.getH(), b)) return true;
  if (pointInCollideable(a.getX() + a.getW(), a.getY() + a.getH(), b)) return true;

  if (pointInCollideable(b.getX(), b.getY(), a)) return true;
  if (pointInCollideable(b.getX() + b.getW(), b.getY(), a)) return true;
  if (pointInCollideable(b.getX(), b.getY() + b.getH(), a)) return true;
  if (pointInCollideable(b.getX() + b.getW(), b.getY() + b.getH(), a)) return true;
  return false;
}

class Light implements Collideable{
  int x,y,w,h;
  LightButton lightButton;
  Direction orient;
  Light(StringDict attrib){
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
    orient = getDirection(attrib.get("direction"));
    if(orient==Direction.DOWN || orient==Direction.LEFT){
      lightButton=new LightButton(x+7,y+7,18,18,false);
    }
    if(orient==Direction.UP || orient==Direction.RIGHT){
      lightButton=new LightButton(x+w-25,y+h-25,18,18,false);
    }
  }
  
  int getX(){
    return x;
  }

  int getY(){
    return y;
  }

  int getW(){
    return w;
  }

  int getH(){
    return h;
  }

  boolean canCollide(){
    return true;
  }
}

class Wall implements Collideable{
  int x,y,w,h;
  String ordNumber;
  boolean forbidden;
  Direction forbiddenDirection;
  Wall(StringDict attrib, String num){
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
    String tmp = attrib.get("forbidden");
    if (tmp == null){
      forbidden = false;
    } else {
      forbidden = true;
      forbiddenDirection = getDirection(tmp);
    }
    ordNumber = num;
  }
  
  int getX(){
    return x;
  }

  int getY(){
    return y;
  }

  int getW(){
    return w;
  }

  int getH(){
    return h;
  }

  boolean canCollide(){
    return true;
  }
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
  Turn turn;
  float angle;
  float turningAngle;
  boolean finish;
  boolean fastForwardFlag = false, animateFlag = false; 
  boolean startingPosition;
  Wall currentWall;
  Light currentLight;
  PVector animatedFrom, animatedTo;
  float animationProgress, angleFrom, angleTo;
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
    buttons.add(new CarForwardButton(this));
    updateButtons();
    finish = false;
    startingPosition = true;
    String tmp = attrib.get("turn");
    if (tmp == null) turn = Turn.FORWARD;
    else turn = getTurn(tmp);
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
    x = int(preciseX);
    y = int(preciseY);
    
    if(currentLight==null && !startingPosition){
      for(Light light : level.lights){
        if(collides(this,light)){
           if(orient==light.orient){
             if(!light.lightButton.lightColor){
                  fastForwardFlag=false;
                } else{
                  fastForwardFlag=true;
                }
           }
        }
      }
    } else if (currentLight!=null){
        if(!startingPosition){
          if(!currentLight.lightButton.lightColor){
            fastForwardFlag=false;
          }
          else{
            fastForwardFlag=true;
           }
          if (!collides(this, currentLight)){
            currentLight = null;
          }
        }
      }
    //verzija sa klasom Wall
    if (currentWall == null && !startingPosition){
      for (Wall wall : level.walls){
        if(collides(this,wall)){ // usli smo u raskrsce
          currentWall = wall;
          
          if(turn==Turn.FORWARD) break;
          
          if (wall.forbidden && applyTurn(turn, orient) == wall.forbiddenDirection)
            continue;
          
          
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
          fastForwardFlag = false;
          turningAngle = angle;
         }
      }
    } else if(currentWall!=null){
      if (!collides(this, currentWall)){ // izasli smo iz raskrsca
        currentWall = null;
      }
    }
    
    if (fastForwardFlag){
      startingPosition=false;
      fastForward(dt);
    }

    updateButtons();

    if(outOfBounds()){
      finish=true;
    }
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
      fastForwardFlag=false;
    }  else if (obj instanceof Pjesak){
        lives-=1;
        if(lives==0){
          println("Izgubili ste sve zivote!");
          exit();
        }
        level.crashed(this);
        fastForwardFlag=false;
    }  else if (obj instanceof TurnSign){
      TurnSign turnSign = (TurnSign) obj;
      if (turnSign.orient == orient){
        turn = turnSign.getNew();
      }
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
    fastForwardFlag = true;
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
}
