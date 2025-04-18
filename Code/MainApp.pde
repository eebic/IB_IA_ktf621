void setup() {
  size(800, 600);
  textSize(16);
}

void draw() {
  background(255);
  fill(0);

  if (!hasChosenStrandType) {
    drawStrandSelectionScreen();
  } else if (showMutationPage) {
    drawMutationScreen();
  } else {
    drawInputScreen();
  }
}
