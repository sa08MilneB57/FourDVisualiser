
class FourVector{
  float x,y,z,w;
  FourVector(float _x,float _y, float _z, float _w){
    x=_x; y=_y; z=_z; w=_w;
  }
  FourVector(float[] v){
    if(v.length != 4){throw new IllegalArgumentException("Fourvector must have four components.");}
    x=v[0]; y=v[1]; z=v[2]; w=v[3];
  }
  
  FourVector add(FourVector v){return new FourVector(x + v.x, y + v.y, z + v.z, w + v.w);}
  FourVector sub(FourVector v){return new FourVector(x - v.x, y - v.y, z - v.z, w - v.w);}
  FourVector mult(float r){return new FourVector(x*r,y*r,z*r,w*r);}
  
  float dot(FourVector v){return x*v.x + y*v.y + z*v.z + w*v.w;}
  float mag2(){return x*x + y*y + z*z + w*w;}
  float mag() {return sqrt(mag2());}
  
  PVector ortho(int dim){
    switch (dim){
      case 0 :
        return new PVector(w,y,z);
      case 1 :
        return new PVector(x,w,z);
      case 2 :
        return new PVector(x,y,w);
      case 3 :
        return new PVector(x,y,z);
      default:
        throw new IllegalArgumentException("Invalid co-ordinate:" + Integer.toString(dim));
    }
  }
  
  PVector persp(float focalLength){return persp(focalLength,3);}
  PVector persp(float focalLength,int dim){
    switch (dim){
      case 0 :
        return new PVector(focalLength*w/x,focalLength*y/x,focalLength*z/x);
      case 1 :
        return new PVector(focalLength*x/y,focalLength*w/y,focalLength*z/y);
      case 2 :
        return new PVector(focalLength*x/z,focalLength*y/z,focalLength*w/z);
      case 3 :
        return new PVector(focalLength*x/w,focalLength*y/w,focalLength*z/w);
      default:
        throw new IllegalArgumentException("Invalid co-ordinate:" + Integer.toString(dim));
    }
  }
}

FourVector fourDComplex(Complex z, Complex w){return fourDComplex(z, w,10);}
FourVector fourDComplex(Complex z, Complex w,float scale){
  return new FourVector(scale * (float)z.re,scale * (float)z.im,scale * (float)w.re,scale * (float)w.im);
}

FourVector sphericalCoordinates(float lon, float lat, float let){return sphericalCoordinates(lon, lat, let,1f);}
FourVector sphericalCoordinates(float lon, float lat, float let,float r){
  //on wikipedia for glome let is psi, lat is theta, lon is phi
  float w = r*cos(let);
  float z = r*sin(let)*cos(lat);
  float y = r*sin(let)*sin(lat)*cos(lon);
  float x = r*sin(let)*sin(lat)*sin(lon);
  return new FourVector(x,y,z,w);
}

FourVector lorentzCoordinates(float lon, float lat, float hlet,float r){
  float w = r*(float)Math.sinh(hlet);
  float x = r*(float)Math.cosh(hlet)*cos(lat);
  float y = r*(float)Math.cosh(hlet)*sin(lat)*cos(lon);
  float z = r*(float)Math.cosh(hlet)*sin(lat)*sin(lon);
  return new FourVector(x,y,z,w);
}

class FourMatrix{
  float xx,xy,xz,xw;
  float yx,yy,yz,yw;
  float zx,zy,zz,zw;
  float wx,wy,wz,ww;
  FourMatrix(float XX, float XY, float XZ, float XW,
             float YX, float YY, float YZ, float YW,
             float ZX, float ZY, float ZZ, float ZW,
             float WX, float WY, float WZ, float WW){
      xx=XX;xy=XY;xz=XZ;xw=XW;
      yx=YX;yy=YY;yz=YZ;yw=YW;
      zx=ZX;zy=ZY;zz=ZZ;zw=ZW;
      wx=WX;wy=WY;wz=WZ;ww=WW;               
  }
  FourMatrix(float[] args){
    if(args.length != 16){throw new IllegalArgumentException("Incorrect argument length for 4x4 Matrix");}
      xx=args[0];xy=args[1];xz=args[2];xw=args[3];
      yx=args[4];yy=args[5];yz=args[6];yw=args[7];
      zx=args[8];zy=args[9];zz=args[10];zw=args[11];
      wx=args[12];wy=args[13];wz=args[14];ww=args[15];               
  }
  void print(){    
    println(xx,xy,xz,xw);
    println(yx,yy,yz,yw);
    println(zx,zy,zz,zw);
    println(wx,wy,wz,ww);
  }
  float[] asArray(){float[] out = {xx,xy,xz,xw,yx,yy,yz,yw,zx,zy,zz,zw,wx,wy,wz,ww}; return out;}
  
  FourVector multiply(FourVector v){
    //this multiplies v from the left
    float ux = xx*v.x + xy*v.y + xz*v.z + xw*v.w;
    float uy = yx*v.x + yy*v.y + yz*v.z + yw*v.w;
    float uz = zx*v.x + zy*v.y + zz*v.z + zw*v.w;
    float uw = wx*v.x + wy*v.y + wz*v.z + ww*v.w;
    return new FourVector(ux,uy,uz,uw);
  }
  FourMatrix multiply(FourMatrix O){
    //this multiplies O from the left
    //eq. O multiplies this from the right
    float[] matrix =  new float[16];
    float[] self = this.asArray();
    float[] other = O.asArray();
    for(int j=0;j<4;j++){
      for(int i=0;i<4;i++){
        //i,j is index in output matrix
        float a = 0;
        for(int k=0;k<4;k++){//column in other/row in self
          a += self[j*4 + k]*other[k*4 + i];
        }
        matrix[j*4 + i] = a;
      }
    }
    return new FourMatrix(matrix);
  }
}

FourMatrix scalar(float x){
  return diagonal(x,x,x,x);
}
FourMatrix diagonal(float x, float y, float z, float w){
  return new FourMatrix(x,0,0,0,
                        0,y,0,0,
                        0,0,z,0,
                        0,0,0,w);
}

FourMatrix rotate4(float theta,int dim1, int dim2){
  //numbers dimensions from 0 to 3 (x,y,z,w)
  //active transformation of points
  if (dim1==dim2){throw new IllegalArgumentException("Dimensions must be different.");}
  if (dim1>3||dim2>3||dim1<0||dim2<0){throw new IllegalArgumentException("Dimensions must between 0 and 3.");}
  float cost = cos(theta);
  float sint = sin(theta);
  float[] matrix = new float[16];
  for(int j=0;j<4;j++){
    for(int i=0;i<4;i++){
      float a=0;
      if(i==j){//diagonal entry
        a = (i==dim1||i==dim2)?cost:1f;
      } else if (i==dim1&&j==dim2){
        a=sint;
      } else if (j==dim1&&i==dim2){
        a=-sint;
      }
      matrix[j*4+i] = a;
    }  
  }
  return new FourMatrix(matrix);
}

float pauliDeterminant(FourVector p){return pauliDeterminant(p.x,p.y,p.z,p.w);}
float pauliDeterminant(float x,float y,float z,float w){
  float l = w*w - x*x - y*y - z*z;
  return l*l;
}
FourMatrix compTwoMatrix(Complex xx, Complex xy,
                         Complex yx, Complex yy){
  return new FourMatrix((float)xx.re,   (float)-xx.im, (float)xy.re,  (float)-xy.im,
                        (float)xx.im,   (float)xx.re,  (float)xy.im,  (float)xy.re,
                        (float)yx.re,   (float)-yx.im, (float)yy.re,  (float)-yy.im,
                        (float)yx.im,   (float)yx.re,  (float)yy.im,  (float)yy.re);
}

FourMatrix pauli(FourVector p){return pauli(p.w,p.x,p.y,p.z);}
FourMatrix pauli(float w, float x, float y, float z){
  return new FourMatrix(w+z,0,x,y,
                        0,w+z,-y,x,
                        x,-y,w-z,0,
                        y,x,0,w-z);
}
