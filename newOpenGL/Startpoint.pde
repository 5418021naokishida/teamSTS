class Startpoint extends Vertex {

  int startpointIndex;
  color startpoint1_col = color(255, 0, 0);  //red
  color startpoint2_col = color(0, 255, 0);  //green
  color startpoint3_col = color(0, 0, 255);  //blue
  color startpoint4_col = color(139, 0, 139);//purple
  
  boolean started;

  Startpoint(float x, float y, float z, float size, int i) {
    super(x, y, z, size);
    startpointIndex = i;
  }

  void display() {
    if (deleted) return;
    if (!started) {
      chengeStartpointCol();
    } else {
      changeCol();
    }
    pushMatrix();
    translate(x, y, z);
    sphere(size/2);
    popMatrix();
  }

  void chengeStartpointCol() {
    strokeWeight(10);
    switch(startpointIndex) {
    case 0:
      stroke(startpoint1_col);
      fill(startpoint1_col);
      break;
    case 1:
      stroke(startpoint2_col);
      fill(startpoint2_col);
      break;
    case 2:
      stroke(startpoint3_col);
      fill(startpoint3_col);
      break;
    case 3:
      stroke(startpoint4_col);
      fill(startpoint4_col);
      break;
    }
  }
  
}
