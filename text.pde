// klasa za rukovanje tekstom
class Text {
  float x, y;
  int textSize;
  String text;
  color textColor;
  
  Text(float x_, float y_, String text_, int textSize_, color textColor_) {
    x = x_;
    y = y_;
    textSize = textSize_;
    text = text_;
    textColor = textColor_;
  }

  //konstruktor: boja_teksta-crna
  Text(float x_, float y_, String text_, int textSize_) {
    x = x_;
    y = y_;
    textSize = textSize_;
    text = text_;
    textColor = color(0);
  }

  //konstruktor: boja_teksta-crna, velicina_teksta-15
  Text(float x_, float y_, String text_) {
    x = x_;
    y = y_;
    textSize = 15;
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
