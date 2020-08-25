class Vertex {
  float x, y, z, size;
  int lineLimit=4;
  ArrayList<Line> lines = new ArrayList<Line>();
  int state = 0;
  boolean deleted;

  color normal_col = color(255);
  color state1_col = color(255, 165, 0);
  color state2_col = color(128, 128, 0);

  Vertex(float x, float y, float z, float size) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.size = size;
  }

  void display() {
    if(deleted) return;
    changeCol();
    pushMatrix();
    translate(x, y, z);
    sphere(size/2);
    popMatrix();
  }
  
  void updateLinesIndex(){
    int num = 1;
    for(Line line : lines){
      if(!line.passed){
        line.index = num;
        num++;
      }
    }
  }
  
  void checkConnected(){
    for(Line line : lines){
      if(!line.passed) return;
    }
    deleted = true;
  }
  
  boolean judgeGameOver(){
    for(Line line : lines){
      if(!line.passed) return false;
    }
    deleted = true;
    return true;
  }

  void makeLine(Vertex[] ver) {
    if (!(lines.size() < lineLimit)) {
      return;
    }
    boolean existsLine;
    Line temp;
    Vertex[] dist = distArray(ver);
    for (int i=1; i<dist.length; i++) {
      existsLine = false;
      for (Line line : lines) {
        if (line.v2 == dist[i] || dist[i].lines.size() > dist[i].lineLimit-2) {
          existsLine = true;
          break;
        }
      }
      if (!existsLine) {
        temp = new Line(this, dist[i], lines.size()+1);
        lines.add(temp);
        temp = new Line(dist[i], this, dist[i].lines.size()+1);
        dist[i].lines.add(temp);
        dist[i].makeLine(dist);
        break;
      }
    }
  }

  void changeCol() {
    stroke(normal_col);
    switch(state) {
    case 1:
      stroke(state1_col);
      fill(state1_col);
      break;
    default:
      stroke(normal_col);
      fill(normal_col);
      break;
    }
  }

  Vertex[] distArray(Vertex[] ver) {
    Vertex[] copy = new Vertex[ver.length];
    arrayCopy(ver, copy);
    Vertex temp;
    //calc_dist & bubble_sort
    for (int j=0; j<ver.length-1; j++) {
      for (int k=0; k<ver.length-1; k++) {
        if (dist(x, y, z, copy[k].x, copy[k].y, copy[k].z) > 
          dist(x, y, z, copy[k+1].x, copy[k+1].y, copy[k+1].z)) {
          temp = copy[k+1];
          copy[k+1] = copy[k];
          copy[k] = temp;
        }
      }
    }
    return copy;
  }
}
