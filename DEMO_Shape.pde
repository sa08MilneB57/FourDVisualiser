class ShapeDemo extends Demo {
  final String[] shapeNames = {"Hypersphere",
                                "Tesseract",
                                "Pentachoron (5-cell)",
                                "Orthoplex (16-cell)",
                                "Octaplex (24-cell)",
                                "Spherinder",
                                "Sphericone",
                                "Clifford Torus",
                                "Klein Bottle (Pinched Torus Embedding)",
                                "Klein Bottle (Figure-8 Embedding)",
                                "Hyperboloid: x^2+y^2+z^2-w^2",
                                "Hyperboloid: x^2+y^2-z^2-w^2",
                                "Cartesian Grid",
                                "PolyRoots Projective Roots Grid (Full)",
                                "PolyRoots Projective Roots Grid (Positive Only)",
                                "PolyRoots Projective Roots Grid (One Positive)",
                                "PolyRoots Projective Roots Grid (One Real)",
                                "PolyRoots Projective Roots Grid (One Pure Imaginary)",
                              };

  final float shapeStrokeWeight = 0.4;


  FourShape shape;//currently selected shape

  boolean drawLines = true;
  boolean drawFaces = true;

  ShapeDemo(PApplet _parent) {
    super(_parent);
  }

  void demoSetup() {
    hint(ENABLE_STROKE_PERSPECTIVE);
    hint(ENABLE_DEPTH_SORT);

    initialiseRotors();

    initialiseCamera();
    menu = createIntegerListMenu(this,shapeNames,18);

    updateProjString();
    menuAction(1);
  }

  void demoDraw() {
    background(0);
    rigLights();

    drawSetting();

    applyUserRotation();
    showShape();

    drawHUD();
    if (recording) {
      saveFrame("frames/FourDimensions#######.png");
    }
  }


  void demoKeyPressed(char key) {
    if (key == TAB){
      showMenu = !showMenu;
    } else if (key=='o') {    //Orthographic Projection
      projection = (projection+1)%4;
      updateProjString();
    } else if (key=='O') {    //Orthographic Projection
      if (projection == -1) {
        projection = 3;
      } else {
        projection = (projection-1 + 4)%4;
      }
      updateProjString();
    } else if (key=='p') { //Perspective Projection
      projection = -1;
      updateProjString();
    } else if (key=='-') { //Lower 4D focal length
      focalLength = max(focalLength/1.418, 0);
      updateProjString();
    } else if (key=='=') { //Raise 4D focal length
      focalLength *= 1.418;
      updateProjString();
    } else if (key=='v') { //toggle recording 
      recording = !recording;
    } else if (key=='x') {  //toggle guides
      showGuides = !showGuides;
    } else if (key=='#') {  //rotate camera or shape
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

  void demoKeyReleased(char key) {
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

  void applyUserRotation() {
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

  void menuAction(int i) {
    //changes the currently selected shape
    switch(i) {
    case 0:
      shape = hypersphere(new FourVector(0, 0, 0, 105), 100, 32, 16, 16);
      break;
    case 1:
      shape = tesseract(new FourVector(0, 0, 0, 50), 50);
      break;
    case 2:
      shape = pentachoron(new FourVector(0, 0, 0, 51), 49);
      break;
    case 3:
      shape = orthoplex(new FourVector(0, 0, 0, 51), 49, amber);
      break;
    case 4:
      shape = octaplex(new FourVector(0, 0, 0, 51), 49, amber);
      break;
    case 5:
      shape = spherinder(new FourVector(0, 0, 0, 105), 80, 80, 32, 16, 16);
      break;
    case 6:
      shape = sphericone(new FourVector(0, 0, 0, 105), 80, 80, 32, 16, 16);
      break;
    case 7:
      shape = cliffordtorus(new FourVector(0, 0, 0, 51), 50/sqrt(2), 48);
      break;
    case 8:
      shape = kleinbottle(new FourVector(0, 0, 0, 60), 30, 25, 32, 32);
      break;
    case 9:
      shape = kleinbottleFIG8(new FourVector(0, 0, 0, 70), 30, 5, 10f, 24, 24);
      break;
    case 10:
      shape = hyperboloid(new FourVector(0, 0, 0, 105), 50, 32, 16, 32);
      break;
    case 11:
      shape = hyperboloid2(new FourVector(0, 0, 0, 105), 50, 32, 16, 32);
      break;
    case 12:
      shape = cartesian(new FourVector(0, 0, 0, 150), new FourVector(-100, -100, -100, -100), new FourVector(100, 100, 100, 100), 11);
      break;
    case 13:
      shape = polygrid(new FourVector(0, 0, 0, 150),6, new FourVector(-3,-3,-3,-3), new FourVector(3, 3, 3, 3), 16);
      break;
    case 14:
      shape = polygrid(new FourVector(0, 0, 0, 150),6, new FourVector(0,0, 0, 0), new FourVector(3, 3, 3, 3), 16);
      break;
    case 15:
      shape = polygrid(new FourVector(0, 0, 0, 150),6, new FourVector(-3,-3, 0, 0), new FourVector(3, 3, 3, 3), 16);
      break;
    case 16:
      shape = polygrid(new FourVector(0, 0, 0, 150),6, new FourVector(-3,-3,-3, 0), new FourVector(3, 3, 3, 0), 16);
      break;
    case 17:
      shape = polygrid(new FourVector(0, 0, 0, 150),6, new FourVector(-3,-3, 0,-3), new FourVector(3, 3, 0, 3), 16);
      break;
    default:
      throw new IllegalArgumentException("Invalid shape number");
    }
    hudLine1 = shapeNames[i];
  }
}
