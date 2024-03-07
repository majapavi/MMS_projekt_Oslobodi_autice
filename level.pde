import ptmx.*;

class Level {
  Ptmx map;
  int tileWidth, tileHeight; // sirina pojedinog tile-a u pikselima
  int mapWidth, mapHeight; // broj tile-ova u nivou
  ArrayList<Car> cars;
  ArrayList<LevelButton> buttons;
  boolean[][] occupationMatrix;
  Level(PApplet game, String filename){
    map = new Ptmx(game, filename);

    PVector tileSize = map.getTileSize();
    tileWidth = int(tileSize.x);
    tileHeight = int(tileSize.y);

    PVector mapSize = map.getMapSize();
    mapWidth = int(mapSize.x);
    mapHeight = int(mapSize.y);
    occupationMatrix = new boolean[mapHeight][mapWidth];

    cars = new ArrayList<Car>();
    buttons = new ArrayList<LevelButton>();
    for (int i = 0;map.getType(i)!=null;i++){
      String type = map.getType(i);

      if (type.equals("objectgroup")){
        StringDict objs[] = map.getObjects(i);
        for (StringDict obj : objs){
          if (obj.get("type").equals("car")){
            Car car = new Car(this, obj);
            cars.add(car);
            buttons.addAll(car.getButtons());
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

  private boolean outOfMap(int x, int y){
    if (x < 0) return true;
    if (y < 0) return true;
    if (x >= mapWidth) return true;
    if (y >= mapHeight) return true;
    return false;
  }

  boolean valid(int x, int y){
    if (outOfMap(x, y)) return true;
    return !occupationMatrix[y][x];
  }

  boolean endTile(int x, int y){
    return outOfMap(x, y);
  }

  void setTile(int x, int y, boolean occupied){
    if (!outOfMap(x, y)){
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
