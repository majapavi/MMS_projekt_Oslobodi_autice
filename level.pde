import ptmx.*;

class Level {
  Ptmx map;
  int tileWidth, tileHeight; // sirina pojedinog tile-a u pikselima
  int mapWidth, mapHeight; // broj tile-ova u nivou
  ArrayList<Car> cars;
  ArrayList<Wall> walls;
  ArrayList<LevelButton> buttons;
  ArrayList<Pjesak> pjesaci;
  int[][] wallMatrix;
  int[][] tileMatrix;
  ArrayList<Collideable> collideObjects;
  PImage leftArrowImage, rightArrowImage;
  Level(PApplet game, String filename){
    map = new Ptmx(game, filename);
    
    PVector tileSize = map.getTileSize();
    tileWidth = int(tileSize.x);
    tileHeight = int(tileSize.y);

    PVector mapSize = map.getMapSize();
    mapWidth = int(mapSize.x);
    mapHeight = int(mapSize.y);
    leftArrowImage = loadImage("leftarrow.png");
    rightArrowImage = loadImage("rightarrow.png");
    //matrica prati gdje se nalazi zid (pomoc pri skretanju auta)
    //u ovoj verziji umjesto nje koristi se klasa Wall
    wallMatrix = new int[mapHeight][mapWidth];
    for (int i=0;i<mapHeight;i++){
      for (int j=0;j<mapWidth;j++){
        wallMatrix[i][j]=0; 
      }
    }
    //matrica prati gdje je cesta
    tileMatrix = new int[mapHeight][mapWidth];
    for (int i=0;i<mapHeight;i++){
      for (int j=0;j<mapWidth;j++){
        tileMatrix[i][j]=map.getTileIndex(1,j,i); 
      }
    }
    collideObjects = new ArrayList<Collideable>();
    cars = new ArrayList<Car>();
    walls = new ArrayList<Wall>();
    buttons = new ArrayList<LevelButton>();
    pjesaci = new ArrayList<Pjesak>();
    for (int i = 0;map.getType(i)!=null;i++){
      String type = map.getType(i);
      if (type.equals("objectgroup")){
        StringDict objs[] = map.getObjects(i);
        for (StringDict obj : objs){
          int j=int(obj.get("name"));
          if (obj.get("type").equals("car")){
            Car car = new Car(this, obj, j);
            cars.add(car);
            collideObjects.add(car);
            buttons.addAll(car.getButtons());
          }
          if (obj.get("type").equals("wall")){
            Wall wall = new Wall(obj, j);
            walls.add(wall);
            if(wall.trafficLight){
             LevelButton bt=wall.lightButton;
             buttons.add(bt);
            }
            
            int tmp = int(obj.get("x"));
            int tmpTileX = pxToTileX(tmp);
            tmp = int(obj.get("y"));
            int tmpTileY = pxToTileY(tmp);
            wallMatrix[tmpTileY][tmpTileX]=j;
          }
          if (obj.get("type").equals("sign")){
            TurnSign turnSign = new TurnSign(this, obj);
            collideObjects.add(turnSign);
            buttons.add(turnSign.getButton());
          }
          if (obj.get("type").equals("pjesak")){
            Pjesak pjesak = new Pjesak(obj);
            pjesaci.add(pjesak);
            collideObjects.add(pjesak);
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
    for (Pjesak p : pjesaci){
      p.draw(); 
    }
  }
  
  boolean finished(){
    for (Car car : cars){
      if (!car.finished()) return false;
    }
    return true;
  }

  private void collisionDetection(){
    for (Car car : cars){
      for (Collideable obj : collideObjects){
        if (car != obj && collides(car, obj)){
          car.collideAction(obj);
        }
      }
    }
  }

  void update(float dt){
    if (finished()){ // mozda bi igra trebala provoditi ovu provjeru, a ne nivo
      finishLevel();
    }
    for (Car car : cars){
      car.update(dt);
    }
    collisionDetection();
  }

  ArrayList<LevelButton> getButtons(){
    return buttons;
  }

  void crashed(Car car){
    println("ANIMACIJA SUDARA");
    startLevel();
  }

  boolean outOfMap(int x, int y){
    if (x < 0) return true;
    if (y < 0) return true;
    if (x >= mapWidth) return true;
    if (y >= mapHeight) return true;
    return false;
  }

  boolean endTile(int x, int y){
    return outOfMap(x, y);
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
