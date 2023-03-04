FourShape polygrid(FourVector origin, FourVector rootCorner1, FourVector rootCorner2, int detail){
  float da = (rootCorner2.x - rootCorner1.x) / (float)(detail-1);
  float aLow = min(rootCorner1.x, rootCorner2.x);
  float db = (rootCorner2.y - rootCorner1.y) / (float)(detail-1);
  float bLow = min(rootCorner1.y, rootCorner2.y);
  float dc = (rootCorner2.z - rootCorner1.z) / (float)(detail-1);
  float cLow = min(rootCorner1.z, rootCorner2.z);
  float dd = (rootCorner2.w - rootCorner1.w) / (float)(detail-1);
  float dLow = min(rootCorner1.w, rootCorner2.w);
  ArrayList<FourVector> points = new ArrayList<FourVector>();
  ArrayList<FourLine> edges = new ArrayList<FourLine>();
  FourFace[] faces = new FourFace[0];
  for(int l=0; l<detail; l++){
    int lindex = l*detail*detail*detail;
    for(int k=0; k<detail; k++){
      int kindex = k*detail*detail;
      for(int j=0; j<detail; j++){
        int jindex = j*detail;
        for(int i=0; i<detail; i++){
          int index = i + jindex + kindex + lindex;
          float a = da*i + aLow;
          float b = db*j + bLow;
          float c = dc*k + cLow;
          float d = dd*l + dLow;
          color clr = color(map(i,0,detail-2,15,255),
                            map((k+l)/2,0,detail-2,15,255),
                            map(j,0,detail-2,15,255));
          points.add(new FourVector(a*b - c*d,
                                    a*d - c*b,
                                    -a - b,
                                    -c - d).add(origin));
          if(i != detail-1){
            //edges.add(new FourLine(index,index + 1, color(255,0,0)) );
            edges.add(new FourLine(index,index + 1, clr) );
          }
          if(j != detail-1){
            //edges.add(new FourLine(index,index + detail, color(0,255,0)) );
            edges.add(new FourLine(index,index + detail, clr) );
          }
          if(k != detail-1){
            //edges.add(new FourLine(index,index + detail*detail, color(0,0,255)) );
            edges.add(new FourLine(index,index + detail*detail, clr) );
          }
          if(l != detail-1){
            //edges.add(new FourLine(index,index + detail*detail*detail, color(255,255,0)) );
            edges.add(new FourLine(index,index + detail*detail*detail, clr) );
          }
        }
      }
    }
  }
  return new FourShape(origin,points.toArray(new FourVector[0]),edges.toArray(new FourLine[0]),faces);
}
