class Score {
  int player1 = 0;
  int player2 = 0;

  int pointsToWin;

  Score(int pointsToWin) {
    this.pointsToWin = pointsToWin;
  }

  void draw() {
    fill(0);
    textAlign(CENTER);
    textSize(16);
    text("Points pour gagner: " + pointsToWin, displayWidth/2, 20);
    textSize(60);
    text(score.player1 + " - " + score.player2, displayWidth/2, 80);
  }
}
