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
  Wall(StringDict attrib, int num){
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
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
  int speed=3;
  ArrayList<CarButton> buttons;
  Direction orient;
  Turn turn;
  boolean finish;
  boolean fastForwardFlag = false; 
  Direction turnable;
  Car(Level level, StringDict attrib, int number){
    this.level = level;
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    preciseX = x;
    preciseY = y;
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
    orient = getDirection(attrib.get("orientation"));
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
  }
  
  void draw(){
    pushMatrix();
    translate(x+w/2,y+h/2);
    altRotateCar();
    translate(-w/2,-h/2);
    image(img, 0, 0, w, h);
    popMatrix();
  }
  
  void altRotateCar(){
    if(orient==Direction.UP){
       rotate(0);
    }
    if(orient==Direction.RIGHT){
       rotate(PI/2);
    }
    if(orient==Direction.DOWN){
       rotate(PI);
    }
    if(orient==Direction.LEFT){
       rotate(3*PI/2);
    }
    return;
  }
  
  void update(float dt){
    if (fastForwardFlag) fastForward();
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
  
  void animateTurn(){
    
  }

  void fastForward(){
    if(orient==Direction.UP){
      preciseY -= speed;
    }
    if(orient==Direction.DOWN){
      preciseY += speed;
    }
    if(orient==Direction.LEFT){
      preciseX -= speed;
    }
    if(orient==Direction.RIGHT){
      preciseX += speed;
    }
    x = int(preciseX);
    y = int(preciseY);

    //verzija sa klasom Wall
    for (Wall wall : level.walls){
      if(collides(this,wall)){
        orient = applyTurn(turn, orient);
        turn = Turn.FORWARD;
        animateTurn();
      }
    }
    
    updateButtons();

    if(outOfBounds()){
      finish=true;
    }
  }
}
