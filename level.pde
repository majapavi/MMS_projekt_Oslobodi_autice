import ptmx.*;

class Level {
  Ptmx map;
  int tileWidth, tileHeight; // sirina pojedinog tile-a u pikselima
  int mapWidth, mapHeight; // broj tile-ova u nivou
  ArrayList<Car> cars;
  ArrayList<LevelButton> buttons;
  int[][] occupationMatrix;
  Level(PApplet game, String filename){
    map = new Ptmx(game, filename);

    PVector tileSize = map.getTileSize();
    tileWidth = int(tileSize.x);
    tileHeight = int(tileSize.y);

    PVector mapSize = map.getMapSize();
    mapWidth = int(mapSize.x);
    mapHeight = int(mapSize.y);
    occupationMatrix = new int[mapHeight][mapWidth]; //ovo je prije bilo boolean
    //sad govori i koji auto (po redu u arrayu cars) je na tom mjestu, ne samo ima li auta
    for (int i=0;i<mapHeight;i++){
      for (int j=0;j<mapHeight;j++){
         occupationMatrix[i][j]=0; 
      }
    }
    
    cars = new ArrayList<Car>();
    buttons = new ArrayList<LevelButton>();
    for (int i = 0;map.getType(i)!=null;i++){
      String type = map.getType(i);

      if (type.equals("objectgroup")){
        StringDict objs[] = map.getObjects(i);
        int j=1;
        for (StringDict obj : objs){
          if (obj.get("type").equals("car")){
            Car car = new Car(this, obj, j);
            cars.add(car);
            buttons.addAll(car.getButtons());
            j++;
          }

        }
      }

    }
  }

  void draw(){
    map.draw(0, 0);
    for (Car car : cars){
      car.draw();
    }
  }

  boolean finished(){
    for (Car car : cars){
      if (!car.finished()) return false;
    }
    return true;
  }

  void update(float dt){
    if (finished()){ // mozda bi igra trebala provoditi ovu provjeru, a ne nivo
      finishLevel();
    }
    for (Car car : cars){
      car.update(dt);
    }
  }

  ArrayList<LevelButton> getButtons(){
    return buttons;
  }

  boolean outOfMap(int x, int y){ //ovo je bilo private u preth verziji
    if (x < 0) return true;
    if (y < 0) return true;
    if (x >= mapWidth) return true;
    if (y >= mapHeight) return true;
    return false;
  }

  boolean valid(int x, int y){
    if (outOfMap(x, y)) return true;
    //return !occupationMatrix[y][x]; //verzija kad je matrica bila boolean
    if (occupationMatrix[y][x]==0) return true;
    return false;
  }

  boolean endTile(int x, int y){
    return outOfMap(x, y);
  }

  void setTile(int x, int y, int occupied){
    if (outOfMap(x, y)==false){
      occupationMatrix[y][x] = occupied;
    }
  }

  int pxToTileX(int pixelX){
    return pixelX / tileWidth;
  }

  int pxToTileY(int pixelY){
    return pixelY / tileHeight;
  }

  int tileToPxX(int tileX){
    return tileX * tileWidth;
  }

  int tileToPxY(int tileY){
    return tileY * tileHeight;
  }
}
