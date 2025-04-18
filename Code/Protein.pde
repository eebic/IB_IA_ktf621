class Protein {
  private String sequence;
  private String[] aminoAcids;

  Protein(String seq) {
    this.sequence = seq.trim();
    this.aminoAcids = sequence.split(" ");
  }

  String getSequence() {
    return sequence;
  }

  ArrayList<String> analyzeFeatures() {
    ArrayList<String> features = new ArrayList<String>();

    // 1. Basic motifs
    if (sequence.contains("Met")) features.add("Start codon detected");
    if (sequence.contains("Pro")) features.add("Helix breaker (Proline loop)");
    if (sequence.contains("Gly")) features.add("Flexible region (Glycine)");
    if (sequence.contains("Asp Asp") || sequence.contains("Glu Glu")) features.add("Potential acidic patch");
    if (sequence.contains("Cys Cys")) features.add("Possible disulfide bond (Cysteine pair)");
    if (sequence.contains("Leu Leu Leu")) features.add("Hydrophobic α-helix segment (Leucine stretch)");
    if (sequence.contains("Lys Lys Arg")) features.add("DNA-binding motif (basic patch)");
    if (sequence.contains("Trp")) features.add("Aromatic residue (Tryptophan)");
    if (sequence.contains("Tyr")) features.add("Aromatic residue (Tyrosine)");

    // 2. Position-based detection
    if (aminoAcids.length >= 3) {
      String start = aminoAcids[0];
      String mid = aminoAcids[aminoAcids.length / 2];
      String end = aminoAcids[aminoAcids.length - 1];
      features.add("Start residue: " + start);
      features.add("Middle residue: " + mid);
      features.add("End residue: " + end);
    }

    // 3. Amino acid frequency
    HashMap<String, Integer> freq = new HashMap<String, Integer>();
    for (String aa : aminoAcids) {
      freq.put(aa, freq.getOrDefault(aa, 0) + 1);
    }

    features.add("Amino Acid Frequency:");
    for (String aa : freq.keySet()) {
      features.add(aa + ": " + freq.get(aa));
    }

    // 4. Simple folding prediction
    int helixCount = 0, sheetCount = 0, loopCount = 0;
    for (String aa : aminoAcids) {
      if (aa.equals("Leu") || aa.equals("Ala") || aa.equals("Glu")) helixCount++;
      if (aa.equals("Val") || aa.equals("Ile")) sheetCount++;
      if (aa.equals("Gly") || aa.equals("Pro") || aa.equals("Cys")) loopCount++;
    }

    String fold = "Undetermined";
    if (helixCount > sheetCount && helixCount > loopCount) fold = "Helix";
    else if (sheetCount > helixCount && sheetCount > loopCount) fold = "Sheet";
    else if (loopCount > helixCount && loopCount > sheetCount) fold = "Loop";

    features.add("Predicted Folding Pattern: " + fold);

    return features;
  }
}

