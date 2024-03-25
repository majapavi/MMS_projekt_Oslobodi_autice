import ptmx.*;

class Level {
  Ptmx map;
  int tileWidth, tileHeight; // sirina pojedinog tile-a u pikselima
  int mapWidth, mapHeight; // broj tile-ova u nivou
  ArrayList<Car> cars;
  ArrayList<Wall> walls;
  ArrayList<Light> lights;
  ArrayList<LevelButton> buttons;
  ArrayList<Pjesak> pjesaci;
  ArrayList<Collideable> collideObjects;
  PImage leftArrowImage, rightArrowImage, upArrowImage;
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
    upArrowImage = loadImage("uparrow.png");
    collideObjects = new ArrayList<Collideable>();
    cars = new ArrayList<Car>();
    walls = new ArrayList<Wall>();
    lights = new ArrayList<Light>();
    buttons = new ArrayList<LevelButton>();
    pjesaci = new ArrayList<Pjesak>();
    for (int i = 0;map.getType(i)!=null;i++){
      String type = map.getType(i);
      if (type.equals("objectgroup")){
        StringDict objs[] = map.getObjects(i);
        for (StringDict obj : objs){
          String j=obj.get("name");
          if (obj.get("type").equals("light")){
            Light light=new Light(obj);
            lights.add(light);
            LevelButton bt=light.lightButton;
            buttons.add(bt);
          }
          if (obj.get("type").equals("wall")){
            Wall wall = new Wall(obj, j);
            walls.add(wall);
          }
          if (obj.get("type").equals("sign")){
            TurnSign turnSign = new TurnSign(this, obj);
            collideObjects.add(turnSign);
            buttons.add(turnSign.getButton());
          }
          if (obj.get("type").equals("pjesak")){
            Pjesak pjesak = new Pjesak(this, obj);
            pjesaci.add(pjesak);
            collideObjects.add(pjesak);
          }
          if (obj.get("type").equals("car")){
            Car car = new Car(this, obj, int(j));
            cars.add(car);
            collideObjects.add(car);
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
    for (Pjesak p : pjesaci){
      p.update(dt);
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

  int centerX(int pixelX){
    return tileToPxX(pxToTileX(pixelX)) + tileWidth / 2;
  }

  int centerY(int pixelY){
    return tileToPxY(pxToTileY(pixelY)) + tileHeight / 2;
  }
}
