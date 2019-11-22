import processing.serial.*;

Serial serial;
String serialText;

int dist1, dist2;

int dist1min = 0, dist1max = 300, dist2min = 0, dist2max = 300;

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
}

void draw() {
  readDistances();


  fill(0);
  text("Calibrage:", 10, 20);
  for (int i = 0; i < 4; i++) {
    buttons[i].draw();
    if (mousePressed && buttons[i].hover()) {
      switch (i) {
      case 0:
        dist1min = dist1;
        break;
      case 1:
        dist1max = dist1;
        break;
      case 2:
        dist2min = dist2;
        break;
      case 3:
        dist2max = dist2;
        break;
      }
    }
  }
}

void readDistances() {
  if (serial.available() > 0) {
    String serialText = serial.readStringUntil('\n');

    if (serialText == null)
      return;

    print("serialText: " + serialText);

    String[] distances = serialText.split(",");

    if (distances.length < 2)
      return;

    dist1 = int(distances[0]);
    dist2 = int(distances[1]);

    println("dist1: " + dist1+", dist2: " + dist2 + "\n");
  }
}
