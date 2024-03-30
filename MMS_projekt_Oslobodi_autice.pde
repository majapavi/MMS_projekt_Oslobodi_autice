String firstLevel = "lvl.tmx";

Level cur;
String nextLevelName;
boolean drawLevel = false;
boolean startLevelFlag = false;

PImage carImage;

ArrayList<Button> buttons;
boolean lastMousePressed = false;

int lastTime; // u milisekundama
float deltaTime; // u sekundama

Display display;
ArrayList<String> allLevelsNames;
int unlockedLevelsIndex;
int numberOfLevels;

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
  display.changeDisplayState(screenState.END);
}

void setup(){
  size(640, 640);
  carImage = loadImage("car.png");
  buttons = new ArrayList<Button>();

  allLevelsNames = new ArrayList<String>();
  allLevelsNames.add("lvl");
  allLevelsNames.add("lvl2");
  unlockedLevelsIndex = 0;
  numberOfLevels = allLevelsNames.size();
  display = new Display();

  setNextLevel(firstLevel);
  startLevel();
  lastTime = millis();
} //<>//

void onClick(int x, int y){
  for (Button button : buttons){
    if (button.validCursor(x, y)){
      button.click();
    }
  }
}

void draw(){
  if (!lastMousePressed && mousePressed)
    onClick(mouseX, mouseY);
  lastMousePressed = mousePressed;

  int curTime = millis();
  deltaTime = float(curTime - lastTime) / 1000.0;
  lastTime = curTime;

  for (Button button : buttons){
    if(button instanceof GameButton)
    {
      GameButton gameButton = (GameButton) button;
      if(gameButton.isActive() == false)
        continue;
    }
    button.draw();
  }
  
  if (startLevelFlag)
    realStartLevel();

  display.showDisplay();

}
