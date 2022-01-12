int functionNumber = 0;
ComplexFunction[] FUNCTIONS= {new CIdentity(),  new CReciprocal(),
                              new CSquare(),    new CCube(),
                              new CSqrt(),      new CQuartish(),
                              new CExp(),new CLog(),
                              
                              new CSin(),new CCos(),new CTan(),
                              new CSinh(),new CCosh(),new CTanh(), 
                              new CASin(),new CACos(),new CATan(),
                              new CASinh(),new CACosh(),new CATanh(),
                                
                              new CBinet(),new CMandel(1000),
                              new CGauss(),new CGaussAbs(),new CErf(0.125/8),
                              new CZeta(30),new CGamma(30),new CReciprocalGamma(30)
                          };

class FunctionPlotDemo implements Demo{
  PeasyCam cam;
  PApplet parent;  
  final float degrees = PI/180f;

  final float boundaryRadius = 1000;//radius of sphere containing hologram (Size of 3D world)
  final float boundaryBuffer = 10;
  final float shapeStrokeWeight = 0.4;
  final float guideStrokeWeight = 0.2;
  final color amber = color(200, 150, 0,125);
  final color green = color(0, 50, 0);
  
  String projName;//name of the projection
  int projection = -1;//-1 is perspective, 0-3 are orthographic
  float focalLength = boundaryRadius/10f;//4D Focal Length
  
  int XY, XZ, YZ, XW, YW, ZW;//keeps track of the planes of rotation the user is controlling with the keyboard. 1 for positive rotation, -1 for negative.
  FourMatrix rotorXY, rotorXZ, rotorYZ, rotorXW, rotorYW, rotorZW; //These matrices remain constant through the simulation and are shorthand for rotation matrices.
  FourMatrix negrotorXY, negrotorXZ, negrotorYZ, negrotorXW, negrotorYW, negrotorZW;;
  
  FourFunctionSurface plot;//currently selected shape
  String hudLine1;
  
  boolean camRotate = false; //whether we rotate the 4D camera or the object itself
  boolean drawLines = true;
  boolean drawFaces = true;
  boolean showGuides = true;
  boolean recording = false;
  
  FunctionPlotDemo(PApplet _parent){
    parent = _parent;
  }
  
  void demoSetup(){
    hint(ENABLE_STROKE_PERSPECTIVE);
    hint(ENABLE_DEPTH_SORT);
    
    initialiseRotors();
    
    initialiseCamera();
    
    updateProjString();
    setShape(1);
  }
  
  void demoDraw(){
    background(0);
    rigLights();
    
    drawSetting();
    
    applyUserRotation();
    showShape();
    
    drawHUD();
    if(recording){saveFrame("frames/FourDimensions#######.png");}
    
    
  }
  
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
    cam.endHUD();
  }
  
  void rigLights(){
    lightFalloff(1, 0, 0);
    lightSpecular(128, 128, 128);
    ambientLight(128, 128, 128);
    directionalLight(128,128,128, cos(frameCount/60f) - 1, sin(10000 + frameCount/50f), cos(50000 + frameCount/70f));
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
  
  void demoKeyPressed(char key){
    if (key=='o') {    //Orthographic Projection
      projection = (projection+1)%4;
      updateProjString();
    } else if (key=='O') {    //Orthographic Projection
      projection = (projection-1 + 4)%4;
      updateProjString();
    } else if (key=='p') { //Perspective Projection
      projection = -1;
      updateProjString();
    } else if (key=='-') { //Lower 4D focal length
      focalLength = max(focalLength/1.418,0);
      updateProjString();
    } else if (key=='=') { //Raise 4D focal length
      focalLength *= 1.418;
      updateProjString();
    } else if (key=='v') { //toggle recording 
      recording = !recording;
    } else if (key=='x') {  //toggle guides
      showGuides = !showGuides;
    } else if (key=='2'){ //number keys control shape
      functionNumber = (functionNumber+1) % FUNCTIONS.length;
      setShape(functionNumber);
    } else if (key=='1'){ //number keys control shape
      functionNumber = (functionNumber-1+FUNCTIONS.length) % FUNCTIONS.length;
      setShape(functionNumber);
    } else if (key=='#'){  //rotate camera or shape
      camRotate=!camRotate;
    } else if (key=='[') { //draw shape lines
      drawLines = !drawLines;
    } else if (key==']') { //draw shape faces
      drawFaces = !drawFaces;
    } else if (key=='q') { // Rotation keys
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
  }
  
  void demoKeyReleased(char key){
    if (key=='q') { //necessary to cancel rotations and have multiple rotations at once possible
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
  
  void applyUserRotation(){
    //applies rotation from 4D camera movements to the shape
    if (XY == -1) {
      plot.applyMatrix(negrotorXY, camRotate);
    }
    if (XY == 1) {
      plot.applyMatrix(rotorXY, camRotate);
    }
    if (XZ == -1) {
      plot.applyMatrix(negrotorXZ, camRotate);
    }
    if (XZ == 1) {
      plot.applyMatrix(rotorXZ, camRotate);
    }
    if (YZ == -1) {
      plot.applyMatrix(negrotorYZ, camRotate);
    }
    if (YZ == 1) {
      plot.applyMatrix(rotorYZ, camRotate);
    }
    if (XW == -1) {
      plot.applyMatrix(negrotorXW, camRotate);
    }
    if (XW == 1) {
      plot.applyMatrix(rotorXW, camRotate);
    }
    if (YW == -1) {
      plot.applyMatrix(negrotorYW, camRotate);
    }
    if (YW == 1) {
      plot.applyMatrix(rotorYW, camRotate);
    }
    if (ZW == -1) {
      plot.applyMatrix(negrotorZW, camRotate);
    }
    if (ZW == 1) {
      plot.applyMatrix(rotorZW, camRotate);
    }
  }
  
  void showShape() {
    //draws the displayed shape to the 3D world.
    strokeWeight(shapeStrokeWeight);
    if (projection==-1) {
      plot.shape.persp(focalLength, drawLines, drawFaces);
    } else {
      plot.shape.ortho(projection, drawLines, drawFaces);
    }
  }
  
  void initialiseCamera(){
    cam = new PeasyCam(parent, 0.5*boundaryRadius);
    cam.setMinimumDistance(10);
    cam.setMaximumDistance(boundaryRadius);
    perspective(PI/3.0, width/height, 0.1, 2*boundaryRadius);
  }
  
  void setShape(int i){
    //changes the currently selected shape
    if(i==21){//special dispensation for mandelbrot set
      final double[] xBounds = {-1.5d,0.5d};
      final double[] yBounds = {-1d,1d};
      plot = new FourFunctionSurface(new FourVector(0,0,0,20),xBounds,255,yBounds,255);      
    } else {
      plot = new FourFunctionSurface(new FourVector(0,0,0,100),5,101,5,101);
    }
    plot.applyFunction(FUNCTIONS[i]);
    plot.generateSheet();
    hudLine1 = FUNCTIONS[i].name();
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
  void drawGuides(){
    //draws XYZ guides for orientation
    stroke(255,0,0);
    line(-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer,0,0);
    stroke(0,255,0);
    line(0,-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer,0);
    stroke(0,0,255);
    line(0,0,-boundaryRadius-boundaryBuffer,0,0,boundaryRadius+boundaryBuffer);
  }
}
