class FunctionPlotDemo extends Demo{
  final ComplexFunction[] FUNCTIONS= {new CIdentity(),  new CReciprocal(),
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
  
  final float shapeStrokeWeight = 0.4;
  
  FourFunctionSurface plot;//currently selected shape
  
  boolean drawLines = true;
  boolean drawFaces = true;
  
  FunctionPlotDemo(PApplet _parent){
    super(_parent);
  }
  
  void demoSetup(){
    hint(ENABLE_STROKE_PERSPECTIVE);
    hint(ENABLE_DEPTH_SORT);
    
    initialiseRotors();
    
    initialiseCamera();
    menu = createFunctionListMenu(this,FUNCTIONS,18);
    
    updateProjString();
    menuAction(1);
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
  
  
  
  
  void demoKeyPressed(char key){
    if (key == TAB){
      showMenu = !showMenu;
    } else if (key=='o') {    //Orthographic Projection
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
  
  
  void menuAction(int i){
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
}
