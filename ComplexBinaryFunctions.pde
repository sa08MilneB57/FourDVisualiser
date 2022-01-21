abstract class ComplexBinaryFunction implements ComplexFunction{
  Complex defaultW;
  ComplexBinaryFunction(){defaultW = new Complex(1,0);}
  ComplexBinaryFunction(Complex _W){
    defaultW = _W;
  }
  Complex f(Complex z){return f(z,defaultW);}
  String menuName(){return name();}
  abstract Complex f(Complex z,Complex w);
}

class C2Sum extends ComplexBinaryFunction{
  C2Sum(){super();}
  String name(){return "z + w";}
  Complex f(Complex z, Complex w){return z.add(w);}
}
class C2Difference extends ComplexBinaryFunction{
  C2Difference(){super();}
  String name(){return "z - w";}
  Complex f(Complex z, Complex w){return z.sub(w);}
}

class C2Product extends ComplexBinaryFunction{
  C2Product(){super();}
  String name(){return "zw";}
  Complex f(Complex z, Complex w){return z.mult(w);}
}

class C2Quotient extends ComplexBinaryFunction{
  C2Quotient(){super();}
  String name(){return "z/w";}
  Complex f(Complex z, Complex w){return z.divBy(w);}
}
class C2Power extends ComplexBinaryFunction{
  C2Power(){super();}
  String name(){return "z^w";}
  Complex f(Complex z, Complex w){return z.raiseBy(w);}
}
class C2Root extends ComplexBinaryFunction{
  C2Root(){super();}
  String name(){return "z^(1/w)";}
  Complex f(Complex z, Complex w){return z.root(w);}
}
class C2HermitianInnerProduct extends ComplexBinaryFunction{
  C2HermitianInnerProduct(){super();}
  String name(){return "<[1+i,1-i]|[z,w]>";}
  Complex f(Complex z, Complex w){
    return z.mult(new Complex(1,-1)).add(w.mult(new Complex(1,1)));
  }
}
