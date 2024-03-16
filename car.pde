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


boolean pointInColliddeable(int x, int y, Collideable b){
  return (b.getX() <= x && x <= b.getX() + b.getW()
       && b.getY() <= y && y <= b.getY() + b.getH());
}

boolean collides(Collideable a, Collideable b){
  if (!a.canCollide() || !b.canCollide()) return false;

  if (pointInColliddeable(a.getX(), a.getY(), b)) return true;
  if (pointInColliddeable(a.getX() + a.getW(), a.getY(), b)) return true;
  if (pointInColliddeable(a.getX(), a.getY() + a.getH(), b)) return true;
  if (pointInColliddeable(a.getX() + a.getW(), a.getY() + a.getH(), b)) return true;

  if (pointInColliddeable(b.getX(), b.getY(), a)) return true;
  if (pointInColliddeable(b.getX() + b.getW(), b.getY(), a)) return true;
  if (pointInColliddeable(b.getX(), b.getY() + b.getH(), a)) return true;
  if (pointInColliddeable(b.getX() + b.getW(), b.getY() + b.getH(), a)) return true;
  return false;
}

class Wall implements Collideable{
  int x,y,w,h;
  int ordNumber;
  boolean forbidden;
  Direction forbiddenDirection;
  Wall(StringDict attrib, int num){
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
  boolean finish;
  boolean fastForwardFlag = false, animateFlag = false; 
  Wall currentWall;
  PVector animatedFrom, animatedTo;
  float animationProgress, angleFrom, angleTo;
  Car(Level level, StringDict attrib, int number){
    this.level = level;
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    preciseX = x;
    preciseY = y;
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
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
    String tmp = attrib.get("turn");
    if (tmp == null) turn = Turn.FORWARD;
    else turn = getTurn(tmp);
    currentWall = null;
  }
  
  void draw(){
    pushMatrix();
    translate(x+w/2,y+h/2);
    rotate(angle);
    translate(-w/2,-h/2);
    image(img, 0, 0, w, h);
    popMatrix();
  }
  
  void update(float dt){
    if (fastForwardFlag) fastForward(dt);
    if (animateFlag) animateTurn(dt);
    x = int(preciseX);
    y = int(preciseY);

    //verzija sa klasom Wall
    if (currentWall == null){
      for (Wall wall : level.walls){
        if(collides(this,wall)){ // usli smo u raskrsce
          currentWall = wall;
          if (wall.forbidden && applyTurn(turn, orient) == wall.forbiddenDirection)
            continue;
          animatedFrom = new PVector(preciseX, preciseY);
          animatedTo = animatedFrom.copy();
          PVector firstTileMove = new PVector(0, -(float) level.tileWidth);
          angleFrom = directionToAngle(orient);
          firstTileMove.rotate(angleFrom);

          orient = applyTurn(turn, orient);

          PVector secondTileMove = new PVector(0, -(float) level.tileWidth);
          angleTo = directionToAngle(orient);
          secondTileMove.rotate(angleTo);

          animatedTo.add(firstTileMove);
          animatedTo.add(secondTileMove);

          turn = Turn.FORWARD;
          // zakomentirati prethodnu liniju za super Koraljku :)
          animateFlag = true;
          fastForwardFlag = false;
          animationProgress = 0;
        }
      }
    } else {
      if (!collides(this, currentWall)){ // izasli smo iz raskrsca
        currentWall = null;
      }
    }

    updateButtons();

    if(outOfBounds()){
      finish=true;
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
    return !finish;
  }


  private void updateButtons(){
    for (CarButton button : buttons){
      button.setCarPos(x, y);
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
    level.crashed(this);
    fastForwardFlag=false;
  }
  
  void animateTurn(float dt){
    animationProgress += dt * speed / level.tileWidth / 2;
    preciseX = lerp(animatedFrom.x, animatedTo.x, animationProgress);
    preciseY = lerp(animatedFrom.y, animatedTo.y, animationProgress);
    angle = lerp(angleFrom, angleTo, animationProgress);
    if (animationProgress >= 1.0){
      preciseX = animatedTo.x;
      preciseY = animatedTo.y;
      angle = angleTo;
      animateFlag = false;
      fastForwardFlag = true;
    }
  }

  void fastForward(float dt){
    PVector displace = new PVector(0, -1);
    displace.rotate(directionToAngle(orient));
    displace.mult(speed * dt);
    preciseX += displace.x;
    preciseY += displace.y;
  }
}
