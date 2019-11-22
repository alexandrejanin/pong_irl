import java.util.function.*;

class Button {
  String label;
  int x, y;
  int width, height;
  boolean pressed;

  public Button(String label, int x, int y, int width, int height) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  public void draw() {
    int bgColor = hover() ? 0 : 255;
    int textColor = hover() ? 255 : 0;
    stroke(textColor);
    fill(bgColor);
    rect(x, y, width, height);
    fill(textColor);
    textAlign(CENTER);
    text(label, x + 3, y + 3, width, height);
  }

  private boolean hover() {
    return mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height;
  }
}
