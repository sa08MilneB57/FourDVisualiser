FourShape sphericone(float radius,float h,int detailLon, int detailLat,int detailH){return sphericone(new FourVector(0,0,0,0),0,radius,h,detailLon,detailLat,detailH);}
FourShape sphericone(float radius1,float radius2,float h,int detailLon, int detailLat,int detailH){return sphericone(new FourVector(0,0,0,0),radius1,radius2,h,detailLon,detailLat,detailH);}
FourShape sphericone(FourVector center,float radius,float h,int detailLon, int detailLat,int detailH){return sphericone(center,0,radius,h,detailLon,detailLat,detailH);}
FourShape sphericone(FourVector center, float radius1,float radius2,float h,int detailLon, int detailLat,int detailH){
  int numOfPoints = detailLon*detailLat*detailH;
  FourVector[] points = new FourVector[numOfPoints];
  FourLine[] lines = new FourLine[3*numOfPoints];
  FourFace[] faces = new FourFace[0*numOfPoints];
  float Hstep = (float)(h/(detailH-1));
  float latstep = (float)(Math.PI/(detailLat-1));
  float lonstep = (float)(2*Math.PI/detailLon);
  int detail2 = detailLat*detailLon;
  for (int k=0; k<detailH;k++){
    float w = k*Hstep - 0.5*h;//0toPI
    float r = lerp((float)k/(float)(detailH-1),radius1,radius2);
    for (int j=0; j<detailLat;j++){
      float lat = j*latstep;//0toPI
      for (int i=0; i<detailLon;i++){
        float lon = i*lonstep;//0to just under 2PI
        color col = color(150+100*cos(lon),150+100*cos(lat),150+100*(float)k/(float)(detailH-1));
        int index = detail2*k + detailLon*j + i;
        points[index] = new FourVector(r*cos(lon)*sin(lat),r*sin(lon)*sin(lat),r*cos(lat),w).add(center);
        if (i==detailLon-1){
          lines[3*index]  =  new FourLine(index,((index-detailLon+1+numOfPoints) % numOfPoints),col);
        } else {
          lines[3*index]  =  new FourLine(index,(index+1) % numOfPoints,col);
        }
        if (j==detailLat-1){
          lines[3*index + 1] = new FourLine(index,index,color(0,0,255));//null line
        } else {
          lines[3*index + 1] = new FourLine(index,(index+detailLon) % (numOfPoints),col);
        }
        if (k==detailH-1){
          lines[3*index + 2] = new FourLine(index,index,col);
        } else {
          lines[3*index + 2] = new FourLine(index,(index+detail2) % numOfPoints,col);
        }
        //int[] face1 = {index,(index+1) % numOfPoints};
        //int[] face2 = {index,(index+detailLon) % numOfPoints};
        //int[] face3 = {index,(index+detail2) % numOfPoints};
        //faces[3*index]  =  new FourFace(face1,col);
        //faces[3*index + 1] = new FourFace(face2,col);
        //faces[3*index + 2] = new FourFace(face3,col);
      }
    }
  }
  return new FourShape(center,points,lines,faces);
}
