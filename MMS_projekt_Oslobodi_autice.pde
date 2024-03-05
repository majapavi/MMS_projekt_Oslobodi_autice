String firstLevel = "city.tmx";

Level next, cur;
boolean drawLevel = false; // zamijeniti s ozbiljnim main menu kodom!

PImage carImage;

void setNextLevel(String filename){
  next = new Level(this, filename);
}

void startLevel(){
  cur = next;
  drawLevel = true;
}

void finishLevel(){
  println("BRAVO");
  exit();
}

void setup(){
  size(640, 640);
  carImage = loadImage("car.png");
  setNextLevel(firstLevel);
  startLevel();
}

void draw(){
  background(35);
  if (drawLevel){
    cur.draw();
  }
}
