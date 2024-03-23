// moguca stanja igre
// moguce osim ovih dodati i brojeve levela ako je zgodnije
enum screenState {
  START, PLAY, END, LEVEL_SELECT
}

// klasa koja pamti trenutno stanje igre i iscrtava odgovarajuci display
class Display
{
  screenState state;
  boolean changedState;
  Text gameTitle;
  Text displayMessage;
  String gameDescription;
  StartButton startButton;
  ResetButton resetButton;
  GoToSelectButton goToSelectButton;
  
  Display() { initStartScreen(); }
  
  void changeDisplayState(screenState newState) //<>//
  {
    switch (state){
      case START:
        closeStartScreen();
        break;
      case END:
        closeEndScreen();
        break;
      case LEVEL_SELECT:
        closeLevelSelectScreen();
        break;
      default:
        closePlayScreen();
    }

    switch (newState) //<>//
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
      default:
        initPlayScreen();
    }
  }
  
  // glavna funkcija koja se poziva iz ostalih dijelova igre
  void showDisplay()
  {
    switch (state)
    {
      case START:
        showStartScreen();
        break;
      case END:
        showEndScreen();
        break;
      case LEVEL_SELECT:
        showLevelSelectScreen();
        break;
      default:
        showPlayScreen();
    }
  }
  
  
  void initStartScreen()
  {
    state = screenState.START;
    gameTitle = new Text( 320, 80, "Oslobodi autiće", 50, color(0, 0, 255));
    startButton = new StartButton( 280, 130 );
    gameDescription = "Dobrodošli u igru Oslobodi autiće!\n"
    +"Vaš današnji cilj je poklikati autiće redom tako da svi izađu iz ekrana i ne sudare se međusobno.\n"
    +"Imate par života. Strelice pokazuju koji je predviđeni smjer kretanja pojedinog autica.\n"
    +"Mozete kliknuti vise autica za redom. Strelice na cesti predstavljaju promjenu smjera kretanja autica.";
    displayMessage = new Text( 320, 220, gameDescription, 15, color(0, 0, 255));
  }
  void showStartScreen()
  {
    background(200);  
    gameTitle.ispisiText();
    displayMessage.ispisiText();
    startButton.draw();
  }
  void closeStartScreen()
  {
    buttons.remove(startButton);
  }

    
  void initEndScreen() //<>//
  {
    state = screenState.END;
    displayMessage = new Text( 350, 100, "Pobijedio si!", 40);
    goToSelectButton = new GoToSelectButton( 100, 100 );
  }
  void showEndScreen() //<>//
  {
    background(255);
    goToSelectButton.draw();
  }    
  void closeEndScreen()
  {
    buttons.remove(goToSelectButton);
  }

  
  // iscrtava obican ekran s igrom / levelom
  // prema potrebi ukloniti i iscrtavati u drugom dijelu koda
  void initPlayScreen()
  {
    state = screenState.PLAY;
    startLevel();
  }
  // prema potrebi ukloniti i iscrtavati u drugom dijelu koda
  void showPlayScreen()
  {
    // update
    if (drawLevel){
      cur.update(deltaTime);
    }
  
    // crtaj
    background(35);
    if (drawLevel){
      cur.draw();
    }
  }
  void closePlayScreen() //<>//
  {}
  
  
  void initLevelSelectScreen() //<>//
  {
    state = screenState.LEVEL_SELECT;
    background(255, 255, 0);
  }
  void showLevelSelectScreen() //<>//
  {}
  void closeLevelSelectScreen()
  {}
  
}
