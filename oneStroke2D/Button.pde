class Button {
  float x, y;
  float sizeX, sizeY;
  int state;
  boolean pushed;

  color normalCol = color(0, 134, 182);
  color selectCol = color(0, 109, 146);
  color pushCol = color(0, 72, 96);

  String str;

  Button(float x, float y, float sizeX, float sizeY, String str) {
    this.x=x;
    this.y=y;
    this.sizeX=sizeX;
    this.sizeY=sizeY;
    this.str=str;
  }

  void display(int msX, int msY) {
    state = checkState(msX, msY);
    noStroke();
    changeColor();
    rect(x, y, sizeX, sizeY);

    fill(255);
    textSize(50);
    text(str, x+sizeX/2, y+sizeY/2);
  }

  int checkState(int msX, int msY) {
    if (pushed) return 0;
    if (isInside(msX, msY)) return 1;
    return 2;
  }

  boolean isInside(int msX, int mxY) {
    if (mouseX > x && mouseX < x+sizeX && mouseY > y && mouseY < y+sizeY) {
      return true;
    }
    return false;
  }

  void changeColor() {
    switch(state) {
    case 0:
      fill(pushCol);
      break;
    case 1:
      fill(selectCol);
      break;
    case 2:
      fill(normalCol);
      break;
    default:
      fill(0, 0, 0);
      break;
    }
  }
}
