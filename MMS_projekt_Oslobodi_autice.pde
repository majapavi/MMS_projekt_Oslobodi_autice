import ptmx.*; //<>// //<>//
import java.util.ArrayDeque;

// Globalne varijable
String firstLevel;

Level cur;
String nextLevelName;
boolean drawLevel = false;
boolean startLevelFlag = false;
boolean levelRunningFlag = false;
float lives = 3;  // float jer se sudar registrira kod oba auta pa se smanjuje za 0.5

PImage carImage;

ArrayList<Button> buttons;
boolean lastMousePressed = false;

int lastTime; // u milisekundama
float deltaTime; // u sekundama

Display display;
ArrayList<String> allLevelsNames;
int unlockedLevelsIndex;
int numberOfLevels;
int  currentLevel;

void setup() {
  size(640, 640);
  carImage = loadImage("car.png");
  buttons = new ArrayList<Button>();

  allLevelsNames = new ArrayList<String>();
  allLevelsNames.add("Tutorial1");
  allLevelsNames.add("lvl");
  allLevelsNames.add("lvl2");
  allLevelsNames.add("lvl2alt");
  unlockedLevelsIndex = 0;
  currentLevel = 0;
  numberOfLevels = allLevelsNames.size();
  display = new Display();

  firstLevel = allLevelsNames.get(0) + ".tmx";
  setNextLevel(firstLevel);
  startLevel();
  lastTime = millis();
}

void draw() {
  if (!lastMousePressed && mousePressed) {  // da ne registrira klik vise puta
    onClick(mouseX, mouseY);
    levelRunningFlag = true;
  }
  lastMousePressed = mousePressed;

  int curTime = millis();
  deltaTime = float(curTime - lastTime) / 1000.0;
  lastTime = curTime;

  display.showDisplay();

  for (Button button : buttons) {
    if (button instanceof NavigationButton) {
      NavigationButton navigationButton = (NavigationButton) button;
      if (navigationButton.isActive() == false)
        continue;
    }
    button.drawB();
  }

  if (startLevelFlag) {
    realStartLevel();
  }
}
