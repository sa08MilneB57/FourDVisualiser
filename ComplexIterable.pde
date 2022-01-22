
class MandelbrotIterable extends ComplexBinaryFunction {
  final double bailout2 = 4;
  String name(){return "Mandelbrot: w^2 + z";}
  Complex f(Complex c){return c;}
  Complex f(Complex z, Complex c) {
    Complex out = z.square().add(c);
    if(out.mag2() >= bailout2){
      return new Complex(Double.NaN,Double.NaN);
    } else {
      return out;
    }
  }
}

class CubelbrotIterable extends ComplexBinaryFunction {
  final double bailout2 = 4;
  String name(){return "Cubelbrot: w^3 + z";}
  Complex f(Complex c){return c;}
  Complex f(Complex z, Complex c) {
    Complex out =  z.cube().add(c);
    if(out.mag2() >= bailout2){
      return new Complex(Double.NaN,Double.NaN);
    } else {
      return out;
    }
  }
}

class BurningShipIterable extends ComplexBinaryFunction {
  final double bailout2 = 4;
  String name(){return "Burning Ship: (|Re(w)| + |Im(w)|)^2 - z";}
  Complex f(Complex c){return c;}
  Complex f(Complex z, Complex c) {
    Complex out =  z.elementAbs().square().add(c);
    if(out.mag2() >= bailout2){
      return  new Complex(Double.NaN,Double.NaN);
    } else {
      return out;
    }
  }
}

class MobiusIterable extends ComplexBinaryFunction{
  final Complex I = new Complex(0, 1);
  String name(){return "Mobius: (w+iz)/(w-iz)";}
  Complex f(Complex c){return new Complex(-1,0);}
  Complex f (Complex z, Complex c) {
    return z.add(c.mult(I)).divBy(z.mult(I).add(c));
  }
}

class TrigIterable extends ComplexBinaryFunction {
  final double bailout2 = 4;
  final Complex ONE = new Complex(1,0);
  String name(){return "2*(1-cos(w)) + z";}
  Complex f(Complex c){return c;}
  Complex f(Complex z, Complex c) {
    Complex out =  z.cos().subFrom(ONE).mult(2).add(c);
    if(out.mag2() >= bailout2){
      return new Complex(Double.NaN,Double.NaN);
    } else {
      return out;
    }
  }
}

class HyperbolicIterable extends ComplexBinaryFunction {
  final double bailout2 = 4;
  final Complex ONE = new Complex(1,0);
  String name(){return "2*(cosh(w) - 1) + z";}
  Complex f(Complex c){return c;}
  Complex f(Complex z, Complex c) {
    Complex out =  z.cosh().sub(ONE).mult(2).add(c);
    if(out.mag2() >= bailout2){
      return new Complex(Double.NaN,Double.NaN);
    } else {
      return out;
    }
  }
}

class ExponentialIterable extends ComplexBinaryFunction {
  final double bailout2 = 4;
  String name(){return "e^z + c";}
  Complex f(Complex c){return c;}
  Complex f(Complex z, Complex c) {
    Complex out =  z.exp().add(c);
    if(out.mag2() >= bailout2){
      return new Complex(Double.NaN,Double.NaN);
    } else {
      return out;
    }
  }
}
