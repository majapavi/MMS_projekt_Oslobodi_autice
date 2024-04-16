// Stanja u kojima se igra (display) moze naci //<>//
enum screenState {
  START, PLAY, END, LEVEL_SELECT
}

// Klasa za pamcenje trenutnog stanja igre i iscrtavanje odgovarajuceg displaya
class Display
{
  screenState state;

  Text gameTitle;
  Text displayMessage;
  String gameDescription;

  StartButton startButton;            // gumb za pokretanje igre
  ResetButton resetButton;            // gumb za resetiranje levela
  GoToSelectButton goToSelectButton;  // gumb za prijelaz u ekran za biranje levela
  
  // lista gumbi otkljucanih levela
  ArrayList<SelectLevelButton> levelSelectButtonsList;

  Display()
  {
    // Inicijalizacija gumbi
    startButton = new StartButton( width/2 - defaultTextButtonW/2, 400 );
    resetButton = new ResetButton( width - defaultTextButtonW - 10, 10 );
    goToSelectButton = new GoToSelectButton(width - defaultTextButtonW - 10, defaultTextButtonH + 20 );

    levelSelectButtonsList = new ArrayList<SelectLevelButton>();
    for (int i = 0; i < numberOfLevels; i++)
      levelSelectButtonsList.add(new SelectLevelButton(0, 300, allLevelsNames.get(i), i));

    initStartScreen();
  }

  // funkcija za promjenu stanja koja se poziva iz ostalih dijelova igre
  void changeDisplayState(screenState newState)
  {
    // "destrukturiraj" staro stanje
    switch (state)
    {
    case START:
      closeStartScreen();
      break;
    case END:
      closeEndScreen();
      break;
    case LEVEL_SELECT:
      closeLevelSelectScreen();
      break;
    case PLAY:
      closePlayScreen();
      break;
    }

    // inicijaliziraj novo stanje
    switch (newState)
    {
    case START:
      initStartScreen();
      break;
    case END:
      initEndScreen();
      break;
    case LEVEL_SELECT:
      initLevelSelectScreen();
      break;
    case PLAY:
      initPlayScreen();
      break;
    }
  }

  // funkcija za iscrtavaje koja se poziva iz ostalih dijelova igre
  void showDisplay()
  {
    switch (state)
    {
    case START:
      showStartScreen();
      //drawLevel = false;
      break;
    case END:
      showEndScreen();
      //drawLevel = false;
      break;
    case LEVEL_SELECT:
      showLevelSelectScreen();
      drawLevel = false;
      break;
    case PLAY:
      showPlayScreen();
      //drawLevel = true;
      break;
    }
  }

  // Inicijalizacija pocetnog ekrana
  void initStartScreen()
  {
    state = screenState.START;

    gameTitle = new Text( 320, 80, "Oslobodi autiće", 50);
    gameDescription = "Dobrodošli u igru Oslobodi autiće!\n\n"
      +"Vaš današnji cilj je poklikati autiće redom tako da svi izađu iz ekrana\n"
      +"i ne sudare se međusobno. Imate 3 života. Možete kliknuti više autića za redom.\n"
      +"Strelice pokazuju koji je predviđeni smjer kretanja pojedinog autića.\n"
      +"Strelice na cesti predstavljaju promjenu smjera kretanja autića.";
    displayMessage = new Text( 320, 220, gameDescription);

    startButton.switchButton();  // aktiviraj startButton
  }
  
  // Prikazi pocetni ekran
  void showStartScreen()
  {
    background(194);
    gameTitle.ispisiText();
    displayMessage.ispisiText();
    //startButton.render();
  }
  
  // Zatvori pocetni ekran
  void closeStartScreen()
  {
    startButton.switchButton();  // deaktiviraj gumb
  }

  // Inicijalizacija pobjednickog ekrana (nakon uspjesno zavrsenog levela)
  void initEndScreen()
  {
    state = screenState.END;
    
    // Otkljucaj sljedeci level
    if(currentLevelIndex == unlockedLevelsIndex && currentLevelIndex < numberOfLevels - 1)
      unlockedLevelsIndex = currentLevelIndex + 1;

    displayMessage = new Text( 320, 100, "Bravo!\nUspješno si prešao level "+str(currentLevelIndex + 1), 40);

    // Pomakni i aktiviraj gumb za odabir levela
    goToSelectButton.moveButton(width/2 - defaultTextButtonW/2, 200);
    goToSelectButton.switchButton();
  }
  
  // Prikazi pobjednicki ekran
  void showEndScreen()
  {
    background(194);
    //goToSelectButton.render();
    displayMessage.ispisiText();
  }
  
  // Zatvori pobjednicki ekran
  void closeEndScreen()
  {
    goToSelectButton.switchButton();
  }

  // Inicijalizacija ekrana za igru
  void initPlayScreen()
  {
    state = screenState.PLAY;

    startLevelFlag = true;
    lives = 3;

    resetButton.switchButton();
    goToSelectButton.moveButton(width - defaultTextButtonW - 10, defaultTextButtonH + 20);
    goToSelectButton.switchButton();    
  }
  
  // iscrtava display sa levelom (glavnim dijelom igre)
  void showPlayScreen()
  {
    if (drawLevel) {
      currentLevel.update(deltaTime);
      currentLevel.render();
    }

    resetButton.render();
    goToSelectButton.render();
  }
  
  // Zatvori ekran za igru
  void closePlayScreen()
  {
    resetButton.switchButton();
    goToSelectButton.switchButton();
  }

  // Inicijalizacija ekrana za odabir levela
  void initLevelSelectScreen()
  {
    state = screenState.LEVEL_SELECT;
    for (int i = 0; i <= unlockedLevelsIndex; i++) {
      levelSelectButtonsList.get(i).switchButton();
    }

    background(194);

    // Centraliziranje pozicije gumbi za izbor levela
    int spacing = 50;
    // Broj stupaca ograničen na 4 ili manje ako je manje otključanih razina
    int columns = min(3, unlockedLevelsIndex + 1); 
    int totalButtonsWidth = columns * defaultTextButtonW + (columns - 1) * spacing;
    int x = (width - totalButtonsWidth) / 2;
    int y = 50;
    
    for (int i = 0; i <= unlockedLevelsIndex; i++) {
      levelSelectButtonsList.get(i).moveButton(x, y);
      x += defaultTextButtonW + spacing;
      if ((i + 1) % columns == 0) {
        x = (width - totalButtonsWidth) / 2;
        y += defaultTextButtonH + spacing;
      }
    }
  }

  // Prikazi ekran za odabir levela
  void showLevelSelectScreen()
  {
    for (int i = 0; i <= unlockedLevelsIndex; i++)
      levelSelectButtonsList.get(i).render();
  }

  // Zatvori ekran za odabir levela
  void closeLevelSelectScreen() {
    for (int i = 0; i <= unlockedLevelsIndex; i++)
      levelSelectButtonsList.get(i).switchButton();
  }
}
