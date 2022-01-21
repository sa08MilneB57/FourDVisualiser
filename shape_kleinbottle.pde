FourShape kleinbottle(float radius, int detail) {
  return kleinbottle(new FourVector(0, 0, 0, 0), radius, radius, detail, detail);
}
FourShape kleinbottle(FourVector center, float radius, int detail) {
  return kleinbottle(center, radius, radius, detail, detail);
}
FourShape kleinbottle(FourVector center, float radius1, float radius2, int detail1, int detail2) {
  int totalpoints = detail1*detail2;
  FourVector[] points = new FourVector[totalpoints];
  FourLine[] edges = new FourLine[2*totalpoints];//first half in theta direction, second half in phi direction
  FourFace[] faces = new FourFace[totalpoints];
  for (int j=0; j<detail2; j++) {
    float phi = j*TAU/detail2;
    for (int i=0; i<detail1; i++) {
      float theta = i*TAU/detail1;
      color col= color(125+125*cos(theta), 125, 125+125*sin(phi), 110);
      //VERTEX
      points[j*detail1 + i] = new FourVector((radius1 + radius2*cos(theta))*cos(phi), 
        (radius1 + radius2*cos(theta))*sin(phi), 
        radius2*sin(theta)*cos(0.5*phi), 
        radius2*sin(theta)*sin(0.5*phi)).add(center);
      //EDGES
      if (i==detail1-1) {//gluing the cylinder together
        edges[j*detail1 + i] = new FourLine(j*detail1 + i, (j-1)*detail1 + i + 1, col);
      } else {
        edges[j*detail1 + i] = new FourLine(j*detail1 + i, j*detail1 + i + 1, col);
      }
      if (j==detail2-1) {//gluing the crossover of the cylinder loops
        if (i==0) {
          edges[totalpoints + j*detail1 + i] = new FourLine(j*detail1 + i, j*detail1 + (detail1-i) - totalpoints, col);
        } else {
          edges[totalpoints + j*detail1 + i] = new FourLine(j*detail1 + i, (j+1)*detail1 + (detail1-i) - totalpoints, col);
        }
      } else {
        edges[totalpoints + j*detail1 + i] = new FourLine(j*detail1 + i, (j+1)*detail1 + i, col);
      }
      //FACES
      if (j==detail2-1) {
        if (i==0) {
          int[] face = {j * detail1, 
            j * detail1 + 1, 
            detail1 - 1, 
            0};
          faces[j*detail1 + i] = new FourFace(face, col);
        } else if (i==detail1-1) {
          int[] face = {j * detail1 + i, 
            totalpoints-detail1, 
            0, 
            1};
          faces[j*detail1 + i] = new FourFace(face, col);
        } else {
          int[] face = {j * detail1 + i, 
            j * detail1 + i + 1, 
            (j+1)*detail1 + (detail1-i) - 1 - totalpoints, 
            (j+1)*detail1 + (detail1-i) - totalpoints};
          faces[j*detail1 + i] = new FourFace(face, col);
        }
      } else {
        if (i==detail1-1) {
          int[] face = {j * detail1 + i, 
            (j-1)*detail1 + i + 1, 
            j * detail1 + i + 1, 
            (j+1) * detail1 + i};
          faces[j*detail1 + i] = new FourFace(face, col);
        } else {
          int[] face = {j * detail1 + i, 
            j * detail1 + i + 1, 
            (j+1)*detail1 + i + 1, 
            (j+1)*detail1 + i};
          faces[j*detail1 + i] = new FourFace(face, col);
        }
      }
    }
  }
  return new FourShape(center, points, edges, faces);
}

FourShape kleinbottleFIG8(float radius, int detail) {
  return kleinbottleFIG8(new FourVector(0, 0, 0, 0), radius, radius, 1f, detail, detail);
}
FourShape kleinbottleFIG8(FourVector center, float radius, int detail) {
  return kleinbottleFIG8(center, radius, radius, 1f, detail, detail);
}
FourShape kleinbottleFIG8(FourVector center, float radius1, float radius2, float epsilon, int detail1, int detail2) {
  int totalpoints = detail1*detail2;
  FourVector[] points = new FourVector[totalpoints];
  FourLine[] edges = new FourLine[2*totalpoints];//first half in theta direction, second half in phi direction
  FourFace[] faces = new FourFace[totalpoints];
  for (int j=0; j<detail2; j++) {
    float phi = j*TAU/detail2;
    for (int i=0; i<detail1; i++) {
      float theta = i*TAU/detail1;
      color col= color(125+125*cos(theta), 125, 125+125*sin(phi), 110);
      //VERTEX
      points[j*detail1 + i] = new FourVector(radius1*(cos(0.5*theta)*cos(phi) - sin(0.5*theta)*sin(2*phi)), 
        radius1*(sin(0.5*theta)*cos(phi) - cos(0.5*theta)*sin(2*phi)), 
        radius2*cos(theta)*(1 + epsilon*sin(phi)), 
        radius2*sin(theta)*(1 + epsilon*sin(phi))).add(center);
      //EDGES
      if (i==detail1-1) {
        edges[j*detail1 + i] = new FourLine(j*detail1 + i, ((detail2/2-j)*detail1 +totalpoints)%totalpoints , col);
      } else {
        edges[j*detail1 + i] = new FourLine(j*detail1 + i, j*detail1 + i + 1, col);
      }

      if (j==detail2-1) {
        edges[totalpoints + j*detail1 + i] = new FourLine(j*detail1 + i, (j+1)*detail1 + i - totalpoints, col);
      } else {
        edges[totalpoints + j*detail1 + i] = new FourLine(j*detail1 + i, (j+1)*detail1 + i, col);
      }
      //FACES
      if(i==detail1-1){
        if(j==detail2-1){
          int[] face = {j * detail1 + i,
                        ((j+1) * detail1 + i)%totalpoints,
                        ((detail2/2-(j+1))*detail1 +totalpoints)%totalpoints,
                        ((detail2/2-j)*detail1 +totalpoints)%totalpoints};
          faces[j*detail1 + i] = new FourFace(face,col);
        } else {
          int[] face = {j * detail1 + i,
                        (j+1) * detail1 + i,
                        ((detail2/2-(j+1))*detail1 +totalpoints)%totalpoints,
                        ((detail2/2-j)*detail1 +totalpoints)%totalpoints};
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
  return new FourShape(center, points, edges, faces);
}
