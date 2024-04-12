// klasa za rukovanje tekstom
class Text {
  float x, y;
  int textSize;
  String text;

  Text(float x_, float y_, String text_, int textSize_) {
    x = x_;
    y = y_;
    textSize = textSize_;
    text = text_;
  }

  Text(float x_, float y_, String text_) {
    x = x_;
    y = y_;
    textSize = 18;
    text = text_;
  }

  void ispisiText() {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(textSize);
    text(text, x, y);
  }
}
