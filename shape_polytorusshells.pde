
FourShape polytorusshells(FourVector center,float scale,float maxR1,float maxR2,int detailT1,int detailT2,int detailR1, int detailR2,boolean shellColor){
  int totalpoints = detailT1*detailT2*detailR1*detailR2;
  FourVector[] points = new FourVector[totalpoints];
  FourLine[] edges = new FourLine[4*totalpoints];//first quarter in theta1 direction, second quarter in theta2 direction, third in r1 direction, fourth in r2 direction
  FourFace[] faces = new FourFace[totalpoints];
  FourFace[] nofaces = new FourFace[0];
  
  for(int l=0;l<detailR2;l++){
    float r2 = (l+1) * maxR2/detailR2;
    for(int k=0;k<detailR1;k++){
      float r1 = (k+1) * maxR1/detailR1;
      for (int j=0; j<detailT2;j++){
        float theta2 = j*TAU/detailT2;
        for (int i=0; i<detailT1;i++){
          float theta1 = i*TAU/detailT1;
          color col;
          if(shellColor){//color based on which shell or which shell we're in
            col= color(255f*r1/maxR1,15 + 15*sin(theta1),255f*r2/maxR2,100);
          } else {
            col= color(125+125*cos(theta1),125+100*sin(theta1),125+125*sin(theta2),100);
          }
          points[l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourVector(r1*r2*cos(theta1 + theta2),
                                     r1*r2*sin(theta1 + theta2),
                                    -(r1*cos(theta1) + r2*cos(theta2)),
                                    -(r1*sin(theta1) + r2*sin(theta2))).mult(scale).add(center);
          //edges in theta1 direction
          if(i==detailT1-1){
            edges[l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourLine(l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 +     j*detailT1 + i,
                                                                                                      l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + (j-1)*detailT1 + i + 1,col);
          } else {//connects 0pi to 2pi
            edges[l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourLine(l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i,
                                                                                                      l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i + 1,col);
          }
          //edges in theta2 direction
          if(j==detailT2-1){
            edges[totalpoints + l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourLine(l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 +     j*detailT1 + i,
                                                                                                                    l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + (j+1)*detailT1 + i - detailT1*detailT2,col);
          } else {//connects 0pi to 2pi
            edges[totalpoints + l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourLine(l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 +     j*detailT1 + i,
                                                                                                                    l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + (j+1)*detailT1 + i,col);
          }
          
          //faces in the theta1-theta2 plane
          if(i==detailT1-1){
            if(j==detailT2-1){
              int[] face = {l*detailT1*detailT2*detailR1 +     k*detailT1*detailT2 + j * detailT1 + i,
                            l*detailT1*detailT2*detailR1 +     k*detailT1*detailT2 + (j-1)*detailT1 + i + 1,
                            l*detailT1*detailT2*detailR1 +     k*detailT1*detailT2 + 0,
                            l*detailT1*detailT2*detailR1 + (k-1)*detailT1*detailT2 + (j+1)*detailT1 + i};
              faces[l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourFace(face,col);
            } else {
              int[] face = {l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j * detailT1 + i,
                            l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + (j-1)*detailT1 + i + 1,
                            l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j * detailT1 + i + 1,
                            l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + (j+1) * detailT1 + i};
              faces[l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourFace(face,col);
            }
          } else {
            if(j==detailT2-1){
              int[] face = {l*detailT1*detailT2*detailR1 +     k*detailT1*detailT2 + j * detailT1 + i,
                            l*detailT1*detailT2*detailR1 +     k*detailT1*detailT2 + j * detailT1 + i + 1,
                            l*detailT1*detailT2*detailR1 + (k-1)*detailT1*detailT2 + (j+1)*detailT1 + i + 1,
                            l*detailT1*detailT2*detailR1 + (k-1)*detailT1*detailT2 + (j+1)*detailT1 + i};
              faces[l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourFace(face,col);
            } else {
              int[] face = {l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j * detailT1 + i,
                            l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j * detailT1 + i + 1,
                            l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + (j+1)*detailT1 + i + 1,
                            l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + (j+1)*detailT1 + i};
              faces[l*detailT1*detailT2*detailR1 + k*detailT1*detailT2 + j*detailT1 + i] = new FourFace(face,col);
            }
          }
          
        }  
      }
    }
  }
  return new FourShape(center,points,edges,faces);
}
