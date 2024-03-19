class Pjesak implements Collideable{
  int x,y,w,h;
  PImage pjesakImage;
  Direction dir;
  float path=0;
  int speed=1;
  
  Pjesak(StringDict attrib){
   x = int(attrib.get("x"))+10;
   y = int(attrib.get("y"))+4;
   w=20;
   h=25;
   pjesakImage = loadImage("pjesak.png");
   dir = getDirection(attrib.get("direction"));
  }
  
  void draw(){
    image(pjesakImage,x,y,w-5,h);
    if(path<1){
      path+=0.01;
      if(path>=0){
        if(dir==Direction.LEFT){
          x-=speed;
        }
        if(dir==Direction.RIGHT){
          x+=speed;
        }
        if(dir==Direction.UP){
          y-=speed;
        }
        if(dir==Direction.DOWN){
          y+=speed;
        }
      }
    }
    if(path>=1){
     path=-1;
     dir=oppositeDirection(dir);
    }
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
