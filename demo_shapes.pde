class ShapeDemo implements Demo{
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
  
  FourShape shape;//currently selected shape
  String hudLine1;
  
  boolean camRotate = false; //whether we rotate the 4D camera or the object itself
  boolean drawLines = true;
  boolean drawFaces = true;
  boolean showGuides = true;
  boolean recording = false;
  
  ShapeDemo(PApplet _parent){
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
    
    if(recording){saveFrame("frames/FourDimensions#######.png");}
    
    drawHUD();
    
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
    
    textAlign(RIGHT);
    text(projName + "\n Global Rotation:" + camRotate,width-10,20,0);
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
    } else if (Character.isDigit(key)){ //number keys control shape
      setShape(key - '0');
    } else if (key=='`'){ //number keys control shape
      setShape(10);
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
  
  void showShape() {
    //draws the displayed shape to the 3D world.
    strokeWeight(shapeStrokeWeight);
    if (projection==-1) {
      shape.persp(focalLength, drawLines, drawFaces);
    } else {
      shape.ortho(projection, drawLines, drawFaces);
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
      case 10:
        shape = hyperboloid(new FourVector(0, 0, 0, 105), 50, 32, 16, 32);
        hudLine1 = "Hyperboloid";
        break;
      default:
        setShape(2);
    }
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
