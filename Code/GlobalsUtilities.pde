// Globals & utilities

// -------------------GLOBALS----------------------

String[][] proteinComparison = new String[2][];

DNASequence dnaSeq;
RNASequence rnaSeq;
Protein protein;

String originalStrand = "";
String oldProteinOutput = "";

boolean positionBoxSelected = false;
boolean valueBoxSelected = false;

int cursorBlinkTimer = 0;
boolean showCursor = true;

boolean inputBoxSelected = false;
int blinkCounter = 0;

String inputStrand = "";
String rnaOutput = "";
String proteinOutput = "";
ArrayList<String> features = new ArrayList<String>();

boolean isDNASelected = false;
boolean isRNASelected = false;
boolean isProteinSelected = false;
boolean hasChosenStrandType = false;
boolean showMutationPage = false;

int maxLength = 300;

String mutationType = "Point";
String mutationPositionInput = "";
String mutationValue = "";
String[] mutationOptions = {"Point", "Deletion", "Insertion"};
int selectedMutationIndex = 0;

// -----------------UTILITIES--------------------

boolean isMouseOver(int x, int y, int w, int h) {
  return mouseX >= x && mouseX <= x + w &&
         mouseY >= y && mouseY <= y + h;
}

void drawButton(int x, int y, int w, int h, String label, boolean hovered) {
  fill(hovered ? color(180, 220, 180) : 240);
  stroke(0);
  rect(x, y, w, h, 10);

  fill(0);
  textSize(18);  
  textAlign(CENTER, CENTER);
  text(label, x + w / 2, y + h / 2);
}


String groupBases(String s) {
  StringBuilder sb = new StringBuilder();
  for (int i = 0; i < s.length(); i++) {
    sb.append(s.charAt(i));
    if ((i + 1) % 3 == 0 && i != s.length() - 1) sb.append(" ");
  }
  return sb.toString();
}

String groupAminoAcids(String s) {
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
    wrapped.append(input.substring(i, end));
    if (end < input.length()) wrapped.append("\\n");
  }
  return wrapped.toString().trim();
}

String[] spliceArray(String[] arr, int index) {
  String[] result = new String[arr.length - 1];
  for (int i = 0, j = 0; i < arr.length; i++) {
    if (i != index) result[j++] = arr[i];
  }
  return result;
}

String[] insertArray(String[] arr, int index, String value) {
  String[] result = new String[arr.length + 1];
  for (int i = 0, j = 0; i < result.length; i++) {
    if (i == index) result[i] = value;
    else result[i] = arr[j++];
  }
  return result;
}
