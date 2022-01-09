import peasy.*;
import java.util.HashSet;
PeasyCam cam;

final float degrees = PI/180f;

final int DEMONSTRATION = 1;
final float boundaryRadius = 1000;
final float boundaryBuffer = 10;
final float shapeStrokeWeight = 0.4;
final float guideStrokeWeight = 0.2;
final color amber = color(200, 150, 0,125);
final color green = color(0, 50, 0);

String projName;
int projection = -1;
float focalLength = boundaryRadius/10f;

int XY, XZ, YZ, XW, YW, ZW;
FourMatrix rotorXY, rotorXZ, rotorYZ, rotorXW, rotorYW, rotorZW;
FourMatrix negrotorXY, negrotorXZ, negrotorYZ, negrotorXW, negrotorYW, negrotorZW;;

final int numOfPoints = 150;
final float maxDistance = 100;
final float drifterRadius = 2;
float sigR = 1;
float sigLon =0;
float sigLat =60*degrees;
float sigLet =1;
float dt = 0.01;
final FourVector pointOrigin = new FourVector(0,0,0,maxDistance+2*drifterRadius);
FourVector pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
FourMatrix pauliRotor = pauli(pauliVector);
FourPoint[] drifters; 

FourShape shape;
String hudLine1;

boolean camRotate = false;
boolean drawLines = true;
boolean drawFaces = true;
boolean recording = false;
boolean showGuides = true;

interface Demo {
  void demoSetup();
  void demoDraw();
}

void setupPlatonics() {
  setShape(1);
}

void setupDrifters(){
   drifters = new FourPoint[numOfPoints];
   FourVector zero = new FourVector(0,0,0,0);
   for (int i=0;i<numOfPoints;i++){
     drifters[i] = new FourPoint(zero,pointOrigin,drifterRadius,HSL(TAU*i/numOfPoints,1,0.5));
     drifters[i].refresh(maxDistance);
   }
}

void drawPlatonics() {
  strokeWeight(shapeStrokeWeight);
  if (projection==-1) {
    shape.persp(focalLength, drawLines, drawFaces);
  } else {
    shape.ortho(projection, drawLines, drawFaces);
  }
  if (XY == -1) {
    shape.applyMatrix(negrotorXY, camRotate);
  }
  if (XY == 1) {
    shape.applyMatrix(rotorXY, camRotate);
  }
  if (XZ == -1) {
    shape.applyMatrix(negrotorXZ, camRotate);
  }
  if (XZ == 1) {
    shape.applyMatrix(rotorXZ, camRotate);
  }
  if (YZ == -1) {
    shape.applyMatrix(negrotorYZ, camRotate);
  }
  if (YZ == 1) {
    shape.applyMatrix(rotorYZ, camRotate);
  }
  if (XW == -1) {
    shape.applyMatrix(negrotorXW, camRotate);
  }
  if (XW == 1) {
    shape.applyMatrix(rotorXW, camRotate);
  }
  if (YW == -1) {
    shape.applyMatrix(negrotorYW, camRotate);
  }
  if (YW == 1) {
    shape.applyMatrix(rotorYW, camRotate);
  }
  if (ZW == -1) {
    shape.applyMatrix(negrotorZW, camRotate);
  }
  if (ZW == 1) {
    shape.applyMatrix(rotorZW, camRotate);
  }
  
}

void drawDrifters(){
  hudLine1 = "sx=" + Float.toString(pauliVector.x) +" sy=" + Float.toString(pauliVector.y) +" sz=" + Float.toString(pauliVector.z) +" sw=" + Float.toString(pauliVector.w)
              + "\nDeterminant:" + Float.toString(pauliDeterminant(pauliVector))
              + "\nLon:" + Float.toString(sigLon/degrees) + "° Lat:" + Float.toString(sigLat/degrees) + "° Let:" + Float.toString(sigLet) + " R:" + Float.toString(sigR);
  strokeWeight(shapeStrokeWeight);
  for (FourPoint drifter : drifters){
    if (projection==-1) {
        drifter.persp(focalLength);
    } else {
        drifter.ortho(projection);
    }
    drifter.stepTime(pauliRotor,dt,maxDistance);
  }
}

void setShape(int i){
  switch(i){
    case 1:
      shape = hypersphere(new FourVector(0, 0, 0, 105), 100, 32, 16, 16);
      hudLine1 = "Hypersphere";
      break;
    case 2:
      shape = tesseract(new FourVector(0, 0, 0, 50), 50);
      hudLine1 = "Tesseract";
      break;
    case 3:
      shape = pentachoron(new FourVector(0, 0, 0, 51), 49);
      hudLine1 = "Pentachoron (5-cell)";
      break;
    case 4:
      shape = orthoplex(new FourVector(0, 0, 0, 50), 50,amber);
      hudLine1 = "Orthoplex (16-cell)";
      break;
    case 5:
      shape = octaplex(new FourVector(0, 0, 0, 51), 50,amber);
      hudLine1 = "Octaplex (24-cell)";
      break;
    case 6:
      shape = spherinder(new FourVector(0, 0, 0, 105), 80, 80, 32, 16, 16);
      hudLine1 = "Spherinder";
      break;
    case 7:
      shape = sphericone(new FourVector(0, 0, 0, 105), 80, 80, 32, 16, 16);
      hudLine1 = "Sphericone";
      break;
    case 8:
      shape = cliffordtorus(new FourVector(0, 0, 0, 51), 50/sqrt(2), 48);
      hudLine1 = "Clifford Torus";
      break;
    case 9:
      shape = kleinbottle(new FourVector(0, 0, 0, 60), 30, 25, 32, 32);
      hudLine1 = "Klein Bottle (Pinched Torus Embedding)";
      break;
    case 0:
      shape = kleinbottleFIG8(new FourVector(0, 0, 0, 70), 30, 5, 10f, 24, 24);
      hudLine1 = "Klein Bottle (Figure-8 Embedding)";
      break;
    default:
      setShape(2);
  }
}

void updateProjString(){
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

void drawGuides(){
  stroke(255,0,0);
  line(-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer,0,0);
  stroke(0,255,0);
  line(0,-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer,0);
  stroke(0,0,255);
  line(0,0,-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer);
}

void keyPressed() {
  if (key=='o') {
    projection = (projection+1)%4;
    updateProjString();
  } else if (key=='p') {
    projection = -1;
    updateProjString();
  } else if (key=='-') {
    focalLength = max(focalLength/1.418,0);
    updateProjString();
  } else if (key=='=') {
    focalLength *= 1.418;
    updateProjString();
  } else if (key=='v') {
    recording = !recording;
  } else if (key=='x') {
    showGuides = !showGuides;
  }
  if (DEMONSTRATION == 0){
    if (Character.isDigit(key)){
      setShape(key - '0');
    } else if (key=='#'){
      camRotate=!camRotate;
    } else if (key=='[') {
      drawLines = !drawLines;
    } else if (key==']') {
      drawFaces = !drawFaces;
    } else if (key=='q') {
      XY = -1;
    } else if (key=='w') {
      YZ = 1;
    } else if (key=='e') {
      XY = 1;
    } else if (key=='a') {
      XZ = -1;
    } else if (key=='s') {
      YZ = -1;
    } else if (key=='d') {
      XZ = 1;
    } else if (key=='r') {
      ZW = -1;
    } else if (key=='t') {
      YW = 1;
    } else if (key=='y') {
      ZW = 1;
    } else if (key=='f') {
      XW = -1;
    } else if (key=='g') {
      YW = -1;
    } else if (key=='h') {
      XW = 1;
    }
  } else if (DEMONSTRATION == 1){
    if (Character.isDigit(key)){
      setShape(key - '0');
    } else if (key=='#'){
      camRotate=!camRotate;
    } else if (key=='[') {
      drawLines = !drawLines;
    } else if (key==']') {
      drawFaces = !drawFaces;
    } else if (key=='q') {
      sigLon += 15*degrees;
      pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
      pauliRotor = pauli(pauliVector);
    } else if (key=='w') {
      sigLat += 15*degrees;
      pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
      pauliRotor = pauli(pauliVector);
    } else if (key=='e') {
      sigLet += 0.1;
      pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
      pauliRotor = pauli(pauliVector);
    } else if (key=='a') {
      sigLon -= 15*degrees;
      pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
      pauliRotor = pauli(pauliVector);
    } else if (key=='s') {
      sigLat -= 15*degrees;
      pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
      pauliRotor = pauli(pauliVector);
    } else if (key=='d') {
      sigLet -= 0.1;
      pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
      pauliRotor = pauli(pauliVector);
    } else if (key=='r') {
      sigR += 0.1;
      pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
      pauliRotor = pauli(pauliVector);
    } else if (key=='f') {
      sigR -= 0.1;
      pauliVector = lorentzCoordinates(sigLon,sigLat,sigLet,sigR);
      pauliRotor = pauli(pauliVector);
    }
  }
}
void keyReleased() {
  if (DEMONSTRATION == 0){
    if (key=='q') {
      XY = 0;
    } else if (key=='w') {
      YZ = 0;
    } else if (key=='e') {
      XY = 0;
    } else if (key=='a') {
      XZ = 0;
    } else if (key=='s') {
      YZ = 0;
    } else if (key=='d') {
      XZ = 0;
    } else if (key=='r') {
      ZW = 0;
    } else if (key=='t') {
      YW = 0;
    } else if (key=='y') {
      ZW = 0;
    } else if (key=='f') {
      XW = 0;
    } else if (key=='g') {
      YW = 0;
    } else if (key=='h') {
      XW = 0;
    }
  }
}

void setup(){
  //size(1920,1048,P3D);
  fullScreen(P3D);
  hint(ENABLE_STROKE_PERSPECTIVE);
  hint(ENABLE_DEPTH_SORT);
  
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
  
  
  cam = new PeasyCam(this, 0.5*boundaryRadius);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(boundaryRadius);
  perspective(PI/3.0, width/height, 0.1, 2*boundaryRadius);
  updateProjString();
  switch (DEMONSTRATION){
    case 0 : 
      setupPlatonics();
      break;
    case 1 :
      setupDrifters();
      break;
    default:
      setupPlatonics();
  }
}

void draw(){
  background(0);
  lightFalloff(1, 0, 0);
  lightSpecular(128, 128, 128);
  ambientLight(128, 128, 128);
  directionalLight(128,128,128, cos(frameCount/60f) - 1, sin(10000 + frameCount/50f), cos(50000 + frameCount/70f));
  
  strokeWeight(guideStrokeWeight);
  noFill();
  stroke(green);
  sphere(boundaryRadius+boundaryBuffer);
  if(showGuides){drawGuides();}
  fill(amber);
  noStroke();
  sphere(0.1);
  switch (DEMONSTRATION){
    case 0 : 
      drawPlatonics();
      break;
    case 1 :
      drawDrifters();
      break;
    default:
      drawPlatonics();
  }
  if(recording){saveFrame("frames/FourDimensions#######.png");}
  
  
  cam.beginHUD();
  fill(255);
  stroke(255);
  textAlign(LEFT);
  text(hudLine1,10,20,0);
  
  textAlign(RIGHT);
  text(projName + "\n Global Rotation:" + camRotate,width-10,20,0);
  if(recording){noStroke();fill(255,0,0);circle(width-20,20,20);}
  cam.endHUD();
}
