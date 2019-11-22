class Ball {
  float x, y;

  float diameter;

  float speed;
  float baseSpeed;
  float speedIncrease;

  float angle;
  float maxAngle = 75;
  int xDir = 1;

  Score score;

  // instead of bouncing on the top/bottom of the screen, wrap to the other side
  boolean wrap = false;

  Ball(float x, float y, float diameter, float baseSpeed, float speedIncrease, Score score) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;

    this.baseSpeed = baseSpeed;
    this.speedIncrease = speedIncrease;

    this.score = score;
  }

  float top() {
    return y - diameter/2;
  }
  float bottom() {
    return y + diameter/2;
  }
  float left() {
    return x - diameter/2;
  }
  float right() {
    return x + diameter/2;
  }

  void draw() {
    fill(255, 0, 0);
    stroke(0);
    circle(x, y, diameter);
  }

  void tick(float y1, float y2, float paddlePixels) {
    x += xDir * speed * cos(radians(angle)) / frameRate;
    y += speed * sin(radians(angle)) / frameRate;

    if (wrap) {
      if (y < 0) {
        y += displayHeight;
      }
      if (y >= displayHeight) {
        y -= displayHeight;
      }
    } else {
      if (top() <= 0) {
        y = diameter / 2;
        speed += speedIncrease;
        angle = -angle;
      }
      if (bottom() >= displayHeight) {
        y = displayHeight - diameter / 2;
        speed += speedIncrease;
        angle = -angle;
      }
    }
    if (left() <= 0) {
      x = diameter / 2;
      if (bottom() < y1 || top() > y1 + paddlePixels) {
        score.player2 += 1;
        reset();
      } else {
        speed += speedIncrease;
        xDir = -xDir;
        angle = map(y, y1, y1 + paddlePixels, -maxAngle, maxAngle);
      }
    }
    if (right() >= displayWidth) {
      x = displayWidth - diameter / 2;
      if (bottom() < y2 || top() > y2 + paddlePixels) {
        score.player1 += 1;
        reset();
      } else {
        speed += speedIncrease;
        xDir = -xDir;
        angle = map(y, y2, y2 + paddlePixels, -maxAngle, maxAngle);
      }
    }
  }

  void reset() {
    x = displayWidth / 2;
    y = displayHeight / 2;
    this.speed = baseSpeed;
    this.angle = random(-maxAngle, maxAngle);
    this.xDir = random(1) > 0.5 ? -1 : 1;
  }
}
