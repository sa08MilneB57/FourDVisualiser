color HSL(float H, float S, float L) {
  //L and S in [0,1], H in [0,2pi]
  float C = (1 - abs(2*L - 1)) * S;
  float Hp = 3*H / PI;
  float X = C*(1 - abs((Hp % 2) - 1));
  float R, G, B;
  if (S == 0 || L==0 || L==1) {
    R=0;
    G=0;
    B=0;
  } else {
    switch(floor(Hp)) {
    case 0:
      R=C; 
      G=X; 
      B=0;
      break;
    case 1:
      R=X; 
      G=C; 
      B=0;
      break;
    case 2:
      R=0; 
      G=C; 
      B=X;
      break;
    case 3:
      R=0; 
      G=X; 
      B=C;
      break;
    case 4:
      R=X; 
      G=0; 
      B=C;
      break;
    case 5:
      R=C; 
      G=0; 
      B=X;
      break;
    default:
      R=0; 
      G=0; 
      B=0;
    }
  }
  float m = L - 0.5*C;
  return color(255*(R+m), 255*(G+m), 255*(B+m));
}
