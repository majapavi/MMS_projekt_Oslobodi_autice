String firstLevel = "city.tmx";

Level next, cur;
boolean drawLevel = false; // zamijeniti s ozbiljnim main menu kodom!

PImage carImage;
ResetButton reset;

ArrayList<Button> buttons;
boolean lastMousePressed = false;

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
  buttons = new ArrayList<Button>();
  reset = new ResetButton(width - 30, 20);
  buttons.add(reset);
  setNextLevel(firstLevel);
  startLevel();
}

void onClick(int x, int y){
  for (Button button : buttons){
    if (button.validCursor(x, y)){
      button.click();
    }
  }
}

void draw(){
  // input
  if (!lastMousePressed && mousePressed){
    onClick(mouseX, mouseY);
  }
  lastMousePressed = mousePressed;
  // crtaj
  background(35);
  if (drawLevel){
    cur.draw();
  }
  for (Button button : buttons){
    button.draw();
  }
}
