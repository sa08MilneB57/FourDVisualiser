import peasy.*;
import java.util.HashSet;



int demoNum = 0;
final Demo[] demos = {new ShapeDemo(this), 
                      new FunctionPlotDemo(this),
                      new ArgandPlotDemo(this)};


void keyPressed() {
  if(key == BACKSPACE){
    demoNum = (demoNum+1) % demos.length;
    demos[demoNum].demoSetup();
  } else {
    demos[demoNum].demoKeyPressed(key);
  }
}
void keyReleased() {
  demos[demoNum].demoKeyReleased(key);
  
}

void setup(){
  //size(1920,1048,P3D);
  fullScreen(P3D);
  demos[demoNum].demoSetup();  
}

void draw(){
  demos[demoNum].demoDraw();
}
