// Sucelje Collideable je u datoteci car.pde

// Klasa za pjesake
class Pjesak implements Collideable{
  Level level;
  int x, y, w, h;
  float x1, y1, x2, y2;
  float distance;        // duljina pjesakovog puta
  PImage pjesakImage;
  Direction dir;
  
  // pozicija 1 je s jedne strane ceste, a pozicija 0 je s druge strane ceste
  //   -> ako je pjesak na cesti, path je u intervalu <0,1>
  float path = 1;        // vrijednost u intervalu [0,1]
  float speed = 60;      // brzina kretanja pjesaka
  
  // Konstruktor
  Pjesak(Level level, StringDict attrib){
    // Inicijalizacija varijabli
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
    distance = dist(x1, y1, x2, y2); // udaljenost od (x1, y1) do (x2,y2)

    dir = getDirection(attrib.get("direction"));
    if(dir == Direction.DOWN) path = 1;
    else if (dir == Direction.UP) path = 0;
    else if (dir == Direction.LEFT) path = 1;
    else path = 0;
    
    // Odredi poziciju pjesaka - odaberi stranu ceste s koje krece?
    x = (int) lerp(x1, x2, constrain(path, 0, 1));
    y = (int) lerp(y1, y2, constrain(path, 0, 1));
  }
  
  // Nacrtaj pjesaka
  void render(){
    image(pjesakImage, x, y, w, h);
  }

  // Azuriraj poziciju pjesaka
  void update(float dt){
    if(dir == Direction.LEFT){
      path -= dt * speed / distance;
    }
    if(dir == Direction.RIGHT){
      path += dt * speed / distance;
    }
    if(dir == Direction.UP){
      path -= dt * speed / distance;
    }
    if(dir == Direction.DOWN){
      path += dt * speed / distance;
    }
    
    // ako je dosao na drugu stranu ceste, promijeni mu smjer kretanja
    if(path >= 1.5 || path <= -0.5){
      dir = oppositeDirection(dir);
    }
    
    // Odredi poziciju pjesaka
    x = (int) lerp(x1, x2, constrain(path, 0, 1));
    y = (int) lerp(y1, y2, constrain(path, 0, 1));
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
  
  // Vraca true jer se uvijek moze sudariti s pjesakom
  boolean canCollide(){
    return true;
  }
}
