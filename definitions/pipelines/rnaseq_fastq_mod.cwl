class: Workflow
cwlVersion: v1.0
doc: >-
  ####Modifications

  - created anew; based on rna_seq.cwl; uses modified subworkflow (new:
  trimmed_fastq_and_hisat_alignmens.cwl), to allow for fastq as inputs

  - in addition to rnaseq_fastq.cwl, here removed the Picard RNA metrics, which
  requires ribosomal interval files and flatRef, which need some additional work
  to get


  ####Notes for running on SB

  - when uploading workflow to SB, the enum field strand is appended with a
  "name" field, but a few places this is left with empty value "", which prevent
  it from running. To fix this, after upload, modify in the code so the new
  "name" field has the value "strand"
label: RNA-Seq alignment and transcript/gene abundance workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: assembly
    type: string
    doc: 'the assembly used, such as GRCh37/38, GRCm37/38'
    'sbg:x': 1135.359375
    'sbg:y': 1258.5
  - id: gene_transcript_lookup_table
    type: File
    'sbg:x': 800.046875
    'sbg:y': 816.5
  - id: kallisto_index
    type: File
    'sbg:x': 0
    'sbg:y': 1284
  - id: read_group_fields
    type: 'string[]'
    'sbg:x': 0
    'sbg:y': 1177
  - id: read_group_id
    type: 'string[]'
    'sbg:x': 0
    'sbg:y': 1070
  - id: reference_annotation
    type: File
    'sbg:x': 1135.359375
    'sbg:y': 667.5
  - id: reference_index
    type: File
    secondaryFiles:
      - .1.ht2
      - .2.ht2
      - .3.ht2
      - .4.ht2
      - .5.ht2
      - .6.ht2
      - .7.ht2
      - .8.ht2
    'sbg:x': 0
    'sbg:y': 963
  - id: reference_transcriptome
    type: File
    'sbg:x': 0
    'sbg:y': 856
  - id: sample_name
    type: string
    'sbg:x': 1135.359375
    'sbg:y': 560.5
  - id: species
    type: string
    doc: 'the species being analyzed, such as homo_sapiens or mus_musculus'
    'sbg:x': 0
    'sbg:y': 535
  - id: strand
    type:
      - 'null'
      - type: enum
        symbols:
          - first
          - second
          - unstranded
        name: ''
    'sbg:x': 464.25372314453125
    'sbg:y': 36.32428741455078
  - id: trimming_adapter_min_overlap
    type: int
    'sbg:x': 0
    'sbg:y': 428
  - id: trimming_adapter_trim_end
    type: string
    'sbg:x': 0
    'sbg:y': 321
  - id: trimming_adapters
    type: File
    'sbg:x': 0
    'sbg:y': 214
  - id: trimming_max_uncalled
    type: int
    'sbg:x': 0
    'sbg:y': 107
  - id: trimming_min_readlength
    type: int
    'sbg:x': 0
    'sbg:y': 0
  - id: reads2
    type: File
    'sbg:x': 192.8369903564453
    'sbg:y': -601.4630737304688
  - id: reads1
    type: File
    'sbg:x': 131.8600616455078
    'sbg:y': -229.5037841796875
outputs:
  - id: filtered_fusion_seqs
    outputSource:
      - pizzly/filtered_fusion_seqs
    type: File
    'sbg:x': 1511.7886962890625
    'sbg:y': 1179.5
  - id: filtered_fusions_json
    outputSource:
      - pizzly/filtered_fusions_json
    type: File
    'sbg:x': 1511.7886962890625
    'sbg:y': 1072.5
  - id: final_bam
    outputSource:
      - mark_dup/sorted_bam
    type: File
    secondaryFiles:
      - .bai
    'sbg:x': 1511.7886962890625
    'sbg:y': 965.5
  - id: final_fusion_calls
    outputSource:
      - grolar/parsed_fusion_calls
    type: File
    'sbg:x': 1862.4630126953125
    'sbg:y': 802.5
  - id: fusion_evidence
    outputSource:
      - kallisto/fusion_evidence
    type: File
    'sbg:x': 1135.359375
    'sbg:y': 1151.5
  - id: gene_abundance
    outputSource:
      - transcript_to_gene/gene_abundance
    type: File
    'sbg:x': 1511.7886962890625
    'sbg:y': 858.5
  - id: stringtie_gene_expression_tsv
    outputSource:
      - stringtie/gene_expression_tsv
    type: File
    'sbg:x': 1862.4630126953125
    'sbg:y': 588.5
  - id: stringtie_transcript_gtf
    outputSource:
      - stringtie/transcript_gtf
    type: File
    'sbg:x': 1862.4630126953125
    'sbg:y': 481.5
  - id: transcript_abundance_h5
    outputSource:
      - kallisto/expression_transcript_h5
    type: File
    'sbg:x': 1135.359375
    'sbg:y': 346.5
  - id: transcript_abundance_tsv
    outputSource:
      - kallisto/expression_transcript_table
    type: File
    'sbg:x': 1135.359375
    'sbg:y': 239.5
  - id: unfiltered_fusion_seqs
    outputSource:
      - pizzly/unfiltered_fusion_seqs
    type: File
    'sbg:x': 1511.7886962890625
    'sbg:y': 318.5
  - id: unfiltered_fusions_json
    outputSource:
      - pizzly/unfiltered_fusions_json
    type: File
    'sbg:x': 1511.7886962890625
    'sbg:y': 211.5
steps:
  - id: get_index_kmer_size
    in:
      - id: kallisto_index
        source: kallisto_index
    out:
      - id: kmer_length
    run: ../tools/kmer_size_from_index.cwl
    label: >-
      Helper script to pull the k-mer size used in generating a kallisto index
      from the index file
    'sbg:x': 297.859375
    'sbg:y': 579
  - id: grolar
    in:
      - id: assembly
        source: assembly
      - id: pizzly_calls
        source: pizzly/filtered_fusions_json
      - id: species
        source: species
    out:
      - id: parsed_fusion_calls
    run: ../tools/grolar.cwl
    label: grolar- pizzly gene fusion output parser
    'sbg:x': 1511.7886962890625
    'sbg:y': 588.5
  - id: index_bam
    in:
      - id: bam
        source: merge/merged_bam
    out:
      - id: indexed_bam
    run: ../tools/index_bam.cwl
    label: samtools index
    'sbg:x': 1135.359375
    'sbg:y': 1044.5
  - id: kallisto
    in:
      - id: fastqs
        source:
          - trimmed_fastq_and_hisat_alignments/fastqs
      - id: kallisto_index
        source: kallisto_index
      - id: strand
        source: strand
    out:
      - id: expression_transcript_h5
      - id: expression_transcript_table
      - id: fusion_evidence
    run: ../tools/kallisto.cwl
    label: 'Kallisto: Quant'
    'sbg:x': 800.046875
    'sbg:y': 695.5
  - id: mark_dup
    in:
      - id: bam
        source: merge/merged_bam
      - id: input_sort_order
        default: coordinate
    out:
      - id: metrics_file
      - id: sorted_bam
    run: ../tools/mark_duplicates_and_sort.cwl
    label: Mark duplicates and Sort
    'sbg:x': 1135.359375
    'sbg:y': 930.5
  - id: merge
    in:
      - id: bams
        source:
          - trimmed_fastq_and_hisat_alignments/aligned_bam
    out:
      - id: merged_bam
    run: ../tools/merge_bams.cwl
    label: 'Sambamba: merge'
    'sbg:x': 800.046875
    'sbg:y': 574.5
  - id: pizzly
    in:
      - id: fusion_evidence
        source: kallisto/fusion_evidence
      - id: kallisto_kmer_size
        source: get_index_kmer_size/kmer_length
      - id: reference_transcriptome
        source: reference_transcriptome
      - id: transcriptome_annotations
        source: reference_annotation
    out:
      - id: filtered_fusion_seqs
      - id: filtered_fusions_json
      - id: unfiltered_fusion_seqs
      - id: unfiltered_fusions_json
    run: ../tools/pizzly.cwl
    label: pizzly gene fusion detector
    'sbg:x': 1135.359375
    'sbg:y': 795.5
  - id: stringtie
    in:
      - id: bam
        source: mark_dup/sorted_bam
      - id: reference_annotation
        source: reference_annotation
      - id: sample_name
        source: sample_name
      - id: strand
        source: strand
    out:
      - id: gene_expression_tsv
      - id: transcript_gtf
    run: ../tools/stringtie.cwl
    label: StringTie
    'sbg:x': 1511.7886962890625
    'sbg:y': 446.5
  - id: transcript_to_gene
    in:
      - id: gene_transcript_lookup_table
        source: gene_transcript_lookup_table
      - id: transcript_table_h5
        source: kallisto/expression_transcript_h5
    out:
      - id: gene_abundance
    run: ../tools/transcript_to_gene.cwl
    label: 'Kallisto: TranscriptToGene'
    'sbg:x': 1135.359375
    'sbg:y': 125.5
  - id: trimmed_fastq_and_hisat_alignments
    in:
      - id: adapter_min_overlap
        source: trimming_adapter_min_overlap
      - id: adapter_trim_end
        source: trimming_adapter_trim_end
      - id: adapters
        source: trimming_adapters
      - id: max_uncalled
        source: trimming_max_uncalled
      - id: min_readlength
        source: trimming_min_readlength
      - id: read_group_fields
        source:
          - read_group_fields
      - id: read_group_id
        source: read_group_id
      - id: reference_index
        source: reference_index
      - id: strand
        source: strand
      - id: reads2
        source: reads2
      - id: reads1
        source: reads1
    out:
      - id: aligned_bam
      - id: fastqs
    run: ../subworkflows/trimmed_fastq_and_hisat_alignments.cwl
    label: trimmed fastqs and HISAT alignments
    'sbg:x': 460.27001953125
    'sbg:y': 413.9497985839844
requirements:
  - class: SubworkflowFeatureRequirement
