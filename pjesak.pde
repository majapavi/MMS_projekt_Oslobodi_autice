class Pjesak implements Collideable{
  Level level;
  int x,y,w,h;
  float x1, y1, x2, y2;
  float distance;
  PImage pjesakImage;
  Direction dir;
  float path = 1;
  float speed = 60;
  
  Pjesak(Level level, StringDict attrib){
    this.level = level;
    pjesakImage = loadImage("pjesak.png");
    w = pjesakImage.width;
    h = pjesakImage.height;
    int tmpX = int(attrib.get("x"));
    int tmpY = int(attrib.get("y"));
    int tmpW = int(attrib.get("width"));
    int tmpH = int(attrib.get("height"));
    x1 = (float) (level.centerX(tmpX) - w / 2);
    y1 = (float) (level.centerY(tmpY) - h / 2);
    x2 = (float) (level.centerX(tmpX + tmpW - 1) - w / 2);
    y2 = (float) (level.centerY(tmpY + tmpH - 1) - h / 2);
    distance = dist(x1, y1, x2, y2); // duljina pjesakovog puta

    dir = getDirection(attrib.get("direction"));
    if(dir==Direction.DOWN) path = 1;
    else if (dir==Direction.UP) path = 0;
    else if (dir == Direction.LEFT) path = 1;
    else path = 0;
    x = (int) lerp(x1, x2, constrain(path, 0, 1));
    y = (int) lerp(y1, y2, constrain(path, 0, 1));
  }
  
  void draw(){
    image(pjesakImage,x,y,w,h);
  }

  void update(float dt){
    if(dir==Direction.LEFT){
      path -= dt * speed / distance;
    }
    if(dir==Direction.RIGHT){
      path += dt * speed / distance;
    }
    if(dir==Direction.UP){
      path -= dt * speed / distance;
    }
    if(dir==Direction.DOWN){
      path += dt * speed / distance;
    }
    if(path >= 1.5 || path <= -0.5){
      dir=oppositeDirection(dir);
    }
    x = (int) lerp(x1, x2, constrain(path, 0, 1));
    y = (int) lerp(y1, y2, constrain(path, 0, 1));
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
