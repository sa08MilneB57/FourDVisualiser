FourShape cartesian(FourVector origin, FourVector corner1, FourVector corner2, int detail){
  float dx = (corner2.x - corner1.x) / (float)(detail-1);
  float xLow = min(corner1.x, corner2.x);
  float dy = (corner2.y - corner1.y) / (float)(detail-1);
  float yLow = min(corner1.y, corner2.y);
  float dz = (corner2.z - corner1.z) / (float)(detail-1);
  float zLow = min(corner1.z, corner2.z);
  float dw = (corner2.w - corner1.w) / (float)(detail-1);
  float wLow = min(corner1.w, corner2.w);
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
          points.add(new FourVector(dx*i + xLow,
                                    dy*j + yLow,
                                    dz*k + zLow,
                                    dw*l + wLow).add(origin));
          if(i != detail-1){
            edges.add(new FourLine(index,index + 1, color(255,0,0)) );
          }
          if(j != detail-1){
            edges.add(new FourLine(index,index + detail, color(0,255,0)) );
          }
          if(k != detail-1){
            edges.add(new FourLine(index,index + detail*detail, color(0,0,255)) );
          }
          if(l != detail-1){
            edges.add(new FourLine(index,index + detail*detail*detail, color(255,255,0)) );
          }
        }
      }
    }
  }
  return new FourShape(origin,points.toArray(new FourVector[0]),edges.toArray(new FourLine[0]),faces);
}
