// moguca stanja igre
// moguce osim ovih dodati i brojeve levela ako je zgodnije
enum screenState {
  START, PLAY, WIN, LOSS
}

// klasa koja pamti trenutno stanje igre i iscrtava odgovarajuci display
class Display
{
  screenState mode;
  
  Display(){ mode = screenState.START; }
  
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
    background(0);
  
    Text gameTitle = new Text( 350, 100, "Oslobodi autice");
    gameTitle.ispisiText();
    
    StartButton startButton( 100, 100 );
    startButton.draw();
  }
  
  // iscrtava pobjednicki ekran
  void showWinScreen()
  {
    background(0);
  
    Text gameTitle = new Text( 350, 100, "Pobijedio si!");
    gameTitle.ispisiText();
    
    ResetButton resetButton( 100, 100 );
    resetButton.draw();
  }
  
  // iscrtava gubitnicki ekran
  void showLossScreen()
  {
    background(0);
  
    Text gameTitle = new Text( 350, 100, "Izgubio si!");
    gameTitle.ispisiText();
    
    ResetButton resetButton( 100, 100 );
    resetButton.draw();
  }
  
  // iscrtava obican ekran s igrom / levelom
  // prema potrebi ukloniti i iscrtavati u drugom dijelu koda
  void showPlayScreen()
  {
  }
  
}
