
FourShape hypersphere(float radius,int detailLon,int detailLat){return hypersphere(new FourVector(0,0,0,0),radius,detailLon,detailLat,detailLat/2);}
FourShape hypersphere(float radius,int detailLon, int detailLat,int detailLet){return hypersphere(new FourVector(0,0,0,0),radius,detailLon,detailLat,detailLet);}
FourShape hypersphere(FourVector center, float radius,int detailLon, int detailLat,int detailLet){
  int numOfPoints = detailLon*detailLat*detailLet;
  FourVector[] points = new FourVector[numOfPoints];
  FourLine[] lines = new FourLine[3*numOfPoints];
  FourFace[] faces = new FourFace[0*numOfPoints];
  float letstep = (float)(Math.PI/(detailLet-1));
  float latstep = (float)(Math.PI/(detailLat-1));
  float lonstep = (float)(2*Math.PI/detailLon);
  int detail2 = detailLat*detailLon;
  for (int k=0; k<detailLet;k++){
    float let = k*letstep;//0toPI
    for (int j=0; j<detailLat;j++){
      float lat = j*latstep;//0toPI
      for (int i=0; i<detailLon;i++){
        float lon = i*lonstep;//0to just under 2PI
        color col = color(150+100*cos(lon),150+100*cos(lat),150+100*cos(let));
        int index = detail2*k + detailLon*j + i;
        points[index] = sphericalCoordinates(lon,lat,let,radius).add(center);
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
        if (k==detailLet-1){
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
