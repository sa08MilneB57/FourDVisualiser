
FourShape pentachoron(float radius){return pentachoron(new FourVector(0,0,0,0),radius);}
FourShape pentachoron(FourVector center,float radius){
  float disp = radius*0.5*sqrt(5f/2f);
  FourVector[] points = {new FourVector(disp,disp/sqrt(10),disp/sqrt(6),disp/sqrt(3)).add(center),
                         new FourVector(-disp,disp/sqrt(10),disp/sqrt(6),disp/sqrt(3)).add(center),
                         new FourVector(0,disp/sqrt(10),disp/sqrt(6),-2*disp/sqrt(3)).add(center),
                         new FourVector(0,disp/sqrt(10),-disp*sqrt(3/2),0).add(center),
                         new FourVector(0,-2*disp*sqrt(2f/5f),0,0).add(center)};
  FourLine[] lines = new FourLine[10];
  for (int i = 0;i<5;i++){
      lines[i] = new FourLine(i,(i+1)%5,color(255,0,0));
  }
  for (int i = 0;i<5;i++){
      lines[5+i] = new FourLine(i,(i+2)%5,color(0,0,255));
  }
  FourFace[] faces = new FourFace[10];
  for (int i = 0;i<5;i++){
    int[] face1 = {i,(i+1)%5,(i+2)%5};
    int[] face2 = {i,(i+2)%5,(i+3)%5};
    faces[2*i] = new FourFace(face1,color(180,0,100,120));
    faces[2*i+1] = new FourFace(face2,color(80,100,40,120));
  }
  return new FourShape(center,points,lines,faces);
}
