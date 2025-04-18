import java.util.ArrayList;

DNASequence dnaSeq;
RNASequence rnaSeq;
Protein protein;

boolean inputBoxSelected = false;
int blinkCounter = 0;
boolean showCursor = true;

String inputStrand = "";
String rnaOutput = "";
String proteinOutput = "";
ArrayList<String> features = new ArrayList<String>();

boolean isDNASelected = false;
boolean isRNASelected = false;
boolean hasChosenStrandType = false;

int maxLength = 300;

void setup() {
  size(800, 600);
  textSize(16);
}

void draw() {
  background(255);
  fill(0);

  if (!hasChosenStrandType) {
    drawStrandSelectionScreen();
  } else {
    drawInputScreen();
  }
}

void drawStrandSelectionScreen() {
  text("Choose input type:", 20, 40);
  drawButton(20, 60, 150, 40, "DNA Strand", isMouseOver(20, 60, 150, 40));
  drawButton(200, 60, 150, 40, "RNA Strand", isMouseOver(200, 60, 150, 40));
  text("Character limit: 300 bases", 20, 130);
}

void drawInputScreen() {
  background(255);
  fill(0);

  int backX = 20, backY = 20, backW = 160, backH = 35;
  boolean backHover = isMouseOver(backX, backY, backW, backH);
  fill(backHover ? color(200) : 240);
  stroke(100);
  rect(backX, backY, backW, backH, 10);
  fill(50);
  textSize(14);
  text("← Back to Home", backX + 20, backY + 22);

  textSize(16);
  String label = isDNASelected ? "Enter DNA Strand:" : "Enter RNA Strand:";
  text(label, 20, 80);

  boolean hoveringBox = isMouseOver(20, 90, 700, 30);
  inputBoxSelected = hoveringBox || inputBoxSelected;
  fill(hoveringBox || inputBoxSelected ? color(200) : 240);
  stroke(0);
  rect(20, 90, 700, 30, 6);

  fill(50);
  String groupedStrand = groupBases(inputStrand);
  text(groupedStrand + (showCursor && inputBoxSelected ? "|" : ""), 25, 110);

  fill(100);
  textSize(12);
  if (isDNASelected) {
    text("Example: " + groupBases("ATGGGTGCTCTGCTGCTGCCTTTGGGCCCTGGTGCGGACTGA"), 25, 135);
    text("(Click to copy)", 400, 135);
  } else if (isRNASelected) {
    text("Example: " + groupBases("AUGCCUACCGGAUUAUUUGGUUUCUGCCCGGGUGAUUGA"), 25, 135);
    text("(Click to copy)", 400, 135);
  }

  int btnY = 135, btnW = 80, btnH = 30;
  int enterX = 620, clearX = 710;
  boolean enterHover = isMouseOver(enterX, btnY, btnW, btnH);
  boolean clearHover = isMouseOver(clearX, btnY, btnW, btnH);

  fill(enterHover ? color(180, 220, 180) : 240);
  stroke(0);
  rect(enterX, btnY, btnW, btnH, 6);
  fill(0);
  text("Enter", enterX + 22, btnY + 20);

  fill(clearHover ? color(255, 230, 230) : 240);
  stroke(0);
  rect(clearX, btnY, btnW, btnH, 6);
  fill(0);
  text("Clear", clearX + 22, btnY + 20);

  blinkCounter++;
  if (blinkCounter % 30 == 0) showCursor = !showCursor;

  int y = 170;
  textSize(16);

  if (isDNASelected) {
    text("RNA Sequence:", 20, y);
    text(wrapText(groupBases(rnaOutput), 60), 25, y + 20);
    y += 100;
  }

  text("Protein Sequence:", 20, y);
  text(wrapText(proteinOutput, 60), 25, y + 20);
  y += 100;

  text("Protein Features:", 20, y);
  int itemsPerColumn = 15;
  int featureX = 25;
  int featureY = y + 20;

  for (int i = 0; i < features.size(); i++) {
    int col = i / itemsPerColumn;
    int row = i % itemsPerColumn;

    int x = featureX + col * 350;
    int yOffset = featureY + row * 20;

    text("- " + features.get(i), x, yOffset);
  }

  int saveY = featureY + ((features.size() > itemsPerColumn) ? itemsPerColumn : features.size()) * 20 + 40;
  boolean saveHover = isMouseOver(20, saveY, 160, 35);
  fill(saveHover ? color(200) : 240);
  stroke(0);
  rect(20, saveY, 160, 35, 8);
  fill(0);
  textSize(14);
  text("💾 Save Sequence", 30, saveY + 22);
}

String groupBases(String s) {
  StringBuilder sb = new StringBuilder();
  for (int i = 0; i < s.length(); i++) {
    sb.append(s.charAt(i));
    if ((i + 1) % 3 == 0 && i != s.length() - 1) sb.append(" ");
  }
  return sb.toString();
}

String wrapText(String input, int lineLength) {
  StringBuilder wrapped = new StringBuilder();
  for (int i = 0; i < input.length(); i += lineLength) {
    int end = min(i + lineLength, input.length());
    wrapped.append(input.substring(i, end)).append("\n");
  }
  return wrapped.toString().trim();
}

void keyPressed() {
  if (!hasChosenStrandType || !inputBoxSelected) return;
  if (key == CODED) return;

  if (keyCode == BACKSPACE && inputStrand.length() > 0) {
    inputStrand = inputStrand.substring(0, inputStrand.length() - 1);
  } else if (keyCode == ENTER) {
    processSequence();
  } else if (inputStrand.length() < maxLength && Character.isLetter(key)) {
    char base = Character.toUpperCase(key);
    if ((isDNASelected && "ATGC".indexOf(base) >= 0) || (isRNASelected && "AUGC".indexOf(base) >= 0)) {
      inputStrand += base;
    }
  }
}

void mousePressed() {
  if (!hasChosenStrandType) {
    if (isMouseOver(20, 60, 150, 40)) {
      isDNASelected = true;
      isRNASelected = false;
      hasChosenStrandType = true;
    } else if (isMouseOver(200, 60, 150, 40)) {
      isRNASelected = true;
      isDNASelected = false;
      hasChosenStrandType = true;
    }
  } else {
    if (isMouseOver(20, 20, 160, 35)) {
      hasChosenStrandType = false;
      isDNASelected = false;
      isRNASelected = false;
      inputStrand = "";
      rnaOutput = "";
      proteinOutput = "";
      features.clear();
      inputBoxSelected = false;
      return;
    }

    inputBoxSelected = isMouseOver(20, 90, 700, 30);

    if (isMouseOver(25, 125, 700, 20)) {
      if (isDNASelected) inputStrand = "ATGGGTGCTCTGCTGCTGCCTTTGGGCCCTGGTGCGGACTGA";
      if (isRNASelected) inputStrand = "AUGCCUACCGGAUUAUUUGGUUUCUGCCCGGGUGAUUGA";
      rnaOutput = "";
      proteinOutput = "";
      features.clear();
    }

    if (isMouseOver(620, 135, 80, 30)) processSequence();
    if (isMouseOver(710, 135, 80, 30)) {
      inputStrand = "";
      rnaOutput = "";
      proteinOutput = "";
      features.clear();
    }

    int saveY = 500 + features.size() * 20;
    if (isMouseOver(20, saveY, 160, 35)) {
      String saveData = "Original Strand (" + (isDNASelected ? "DNA" : "RNA") + "):\n" +
                        groupBases(inputStrand) + "\n\n" +
                        (isDNASelected ? "Transcribed RNA:\n" + groupBases(rnaOutput) + "\n\n" : "") +
                        "Protein Sequence:\n" + proteinOutput + "\n\n" +
                        "Protein Features:\n";
      for (String f : features) saveData += "- " + f + "\n";
      saveStrings("protein_sequence.txt", split(saveData, "\n"));
    }
  }
}

void processSequence() {
  if (isDNASelected) {
    dnaSeq = new DNASequence(inputStrand.toUpperCase());
    rnaSeq = new RNASequence(dnaSeq.transcribe());
  } else {
    rnaSeq = new RNASequence(inputStrand.toUpperCase());
  }
  protein = new Protein(rnaSeq.translate());
  rnaOutput = rnaSeq.getSequence();
  proteinOutput = protein.getSequence();
  features = protein.analyzeFeatures();
}

boolean isMouseOver(int x, int y, int w, int h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}

void drawButton(int x, int y, int w, int h, String label, boolean hovered) {
  fill(hovered ? color(180, 220, 180) : 200);
  stroke(0);
  rect(x, y, w, h, 10);
  fill(0);
  text(label, x + 20, y + 25);
}
