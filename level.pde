import ptmx.*;

class Level {
  Ptmx map;
  int tileWidth, tileHeight; // sirina pojedinog tile-a u pikselima
  int mapWidth, mapHeight; // broj tile-ova u nivou
  ArrayList<Car> cars;
  ArrayList<LevelButton> buttons;
  Level(PApplet game, String filename){
    map = new Ptmx(game, filename);

    PVector tileSize = map.getTileSize();
    tileWidth = int(tileSize.x);
    tileHeight = int(tileSize.y);

    PVector mapSize = map.getMapSize();
    mapWidth = int(mapSize.x);
    mapHeight = int(mapSize.y);

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

  void update(float dt){
  }

  ArrayList<LevelButton> getButtons(){
    return buttons;
  }
}
