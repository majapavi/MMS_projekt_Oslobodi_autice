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

class Car {
  Level level;
  int x, y, w, h;
  int tileX, tileY, tileW, tileH;
  int ordNumber;
  PImage img;
  int speed=3;
  ArrayList<CarButton> buttons;
  Direction orient;
  boolean finish;
  boolean fastForwardFlag = false; 
  Car(Level level, StringDict attrib, int number){
    this.level = level;
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
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
  }
  
  void draw(){
    image(img, x, y, w, h);
  }

  void update(float dt){
    if(fastForwardFlag) fastForward();
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
  
  void fastForward(){
    int auxTileX=0, auxTileY=0;
    if(orient==Direction.UP){
      y -= speed;
      auxTileX=level.pxToTileX(x + w / 2);
      auxTileY=level.pxToTileY(y);
    }
    if(orient==Direction.DOWN){
      y += speed;
      auxTileX=level.pxToTileX(x + w / 2);
      auxTileY=level.pxToTileY(y + h);
    }
    if(orient==Direction.LEFT){
      x -= speed;
      auxTileX=level.pxToTileX(x);
      auxTileY=level.pxToTileY(y + h / 2);
    }
    if(orient==Direction.RIGHT){
      x += speed;
      auxTileX=level.pxToTileX(x + w);
      auxTileY=level.pxToTileY(y + h / 2);
    }
    
    updateButtons();
    if(!level.outOfMap(auxTileX,auxTileY) && level.occupationMatrix[auxTileY][auxTileX]==0){
       level.occupationMatrix[auxTileY][auxTileX]=ordNumber;
       if(orient==Direction.RIGHT) level.occupationMatrix[auxTileY][auxTileX-1]=0;
       if(orient==Direction.DOWN) level.occupationMatrix[auxTileY-1][auxTileX]=0;
       if(orient==Direction.LEFT) level.occupationMatrix[auxTileY][auxTileX+1]=0;
       if(orient==Direction.UP) level.occupationMatrix[auxTileY+1][auxTileX]=0;
    }
    if(!level.outOfMap(auxTileX,auxTileY) && level.occupationMatrix[auxTileY][auxTileX]>0){
      if(level.occupationMatrix[auxTileY][auxTileX]!=ordNumber){
        level.crashed(this);
        level.setTile(tileX, tileY, ordNumber);
        fastForwardFlag=false;
      }
    }
    if(outOfBounds()){
      fastForwardFlag=false;
      //level.setTile(tileX, tileY, 0);
      level.setTile(auxTileX, auxTileY, 0);
      if(orient==Direction.RIGHT) level.setTile(auxTileX-2,auxTileY,0);
      if(orient==Direction.RIGHT) level.setTile(auxTileX-1,auxTileY,0);
      //ako netko shvati zasto je ovdje potrebno -2 umjesto -1 (sto ne radi dobro) nek javi
      if(orient==Direction.DOWN) level.setTile(auxTileX,auxTileY-2,0);
      if(orient==Direction.DOWN) level.setTile(auxTileX,auxTileY-1,0);
      if(orient==Direction.LEFT) level.setTile(auxTileX+2,auxTileY,0);
      if(orient==Direction.LEFT) level.setTile(auxTileX+1,auxTileY,0);
      if(orient==Direction.UP) level.setTile(auxTileX,auxTileY+2,0);
      if(orient==Direction.UP) level.setTile(auxTileX,auxTileY+1,0);
      finish=true;
      return;
    }
  }
}
