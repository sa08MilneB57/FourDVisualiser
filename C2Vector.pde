
FourVector fourDComplex(Complex z, Complex w){return fourDComplex(z, w,10);}
FourVector fourDComplex(Complex z, Complex w,float scale){
  return new FourVector(scale * (float)z.re,scale * (float)z.im,scale * (float)w.re,scale * (float)w.im);
}
FourVector fourDComplex(C2Vector v){return fourDComplex(v,10);}
FourVector fourDComplex(C2Vector v,float scale){
  return new FourVector(scale * (float)v.x.re,scale * (float)v.x.im,scale * (float)v.y.re,scale * (float)v.y.im);
}

class C2Vector{
  Complex x,y;
  C2Vector(double xr,double xi, double yr, double yi){
    x=new Complex(xr,xi); y=new Complex(yr,yi);
  }
  C2Vector(Complex _x,Complex _y){
    x = _x; y = _y;
  }
  
  C2Vector add(C2Vector v){return new C2Vector(x.add(v.x), y.add(v.y));}
  C2Vector sub(C2Vector v){return new C2Vector(x.sub(v.x), y.sub(v.y));}
  C2Vector mult(double r){return new C2Vector(x.mult(r),y.mult(r));}
  C2Vector mult(Complex r){return new C2Vector(x.mult(r),y.mult(r));}
  
  Complex dot(FourVector v){return x.mult(v.x).add( y.mult(v.y) );}
  Complex hermitianProductAsBra(C2Vector v){return v.hermitianProductAsKet(this);}//where "this" is a Bra, and v is a Ket
  Complex hermitianProductAsKet(C2Vector v){return x.mult(v.x.conj()).add( y.mult(v.y.conj()) );}//where "this" is a Ket, and v is a Bra
  double mag2(){return x.mag2() + y.mag2();}
  double mag() {return Math.sqrt(mag2());}
  double magChebyshev(){return Math.max(x.mag(),y.mag());}
  double phaseDiff(){return y.arg() - x.arg();}
}

C2Vector lerp(C2Vector a, C2Vector b, double t){
  return a.add( (b.sub(a)).mult(t) );
}

//float pauliDeterminant(FourVector p){return pauliDeterminant(p.x,p.y,p.z,p.w);}
//float pauliDeterminant(float x,float y,float z,float w){
//  float l = w*w - x*x - y*y - z*z;
//  return l*l;
//}
//FourMatrix compTwoMatrix(Complex xx, Complex xy,
//                         Complex yx, Complex yy){
//  return new FourMatrix((float)xx.re,   (float)-xx.im, (float)xy.re,  (float)-xy.im,
//                        (float)xx.im,   (float)xx.re,  (float)xy.im,  (float)xy.re,
//                        (float)yx.re,   (float)-yx.im, (float)yy.re,  (float)-yy.im,
//                        (float)yx.im,   (float)yx.re,  (float)yy.im,  (float)yy.re);
//}

//FourMatrix pauli(FourVector p){return pauli(p.w,p.x,p.y,p.z);}
//FourMatrix pauli(float w, float x, float y, float z){
//  return new FourMatrix(w+z,0,x,y,
//                        0,w+z,-y,x,
//                        x,-y,w-z,0,
//                        y,x,0,w-z);
//}
