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
    if (index == -1) index = 0;
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

interface TurnLogic {
  Turn read();
  void next();
  void write(Turn t);
}

class ForwardTurn implements TurnLogic {
  Turn current;
  ForwardTurn(Turn t){
    current = t;
  }
  
  Turn read(){
    return current;
  }

  void next(){
    current = Turn.FORWARD;
  }

  void write(Turn t){
    current = t;
  }
}

class VariableTurn implements TurnLogic {
  // super koraljka :)
  Turn current;
  VariableTurn(Turn t){
    current = t;
  }
  
  Turn read(){
    return current;
  }

  void next(){
  }

  void write(Turn t){
    current = t;
  }
}

class StackTurn implements TurnLogic {
  ArrayDeque<Turn> stack;
  StackTurn(Turn t){
    stack = new ArrayDeque<Turn>();
  }

  Turn read(){
    if (stack.isEmpty()) return Turn.FORWARD;
    return stack.peek();
  }

  void next(){
    if (!stack.isEmpty()) stack.pop();
  }

  void write(Turn t){
    stack.push(t);
  }
}

class QueueTurn implements TurnLogic {
  ArrayDeque<Turn> queue;
  QueueTurn(Turn t){
    queue = new ArrayDeque<Turn>();
  }

  Turn read(){
    if (queue.isEmpty()) return Turn.FORWARD;
    return queue.peekFirst();
  }

  void next(){
    if (!queue.isEmpty()) queue.removeFirst();
  }

  void write(Turn t){
    queue.add(t);
  }
}
