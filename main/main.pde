import processing.opengl.*;

int side_length = 50; // danger < 40, set 60 over
float ball_size = side_length * 0.5;
int number_of_vertexes = 10;
int number_of_squaresX, number_of_squaresY;
int textbox_rectCount = 3;
int[] pointXs, pointYs;
boolean gameClear, gameOver;

Vertex[] v = new Vertex[number_of_vertexes];
Vertex cur, pre;
Button hintButton ;

void setup() {
  size(2000, 1500);
  makePointXY();
  makeVertexes();
  v[0].makeLine(v);
  makeButton();
  textAlign(CENTER, CENTER);
  for(int i=0;i<number_of_vertexes;i++){
    print(v[i].lines.size() + " ");
  }
}

void draw() {
  background(255);
  //drawBorderLine();
  drawLine();
  drawVertex();
  drawButton();
  printText();
}

void mouseClicked() {
  updatePlayScreen();
  checkButton();
}

void makePointXY() {
  number_of_squaresX = width/side_length;
  number_of_squaresY = height/side_length - textbox_rectCount;
  pointXs = new int[number_of_squaresX - 1];
  pointYs = new int[number_of_squaresY - 1];

  for (int i=0; i < pointXs.length; i++) {
    pointXs[i] = (i+1) * side_length;
  }
  for (int i=0; i < pointYs.length; i++) {
    pointYs[i] = (i+1) * side_length;
  }
}

void makeVertexes() {
  int a=0, b=0;
  for (int i=0; i < number_of_vertexes; i++) {
    boolean overlaped = true;
    while (overlaped) {
      a = (int)(random(pointXs.length));
      b = (int)(random(pointYs.length));
      for (int j=0; j<=i; j++) {
        if (j==i) {
          overlaped=false;
          break;
        } else if (v[j].x == pointXs[a] && v[j].y == pointYs[b]) {
          break;
        }
      }
    }
    if(i==0) v[i] = new Startpoint(pointXs[a], pointYs[b], ball_size, i);
    else v[i] = new Vertex(pointXs[a], pointYs[b], ball_size, i);
  }
}

void makeButton() {
  hintButton = new Button(
    0, height - side_length * textbox_rectCount, width/5, side_length * textbox_rectCount, "HINT");
}

void drawBorderLine() {
  strokeWeight(1);
  stroke(0);
  for (int x : pointXs) {
    line(x, 0, x, height - (side_length * textbox_rectCount));
  }
  for (int y : pointYs) {
    line(0, y, width, y);
  }
}

void drawLine() {
  for (int i=0; i< number_of_vertexes; i++) {
    for (Line line : v[i].lines) {
      line.display();
    }
  }
}

void drawVertex() {
  strokeWeight(4);
  stroke(0);
  for (int i=0; i < number_of_vertexes; i++) {
    v[i].display();
  }
}

void drawButton() {
  hintButton.display(mouseX, mouseY);
}

void printText() {
  strokeWeight(5);
  stroke(0);
  line(0, height - (side_length * textbox_rectCount), width, height - (side_length * textbox_rectCount));
  fill(0);
  textSize(60);
  if (gameClear) {
    text("GameClear", width/2, height - (side_length * textbox_rectCount) / 2);
  } else if (gameOver) {
    text("GameOver", width/2, height - (side_length * textbox_rectCount) / 2);
  } else {
    text("Incomplete", width/2, height - (side_length * textbox_rectCount) / 2);
  }
}

void updatePlayScreen() {
  if (cur==null) {
    for (int i=0; i<number_of_vertexes; i++) {
      if (v[i].judgeClicked(mouseX, mouseY)) {
        cur = v[i];
        cur.state = 1;
        break;
      }
    }
  } else {
    for (Line line : cur.lines) {
      if (line.passed) {
        continue;
      }
      if (line.v2.judgeClicked(mouseX, mouseY)) {
        if (pre != null) {
          pre.state = 0;
        }
        pre = cur;
        pre.state = 2;
        cur = line.v2;
        cur.state = 1;
        line.passed=true;
        for (Line line2 : cur.lines) {
          if (line2.v2 == pre) {
            line2.passed = true;
          }
        }
        gameClear = judgeGameCleared();
        gameOver = judgeGameOver();
        break;
      }
    }
  }
}

void checkButton() {
  if (hintButton.isInside(mouseX, mouseY)) {
    hintButton.pushed = true;
  }
}

boolean judgeGameCleared() {
  for (int i=0; i<number_of_vertexes; i++) {
    for (Line line : v[i].lines) {
      if (!line.passed) {
        return false;
      }
    }
  }
  return true;
}

boolean judgeGameOver() {
  for (Line line : cur.lines) {
    if (!line.passed) {
      return false;
    }
  }
  return true;
}
