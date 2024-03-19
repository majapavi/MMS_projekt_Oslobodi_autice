String firstLevel = "lvl.tmx";

Level cur;
String nextLevelName;
boolean drawLevel = false; // zamijeniti s ozbiljnim main menu kodom!
boolean startLevelFlag = false;

PImage carImage;
ResetButton reset;

ArrayList<Button> buttons;
boolean lastMousePressed = false;

int lastTime; // u milisekundama
float deltaTime; // u sekundama

void setNextLevel(String filename){
  nextLevelName = filename;
}

void startLevel(){
  startLevelFlag = true;
}

void realStartLevel(){
  if (cur != null){
    buttons.removeAll(cur.getButtons());
  }
  cur = new Level(this, nextLevelName);
  buttons.addAll(cur.getButtons());
  drawLevel = true;
  startLevelFlag = false;
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
  lastTime = millis();
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

  int curTime = millis();
  deltaTime = float(curTime - lastTime) / 1000.0;
  lastTime = curTime;

  // update
  if (drawLevel){
    cur.update(deltaTime);
  }

  // crtaj
  background(35);
  if (drawLevel){
    cur.draw();
  }
  for (Button button : buttons){
    button.draw();
  }
  if (startLevelFlag){
    realStartLevel();
  }
}
