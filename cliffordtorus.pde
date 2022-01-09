FourShape cliffordtorus(float radius,int detail){return cliffordtorus(new FourVector(0,0,0,0),radius,radius,detail,detail);}
FourShape cliffordtorus(FourVector center,float radius,int detail){return cliffordtorus(center,radius,radius,detail,detail);}
FourShape cliffordtorus(FourVector center,float radius1,float radius2,int detail1,int detail2){
  int totalpoints = detail1*detail2;
  FourVector[] points = new FourVector[totalpoints];
  FourLine[] edges = new FourLine[2*totalpoints];//first half in theta direction, second half in phi direction
  FourFace[] faces = new FourFace[totalpoints];
  for (int j=0; j<detail2;j++){
    float phi = j*TAU/detail2;
    for (int i=0; i<detail1;i++){
      float theta = i*TAU/detail1;
      color col= color(125+125*cos(theta),125,125+125*sin(phi),125);
      points[j*detail1 + i] = new FourVector(radius1*cos(theta),radius1*sin(theta),radius2*cos(phi),radius2*sin(phi)).add(center);
      if(i==detail1-1){
        edges[j*detail1 + i] = new FourLine(j*detail1 + i,(j-1)*detail1 + i + 1,col);
      } else {
        edges[j*detail1 + i] = new FourLine(j*detail1 + i,j*detail1 + i + 1,col);
      }
      if(j==detail2-1){
        edges[totalpoints + j*detail1 + i] = new FourLine(j*detail1 + i,(j+1)*detail1 + i - totalpoints,col);
      } else {
        edges[totalpoints + j*detail1 + i] = new FourLine(j*detail1 + i,(j+1)*detail1 + i,col);
      }
      if(i==detail1-1){
        if(j==detail2-1){
          int[] face = {j * detail1 + i,
                        (j-1)*detail1 + i + 1,
                        0,
                        (j+1)*detail1 + i - totalpoints};
          faces[j*detail1 + i] = new FourFace(face,col);
        } else {
          int[] face = {j * detail1 + i,
                        (j-1)*detail1 + i + 1,
                        j * detail1 + i + 1,
                        (j+1) * detail1 + i};
          faces[j*detail1 + i] = new FourFace(face,col);
        }
      } else {
        if(j==detail2-1){
          int[] face = {j * detail1 + i,
                        j * detail1 + i + 1,
                        (j+1)*detail1 + i + 1 - totalpoints,
                        (j+1)*detail1 + i - totalpoints};
          faces[j*detail1 + i] = new FourFace(face,col);
        } else {
          int[] face = {j * detail1 + i,
                        j * detail1 + i + 1,
                        (j+1)*detail1 + i + 1,
                        (j+1)*detail1 + i};
          faces[j*detail1 + i] = new FourFace(face,col);
        }
      }
      
    }  
  }
  return new FourShape(center,points,edges,faces);
}
