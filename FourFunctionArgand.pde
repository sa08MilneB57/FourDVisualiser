class FourFunctionArgand{
  //a 4d cartesian grid plotting a function of C^2 using domain colouring
  int detail;
  float intScale;
  FourShape shape;
  FourVector origin;
  FourMatrix planeRotation;
  FourMatrix camRotation;
  Complex[] z,w,outputs;
  FourFunctionArgand(ComplexBinaryFunction f,FourVector _origin,double extent, int _detail, float _intScale){
    detail = _detail;    origin = _origin; intScale = _intScale;
    generateC2(extent);
    applyFunction(f);
    resetOrientation();
    generateSheet();
  }
  
  void resetOrientation(){
    planeRotation = scalar(1);
    camRotation = scalar(1);
    generateSheet();
  }
  
  void applyFunction(ComplexBinaryFunction f){
    outputs = new Complex[detail * detail * detail * detail];
    for(int l=0; l<detail; l++){
      int lindex = l*detail*detail*detail;
      for(int k=0; k<detail; k++){
        int kindex = k*detail*detail;
        int windex = k + l * detail;
        for(int j=0; j<detail; j++){
          int jindex = j*detail;
          for(int i=0; i<detail; i++){
            int zindex = i + jindex;
            int outindex = i + jindex + kindex + lindex;
            //println("out",outindex,"z",zindex,"w",windex);
            outputs[outindex] = f.f(z[zindex],w[windex]);
          }
        }
      }
    }
  }
  
  void applyMatrix(FourMatrix M,boolean global){
    if(global){
      camRotation.multiply(M);
    } else {
      planeRotation.multiply(M);      
    }
    shape.applyMatrix(M,global);
  }
  
  void generateC2(double extent){
    double dx = (2*extent) / (detail-1);
    z = new Complex[detail * detail];
    w = new Complex[detail * detail];
    for (int j=0; j<detail; j++){
      for (int i=0; i<detail; i++){
        int ind = i + j*detail;
        double x = i*dx - extent;
        double y = j*dx - extent;
        z[ind] = new Complex(x,y);
        w[ind] = new Complex(x,y);
      }
    }
    
    
  }
  
  void generateSheet(){
    ArrayList<FourVector> points = new ArrayList<FourVector>();
    ArrayList<FourLine> edges = new ArrayList<FourLine>();
    FourFace[] faces = new FourFace[0];
    for(int l=0; l<detail; l++){
      int lindex = l*detail*detail*detail;
      for(int k=0; k<detail; k++){
        int kindex = k*detail*detail;
        int windex = k + l * detail;
        for(int j=0; j<detail; j++){
          int jindex = j*detail;
          for(int i=0; i<detail; i++){
            int zindex = i + jindex; 
            int index = i + jindex + kindex + lindex;
            points.add(new FourVector((float)z[zindex].re,
                                      (float)z[zindex].im,
                                      (float)w[windex].re,
                                      (float)w[windex].im).mult(intScale).add(origin));
                                      
            Complex thisProduct = outputs[index];
            if(i != detail-1){
              Complex thatProduct = outputs[index+1];
              Complex avg = thisProduct.add(thatProduct).mult(0.5d);
              edges.add(new FourLine(index,index + 1, argandColor(avg,10)) );
            }
            if(j != detail-1){
              Complex thatProduct = outputs[index+detail];
              Complex avg = thisProduct.add(thatProduct).mult(0.5d);
              edges.add(new FourLine(index,index + detail, argandColor(avg,10)) );
            }
            if(k != detail-1){
              Complex thatProduct = outputs[index+detail*detail];
              Complex avg = thisProduct.add(thatProduct).mult(0.5d);
              edges.add(new FourLine(index,index + detail*detail, argandColor(avg,10)) );
            }
            if(l != detail-1){
              Complex thatProduct = outputs[index+detail*detail*detail];
              Complex avg = thisProduct.add(thatProduct).mult(0.5d);
              edges.add(new FourLine(index,index + detail*detail*detail, argandColor(avg,10)) );
            }
          }
        }
      }
    }
    shape = new FourShape(origin,points.toArray(new FourVector[0]),edges.toArray(new FourLine[0]),faces);
    shape.applyMatrix(planeRotation,false);
    shape.applyMatrix(camRotation,true);
  }
}
