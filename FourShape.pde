class FourLine {
  int index1, index2;
  color col;
  boolean nullLine;
  FourLine(int a, int b, color c) {
    index1 = min(a,b); 
    index2 = max(a,b);
    col=c;
    nullLine = a==b;
  }
  @Override
  public final boolean equals(Object o){
    if (o == this){
        return true;}
    if (!(o instanceof FourLine)){
        return false;}
    FourLine other = (FourLine)o;
    return index1==other.index1 && index2==other.index2;
  }
  @Override
  public final int hashCode() {
    int[] ar = {index1,index2};
    return ar.hashCode();
  }
}
class FourFace {
  int[] indices;
  color col;
  FourFace(int[] ind, color _col) {
    indices = ind; 
    col=_col;
  }
  @Override
  public boolean equals(Object o){
    if (o == this){return true;}
    if (!(o instanceof FourFace)){return false;}
    FourFace other = (FourFace)o;
    return indices==other.indices;
  }
  @Override
  public final int hashCode() {return indices.hashCode();}
}

FourLine nullLine(){return new FourLine(0,0,0);}

//draws a sphere at a particular point in 4D space, a convenience class
//class FourPoint{
//  FourVector pos,o;
//  private float r;
//  private color pointcol;
//  private FourShape sphere;
//  FourPoint(FourVector position,float radius,color col){
//    pos=position;
//    o = new FourVector(0,0,0,0);
//    r=radius;
//    pointcol = col;
//    sphere = hypersphere(pos, r, 6, 6, 6);
//  }
//  FourPoint(FourVector position,FourVector origin,float radius,color col){
//    pos=position;
//    o = origin;
//    r=radius;
//    pointcol = col;
//    sphere = hypersphere(pos, r, 6, 6, 6);
//  }
  
//  void applyMatrix(FourMatrix M, boolean global){
//    FourVector newv = (global)? M.multiply(pos) : M.multiply(pos.sub(o)).add(o);
//    sphere.slide(newv.sub(pos));
//    pos = newv;
//  }
  
//  void refresh(float len){
//    pos = new FourVector(random(2*len)-len,random(2*len)-len,random(2*len)-len,random(2*len)-len).add(o);
//    sphere.slide(pos.sub(sphere.anchor));
//  }
  
//  void stepTime(FourMatrix M,float dt, float maxDistance){
//    float maxDistance2 = maxDistance*maxDistance;
//    FourVector vel = M.multiply(pos.sub(o)).mult(dt);
//    pos = pos.add(vel);
//    float dis2 = pos.sub(o).mag2(); 
//    if(dis2>maxDistance2 || dis2<0.1){
//      refresh(maxDistance);
//    } else {
//      sphere.slide(vel);
//    }
//  }
  
//  void ortho(int coord) {
//    noFill();
//    for (FourLine l : sphere.lines) {
//      if(l.nullLine){continue;}
//      PVector a = sphere.points[l.index1].sub(o).ortho(coord);
//      PVector b = sphere.points[l.index2].sub(o).ortho(coord);
//      stroke(l.col);
//      line(a.x, a.y, a.z, b.x, b.y, b.z);
//    }
//  }
  
//  void persp(float focalLength) {
//    noFill();
//    for (FourLine l : sphere.lines) {
//      if(l.nullLine){continue;}
//      PVector a = sphere.points[l.index1].persp(focalLength);
//      PVector b = sphere.points[l.index2].persp(focalLength);
//      stroke(pointcol);
//      line(a.x, a.y, a.z, b.x, b.y, b.z);
//    }
//  }
//}

class FourShape {
  int lineDetail = 2;
  FourVector anchor;
  FourVector[] points;
  FourLine[] lines;
  FourFace[] faces;
  FourShape(FourVector _anchor,FourVector[] p, FourLine[] l, FourFace[] f) {
    anchor = _anchor;
    points = p; 
    lines = l; 
    faces = f;
  }
  
  FourVector[] edge(int i){//Returns the two points at the end of line[i]
    return edge(lines[i]);}
  FourVector[] edge(FourLine e){//Returns two points at the end of "e"
    FourVector u = points[e.index1];
    FourVector v = points[e.index2];
    FourVector[] out = {v,u};
    return out;
  }
  FourLine[] edgesFrom(int i){//Returns all FourLines  connected to point[i]
    ArrayList<FourLine> edges = new ArrayList<FourLine>();
    for (FourLine line : lines){
      if( i == line.index1 || i == line.index2){
        edges.add(lines[i]);
      }
    }
    return edges.toArray(new FourLine[0]);
  }
  
  void makeRegularEdges(color col){//assuming regularity, connects all points that are equidistant
    float short2 = Float.POSITIVE_INFINITY;
    int n = points.length;
    for(int i=0;i<n;i++){
      FourVector p = points[i];
      for(int j=0;j<n;j++){
        if(i==j){continue;}
        FourVector q = points[j];
        short2 = min(short2,p.sub(q).mag2());
      }
    }
    
    HashSet<FourLine> edges = new HashSet<FourLine>();
    for(int i=0;i<n;i++){
      FourVector p = points[i];
      for(int j=0;j<i;j++){
        FourVector q = points[j];
        if(short2 == p.sub(q).mag2()){
          edges.add(new FourLine(i,j,col));
        }
      }
    }
    lines = edges.toArray(new FourLine[0]);
  }
  
  void applyMatrix(FourMatrix M,boolean global){
    if (global){
      anchor = M.multiply(anchor);
      for(int i=0; i<points.length;i++){
        points[i] = M.multiply(points[i]);
      }
    } else {
      for(int i=0; i<points.length;i++){
        points[i] = points[i].sub(anchor);
        points[i] = M.multiply(points[i]);
        points[i] = points[i].add(anchor);
      }
    } 
  }
  void slide(float x, float y, float z, float w){slide(new FourVector(x,y,z,w));}
  void slide(FourVector v){
    anchor = anchor.add(v);
    for(int i=0; i<points.length;i++){
      points[i] = points[i].add(v);
    }
  }
  
  void ortho(int coord){ortho(coord,true,true);}
  void ortho(int coord,boolean drawlines,boolean drawfaces) {
    noFill();
    
    if(drawlines){
      for (FourLine l : lines) {
        if(l == null){continue;}
        if(l.nullLine){continue;}
        color clr = l.col;
        if(points[l.index1].w <= 0 || points[l.index2].w <= 0){
          clr = capBrightness(clr,127);
        }
        PVector a = points[l.index1].ortho(coord);
        PVector b = points[l.index2].ortho(coord);
        stroke(clr);
        line(a.x, a.y, a.z, b.x, b.y, b.z);
      }
    }

    noStroke();
    if (drawfaces){
      for (FourFace f : faces) {
        beginShape();
        fill(f.col);
        alpha(100);
        for (int index : f.indices) {
          PVector a = points[index].ortho(coord);
          vertex(a.x, a.y, a.z);
        }
        endShape();
      }
    }
  }
  void persp(float focalLength){persp(focalLength,true,true);}
  void persp(float focalLength,boolean drawlines,boolean drawfaces) {
    if (drawlines){
      noFill();
      for (FourLine l : lines) {
        if(l == null){continue;}
        if(l.nullLine || 
           (points[l.index1].w <= 0 && points[l.index2].w <= 0) ||
           (lineDetail == 2 && (points[l.index1].w <= 0 ||
            points[l.index2].w <= 0))){continue;}
        FourVector a = points[l.index1];
        FourVector b = points[l.index2];
        stroke(l.col);
        if(lineDetail <= 2){
          PVector p0 = a.persp(focalLength);
          PVector p1 = b.persp(focalLength);
          line(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z);
        } else {
            float dt = 1f / lineDetail;
            FourVector v1 = a.mult(1);
            PVector p1 = a.persp(focalLength);
            for(float i=0; i<lineDetail;i++){
              println(i);
              FourVector v0 = v1;
              PVector p0 = p1.copy();
              v1 = lerp(a,b,(i+1)*dt);
              p1 = v1.persp(focalLength);
              if(v0.w <= 0 || v1.w <= 0){continue;}
              line(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z);
            }
        }
      }
    }

    noStroke();
    if(drawfaces){
      for (FourFace f : faces) {
        beginShape();
        fill(f.col);
        for (int index : f.indices) {
          PVector a = points[index].persp(focalLength);
          vertex(a.x, a.y, a.z);
        }
        endShape();
      }
    }
  }
}
