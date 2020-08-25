class Line {
  Vertex v1, v2;
  Line line2;
  boolean passed;

  Line(Vertex v1, Vertex v2) {
    this.v1 = v1; 
    this.v2 = v2;
  }

  void display() {
    line2 = anotherLine();
    stroke(255);
    strokeWeight(10);
    line(v1.x, v1.y, v2.x, v2.y);
    if (passed) {
      stroke(255, 165, 0);
    } else {
      if ((v1.state == 1 && v2.state == 0) || (v1.state == 0 && v2.state == 1)) {
        stroke(0, 255, 0);
      } else if ((v1.state == 2 && v2.state == 1) || (v1.state == 1 && v2.state == 2)) {
        stroke(255, 165, 0);
        passed = true;
      } else {
        stroke(0);
      }
    }
    strokeWeight(3);
    line(v1.x, v1.y, v2.x, v2.y);
    line(line2.v1.x, line2.v1.y, line2.v2.x, line2.v2.y);
  }

  Line anotherLine() {
    for (Line line : v2.lines) {
      if (line.v2 == v1) {
        return line;
      }
    }
    return null;
  }
}
