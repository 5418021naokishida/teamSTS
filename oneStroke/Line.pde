class Line {
  Vertex v1, v2;
  boolean passed;
  int state = 0;
  int index;

  color normal_col = color(255);
  color index1_col = color(255, 0, 0);  //red
  color index2_col = color(0, 255, 0);  //green
  color index3_col = color(0, 0, 255);  //blue
  color index4_col = color(139, 0, 139);//purple


  Line(Vertex v1, Vertex v2, int index) {
    this.v1 = v1;
    this.v2 = v2;
    this.index = index;
  }

  void display() {
    if(passed){ return; }
    strokeWeight(3);
    checkState();
    switch(state) {
    case 1:
      if (index == 1) {
        stroke(index1_col);
      } else if (index == 2) {
        stroke(index2_col);
      } else if (index == 3) {
        stroke(index3_col);
      } else if (index == 4) {
        stroke(index4_col);
      }
      break;
    default:
      stroke(normal_col);
      break;
    }
    line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
  }

  void checkState() {
    if (!passed && v1.state == 1 && v2.state == 0) {
      state = 1;
    } else if (passed || (v1.state == 2 && v2.state == 1) || (v1.state == 1 && v2.state == 2)) {
      state = 2;
      passed = true;
    } else {
      state = 0;
    }
  }
}
