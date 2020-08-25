class Vertex {
  int x, y, index, lineLimit;
  float size;
  ArrayList<Line> lines = new ArrayList<Line>();
  int state = 0;

  Vertex() {
  }
  Vertex(int x, int y, float size, int index) {
    this.x=x; 
    this.y=y;
    this.size=size; 
    this.index=index;
    if (index%2==0) lineLimit = 2;
    else if(index%3==0) lineLimit = 4;
    else lineLimit = 6;
  }

  void display() {
    stroke(0);
    switch(state) {
    case 1:
      fill(255, 165, 0);
      break;
    case 2:
      fill(128, 128, 0);
      break;
    default:
      fill(255);
      break;
    }
    ellipse(x, y, size, size);
  }

  void makeLine(Vertex[] ver) {
    if (lines.size() >= lineLimit) {
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
        temp = new Line(this, dist[i]);
        lines.add(temp);
        temp = new Line(dist[i], this);
        dist[i].lines.add(temp);
        dist[i].makeLine(dist);
        break;
      }
    }
  }

  boolean judgeClicked(int msX, int msY) {
    if (dist(msX, msY, x, y)<=size/2) {
      return true;
    }
    return false;
  }

  Vertex[] distArray(Vertex[] ver) {
    Vertex[] copy = new Vertex[ver.length];
    arrayCopy(ver, copy);
    Vertex temp;
    //calc_dist & bubble_sort
    for (int j=0; j<ver.length-1; j++) {
      for (int k=0; k<ver.length-1; k++) {
        if (dist(x, y, copy[k].x, copy[k].y) > dist(x, y, copy[k+1].x, copy[k+1].y)) {
          temp = copy[k+1];
          copy[k+1] = copy[k];
          copy[k] = temp;
        }
      }
    }
    return copy;
  }
}
