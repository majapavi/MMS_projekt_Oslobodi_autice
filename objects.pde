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
    return !lightButton.lightColor;
  }
}

class Wall implements Collideable{
  // klasa koja oznacava raskrsca
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

class Hazard implements Collideable {
  int x, y, w, h;
  Hazard(StringDict attrib){
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
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
