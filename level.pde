// Klasa koja se brine o svemu vezanom uz level
class Level {
  Ptmx map;                  // mapa iz programa Tiled
  int tileWidth, tileHeight; // sirina pojedinog tile-a u pikselima
  int mapWidth, mapHeight;   // broj tile-ova u nivou
  int pxWidth, pxHeight;     // dimenzije mape u pikselima (umnozak gornje dvije vrijednosti)
  ArrayList<Car> cars;
  ArrayList<Wall> walls;
  ArrayList<Light> lights;
  ArrayList<LevelButton> levelButtons;
  ArrayList<Pjesak> pjesaci;
  ArrayList<Collideable> collideObjects;
  PImage leftArrowImage, rightArrowImage, upArrowImage, heartImage;
  
  // Konstruktor
  // -----------
  Level(PApplet game, String filename){    // PApplet je bazna klasa za skiciranje
    // Inicijalizacija varijabli
    map = new Ptmx(game, filename);
    
    PVector tileSize = map.getTileSize();
    tileWidth = int(tileSize.x);
    tileHeight = int(tileSize.y);

    PVector mapSize = map.getMapSize();
    mapWidth = int(mapSize.x);
    mapHeight = int(mapSize.y);
    pxWidth = tileWidth * mapWidth;
    pxHeight = tileHeight * mapHeight;
    windowResize(pxWidth, pxHeight);
    leftArrowImage = loadImage("leftarrow.png");
    rightArrowImage = loadImage("rightarrow.png");
    upArrowImage = loadImage("uparrow.png");
    heartImage = loadImage("heart.png");
    if (STOP_TIME_WHEN_LEVEL_STARTS) TIME_GOES = false;
    
    // Inicijalizacija listi drugih objekata
    collideObjects = new ArrayList<Collideable>();
    cars = new ArrayList<Car>();
    walls = new ArrayList<Wall>();
    lights = new ArrayList<Light>();
    levelButtons = new ArrayList<LevelButton>();
    pjesaci = new ArrayList<Pjesak>();
    
    // Inicijalizacija svih objekata, tj citanje iz Tiled mape
    for (int i = 0;map.getType(i)!=null;i++){
      String type = map.getType(i);
      if (type.equals("objectgroup")){
        StringDict objs[] = map.getObjects(i);
        for (StringDict obj : objs){
          String j = obj.get("name");
          if (j == null) j = "";
          
          // Semafori
          if (obj.get("type").equals("light")){
            Light light = new Light(obj);
            lights.add(light);
            collideObjects.add(light);
            LevelButton bt = light.lightButton;
            levelButtons.add(bt);
          }
          
          // Zidovi/raskrsca
          if (obj.get("type").equals("wall")){
            Wall wall = new Wall(obj);
            walls.add(wall);
          }
          
          // Strelice na cesti
          if (obj.get("type").equals("sign")){
            TurnSign turnSign = new TurnSign(this, obj);
            collideObjects.add(turnSign);
            levelButtons.add(turnSign.getButton());
          }
          
          // Pjesaci
          if (obj.get("type").equals("pjesak")){
            Pjesak pjesak = new Pjesak(this, obj);
            pjesaci.add(pjesak);
            collideObjects.add(pjesak);
          }
          
          // Autici
          if (obj.get("type").equals("car")){
            Car car = new Car(this, obj);
            cars.add(car);
            collideObjects.add(car);
            levelButtons.addAll(car.getButtons());
          }
          
          // Prepreke
          if (obj.get("type").equals("hazard")){
            Hazard hazard = new Hazard(obj);
            collideObjects.add(hazard);
          }
        }  // kraj druge for petlje
      }  // kraj prvog if-a
    }  // kraj prve for petlje
  }
  // kraj konstruktora
  // -----------------

  // Crtanje levela
  void render(){
    map.draw(0, 0);
    for (Car car : cars){
      car.render();
    }
    for (Pjesak p : pjesaci){
      p.render(); 
    }
    image(heartImage, 0, 0, 32, 32);
    text((int)lives, 25, 16);
  }
  
  // Vraca true ako su svi autici izvan ekrana
  boolean finished(){
    if (SKIP_LEVEL){
      SKIP_LEVEL = false;
      return true;
    }
    for (Car car : cars){
      if (!car.finished()) return false;
    }
    return true;
  }

  // Detekcija sudara autica s nekim objektom
  private void collisionDetection(){
    for (Car car : cars){
      for (Collideable obj : collideObjects){
        if (car != obj && collides(car, obj)){
          car.collideAction(obj);
        }
      }
    }
  }

  // Azurira objekte koji se krecu po ekranu
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

  // Vraca listu gumbiju tipa LevelButton
  ArrayList<LevelButton> getButtons(){
    return levelButtons;
  }

  // Prilikom sudara 2 auta, resetiraj level
  void crashed(){
    println("ANIMACIJA SUDARA");
    startLevelFlag = true;
  }

  // Funkcije vezane za piksele i tile-ove, poziciju na ekranu
  // -------
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
  // -------
}

// Funkcija koja pokrece level prvi puta ili prilikom restarta
void startLevel(){
  if (currentLevel != null){
    buttons.removeAll(currentLevel.getButtons());
  }
  currentLevel = new Level(this, nextLevelName);
  buttons.addAll(currentLevel.getButtons());
  
  drawLevel = true;
  startLevelFlag = false;
}

// Funkcija koja se poziva kada je level prijeđen
void finishLevel(){
  drawLevel = false;
  display.changeDisplayState(screenState.END);
}
