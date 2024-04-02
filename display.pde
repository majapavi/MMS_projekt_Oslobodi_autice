// Stanja u kojima se igra (display) moze naci //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
enum screenState {
  START, PLAY, END, LEVEL_SELECT
}

// Klasa za pamcenje trenutnog stanje igre i iscrtavanje odgovarajuceg displaya
class Display
{
  screenState state;

  Text gameTitle;
  Text displayMessage;
  String gameDescription;

  StartButton startButton;
  ResetButton resetButton;
  GoToSelectButton goToSelectButton;
  ArrayList<SelectLevelButton> levelSelectButtonsList;

  Display()
  {
    startButton = new StartButton( 280, 130 );
    goToSelectButton = new GoToSelectButton( 280, 180 );
    resetButton = new ResetButton(width - 30, 20);

    levelSelectButtonsList = new ArrayList<SelectLevelButton>();
    for (int i = 0; i < numberOfLevels; i++)
      levelSelectButtonsList.add(new SelectLevelButton(0, 300, allLevelsNames.get(i)));

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
      drawLevel = false;
      break;
    case END:
      showEndScreen();
      drawLevel = false;
      break;
    case LEVEL_SELECT:
      showLevelSelectScreen();
      drawLevel = false;
      break;
    case PLAY:
      showPlayScreen();
      drawLevel = true;
      break;
    }
  }


  void initStartScreen()
  {
    state = screenState.START;

    gameTitle = new Text( 320, 80, "Oslobodi autiće", 50, color(0, 0, 160));
    gameDescription = "Dobrodošli u igru Oslobodi autiće!\n"
      +"Vaš današnji cilj je poklikati autiće redom tako da svi izađu iz ekrana i ne sudare se međusobno.\n"
      +"Imate par života. Strelice pokazuju koji je predviđeni smjer kretanja pojedinog autica.\n"
      +"Mozete kliknuti vise autica za redom. Strelice na cesti predstavljaju promjenu smjera kretanja autica.";
    displayMessage = new Text( 320, 220, gameDescription, 15, color(0, 0, 160));

    startButton.switchButton();
  }
  void showStartScreen()
  {
    background(194);
    gameTitle.ispisiText();
    displayMessage.ispisiText();
    startButton.drawB();
  }
  void closeStartScreen()
  {
    startButton.switchButton();
  }


  void initEndScreen()
  {
    state = screenState.END;
    unlockedLevelsIndex = min(unlockedLevelsIndex + 1, numberOfLevels - 1);

    displayMessage = new Text( 320, 100, "Pobijedio si :)", 40, color(0, 0, 160));

    goToSelectButton.switchButton();
  }
  void showEndScreen()
  {
    background(194);
    goToSelectButton.drawB();
    displayMessage.ispisiText();
  }
  void closeEndScreen()
  {
    goToSelectButton.switchButton();
  }


  void initPlayScreen()
  {
    state = screenState.PLAY;

    startLevel();

    resetButton.switchButton();
  }
  // iscrtava display sa levelom (glavnim dijelom igre)
  void showPlayScreen()
  {
    if (drawLevel)
      cur.update(deltaTime);

    if (drawLevel)
      cur.drawL();

    resetButton.drawB();
  }
  void closePlayScreen()
  {
    resetButton.switchButton();
  }


  void initLevelSelectScreen()
  {
    state = screenState.LEVEL_SELECT;
    for (int i = 0; i <= unlockedLevelsIndex; i++) {
      levelSelectButtonsList.get(i).switchButton();
    }

    background(194);

    // centraliziranje pozicije gumbi za izbor levela
    int buttonWidth = levelSelectButtonsList.get(0).w;
    int totalButtonsWidth = (unlockedLevelsIndex + 1) * (buttonWidth + 50) - 50;
    int x = (width - totalButtonsWidth) / 2;
    for (int i = 0; i <= unlockedLevelsIndex; i++) {
      levelSelectButtonsList.get(i).moveButton(x, levelSelectButtonsList.get(i).y);
      x += buttonWidth + 50;
    }
  }

  void showLevelSelectScreen()
  {
    for (int i = 0; i <= unlockedLevelsIndex; i++)
      levelSelectButtonsList.get(i).drawB();
  }

  void closeLevelSelectScreen() {
    for (int i = 0; i <= unlockedLevelsIndex; i++)
      levelSelectButtonsList.get(i).switchButton();
  }
}
