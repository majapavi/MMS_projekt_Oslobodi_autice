enum Direction {
  UP, RIGHT, DOWN, LEFT
}

interface Button {
  void draw();
  void click();
  boolean validCursor(int x, int y);
}

interface LevelButton extends Button {
  void setLevelRef(int x, int y);
}

interface CarButton extends LevelButton {
  void setCarPos(int x, int y);
  void setCarDirection(Direction dir);
}
