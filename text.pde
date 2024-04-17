// Klasa za rukovanje tekstom
class Text {
  float x, y;    // pozicija teksta
  int textSize;  // velicina teksta
  String text;   // sadrzaj

  // Konstruktor
  Text(float x_, float y_, String text_) {
    x = x_;
    y = y_;
    textSize = 18;
    text = text_;
  }
  
  // Konstruktor s varijabilnim fontom
  Text(float x_, float y_, String text_, int textSize_) {
    x = x_;
    y = y_;
    textSize = textSize_;
    text = text_;
  }

  // Prikazi tekst na ekranu
  void ispisiText() {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(textSize);
    text(text, x, y);
  }
}
