int depth;
int block_size = 100;
float ball_size = block_size * 0.5;
int number_of_vertexes = 30;
int number_of_squaresX, number_of_squaresY, number_of_squaresZ;
float[] pointXs, pointYs, pointZs;

Vertex[] ver = new Vertex[number_of_vertexes];
ArrayList<Startpoint> startpoints = new ArrayList<Startpoint>();
Vertex cur, pre;

color bgCol = color(0);
color borderLineCol = color(255);
color gameClearCol = color(255);
color gameClearText = color(127, 255, 0);
color gameOverCol = color(135, 206, 250);
color gameOverText = color(255);

boolean started;
boolean gameClear;
boolean gameOver;

MouseCamera mouseCamera;

void setup() {
  size(1800, 1800, P3D);
  depth = max(width, height);
  mouseCamera = new MouseCamera(1800.0, 0, 0, depth * 5/4, 0, 0, 0, 0, 1, 0);
  smooth();
  makePoint();
  makeVertex();
  ver[0].makeLine(ver);
  printOption1();
  textAlign(CENTER, CENTER);
}

void draw() {
  if (!gameClear && !gameOver) {
    background(bgCol);
    mouseCamera.update();
    //drawBorderLine();
    drawLine();
    drawVertex();
  } else {
    mouseCamera.update();
    printText();
  }
}

void mousePressed() {
  mouseCamera.mousePressed();
}
void mouseDragged() {
  mouseCamera.mouseDragged();
}
void mouseWheel(MouseEvent event) {
  mouseCamera.mouseWheel(event);
}
void keyPressed() {
  int zero = int('0');
  if (zero + 1 <= int(key) && int(key) <= zero + 4) {
    updatePlayScreen(int(key)-zero);
  }
}

void makePoint() {
  number_of_squaresX = width/block_size;
  number_of_squaresY = height/block_size;
  number_of_squaresZ = depth/block_size;
  pointXs = new float[number_of_squaresX - 1];
  pointYs = new float[number_of_squaresY - 1];
  pointZs = new float[number_of_squaresZ - 1];
  if (pointXs.length%2 == 1) {
    for (int i=0; i<pointXs.length; i++) pointXs[i] = (i-pointXs.length/2) * block_size;
  } else {
    for (int i=0; i<pointXs.length; i++) pointXs[i] = (i-pointXs.length/2 - 0.5) * block_size;
  }
  if (pointYs.length%2 == 1) {
    for (int i=0; i<pointYs.length; i++) pointYs[i] = (i-pointYs.length/2) * block_size;
  } else {
    for (int i=0; i<pointYs.length; i++) pointYs[i] = (i-pointYs.length/2 - 0.5) * block_size;
  }
  if (pointZs.length%2 == 1) {
    for (int i=0; i<pointZs.length; i++) pointZs[i] = (i-pointZs.length/2) * block_size;
  } else {
    for (int i=0; i<pointZs.length; i++) pointZs[i] = (i-pointZs.length/2 - 0.5) * block_size;
  }
}

void makeVertex() {
  int a=0, b=0, c=0;
  for (int i=0; i < number_of_vertexes; i++) {
    boolean overlapped = true;
    while (overlapped) {
      a = (int)(random(pointXs.length));
      b = (int)(random(pointYs.length));
      c = (int)(random(pointZs.length));
      for (int j=0; j<=i; j++) {
        if (j==i) {
          overlapped=false;
          break;
        } else if (ver[j].x == pointXs[a] && ver[j].y == pointYs[b] && ver[j].z == pointZs[c]) {
          break;
        }
      }
    }
    if (i==0 || (i+1)%(number_of_vertexes/3)==0) {
      Startpoint temp = new Startpoint(pointXs[a], pointYs[b], pointZs[c], ball_size, (i+1)/(number_of_vertexes/3));
      ver[i] = temp;
      startpoints.add(temp);
    } else {
      ver[i] = new Vertex(pointXs[a], pointYs[b], pointZs[c], ball_size);
    }
  }
}

void printOption1() {
  println("--------------------------------------------");
  println("Select startpoint");
  println("Startpoint's color == RED    : press '1' key");
  println("Startpoint's color == GREEN  : press '2' key");
  println("Startpoint's color == BLUE   : press '3' key");
  println("Startpoint's color == PURPLE : press '4' key");
  println("--------------------------------------------");
}
void printOption2() {
  println("Select line");
  println("Line's color == RED    : press '1' key");
  println("Line's color == GREEN  : press '2' key");
  println("Line's color == BLUE   : press '3' key");
  println("Line's color == PURPLE : press '4' key");
  println("--------------------------------------");
}

void drawBorderLine() {
  strokeWeight(1);
  stroke(borderLineCol);
  for (float z : pointZs) {
    for (float x : pointXs) line(x, pointYs[0], z, x, pointYs[pointYs.length-1], z);
    for (float y : pointYs) line(pointXs[0], y, z, pointXs[pointXs.length-1], y, z);
  }
  for (float x : pointXs) {
    for (float y : pointYs) line(x, y, pointZs[0], x, y, pointZs[pointZs.length - 1]);
  }
}

void drawLine() {
  if (started) {
    for (int i=0; i<number_of_vertexes; i++) {
      if (ver[i] != cur) {
        for (Line line : ver[i].lines) {
          line.display();
        }
      }
    }
    for (Line line : cur.lines) {
      line.display();
    }
  } else {
    for (int i=0; i<number_of_vertexes; i++) {
      for (Line line : ver[i].lines) {
        line.display();
      }
    }
  }
}

void drawVertex() {
  strokeWeight(4);
  stroke(0);
  for (int i=0; i<number_of_vertexes; i++) {
    ver[i].display();
  }
}

void printText() {
  textSize(300);
  if (gameClear) {
    background(gameClearCol);
    fill(gameClearText);
    text("GameClear", 0, 0);
  } else if (gameOver) {
    background(gameOverCol);
    fill(gameOverText);
    text("GameOver", 0, 0);
  }
}

void updatePlayScreen(int nextIndex) {
  if (cur == null) {
    for (Startpoint startpoint : startpoints) {
      if (startpoint.startpointIndex == nextIndex-1) {
        cur = startpoint;
        cur.state = 1;
        started = true;
        printOption2();
      }
    }
    for (Startpoint startpoint : startpoints ) {
      startpoint.started = true;
    }
  } else {
    for (Line line : cur.lines) {
      if (line.passed) {
        continue;
      }
      if (line.index == nextIndex) {
        if (pre != null) {
          pre.state = 0;
        }
        pre = line.v1;
        pre.state = 2;
        cur = line.v2;
        cur.state = 1;
        line.passed=true;
        for (Line line2 : cur.lines) {
          if (line2.v2 == pre) {
            line2.passed = true;
          }
        }
        pre.checkConnected();
        cur.checkConnected();
        cur.updateLinesIndex();
        if (judgeGameClear()) {
          gameClear = true;
          println("GameClear");
          println("---------");
        } else if ( judgeGameOver()) {
          gameOver = true;
          println("GameOver");
          println("--------");
        }
        break;
      }
    }
  }
}

boolean judgeGameClear() {
  for (Vertex v : ver) {
    for (Line line : v.lines) {
      if (!line.passed) return false;
    }
  }
  return true;
}
boolean judgeGameOver() {
  if (cur.deleted == true) return true;
  else return false;
}
