// Logic & UI

void drawStrandSelectionScreen() {
  background(255);
  fill(0);

  // Header
  textAlign(LEFT, CENTER);
  textSize(24);
  text("Choose input type:", 30, 40);

  // Buttons
  drawButton(30, 80, 150, 45, "DNA Strand", isMouseOver(30, 80, 150, 45));
  drawButton(200, 80, 150, 45, "RNA Strand", isMouseOver(200, 80, 150, 45));
  drawButton(370, 80, 200, 45, "Protein Sequence", isMouseOver(370, 80, 200, 45));

  textSize(18);
  text("Character limit: 300 bases", 125, 165);
}



void drawInputScreen() {
  if (showMutationPage) {
    drawMutationScreen();
    return;
  }

  background(255);
  fill(0);

  // Back to Home button
  boolean backHover = isMouseOver(20, 20, 180, 40);
  fill(backHover ? color(200) : 240);
  stroke(0);
  rect(20, 20, 180, 40, 10);
  fill(0);
  textSize(20);
  textAlign(LEFT, CENTER);
  text("   ←  Back to Home", 30, 40);

  // Input label
  textSize(16);
  String label = isDNASelected ? "Enter DNA Strand:" :
                 isRNASelected ? "Enter RNA Strand:" :
                 "Enter Protein Sequence (3-letter):";
  text(label, 20, 80);

  // Input box
  boolean hoveringBox = isMouseOver(20, 90, 700, 40);
  inputBoxSelected = hoveringBox || inputBoxSelected;
  fill(hoveringBox || inputBoxSelected ? color(200) : 240);
  stroke(0);
  rect(20, 90, 700, 40, 6);
  fill(50);
  textAlign(LEFT, CENTER);
  text(inputStrand + (showCursor && inputBoxSelected ? "|" : ""), 25, 110);

  // Example strands
  fill(100);
  textSize(12);
  if (isDNASelected) text("Example: " + groupBases("ATGGGTGCTCTGCTGCTGCCTTTGGGCCCTGGTGCGGACTGA"), 25, 145);
  else if (isRNASelected) text("Example: " + groupBases("AUGCCUACCGGAUUAUUUGGUUUCUGCCCGGGUGAUUGA"), 25, 145);
  else if (isProteinSelected) text("Example: Met Gly Ala Leu Leu Leu Pro Phe Gly Pro", 25, 145);
  text("(Click to copy example)", 600, 145);

  // Enter + Clear buttons
  drawButton(610, 160, 80, 35, "Enter", isMouseOver(610, 160, 80, 35));
  drawButton(700, 160, 80, 35, "Clear", isMouseOver(700, 160, 80, 35));

  // Blinking cursor
  blinkCounter++;
  if (blinkCounter % 30 == 0) showCursor = !showCursor;

  int y = 210;
  textAlign(LEFT, BASELINE);

  if (isDNASelected) {
    text("RNA Sequence:", 20, y);
    text(wrapText(groupBases(rnaOutput), 60), 25, y + 20);
    y += 60;
  }

  text("Protein Sequence:", 20, y);
  text(wrapText(proteinOutput, 60), 25, y + 20);
  y += 60;

  text("Protein Features:", 20, y);
  y += 20;

  // Feature display
  int colWidth = 400;  
  int colX = 25;
  int lineH = 20;
  int row = 0;
  for (int i = 0; i < features.size(); i++) {
    text("- " + features.get(i), colX, y + row * lineH);
    row++;
    if ((y + (row + 1) * lineH) > height - 50) {
      row = 0;
      colX += colWidth;
    }
  }

  // Apply Mutation button (only for DNA or RNA pages)
  if (!isProteinSelected) {
    drawButton(20, height - 50, 180, 35, "Apply Mutation", isMouseOver(20, height - 50, 180, 35));
  }
}



void mousePressed() {
  if (!hasChosenStrandType) {
    if (isMouseOver(30, 80, 150, 45)) {
      isDNASelected = true; isRNASelected = false; isProteinSelected = false; hasChosenStrandType = true;
    } else if (isMouseOver(200, 80, 150, 45)) {
      isRNASelected = true; isDNASelected = false; isProteinSelected = false; hasChosenStrandType = true;
    } else if (isMouseOver(370, 80, 200, 45)) {
      isProteinSelected = true; isRNASelected = false; isDNASelected = false; hasChosenStrandType = true;
    }
  } else if (!showMutationPage) {
    if (isMouseOver(20, 20, 180, 40)) {
      // Reset home navigation
      hasChosenStrandType = false;
      isDNASelected = false;
      isRNASelected = false;
      isProteinSelected = false;
    
      // Clear strand data
      inputStrand = "";
      rnaOutput = "";
      proteinOutput = "";
      features.clear();
    
      // Reset mutation screen
      showMutationPage = false;
      originalStrand = "";
      oldProteinOutput = "";
      mutationPositionInput = "";
      mutationValue = "";
      positionBoxSelected = false;
      valueBoxSelected = false;
      selectedMutationIndex = -1;
      mutationType = "Point";  // default mutation type
    }

    if (isMouseOver(25, 125, 700, 20)) {
      inputStrand = isDNASelected ? groupBases("ATGGGTGCTCTGCTGCTGCCTTTGGGCCCTGGTGCGGACTGA") :
                    isRNASelected ? groupBases("AUGCCUACCGGAUUAUUUGGUUUCUGCCCGGGUGAUUGA") :
                    "Met Gly Ala Leu Leu Leu Pro Phe Gly Pro";
    }

    if (isMouseOver(620, 155, 80, 35)) processSequence();
    if (isMouseOver(710, 155, 80, 35)) {
      inputStrand = ""; rnaOutput = ""; proteinOutput = ""; features.clear();
    }

    // Only allow mutation page for DNA or RNA
    if ((isDNASelected || isRNASelected) && isMouseOver(20, height - 50, 180, 35)) {
      showMutationPage = true;
    }

    inputBoxSelected = isMouseOver(20, 90, 700, 40);
  } else {
    for (int i = 0; i < mutationOptions.length; i++) {
      int x = 20 + i * 130;
      if (isMouseOver(x, 60, 120, 30)) {
        selectedMutationIndex = i;
        mutationType = mutationOptions[i];
    
        // Reset to original unmutated strand
        inputStrand = originalStrand;
        processSequence();
    
        // Clear mutation inputs
        mutationPositionInput = "";
        mutationValue = "";
        positionBoxSelected = false;
        valueBoxSelected = false;
      }
    }

    positionBoxSelected = isMouseOver(100, 95, 60, 25);
    valueBoxSelected = !mutationType.equals("Deletion") && isMouseOver(280, 95, 60, 25);

    if (isMouseOver(20, 150, 120, 30)) {
      applyMutation();
    }

    if (isMouseOver(160, 150, 120, 30)) {
      showMutationPage = false;
    
      // Reset mutation input
      mutationPositionInput = "";
      mutationValue = "";
      positionBoxSelected = false;
      valueBoxSelected = false;
    
      // Reset strand back to original
      inputStrand = originalStrand;
      processSequence();  // Re-process to regenerate RNA & protein outputs
    }
  }
}



void keyPressed() {
  // Mutation Screen Input
  if (showMutationPage) {
    // Typing into Position Box
    if (positionBoxSelected) {
      if (keyCode == BACKSPACE && mutationPositionInput.length() > 0) {
        mutationPositionInput = mutationPositionInput.substring(0, mutationPositionInput.length() - 1);
      } else if (Character.isDigit(key) && key != '0') {
        mutationPositionInput += key;
      }
    }

    // Typing into new Value Box
    if (valueBoxSelected) {
      if (keyCode == BACKSPACE && mutationValue.length() > 0) {
        mutationValue = mutationValue.substring(0, mutationValue.length() - 1);
      } else if (mutationValue.length() < 1 && Character.isLetter(key)) {
        char base = Character.toUpperCase(key);
        if ((isDNASelected && "ATGC".indexOf(base) >= 0) ||
            (isRNASelected && "AUGC".indexOf(base) >= 0)) {
          mutationValue = String.valueOf(base);
        }
      }
    }

    return; 
  }

  // Input Screen typing
  if (!hasChosenStrandType || !inputBoxSelected) return;
  if (key == CODED) return;

  if (keyCode == BACKSPACE && inputStrand.length() > 0) {
    String raw = inputStrand.replace(" ", "");
    if (raw.length() > 0) {
      raw = raw.substring(0, raw.length() - 1);
      inputStrand = groupBases(raw);
    }
  } else if (keyCode == ENTER) {
    processSequence();
  } else if (inputStrand.length() < maxLength && Character.isLetter(key)) {
    char base = Character.toUpperCase(key);
    if ((isDNASelected && "ATGC".indexOf(base) >= 0) ||
        (isRNASelected && "AUGC".indexOf(base) >= 0)) {
      inputStrand = groupBases(inputStrand.replace(" ", "") + base);
    } else if (isProteinSelected && Character.isLetter(key)) {
        String raw = inputStrand.replace(" ", "") + key;
        inputStrand = groupAminoAcids(raw);
    }

  }
}



void drawMutationScreen() {
  background(255);
  textSize(18);
  fill(0);
  text("Mutation Page", 75, 30);

  // Mutation type buttons
  for (int i = 0; i < mutationOptions.length; i++) {
    int x = 20 + i * 130;
    drawButton(x, 60, 120, 30, mutationOptions[i], isMouseOver(x, 60, 120, 30) || selectedMutationIndex == i);
  }

  // Blinking cursor logic
  cursorBlinkTimer++;
  if (cursorBlinkTimer % 30 == 0) showCursor = !showCursor;

  // Position input
  textSize(14);
  textAlign(LEFT, CENTER);
  text("Position:", 20, 115);
  fill(positionBoxSelected ? color(200) : 240);
  stroke(0);
  rect(100, 103, 60, 25, 4);
  fill(0);
  text(mutationPositionInput + (positionBoxSelected && showCursor ? "|" : ""), 105, 115);

  // New value input
  if (!mutationType.equals("Deletion")) {
    text("New Value:", 180, 115);
    fill(valueBoxSelected ? color(200) : 240);
    stroke(0);
    rect(280, 103, 60, 25, 4);
    fill(0);
    text(mutationValue + (valueBoxSelected && showCursor ? "|" : ""), 285, 115);
  }

  // Apply + Back buttons
  textAlign(LEFT, BASELINE);
  drawButton(20, 150, 120, 30, "Apply", isMouseOver(20, 150, 120, 30));
  drawButton(160, 150, 120, 30, "← Back", isMouseOver(160, 150, 120, 30));

  // Sequence comparison
  if (!originalStrand.equals("")) {
    textSize(14);
    fill(0);
    text("Before:", 40, 200);
    text("After:", 35, 260);

    String cleanOriginal = originalStrand.replace(" ", "");
    String cleanMutated = inputStrand.replace(" ", "");

    int xStart = 25;
    int yBefore = 220;
    int yAfter = 280;
    int maxPerLine = 60;

    for (int i = 0; i < cleanOriginal.length(); i++) {
      int x = xStart + (i % maxPerLine) * 10;
      int yOffset = (i / maxPerLine) * 20;

      // Original
      fill(0);
      text(cleanOriginal.charAt(i), x, yBefore + yOffset);

      // Mutated
      char mutatedChar = i < cleanMutated.length() ? cleanMutated.charAt(i) : '-';
      fill((i >= cleanMutated.length() || mutatedChar != cleanOriginal.charAt(i)) ? color(255, 0, 0) : 0);
      text(mutatedChar, x, yAfter + yOffset);
    }
  }

  // Protein comparison using 2D array
  if (
    proteinComparison != null &&
    proteinComparison.length == 2 &&
    proteinComparison[0] != null &&
    proteinComparison[1] != null &&
    !isProteinSelected
  ) {
    textSize(14);
    fill(0);
    text("Protein Sequence Before:", 95, 335);
    text("Protein Sequence After:", 90, 395);

    int maxLen = max(proteinComparison[0].length, proteinComparison[1].length);
    for (int i = 0; i < maxLen; i++) {
      int x = 30 + (i % 18) * 42;
      int y1 = 360 + (i / 18) * 20;
      int y2 = 420 + (i / 18) * 20;

      // BEFORE
      if (i < proteinComparison[0].length) {
        fill(0);
        text(proteinComparison[0][i], x, y1);
      }

      // AFTER (highlight if different)
      if (i < proteinComparison[1].length) {
        boolean changed = (i >= proteinComparison[0].length || !proteinComparison[1][i].equals(proteinComparison[0][i]));
        fill(changed ? color(255, 0, 0) : 0);
        text(proteinComparison[1][i], x, y2);
      }
    }
  }
}



void processSequence() { 
  if (isDNASelected) {
    dnaSeq = new DNASequence(inputStrand.replace(" ", "").toUpperCase());
    rnaSeq = new RNASequence(dnaSeq.transcribe());
    protein = new Protein(rnaSeq.translate());
    rnaOutput = rnaSeq.getSequence();
  } else if (isRNASelected) {
    rnaSeq = new RNASequence(inputStrand.replace(" ", "").toUpperCase());
    protein = new Protein(rnaSeq.translate());
    rnaOutput = rnaSeq.getSequence();
  } else if (isProteinSelected) {
    protein = new Protein(inputStrand.trim());
  }


  if (originalStrand.equals("")) {
    originalStrand = inputStrand;
  }

  proteinOutput = protein.getSequence();
  features = protein.analyzeFeatures();
}



void applyMutation() {
  if (isProteinSelected) return;
  if (mutationPositionInput.equals("")) return;

  try {
    int pos = Integer.parseInt(mutationPositionInput) - 1;
    if (pos < 0) return;

    String raw = originalStrand.replace(" ", "");
    int rawLength = raw.length();

    if ((mutationType.equals("Point") || mutationType.equals("Deletion")) && pos >= rawLength) {
      println("Mutation position too large.");
      return;
    }
    if (mutationType.equals("Insertion") && pos > rawLength) {
      println("Insertion position out of bounds.");
      return;
    }

    // for safety: make sure proteinOutput exists first bc i dealt with too way many nullpointer exceptions
    if (proteinOutput == null || proteinOutput.trim().equals("")) {
      println("Protein output not available — cannot apply mutation.");
      return;
    }

    // store pre-mutation version
    String before = proteinOutput.trim();

    // Apply mutation to original
    StringBuilder sb = new StringBuilder(raw);

    if (mutationType.equals("Point")) {
      sb.setCharAt(pos, mutationValue.charAt(0));
    } else if (mutationType.equals("Deletion")) {
      sb.deleteCharAt(pos);
    } else if (mutationType.equals("Insertion")) {
      sb.insert(pos, mutationValue);
    }

    inputStrand = groupBases(sb.toString());
    processSequence();  // sets proteinOutput again

    // Only assigns to 2D array if both are safe
    if (proteinOutput != null && !proteinOutput.trim().equals("")) {
      proteinComparison = new String[2][];
      proteinComparison[0] = before.split(" ");
      proteinComparison[1] = proteinOutput.trim().split(" ");
    } else {
      println("New protein output invalid — skipping comparison array.");
    }

  } catch (NumberFormatException e) {
    println("Position input is not a valid number.");
  } catch (Exception e) {
    println("Unexpected mutation error: " + e.getMessage());
  }
}
