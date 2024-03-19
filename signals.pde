class TurnSign implements Collideable {
  int x, y, w, h;
  Level level;
  Direction orient;
  Turn turns[];
  int index;
  int len;
  TurnButton button;
  TurnSign(Level level, StringDict attrib){
    this.level = level;
    x = int(attrib.get("x")) + 2;
    y = int(attrib.get("y")) + 2;
    w = int(attrib.get("width")) - 4;
    h = int(attrib.get("height")) - 4;
    orient = getDirection(attrib.get("orientation"));
    
    String tmp = attrib.get("turn");
    len = tmp.length();
    turns = new Turn[len];
    for (int i = 0;i < len;i++){
      turns[i] = getTurn("" + tmp.charAt(i));
    }
    char indexLetter = attrib.get("default").charAt(0);
    index = tmp.indexOf(indexLetter);
    button = new TurnButton(this, x, y, w, h, orient, turns[index]);
  }

  void change(){
    index++;
    index %= len;
    button.setTurn(turns[index]);
  }

  TurnButton getButton(){
    return button;
  }

  Turn getNew(){
    return turns[index];
  }

  int getX(){
    return x;
  }

  int getY(){
    return y;
  }

  int getW(){
    return w;
  }

  int getH(){
    return h;
  }

  boolean canCollide(){
    return true;
  }
}
