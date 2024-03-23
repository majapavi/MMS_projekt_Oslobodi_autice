// moguca stanja igre
// moguce osim ovih dodati i brojeve levela ako je zgodnije
enum screenState {
  START, PLAY, WIN, LOSS
}

// klasa koja pamti trenutno stanje igre i iscrtava odgovarajuci display
class Display
{
  screenState mode;
  boolean changedState;
  Text gameTitle;
  Text displayMessage;
  StartButton startButton;
  ResetButton resetButton;
  
  Display(){
    changeDisplayState(screenState.START);
  }
  
  void changeDisplayState(screenState newState)
  {
    switch (newState) {
      case START:
        initStartScreen();
        break;
      case WIN:
        initWinScreen();
        break;
      case LOSS:
        initLossScreen();
        break;
      default:
        initPlayScreen();
    }

    //switch (mode) {
    //  case START:
    //    closeStartScreen();
    //    break;
    //  case WIN:
    //    closeWinScreen();
    //    break;
    //  case LOSS:
    //    closeLossScreen();
    //    break;
    //  default:
    //    closePlayScreen();
    //}
    
    mode = newState;
  }
  
  // glavna funkcija koja se poziva iz ostalih dijelova igre
  void showDisplay()
  {
    switch (mode) {
      case START:
        showStartScreen();
        break;
      case WIN:
        showWinScreen();
        break;
      case LOSS:
        showLossScreen();
        break;
      default:
        showPlayScreen();
    }
  }
  
  
  
  // iscrtava pocetni ekran
  void showStartScreen()
  {
    background(255);  
    gameTitle.ispisiText();
    startButton.draw();
  }
  
  // iscrtava pobjednicki ekran
  void showWinScreen()
  {
    background(0);
    gameTitle.ispisiText();
    resetButton.draw();
  }
  
  // iscrtava gubitnicki ekran
  void showLossScreen()
  {
    background(0);
    gameTitle.ispisiText();
    resetButton.draw();
  }
  
  // iscrtava obican ekran s igrom / levelom
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
  





  // iscrtava pocetni ekran
  void initStartScreen()
  {
    gameTitle = new Text( 350, 100, "Oslobodi autice", 50);
    startButton = new StartButton( 100, 100 );
  }
  
  // iscrtava pobjednicki ekran
  void initWinScreen()
  {
    displayMessage = new Text( 350, 100, "Pobijedio si!", 40);
    startButton = new StartButton( 100, 100 );
  }
  
  // iscrtava gubitnicki ekran
  void initLossScreen()
  {
    displayMessage = new Text( 350, 100, "Izgubio si!", 40);
    startButton = new StartButton( 100, 100 );
  }
  
  // iscrtava obican ekran s igrom / levelom
  // prema potrebi ukloniti i iscrtavati u drugom dijelu koda
  void initPlayScreen()
  {
    startLevel();
  }
}
