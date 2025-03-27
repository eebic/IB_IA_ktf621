# Internal Assessment
Candidate Code: ktf621

## <ins>Protein Sequence Analysis<ins>

**Basic Concept:** RNA (or DNA that can be transcribed into RNA) will be input by the user. This program will then analyze the protein sequence derived from the RNA and can predict secondary structures or motifs.

**Purpose:** The purpose of this program is to make the analysis of RNA, DNA, and protein structures faster and more accurate, as current methods—especially those used in high school and middle school classes—are time-consuming, energy-intensive, and prone to human error.

## Logic Flow Diagram

<img src="https://github.com/eebic/InternalAssessment/blob/main/img/IA_Logic_Flow_Diagram.png?raw=true" width="700" />

## Mockup

<img src="https://github.com/eebic/InternalAssessment/blob/main/img/IA_Mockup.png?raw=true" width="900" />


notes: main.java, transcription.java, translation.java, ProteinAnalysis.java


1. User Input & Object Creation
When the user enters a DNA or RNA sequence, the program creates an object of either DNASequence or RNASequence.

If the user inputs DNA, a DNASequence object is created.

If the user inputs RNA, an RNASequence object is created.

2. Processing & Hierarchical Flow
If a DNASequence object is created, it can be transcribed into an RNASequence object using the transcribe() method.

Once the RNASequence object is obtained, it can be translated into a ProteinSequence object using the translate() method.

3. Analysis Using OOP
Each sequence type (DNASequence, RNASequence, ProteinSequence) inherits from a common abstract class BiologicalSequence, which means they share common attributes (like sequence) but have their own specific behaviors.

The analyze() method is defined in the parent class but is overridden in each subclass, meaning:

A DNA sequence might be analyzed for GC content.

An RNA sequence might be analyzed for codon frequency.

A protein sequence might be analyzed for motifs and secondary structures.

4. Additional Functionality with Interfaces
A ProteinAnalyzer class implements the SequenceAnalyzer interface, which contains methods like:

predictSecondaryStructure()

identifyMotifs()

This allows separation of concerns, keeping analysis separate from sequence conversion.

5. Example User Flow
User inputs: "ATGCGT" (a DNA sequence).

DNASequence object is created.

DNA is transcribed to RNA, creating an RNASequence object.

RNA is translated to a protein, creating a ProteinSequence object.

A ProteinAnalyzer object is created to analyze the protein.

The program outputs predicted secondary structures and motifs of the protein.

Why This OOP Structure is Good
Encapsulation: Keeps data private and only accessible through methods.

Inheritance: Reduces redundancy, since all sequences share common behaviors.

Polymorphism: The analyze() method works differently depending on whether it's DNA, RNA, or protein.

Modularity: You can extend it in the future (e.g., add mutation analysis without affecting existing code).

INCLUDE MUTATIONS???
