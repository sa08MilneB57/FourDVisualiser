abstract class Demo {
  PApplet parent;
  PeasyCam cam;
  ListMenu menu;
  final float degrees = PI/180f;
  final color amber = color(200, 150, 0,125);
  final color green = color(0, 50, 0);

  final float boundaryRadius = 1000;//radius of sphere containing hologram (Size of 3D world)
  final float boundaryBuffer = 10;
  final float guideStrokeWeight = 0.2;
  
  String projName;//name of the projection
  int projection = -1;//-1 is perspective, 0-3 are orthographic
  float focalLength = boundaryRadius/10f;//4D Focal Length
  
  int XY, XZ, YZ, XW, YW, ZW;//keeps track of the planes of rotation the user is controlling with the keyboard. 1 for positive rotation, -1 for negative.
  FourMatrix rotorXY, rotorXZ, rotorYZ, rotorXW, rotorYW, rotorZW; //These matrices remain constant through the simulation and are shorthand for rotation matrices.
  FourMatrix negrotorXY, negrotorXZ, negrotorYZ, negrotorXW, negrotorYW, negrotorZW;;
  
  String hudLine1; 
  
  boolean showMenu = false;
  boolean showGuides = true;
  boolean camRotate = false; //whether we rotate the 4D camera or the object itself
  boolean recording = false;
  
  Demo(PApplet _parent){
    parent = _parent;
  }
  
  abstract void demoSetup();
  abstract void demoDraw();
  abstract void demoKeyPressed(char key);
  abstract void demoKeyReleased(char key);
  abstract void menuAction(int i);
  
  void drawSetting(){
    strokeWeight(guideStrokeWeight);
    noFill();
    stroke(green);
    sphere(boundaryRadius+boundaryBuffer);
    if(showGuides){drawGuides();}
    fill(amber);
    noStroke();
    sphere(0.1);
  }
  
  void rigLights(){
    lightFalloff(1, 0, 0);
    lightSpecular(128, 128, 128);
    ambientLight(128, 128, 128);
    directionalLight(128,128,128, cos(frameCount/60f) - 1, sin(10000 + frameCount/50f), cos(50000 + frameCount/70f));
  }
  
  void drawGuides(){
    //draws XYZ guides for orientation
    stroke(255,0,0);
    line(-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer,0,0);
    stroke(0,255,0);
    line(0,-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer,0);
    stroke(0,0,255);
    line(0,0,-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer);
  }
  
  void drawHUD(){
    cam.beginHUD();
    fill(255);
    stroke(255);
    textAlign(LEFT);
    text(hudLine1,10,20,0);
    
    String rotationString = "";
    if(XY !=0){rotationString += "XY ";}
    if(XZ !=0){rotationString += "XZ ";}
    if(YZ !=0){rotationString += "YZ ";}
    if(XW !=0){rotationString += "XW ";}
    if(YW !=0){rotationString += "YW ";}
    if(ZW !=0){rotationString += "ZW ";}
    textAlign(RIGHT);
    text(projName + 
      "\nGlobal Rotation:" + camRotate +
      "\n Active Rotations: " + rotationString,width-10,20,0);
      
    if(recording){noStroke();fill(255,0,0);circle(width-20,20,20);}
    
    if (showMenu) {
      if (menu.show()) {//if an item is selected
        showMenu = false;
      }
    }
    
    cam.endHUD();
  }
  
  void initialiseCamera(){
    cam = new PeasyCam(parent, 0.5*boundaryRadius);
    cam.setMinimumDistance(10);
    cam.setMaximumDistance(boundaryRadius);
    perspective(PI/3.0, width/height, 0.1, 2*boundaryRadius);
  }
  
  void updateProjString(){
    //updates the name of the projection displayed on the HUD
    switch(projection){
      case 0:
        projName = "Orthogonal:(w,y,z)";
        break;
      case 1:
        projName = "Orthogonal:(x,w,z)";
        break;
      case 2:
        projName = "Orthogonal:(x,y,w)";
        break;
      case 3:
        projName = "Orthogonal:(x,y,z)";
        break;
      case -1:
        projName = "Perspective (" + Float.toString(focalLength) +"/w)";
        break;
      default:
        projName = "ProjNameError";
    }
  }
  void initialiseRotors(){
    rotorXY = rotate4(0.5*degrees, 0, 1);
    rotorXZ = rotate4(0.5*degrees, 0, 2);
    rotorYZ = rotate4(0.5*degrees, 1, 2);
    rotorXW = rotate4(0.5*degrees, 0, 3);
    rotorYW = rotate4(0.5*degrees, 1, 3);
    rotorZW = rotate4(0.5*degrees, 2, 3);
  
    negrotorXY = rotate4(-0.5*degrees, 0, 1);
    negrotorXZ = rotate4(-0.5*degrees, 0, 2);
    negrotorYZ = rotate4(-0.5*degrees, 1, 2);
    negrotorXW = rotate4(-0.5*degrees, 0, 3);
    negrotorYW = rotate4(-0.5*degrees, 1, 3);
    negrotorZW = rotate4(-0.5*degrees, 2, 3);
  }
}
