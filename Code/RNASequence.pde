class RNASequence {
  private String sequence;

  RNASequence(String seq) {
    this.sequence = seq;
  }

  String getSequence() {
    return sequence;
  }

  String translate() {
    CodonTable codonTable = new CodonTable();
    StringBuilder protein = new StringBuilder();

    for (int i = 0; i < sequence.length() - 2; i += 3) {
      String codon = sequence.substring(i, i + 3);
      protein.append(codonTable.getAminoAcid(codon)).append(" ");
    }

    return protein.toString().trim();
  }
}

