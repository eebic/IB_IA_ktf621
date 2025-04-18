class DNASequence {
  private String sequence;

  DNASequence(String seq) {
    this.sequence = seq;
  }

  String getSequence() {
    return sequence;
  }

  String transcribe() {
    return sequence.replace('T', 'U');
  }
}

