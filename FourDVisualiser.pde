import peasy.*;
import java.util.HashSet;

interface Demo {
  void demoSetup();
  void demoDraw();
  void demoKeyPressed(char key);
  void demoKeyReleased(char key);
}

final Demo demo = new ShapeDemo(this);

void keyPressed() {
  demo.demoKeyPressed(key);
}
void keyReleased() {
  demo.demoKeyReleased(key);
  
}

void setup(){
  //size(1920,1048,P3D);
  fullScreen(P3D);
  demo.demoSetup();  
}

void draw(){
  demo.demoDraw();
}
