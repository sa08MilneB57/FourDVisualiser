class FourFunctionSurface{
  //A 2-manifold embedded in C^2 (R^4) where [x,y]start as [Re(z),Im(z)] and [z,w] start as [Re(f(z)),Im(f(z))]
  int xDetail,yDetail;
  FourShape shape;
  FourVector origin;
  FourMatrix planeRotation;
  FourMatrix camRotation;
  Complex[] z,w;
  FourFunctionSurface(FourVector _origin,double xRadius, int _xDetail,double yRadius, int _yDetail){
    xDetail = _xDetail;    yDetail = _yDetail;    origin = _origin;
    generateC1(xRadius,yRadius);
    resetOrientation();
    generateSheet();
  }
  FourFunctionSurface(FourVector _origin,double[] xBounds, int _xDetail,double[] yBounds, int _yDetail){
    xDetail = _xDetail;    yDetail = _yDetail;    origin = _origin;
    generateC1(xBounds,yBounds);
    resetOrientation();
    generateSheet();
  }
  
  void applyFunction(ComplexFunction f){
    for (int i=0; i<z.length; i++){
      w[i] = f.f(z[i]);
    }
  }
  
  void iterateFunction(ComplexBinaryFunction f){
    for (int i=0; i<z.length; i++){
      w[i] = f.f(w[i],z[i]);
    }
  }
  
  void resetOrientation(){
    planeRotation = scalar(1);
    camRotation = scalar(1);
    generateSheet();
  }
  
  void applyMatrix(FourMatrix M,boolean global){
    if(global){
      camRotation = camRotation.multiply(M);
    } else {
      planeRotation = planeRotation.multiply(M);      
    }
    shape.applyMatrix(M,global);
  }
  
  void generateC1(double xRadius,double yRadius){
    double dx = (2*xRadius) / (xDetail-1);
    double dy = (2*xRadius) / (yDetail-1);
    z = new Complex[xDetail * yDetail];
    w = new Complex[xDetail * yDetail];
    for (int j=0; j<yDetail; j++){
      for (int i=0; i<xDetail; i++){
        int ind = i + j*xDetail;
        double x = i*dx - xRadius;
        double y = j*dy - yRadius;
        z[ind] = new Complex(x,y);
        w[ind] = new Complex(x,y);
      }
    }
  }
  void generateC1(double[] xBounds,double[] yBounds){
    if(xBounds.length != 2 || yBounds.length != 2){throw new IllegalArgumentException("xBounds and yBounds must be length 2, 1 lower bound, 1 upper bound");}
    double x1 = Math.min(xBounds[0], xBounds[1]);
    double x2 = Math.max(xBounds[0], xBounds[1]);
    double y1 = Math.min(yBounds[0], yBounds[1]);
    double y2 = Math.max(yBounds[0], yBounds[1]);
    double dx = (x2-x1) / (xDetail-1);
    double dy = (y2-y1) / (yDetail-1);
    z = new Complex[xDetail * yDetail];
    w = new Complex[xDetail * yDetail];
    for (int j=0; j<yDetail; j++){
      for (int i=0; i<xDetail; i++){
        int ind = i + j*xDetail;
        double x = i*dx + x1;
        double y = j*dy + y1;
        z[ind] = new Complex(x,y);
        w[ind] = new Complex(x,y);
      }
    }
  }
  void generateSheet(){generateSheet(false);}
  void generateSheet(boolean outputColor){
    FourVector[] points = new FourVector[xDetail*yDetail];
    ArrayList<FourLine> edges = new ArrayList<FourLine>();
    FourFace[] faces = new FourFace[0];
    for (int j=0; j<yDetail; j++){
      for (int i=0; i<xDetail; i++){
        int ind = i + j*xDetail;
        points[ind] = fourDComplex(z[ind],w[ind]).add(origin);
        if( i+1 < xDetail){
          color col = (outputColor)  ?  argandColor(w[ind],1)  :  argandColor(z[ind],1);
          edges.add( new FourLine(ind,ind+1,col) );
        }
        if( j+1 < yDetail ){
          color col = (outputColor)  ?  argandColor(w[ind],1)  :  argandColor(z[ind],1);
          edges.add( new FourLine(ind,ind+xDetail,col) );
        }
      }
    }
    shape = new FourShape(origin,points,edges.toArray(new FourLine[0]),faces);
    shape.applyMatrix(planeRotation,false);
    shape.applyMatrix(camRotation,true);
  }
}


color argandColor(Complex z,double maxExpected){
    if (z.isNaN()) {
      return color(255);
    }
    final float hue = (float)(z.arg()%TAU + TAU) % TAU;
    final double mag = z.mag();
    float l;
    if (maxExpected == -1){
      l = 0.5;
    } else if (mag <= maxExpected) {
      l = (float)(0.5d*mag/maxExpected);
    } else {
      l = (float)(0.5d*(2d - (maxExpected/(Math.log(mag - maxExpected + 1) + maxExpected))));
    }
    return HSL(hue, 1, l);
}
