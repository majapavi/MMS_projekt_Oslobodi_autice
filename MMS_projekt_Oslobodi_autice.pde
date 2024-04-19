import ptmx.*; // Potrebno instalirati biblioteku Ptmx //<>//
import java.util.ArrayDeque;

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

// Globalna funkcija za validaciju klika misem
void onClick(int x, int y) {
  for (Button button : buttons) {
    if (button.validCursor(x, y)) {
      button.click();
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
  allLevelsNames.add("lvl");
  allLevelsNames.add("lvl2");
  allLevelsNames.add("lvl2alt");
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
  }
  lastMousePressed = mousePressed;

  int curTime = millis();
  deltaTime = float(curTime - lastTime) / 1000.0;
  lastTime = curTime;

  // Prikazi ekran
  display.showDisplay();

  // Nacrtaj sve gumbe koji se mogu kliknuti u trenutnom ekranu
  for (Button button : buttons) {

    // Ne crtaj slikicu koja oznacava vrstu gumba autica
    if (button instanceof VisibleCarButton) {
      continue;
    }
    if (button instanceof NavigationButton)
    ; //<>//
    else
      button.render();
  }

  if (startLevelFlag) {
    startLevel();
  }
}
