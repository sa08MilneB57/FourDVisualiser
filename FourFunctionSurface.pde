class FourFunctionSurface{
  int xDetail,yDetail;
  FourShape shape;
  FourVector origin;
  FourMatrix planeRotation;
  FourMatrix camRotation;
  Complex[] z,w;
  FourFunctionSurface(FourVector _origin,double xRadius, int _xDetail,double yRadius, int _yDetail){
    xDetail = _xDetail;
    yDetail = _yDetail;
    origin = _origin;
    double dx = (2*xRadius) / (xDetail-1);
    double dy = (2*xRadius) / (xDetail-1);
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
    resetOrientation();
    generateSheet();
  }
  
  void applyFunction(ComplexFunction f){
    for (int i=0; i<z.length; i++){
      w[i] = f.f(z[i]);
    }
  }
  
  void resetOrientation(){
    planeRotation = scalar(1);
    camRotation = scalar(1);
    generateSheet();
  }
  
  void applyMatrix(FourMatrix M,boolean global){
    if(global){
      camRotation.multiply(M);
    } else {
      planeRotation.multiply(M);      
    }
    shape.applyMatrix(M,global);
  }
  
  void generateSheet(){
    FourVector[] points = new FourVector[xDetail*yDetail];
    ArrayList<FourLine> edges = new ArrayList<FourLine>();
    FourFace[] faces = new FourFace[0];
    for (int j=0; j<yDetail; j++){
      for (int i=0; i<xDetail; i++){
        int ind = i + j*xDetail;
        points[ind] = fourDComplex(z[ind],w[ind]).add(origin);
        if( i+1 < xDetail){
          edges.add( new FourLine(ind,ind+1,argandColor(z[ind],1)) );
        }
        if( j+1 < yDetail ){
          edges.add( new FourLine(ind,ind+xDetail,argandColor(z[ind],1)) );
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
    if (mag <= maxExpected) {
      l = (float)(0.5d*mag/maxExpected);
    } else {
      l = (float)(0.5d*(2d - (maxExpected/(Math.log(mag - maxExpected + 1) + maxExpected))));
    }
    return HSL(hue, 1, l);
}
