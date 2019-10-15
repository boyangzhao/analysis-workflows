class: Workflow
cwlVersion: v1.0
doc: >-
  ####Modifications

  - removed vep annotations in the last steps

  - vcf expression annotator for adding the transcript abundance, the
  ignore-transcript-version is turned on to true


  ####Modifications (in individual components)

  - in tools/pvacseq.cwl: in order for this to be compatible with SB, the
  alleles was changed from input port to as arguments. In input port, the * is
  causing problems

  - in tools/vcf_expression_annotator.cwl: added ignore-transcript-version as an
  optional input
label: Workflow to run pVACseq from detect_variants and rnaseq pipeline outputs
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: additional_report_columns
    type:
      - 'null'
      - type: enum
        symbols:
          - sample_name
        name: ''
    'sbg:x': 1878.857177734375
    'sbg:y': 2140
  - id: alleles
    type: 'string[]'
    'sbg:x': 1878.857177734375
    'sbg:y': 2033
  - id: detect_variants_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 1926
  - id: downstream_sequence_length
    type: string?
    'sbg:x': 1878.857177734375
    'sbg:y': 1819
  - id: epitope_lengths
    type: 'int[]?'
    'sbg:x': 1878.857177734375
    'sbg:y': 1712
  - id: exclude_nas
    type: boolean?
    'sbg:x': 1878.857177734375
    'sbg:y': 1605
  - id: expn_val
    type: float?
    'sbg:x': 1878.857177734375
    'sbg:y': 1498
  - id: expression_tool
    type: string
    default: kallisto
    'sbg:x': 0
    'sbg:y': 1819
  - id: fasta_size
    type: int?
    'sbg:x': 1878.857177734375
    'sbg:y': 1391
  - id: gene_expression_file
    type: File
    'sbg:x': 0
    'sbg:y': 1712
  - id: maximum_transcript_support_level
    type:
      - 'null'
      - type: enum
        symbols:
          - '1'
          - '2'
          - '3'
          - '4'
          - '5'
        name: ''
    'sbg:x': 1878.857177734375
    'sbg:y': 1177
  - id: minimum_fold_change
    type: float?
    'sbg:x': 1878.857177734375
    'sbg:y': 1070
  - id: n_threads
    type: int?
    'sbg:x': 1878.857177734375
    'sbg:y': 963
  - id: net_chop_method
    type:
      - 'null'
      - type: enum
        symbols:
          - cterm
          - 20s
        name: ''
    'sbg:x': 1878.857177734375
    'sbg:y': 856
  - id: net_chop_threshold
    type: float?
    'sbg:x': 1878.857177734375
    'sbg:y': 749
  - id: netmhc_stab
    type: boolean?
    'sbg:x': 1878.857177734375
    'sbg:y': 642
  - id: normal_cov
    type: int?
    'sbg:x': 1878.857177734375
    'sbg:y': 535
  - id: normal_sample_name
    type: string?
    default: NORMAL
    'sbg:x': 1878.857177734375
    'sbg:y': 428
  - id: normal_vaf
    type: float?
    'sbg:x': 1878.857177734375
    'sbg:y': 321
  - id: peptide_sequence_length
    type: int?
    'sbg:x': 1878.857177734375
    'sbg:y': 214
  - id: phased_proximal_variants_vcf
    type: File?
    secondaryFiles:
      - .tbi
    'sbg:x': 1878.857177734375
    'sbg:y': 107
  - id: prediction_algorithms
    type: 'string[]'
    'sbg:x': 1878.857177734375
    'sbg:y': 0
  - id: readcount_minimum_base_quality
    type: int?
    'sbg:x': 0
    'sbg:y': 1605
  - id: readcount_minimum_mapping_quality
    type: int?
    'sbg:x': 0
    'sbg:y': 1498
  - id: reference_fasta
    type: string
    'sbg:x': 0
    'sbg:y': 1391
  - id: rnaseq_bam
    type: File
    secondaryFiles:
      - .bai
    'sbg:x': 0
    'sbg:y': 1284
  - id: sample_name
    type: string?
    default: TUMOR
    'sbg:x': 0
    'sbg:y': 1177
  - id: tdna_cov
    type: int?
    'sbg:x': 0
    'sbg:y': 1070
  - id: tdna_vaf
    type: float?
    'sbg:x': 0
    'sbg:y': 963
  - id: top_score_metric
    type:
      - 'null'
      - type: enum
        symbols:
          - lowest
          - median
        name: ''
    'sbg:x': 0
    'sbg:y': 856
  - id: transcript_expression_file
    type: File
    'sbg:x': 0
    'sbg:y': 749
  - id: trna_cov
    type: int?
    'sbg:x': 0
    'sbg:y': 642
  - id: trna_vaf
    type: float?
    'sbg:x': 0
    'sbg:y': 535
outputs:
  - id: annotated_vcf
    outputSource:
      - add_transcript_expression_data_to_vcf/annotated_expression_vcf
    type: File
    'sbg:x': 1878.857177734375
    'sbg:y': 1926
  - id: combined_all_epitopes
    outputSource:
      - pvacseq/combined_all_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 1430.5
  - id: combined_filtered_epitopes
    outputSource:
      - pvacseq/combined_filtered_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 1323.5
  - id: combined_ranked_epitopes
    outputSource:
      - pvacseq/combined_ranked_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 1216.5
  - id: mhc_i_all_epitopes
    outputSource:
      - pvacseq/mhc_i_all_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 1109.5
  - id: mhc_i_filtered_epitopes
    outputSource:
      - pvacseq/mhc_i_filtered_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 1002.5
  - id: mhc_i_ranked_epitopes
    outputSource:
      - pvacseq/mhc_i_ranked_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 895.5
  - id: mhc_ii_all_epitopes
    outputSource:
      - pvacseq/mhc_ii_all_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 788.5
  - id: mhc_ii_filtered_epitopes
    outputSource:
      - pvacseq/mhc_ii_filtered_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 681.5
  - id: mhc_ii_ranked_epitopes
    outputSource:
      - pvacseq/mhc_ii_ranked_epitopes
    type: File?
    'sbg:x': 2939.70654296875
    'sbg:y': 574.5
steps:
  - id: add_gene_expression_data_to_vcf
    in:
      - id: data_type
        default: gene
      - id: expression_file
        source: gene_expression_file
      - id: expression_tool
        source: expression_tool
      - id: sample_name
        source: sample_name
      - id: vcf
        source: add_tumor_rna_bam_readcount_to_vcf/annotated_bam_readcount_vcf
    out:
      - id: annotated_expression_vcf
    run: ../tools/vcf_expression_annotator.cwl
    label: add expression info to vcf
    'sbg:x': 1172.4278564453125
    'sbg:y': 1049
  - id: add_transcript_expression_data_to_vcf
    in:
      - id: data_type
        default: transcript
      - id: expression_file
        source: transcript_expression_file
      - id: expression_tool
        source: expression_tool
      - id: sample_name
        source: sample_name
      - id: vcf
        source: add_gene_expression_data_to_vcf/annotated_expression_vcf
      - id: ignore_transcript_version
        default: true
    out:
      - id: annotated_expression_vcf
    run: ../tools/vcf_expression_annotator.cwl
    label: add expression info to vcf
    'sbg:x': 1525.642578125
    'sbg:y': 1049
  - id: add_tumor_rna_bam_readcount_to_vcf
    in:
      - id: data_type
        default: RNA
      - id: indel_bam_readcount_tsv
        source: tumor_rna_bam_readcount/indel_bam_readcount_tsv
      - id: sample_name
        source: sample_name
      - id: snv_bam_readcount_tsv
        source: tumor_rna_bam_readcount/snv_bam_readcount_tsv
      - id: vcf
        source: tumor_rna_bam_readcount/normalized_vcf
    out:
      - id: annotated_bam_readcount_vcf
    run: vcf_readcount_annotator.cwl
    label: Add snv and indel bam-readcount files to a vcf
    'sbg:x': 748.9632568359375
    'sbg:y': 1049
  - id: index
    in:
      - id: vcf
        source: add_transcript_expression_data_to_vcf/annotated_expression_vcf
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1878.857177734375
    'sbg:y': 1284
  - id: pvacseq
    in:
      - id: additional_report_columns
        source: additional_report_columns
      - id: alleles
        source:
          - alleles
      - id: downstream_sequence_length
        source: downstream_sequence_length
      - id: epitope_lengths
        source:
          - epitope_lengths
      - id: exclude_nas
        source: exclude_nas
      - id: expn_val
        source: expn_val
      - id: fasta_size
        source: fasta_size
      - id: input_vcf
        source: index/indexed_vcf
      - id: maximum_transcript_support_level
        source: maximum_transcript_support_level
      - id: minimum_fold_change
        source: minimum_fold_change
      - id: n_threads
        source: n_threads
      - id: net_chop_method
        source: net_chop_method
      - id: net_chop_threshold
        source: net_chop_threshold
      - id: netmhc_stab
        source: netmhc_stab
      - id: normal_cov
        source: normal_cov
      - id: normal_sample_name
        source: normal_sample_name
      - id: normal_vaf
        source: normal_vaf
      - id: peptide_sequence_length
        source: peptide_sequence_length
      - id: phased_proximal_variants_vcf
        source: phased_proximal_variants_vcf
      - id: prediction_algorithms
        source:
          - prediction_algorithms
      - id: sample_name
        source: sample_name
      - id: tdna_cov
        source: tdna_cov
      - id: tdna_vaf
        source: tdna_vaf
      - id: top_score_metric
        source: top_score_metric
      - id: trna_cov
        source: trna_cov
      - id: trna_vaf
        source: trna_vaf
    out:
      - id: combined_all_epitopes
      - id: combined_filtered_epitopes
      - id: combined_ranked_epitopes
      - id: mhc_i_all_epitopes
      - id: mhc_i_filtered_epitopes
      - id: mhc_i_ranked_epitopes
      - id: mhc_ii_all_epitopes
      - id: mhc_ii_filtered_epitopes
      - id: mhc_ii_ranked_epitopes
    run: ../tools/pvacseq.cwl
    label: run pVACseq
    'sbg:x': 2208.060302734375
    'sbg:y': 1123.5
  - id: tumor_rna_bam_readcount
    in:
      - id: bam
        source: rnaseq_bam
      - id: min_base_quality
        source: readcount_minimum_base_quality
      - id: min_mapping_quality
        source: readcount_minimum_mapping_quality
      - id: reference_fasta
        source: reference_fasta
      - id: sample
        source: sample_name
      - id: vcf
        source: detect_variants_vcf
    out:
      - id: indel_bam_readcount_tsv
      - id: normalized_vcf
      - id: snv_bam_readcount_tsv
    run: bam_readcount.cwl
    label: bam_readcount workflow
    'sbg:x': 354.53125
    'sbg:y': 1035
requirements:
  - class: SubworkflowFeatureRequirement
