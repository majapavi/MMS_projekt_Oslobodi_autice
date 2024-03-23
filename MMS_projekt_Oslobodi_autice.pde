String firstLevel = "lvl.tmx";

Level cur;
String nextLevelName;            // current level
boolean drawLevel = false;       // flag za crtanje levela na ekran
boolean startLevelFlag = false;  // aktivan kad se treba ucitati nivo nextLevelName (pokretanje, reset)

Display display;

PImage carImage;
ResetButton reset;

ArrayList<Button> buttons;      // svi gumbi, resetira se skrz kod novog levela
boolean lastMousePressed = false;

int lastTime; // u milisekundama
float deltaTime; // u sekundama

void setNextLevel(String filename){
  nextLevelName = filename;
}

void startLevel(){                          // "svaka susa poziva", na klik, reset/pokretanje
  startLevelFlag = true;
}

void realStartLevel(){                      // interna funkcija, stanje
  if (cur != null){
    buttons.removeAll(cur.getButtons());
  }
  cur = new Level(this, nextLevelName);
  buttons.addAll(cur.getButtons());
  drawLevel = true;
  startLevelFlag = false;
}

void finishLevel(){                        // poziva se kad su svi autici izvan nivoa
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
  display = new Display();
}

void onClick(int x, int y){                  // pomocna funkcija za klikanje misa, da se ne klikne 10000 puta
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

  for (Button button : buttons){
    button.draw();
  }
  if (startLevelFlag){
    realStartLevel();
  }

  display.showDisplay();

}
