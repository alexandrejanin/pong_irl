import processing.serial.*;

// Height of a paddle in millimeters
float paddleHeight = 80;

Serial serial;
String serialText;

float dist1, dist2;
float paddlePixels;
float dist1min = 0, dist1max = 0, dist2min = 0, dist2max = 0;

boolean bot1 = false;
boolean bot2 = false;

boolean drawPaddles = false;

Score score = new Score(5);

Ball ball = new Ball(displayWidth/2, displayHeight/2, 40, 500, 50, score);

Button[] buttons = {
  new Button("Haut Gauche", 10, 30, 80, 20), 
  new Button("Bas Gauche", 10, 60, 80, 20), 
  new Button("Haut Droite", 100, 30, 80, 20), 
  new Button("Bas Droite", 100, 60, 80, 20), 
};

void setup() {
  String portName = Serial.list()[0];
  serial = new Serial(this, portName, 9600);

  fullScreen();

  ball.reset();
}

void draw() {
  background(169, 215, 235);

  fill(0);

  // get paddle coordinates
  float y1 = map(dist1, dist1min, dist1max, 0, displayHeight - paddlePixels);
  float y2 = map(dist2, dist2min, dist2max, 0, displayHeight - paddlePixels);

  if (bot1)
    y1 = ball.y - random(paddlePixels); 

  if (bot2)
    y2 = ball.y - random(paddlePixels);

  fill(0);
  textSize(12);

  textAlign(LEFT);
  text("dist1:"+dist1, 0, displayHeight - 80 );
  text("dist1min:"+dist1min, 0, displayHeight - 60 );
  text("dist1max:"+dist1max, 0, displayHeight - 40 );
  text("paddlePixels:"+paddlePixels, 0, displayHeight - 20 );

  textAlign(RIGHT);
  text("dist2:"+dist2, displayWidth, displayHeight - 80 );
  text("dist2min:"+dist2min, displayWidth, displayHeight - 60 );
  text("dist2max:"+dist2max, displayWidth, displayHeight - 40 );
  text("paddlePixels:"+paddlePixels, displayWidth, displayHeight - 20 );

  textAlign(LEFT);
  text("Calibrage:", 10, 20);

  for (int i = 0; i < 4; i++) {
    buttons[i].draw();
    if (mousePressed && buttons[i].hover()) {
      float pixelsPerMm;
      switch (i) {
      case 0:
        dist1min = dist1; 
        pixelsPerMm = displayHeight / (dist1max + paddleHeight - dist1min) ;
        paddlePixels = pixelsPerMm * paddleHeight;
        break;
      case 1:
        dist1max = dist1;
        pixelsPerMm = displayHeight / (dist1max + paddleHeight - dist1min) ;
        paddlePixels = pixelsPerMm * paddleHeight;
        break;
      case 2:
        dist2min = dist2;
        pixelsPerMm = displayHeight / (dist2max + paddleHeight - dist2min) ;
        paddlePixels = pixelsPerMm * paddleHeight;
        break;
      case 3:
        dist2max = dist2;
        pixelsPerMm = displayHeight / (dist2max + paddleHeight - dist2min) ;
        paddlePixels = pixelsPerMm * paddleHeight;
        break;
      }
    }
  }

  score.draw();
  
  textAlign(CENTER);
  textSize(16);
  text("Vitesse: " + ball.speed, displayWidth/2, displayHeight - 20);

  // draw paddles
  if (drawPaddles) {
    rect(0, y1, 4, paddlePixels);
    rect(displayWidth - 4, y2, 4, paddlePixels);
  }

  // draw ball
  if (dist1min ==0 || dist1max == 0 || dist2min == 0 || dist2max == 0) {
    textAlign(CENTER);
    textSize(20);
    text("Veuillez calibrer les capteurs", displayWidth/2, displayHeight/2 + 40);
    ball.reset();
  } else {
    ball.tick(y1, y2, paddlePixels);
  }

  ball.draw();
}

void keyPressed() {
  if (key == '1') {
    bot1 = !bot1;
  }
  if (key == '2') {
    bot2 = !bot2;
  }
  if (key == 'p') {
    drawPaddles = !drawPaddles;
  }
}

void serialEvent(Serial serial) {
  String serialText = serial.readStringUntil('\n');
  if (serialText != null) {
    //println("serialEvent: " + serialText);
    String[] distances = serialText.split(",");

    if (distances.length != 2)
      return;

    dist1 = float(distances[0]);
    dist2 = float(distances[1]);

    //println("dist1: " + dist1 + ", dist2: " + dist2 + "\n");
  }
}
