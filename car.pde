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
  PImage img;
  ArrayList<CarButton> buttons;
  Direction orient;
  boolean finish;
  Car(Level level, StringDict attrib){
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
    level.setTile(x, y, true);
    img = carImage;
    buttons = new ArrayList<CarButton>();
    buttons.add(new CarForwardButton(this));
    update_buttons();
    finish = false;
  }
  
  void draw(){
    image(img, x, y, w, h);
  }

  void update(float dt){
  }

  private void update_buttons(){
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
    level.setTile(tileX, tileY, false);
    tileX = newX;
    tileY = newY;
    level.setTile(tileX, tileY, true);
    if (level.endTile(tileX, tileY)){
      finish = true;
    }

    // ovaj dio se treba animirati:
    x = level.tileToPxX(tileX);
    y = level.tileToPxX(tileY);

    update_buttons();
    return true;
  }
}
