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
  boolean finish;
  boolean fastForwardFlag = false; 
  int turnable = 0;
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
    level.setTile(tileX, tileY, ordNumber);
    img = rotateCar();
    buttons = new ArrayList<CarButton>();
    buttons.add(new CarForwardButton(this));
    updateButtons();
    finish = false;
    turnable = turner(attrib);
  }
  
  void draw(){
    PImage tmp=carImage;
    pushMatrix();
    translate(x+w/2,y+h/2);
    altRotateCar();
    translate(-w/2,-h/2);
    image(tmp, 0, 0, w, h);
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
  
  int turner(StringDict attrib){
    if (attrib.get("orientation").equals("upturn")){
      if(attrib.get("turning").equals("right")) return 1;
      if(attrib.get("turning").equals("left")) return -1;
    }
    if (attrib.get("orientation").equals("downturn")){
      if(attrib.get("turning").equals("right")) return 1;
      if(attrib.get("turning").equals("left")) return -1;
    }
    return 0;
  }

  void update(float dt){
    if(fastForwardFlag) fastForward();
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

  PImage rotateCar(){
    PImage img;
    if(orient==Direction.UP){
       img=loadImage("car.png"); 
       return img;
    }
    if(orient==Direction.RIGHT){
       img=loadImage("rightcar.png");
       return img;
    }
    if(orient==Direction.DOWN){
       img=loadImage("downcar.png");
       return img;
    }
    if(orient==Direction.LEFT){
       img=loadImage("leftcar.png");
       return img;
    }
    return carImage;
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

  boolean forward(){
    int newX = tileX;
    int newY = tileY;
    if (orient == Direction.UP){
      newY--;
    }
    if (orient == Direction.RIGHT){
      newX++;
    }
    if (orient == Direction.DOWN){
      newY++;
    }
    if (orient == Direction.LEFT){
      newX--;
    }
    if (!level.valid(newX, newY)){
      return false;
    }
    level.setTile(tileX, tileY, ordNumber);
    tileX = newX;
    tileY = newY;
    level.setTile(tileX, tileY, ordNumber);
    if (level.endTile(tileX, tileY)){
      finish = true;
    }

    // ovaj dio se treba animirati:
    x = level.tileToPxX(tileX);
    y = level.tileToPxX(tileY);

    updateButtons();
    return true;
  }
  
  void collideAction(Collideable obj){
    level.crashed(this);
    level.setTile(tileX, tileY, ordNumber);
    fastForwardFlag=false;
  }
  
  void animateTurn(){
    
  }

  void fastForward(){
    if(turnable==1){
      int tmpTX = level.pxToTileX(int(preciseX));
      int tmpTY = level.pxToTileY(int(preciseY));
      if(level.wallMatrix[tmpTY][tmpTX+1]==1){
        orient=Direction.RIGHT;
        turnable=0;
        animateTurn();
      }
    }
    
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

    updateButtons();

    if(outOfBounds()){
      finish=true;
    }
  }
}
