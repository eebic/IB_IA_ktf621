# Internal Assessment
Candidate Code: ktf621

## <ins>Protein Sequence Analysis<ins>

**Basic Concept:** RNA (or DNA that can be transcribed into RNA) will be input by the user. This program will then analyze the protein sequence derived from the RNA and can predict secondary structures or motifs.

**Purpose:** The purpose of this program is to make the analysis of RNA, DNA, and protein structures faster and more accurate, as current methods—especially those used in high school and middle school classes—are time-consuming, energy-intensive, and prone to human error.

## Logic Flow Diagram

<img src="https://github.com/eebic/InternalAssessment/blob/main/img/IA_Logic_Flow_Diagram.png?raw=true" width="700" />

## Mockup

<img src="https://github.com/eebic/InternalAssessment/blob/main/img/IA_Mockup.png?raw=true" width="900" />

// Additional global state for protein input mode
boolean isProteinSelected = false;

// In drawStrandSelectionScreen(), add third option
void drawStrandSelectionScreen() {
  text("Choose input type:", 20, 40);
  drawButton(20, 60, 150, 40, "DNA Strand", isMouseOver(20, 60, 150, 40));
  drawButton(200, 60, 150, 40, "RNA Strand", isMouseOver(200, 60, 150, 40));
  drawButton(380, 60, 200, 40, "Protein Sequence", isMouseOver(380, 60, 200, 40));
  text("Character limit: 300 bases", 20, 130);
}

// In mousePressed() -> strand selection section, add:
if (isMouseOver(380, 60, 200, 40)) {
  isProteinSelected = true;
  isDNASelected = false;
  isRNASelected = false;
  hasChosenStrandType = true;
}

// New block in drawInputScreen() for protein input
if (isProteinSelected) {
  text("Enter Protein Sequence (3-letter abbreviations):", 20, 80);
  boolean hoveringBox = isMouseOver(20, 90, 700, 30);
  inputBoxSelected = hoveringBox || inputBoxSelected;
  fill(hoveringBox || inputBoxSelected ? color(200) : 240);
  stroke(0);
  rect(20, 90, 700, 30, 6);
  fill(50);
  text(inputStrand + (showCursor && inputBoxSelected ? "|" : ""), 25, 110);

  // Example
  fill(100);
  textSize(12);
  text("Example: Met Gly Ala Leu Leu Leu Pro Phe Gly Pro", 25, 135);
  text("Click to copy", 600, 135);

  // Buttons
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

  int y = 170;
  textSize(16);
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
