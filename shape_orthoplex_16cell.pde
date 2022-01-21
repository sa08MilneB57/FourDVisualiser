FourShape orthoplex(float radius,color col){return orthoplex(new FourVector(0,0,0,0),radius,col);}
FourShape orthoplex(FourVector center,float radius,color col){
  //also known as hexadecachoron
  //analogue of the octahedron
  FourVector[] points = {
      new FourVector(radius,0,0,0).add(center),
      new FourVector(0,radius,0,0).add(center),
      new FourVector(0,0,radius,0).add(center),
      new FourVector(0,0,0,radius).add(center),
      new FourVector(-radius,0,0,0).add(center),
      new FourVector(0,-radius,0,0).add(center),
      new FourVector(0,0,-radius,0).add(center),
      new FourVector(0,0,0,-radius).add(center),
  };
  FourLine[] lines = new FourLine[0];//24];
  //for (int i=0; i<8;i++){
  //    lines[3*i] = new FourLine(i,(i+1)%8,color(255,0,0));
  //    lines[3*i+1] = new FourLine(i,(i+2)%8,color(0,255,0));
  //    lines[3*i+2] = new FourLine(i,(i+3)%8,color(0,0,255));
  //}
  FourFace[] faces = new FourFace[0];//32];
  //for (int p=0;p<8;p++){
  //  int[] face1 = {p,(p+1)%8,(p+3)%8};
  //  int[] face2 = {p,(p+1)%8,(p+4)%8};
  //  int[] face3 = {p,(p+5)%8,(p+6)%8};
  //  int[] face4 = {p,(p+5)%8,(p+7)%8}; 
  //  faces[4*p] = new FourFace(face1,color(125,0,125));
  //  faces[4*p+1] = new FourFace(face2,color(125,125,0));
  //  faces[4*p+2] = new FourFace(face3,color(0,125,125));
  //  faces[4*p+3] = new FourFace(face4,color(100,200,50));
  //}
  FourShape out = new FourShape(center,points,lines,faces);
  out.makeRegularEdges(col);
  return out;
}
