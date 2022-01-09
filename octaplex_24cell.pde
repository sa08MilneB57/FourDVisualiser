FourShape octaplex(FourVector center, float r,color col){
  FourVector[] points = {new FourVector(0,0,0,-r).add(center),
                         new FourVector(0,0,0, r).add(center),
                         new FourVector(0,0,-r,0).add(center),
                         new FourVector(0,0, r,0).add(center),
                         new FourVector(0,-r,0,0).add(center),
                         new FourVector(0, r,0,0).add(center),
                         new FourVector(-r,0,0,0).add(center),
                         new FourVector( r,0,0,0).add(center),
                         new FourVector( 0.5, 0.5, 0.5, 0.5).mult(r).add(center),
                         new FourVector( 0.5, 0.5, 0.5,-0.5).mult(r).add(center),
                         new FourVector( 0.5, 0.5,-0.5, 0.5).mult(r).add(center),
                         new FourVector( 0.5, 0.5,-0.5,-0.5).mult(r).add(center),
                         new FourVector( 0.5,-0.5, 0.5, 0.5).mult(r).add(center),
                         new FourVector( 0.5,-0.5, 0.5,-0.5).mult(r).add(center),
                         new FourVector( 0.5,-0.5,-0.5, 0.5).mult(r).add(center),
                         new FourVector( 0.5,-0.5,-0.5,-0.5).mult(r).add(center),
                         new FourVector(-0.5, 0.5, 0.5, 0.5).mult(r).add(center),
                         new FourVector(-0.5, 0.5, 0.5,-0.5).mult(r).add(center),
                         new FourVector(-0.5, 0.5,-0.5, 0.5).mult(r).add(center),
                         new FourVector(-0.5, 0.5,-0.5,-0.5).mult(r).add(center),
                         new FourVector(-0.5,-0.5, 0.5, 0.5).mult(r).add(center),
                         new FourVector(-0.5,-0.5, 0.5,-0.5).mult(r).add(center),
                         new FourVector(-0.5,-0.5,-0.5, 0.5).mult(r).add(center),
                         new FourVector(-0.5,-0.5,-0.5,-0.5).mult(r).add(center)};
  FourLine[] lines = new FourLine[0];
  FourFace[] faces = new FourFace[0];
  
  FourShape out = new FourShape(center,points,lines,faces);
  out.makeRegularEdges(col);
  return out;
}
