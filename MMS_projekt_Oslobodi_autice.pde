import ptmx.*; // Potrebno instalirati biblioteku Ptmx //<>//
import java.util.ArrayDeque;
import static java.awt.event.KeyEvent.*;

// Globalne varijable
Level currentLevel;                 // trenutni level
String nextLevelName;               // ime datoteke sljedeceg levela za ucitavanje (bez .tmx nastavka)
boolean drawLevel = false;          // zastavica je true ako se level treba crtati na ekran 
boolean startLevelFlag = false;     // zastavica je true ako se level crta ispocetka (prvi puta ili zbog reseta)
//boolean levelRunningFlag = false;
float lives;                        // float jer se sudar registrira kod oba auta pa se smanjuje za 0.5

PImage carImage;

ArrayList<Button> buttons;          // lista svega na sto se moze kliknuti misem (na trenutnom ekranu)
boolean lastMousePressed = false;   // kontrolna varijabla za klikanje misem

int lastTime; // u milisekundama
float deltaTime; // u sekundama

Display display;
ArrayList<String> allLevelsNames;   // svi nazivi levela koji ce se pojaviti u igrici redoslijedom kojim su dodani, bez .tmx
int unlockedLevelsIndex;            // broj levela koje je igrac prosao
int numberOfLevels;                 // broj levela koji postoje u igrici (duljina liste allLevelsNames)
int currentLevelIndex;              // indeks levela koji se trenutno igra

// showcase postavke
boolean TIME_GOES = true;
boolean STOP_TIME_WHEN_LEVEL_STARTS = false;
boolean SLOW_TIME = false;
boolean SKIP_LEVEL = false;
boolean SHOW_EVERYTHING = false;

// Globalna funkcija za validaciju klika misem
void onClick(int x, int y) {
  for (Button button : buttons) {
    if (button.validCursor(x, y)) {
      button.click();
      break;
    }
  }
}

void setup() {
  size(640, 640);
  carImage = loadImage("car.png");
  buttons = new ArrayList<Button>();

  allLevelsNames = new ArrayList<String>();
  allLevelsNames.add("Tutorial1");
  allLevelsNames.add("Tutorial2");
  allLevelsNames.add("Tutorial3");
  allLevelsNames.add("Tutorial4");
  allLevelsNames.add("Tutorial5");
  allLevelsNames.add("Tutorial6");
  allLevelsNames.add("lvl");
  allLevelsNames.add("lvl2");
  allLevelsNames.add("lvl2alt");
  allLevelsNames.add("kruzni_tok");
  allLevelsNames.add("divide");
  allLevelsNames.add("kapaljka");
  allLevelsNames.add("brza_kapaljka");
  allLevelsNames.add("the_grid");
  allLevelsNames.add("q_navigation");
  allLevelsNames.add("q_navigation2");
  allLevelsNames.add("s_like");
  allLevelsNames.add("city");
  unlockedLevelsIndex = 0;
  currentLevelIndex = 0;
  numberOfLevels = allLevelsNames.size();
  display = new Display();

  nextLevelName = allLevelsNames.get(0) + ".tmx";
  startLevelFlag = true;
  lives = 3;
  lastTime = millis();
}

void draw() {
  if (!lastMousePressed && mousePressed) {  // da ne registrira klik vise puta
    onClick(mouseX, mouseY);
    TIME_GOES = true;
  }
  lastMousePressed = mousePressed;

  int curTime = millis();
  deltaTime = float(curTime - lastTime) / 1000.0;
  if (SLOW_TIME) deltaTime /= 3.0;
  lastTime = curTime;

  // Prikazi ekran
  display.showDisplay();

  // Nacrtaj sve gumbe koji se mogu kliknuti u trenutnom ekranu
  for (Button button : buttons) {

    if (button instanceof NavigationButton)
    ; //<>//
    else
      button.render();
  }

  if (startLevelFlag) {
    startLevel();
  }
}

void keyPressed(){
  if (keyCode == java.awt.event.KeyEvent.VK_F1){
    DEBUG_COLLISION = !DEBUG_COLLISION;
  }
  if (keyCode == java.awt.event.KeyEvent.VK_F2){
    SHOW_EVERYTHING = !SHOW_EVERYTHING;
  }
  if (keyCode == java.awt.event.KeyEvent.VK_F3){
    unlockedLevelsIndex = numberOfLevels - 1;
  }
  if (keyCode == java.awt.event.KeyEvent.VK_F4){
    STOP_TIME_WHEN_LEVEL_STARTS = !STOP_TIME_WHEN_LEVEL_STARTS;
  }
  if (keyCode == java.awt.event.KeyEvent.VK_F5){
    TIME_GOES = !TIME_GOES;
  }
  if (keyCode == java.awt.event.KeyEvent.VK_F6){
    SLOW_TIME = !SLOW_TIME;
  }
  if (keyCode == java.awt.event.KeyEvent.VK_F7){
    SKIP_LEVEL = true;
  }
  if (keyCode == java.awt.event.KeyEvent.VK_F8){
    lives += 1.0;
  }
}
