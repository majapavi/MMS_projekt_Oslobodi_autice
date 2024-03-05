import ptmx.*;

class Level {
  Ptmx map;
  Level(PApplet game, String filename){
    map = new Ptmx(game, filename);
  }

  void draw(){
    map.draw(0, 0);
  }

  void update(float dt){
  }
}
