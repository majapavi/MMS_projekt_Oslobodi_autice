// klasa za rukovanje tekstom
class Text {
  float x, y;
  int textSize;
  String text;
  color textColor;
  
  Text(float x_, float y_, int textSize_, String text_, color textColor_) {    // predaje se pozicija centra teksta
    x = x_;
    y = y_;
    textSize = textSize_;
    text = text_;
    textColor = textColor_;
  }

  //defaultna crna boja i velicina teksta 30
  Text(float x_, float y_, String text_) {    // predaje se pozicija centra teksta
    x = x_;
    y = y_;
    textSize = 30;
    text = text_;
    textColor = color(0);
  }

  void ispisiText() {
    fill(textColor);
    textAlign(CENTER, CENTER);
    textSize(textSize);
    text(text, x, y);
  }
}
