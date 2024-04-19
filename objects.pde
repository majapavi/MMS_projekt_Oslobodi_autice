// Sucelje Collideable je u datoteci car.pde

// Klasa za semafore
class Light implements Collideable{
  int x, y, w, h;
  LightButton lightButton;
  Direction orient;
  
  // Konstruktor
  Light(StringDict attrib){
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
    orient = getDirection(attrib.get("direction"));
    
    // Semafor se nalazi s desne strane autica na koje utjece
    if(orient==Direction.DOWN || orient==Direction.LEFT){
      lightButton = new LightButton(x+7, y+7, 18, 18, false);
    }
    if(orient==Direction.UP || orient==Direction.RIGHT){
      lightButton = new LightButton(x+w-25, y+h-25, 18, 18, false);
    }
  }
  
  // Geteri
  // ------
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
  // ------

  // Vraca true ako je crveni semafor, a false ako je zeleni
  boolean canCollide(){
    return !lightButton.lightColor;
  }
}

// Klasa koja oznacava raskrsca
class Wall implements Collideable{
  int x, y, w, h;
  boolean forbidden;              // false ako je otvoreno raskrsce (cesta sa sve 4 strane)
  Direction forbiddenDirection;   // smjer u koji je zabranjeno skrenuti (nema ceste u tom smjeru)
  
  // Konstruktor
  Wall(StringDict attrib){
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
    
    // Postavi zabranjeni smjer, ako postoji
    String tmp = attrib.get("forbidden");
    if (tmp == null){
      forbidden = false;  // nema parametra forbidden
    } else {
      forbidden = true;
      forbiddenDirection = getDirection(tmp);
    }
    
  }
  
  // Geteri
  // ------
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
  // ------
  
  // Vrati true jer se uvijek moze doci u raskrsce
  boolean canCollide(){
    return true;
  }
}

// Klasa za prepreke
class Hazard implements Collideable {
  int x, y, w, h;
  
  // Konstruktor
  Hazard(StringDict attrib){
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
  }

  // Geteri
  // ------
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
  // ------
  
  // Vraca true jer se uvijek moze sudariti s preprekom
  boolean canCollide(){
    return true;
  }
}
