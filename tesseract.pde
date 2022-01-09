
FourShape tesseract(float sideLength){return tesseract(new FourVector(0,0,0,0),sideLength);}
FourShape tesseract(FourVector center,float sideLength){
  float disp = 0.5*sideLength;
  
  //points
  FourVector[] points = new FourVector[16];
  for (int p=0; p<16; p++){
    String bin = Integer.toBinaryString(p);
    bin = "0000".substring(bin.length()) + bin;
    float[] point = new float[4];
    for(int c=0; c<4;c++){
      if(bin.charAt(c) == '0'){
        point[c] = -disp;
      } else {
        point[c] = disp;
      }
    }
    points[p] = new FourVector(point).add(center);
  }
  
  
  //edges
  FourLine[] lines = new FourLine[32];
  color col = color(255,0,0);
  for (int i=0; i<8; i++){
    lines[i] = new FourLine(2*i,2*i+1,col);
  }
  col = color(0,255,0);
  for (int i=0;i<4;i++){
    lines[2*i + 8] = new FourLine(4*i,4*i+2,col);
    lines[2*i + 9] = new FourLine(4*i+1,4*i+3,col);
  }
  col = color(0,0,255);
  for (int i=0;i<2;i++){
    lines[4*i + 16] = new FourLine(8*i,8*i+4,col);
    lines[4*i + 17] = new FourLine(8*i+1,8*i+5,col);
    lines[4*i + 18] = new FourLine(8*i+2,8*i+6,col);
    lines[4*i + 19] = new FourLine(8*i+3,8*i+7,col);
  }
  col = color(125,0,125);
  for (int i=0;i<1;i++){
    lines[8*i + 24] = new FourLine(8*i,8*i+8,col);
    lines[8*i + 25] = new FourLine(8*i+1,8*i+9,col);
    lines[8*i + 26] = new FourLine(8*i+2,8*i+10,col);
    lines[8*i + 27] = new FourLine(8*i+3,8*i+11,col);
    lines[8*i + 28] = new FourLine(8*i+4,8*i+12,col);
    lines[8*i + 29] = new FourLine(8*i+5,8*i+13,col);
    lines[8*i + 30] = new FourLine(8*i+6,8*i+14,col);
    lines[8*i + 31] = new FourLine(8*i+7,8*i+15,col);
  }
  
  //faces
  int facenum = 0;
  FourFace[] faces = new FourFace[24];
  int[] acb = {0,4,8,12};
  int[] dfb = {0,1,8,9};
  int[] aed = {0,2,8,10};
  int[] hjb = {0,1,4,5};
  int[] hia = {0,2,4,6};
  int[] hld = {0,1,2,3};
  
  col = color(255,0,0,180);
  for(int i : acb){
    int[] inds = {i,i+1,i+3,i+2};
    faces[facenum] = new FourFace(inds,col);
    facenum++;
  }
  col = color(0,255,0,180);
  for(int i : dfb){
    int[] inds = {i,i+4,i+6,i+2};
    faces[facenum] = new FourFace(inds,col);
    facenum++;
  }
  col = color(0,0,255,180);
  for(int i : aed){
    int[] inds = {i,i+1,i+5,i+4};
    faces[facenum] = new FourFace(inds,col);
    facenum++;
  }
  col = color(125,0,125,180);
  for(int i : hjb){
    int[] inds = {i,i+8,i+10,i+2};
    faces[facenum] = new FourFace(inds,col);
    facenum++;
  }
  col = color(125,125,0,180);
  for(int i : hia){
    int[] inds = {i,i+8,i+9,i+1};
    faces[facenum] = new FourFace(inds,col);
    facenum++;
  }
  col = color(0,125,125,180);
  for(int i : hld){
    int[] inds = {i,i+8,i+12,i+4};
    faces[facenum] = new FourFace(inds,col);
    facenum++;
  }
  
  
  return new FourShape(center,points,lines,faces);
}
