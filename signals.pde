// Sucelje Collideable je u datoteci car.pde

// Klasa za strelice na cesti
class TurnSign implements Collideable {
  int x, y, w, h;
  Level level;
  Direction orient;
  Turn turns[];      // polje koje cuva sva moguca skretanja
  int index;         // indeks trenutno odabranog skretanja
  int len;           // duljina polja turns
  TurnButton button; // gumb za promjenu smjera strelice
  
  // Konstruktor
  TurnSign(Level level, StringDict attrib){
    // Inicijalizacija varijabli
    this.level = level;
    x = int(attrib.get("x")) + 2;
    y = int(attrib.get("y")) + 2;
    w = int(attrib.get("width")) - 4;
    h = int(attrib.get("height")) - 4;
    orient = getDirection(attrib.get("orientation"));
    
    // Inicijalizacija polja sa skretanjima
    String tmp = attrib.get("turn");
    len = tmp.length();
    turns = new Turn[len];
    for (int i = 0;i < len;i++){
      turns[i] = getTurn("" + tmp.charAt(i));
    }
    
    // Postavi index
    char indexLetter = attrib.get("default").charAt(0);
    index = tmp.indexOf(indexLetter);
    if (index == -1) index = 0;
    
    button = new TurnButton(this, x, y, w, h, orient, turns[index]);
  }

  // Promijeni smjer strelice
  void change(){
    index++;
    index %= len;
    button.setTurn(turns[index]);
  }

  // Vrati gumb strelice na cesti
  TurnButton getButton(){
    return button;
  }

  // Vrati sljedeci smjer strelice
  Turn getNew(){
    return turns[index];
  }

  // Geteri
  // ------
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
  // ------

  // Vraca true jer se uvijek moze autic "sudariti" sa strelicom na cesti
  boolean canCollide(){
    return true;
  }
}

// Sucelje za logiku iza skretanja
interface TurnLogic {
  Turn read();
  void next();
  void write(Turn t);
  void writeHead(Turn t);
  Iterable<Turn> getTail();
}

// Odigrati s_like.tmx za demonstraciju logika

class ForwardTurn implements TurnLogic {
  Turn current;           // trenutni smjer u kojem se autic krece
  ArrayList<Turn> empty;  // prazna lista skretanja
  
  ForwardTurn(Turn t){
    current = t;
    empty = new ArrayList<Turn>();
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

  void writeHead(Turn t){
    current = t;
  }

  ArrayList<Turn> getTail(){
    return empty;
  }
}


class VariableTurn implements TurnLogic {
  // super koraljka :)
  Turn current;            // trenutni smjer u kojem se autic krece
  ArrayList<Turn> empty;   // prazna lista skretanja
  
  VariableTurn(Turn t){
    current = t;
    empty = new ArrayList<Turn>();
  }
  
  Turn read(){
    return current;
  }

  void next(){
  }

  void write(Turn t){
    current = t;
  }

  void writeHead(Turn t){
    current = t;
  }

  ArrayList<Turn> getTail(){
    return empty;
  }
}


class StackTurn implements TurnLogic {
  ArrayDeque<Turn> stack;
  boolean wasEmpty = false;
  StackTurn(){
    stack = new ArrayDeque<Turn>();
  }

  Turn read(){
    if (stack.isEmpty()) return Turn.FORWARD;
    return stack.peekFirst();
  }

  void next(){
    if (!stack.isEmpty()) stack.removeFirst();
  }

  void write(Turn t){
    stack.addFirst(t);
  }
  
  void writeHead(Turn t){
    if (wasEmpty) wasEmpty = false;
    else stack.addFirst(t);
  }

  ArrayDeque<Turn> getTail(){
    if (stack.isEmpty()){
      wasEmpty = true;
      return stack;
    }
    next();
    return stack;
  }
}


class QueueTurn implements TurnLogic {
  ArrayDeque<Turn> queue;
  boolean wasEmpty = false;
  
  QueueTurn(){
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

  void writeHead(Turn t){
    if (wasEmpty) wasEmpty = false;
    else queue.addFirst(t);
  }

  ArrayDeque<Turn> getTail(){
    if (queue.isEmpty()){
      wasEmpty = true;
      return queue;
    }
    next();
    return queue;
  }
}
