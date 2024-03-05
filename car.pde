class Car {
  Level level;
  int x, y, w, h;
  int tileX, tileY;
  PImage img;
  ArrayList<CarButton> buttons;
  Car(Level level, StringDict attrib){
    this.level = level;
    x = int(attrib.get("x"));
    y = int(attrib.get("y"));
    w = int(attrib.get("width"));
    h = int(attrib.get("height"));
    img = carImage;
    buttons = new ArrayList<CarButton>();
  }
  
  void draw(){
    image(img, x, y, w, h);
  }

  void update(float dt){
  }

  ArrayList<CarButton> getButtons(){
    return buttons;
  }
}
