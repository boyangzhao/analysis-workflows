class: Workflow
cwlVersion: v1.0
doc: >-
  ####Modifications

  - created anew, based on sequence_to_bqsr.cwl

  - changed alignment to directly use tool sequence_align_and_tag.cwl
  (previously was using subworkflow sequence_align_and_tag_adapter.cwl)

  - with the above, do not have to use unaligned structure (which was not
  working on sb)

  - modified index_bam.cwl, with no cp

  - modified sequence_align_and_tag.cwl, for output to include glob to search
  for .bam file and type as File

  - note: final_name was renamed to final_bam_name, which emphasize should
  contain the .bam ending
label: Raw sequence data to BQSR
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: bqsr_intervals
    type: 'string[]?'
    'sbg:x': 0
    'sbg:y': 535
  - id: dbsnp_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 0
    'sbg:y': 428
  - id: final_bam_name
    type: string?
    default: final.bam
    'sbg:x': 195.81915283203125
    'sbg:y': 115.2473373413086
  - id: known_indels
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 0
    'sbg:y': 321
  - id: mills
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 0
    'sbg:y': 214
  - id: reference
    type: string
    'sbg:x': -5.755651950836182
    'sbg:y': -251.84173583984375
  - id: readgroup
    type: string
    'sbg:exposed': true
  - id: fastq2
    type: File?
    'sbg:x': -4.178365707397461
    'sbg:y': 4.973054885864258
  - id: fastq1
    type: File?
    'sbg:x': -6.078339099884033
    'sbg:y': -124
  - id: bam
    type: File?
    'sbg:x': -3.6261837482452393
    'sbg:y': 120.25920104980469
outputs:
  - id: final_bam
    outputSource:
      - index_bam/indexed_bam
    type: File
    secondaryFiles:
      - .bai
      - ^.bai
    'sbg:x': 1461.662353515625
    'sbg:y': 267.5
  - id: mark_duplicates_metrics_file
    outputSource:
      - mark_duplicates_and_sort/metrics_file
    type: File
    'sbg:x': 992.990478515625
    'sbg:y': 118.5
  - id: sorted_bam
    outputSource:
      - mark_duplicates_and_sort/sorted_bam
    'sbg:fileTypes': BAM
    type: File
    secondaryFiles:
      - .bai
    'sbg:x': 991.1401977539062
    'sbg:y': -37.7564582824707
steps:
  - id: apply_bqsr
    in:
      - id: bam
        source: mark_duplicates_and_sort/sorted_bam
      - id: bqsr_table
        source: bqsr/bqsr_table
      - id: output_name
        source: final_bam_name
      - id: reference
        source: reference
    out:
      - id: bqsr_bam
    run: ../tools/apply_bqsr.cwl
    label: apply BQSR
    'sbg:x': 992.990478515625
    'sbg:y': 395.5
  - id: bqsr
    in:
      - id: bam
        source: mark_duplicates_and_sort/sorted_bam
      - id: intervals
        source:
          - bqsr_intervals
      - id: known_sites
        source:
          - dbsnp_vcf
          - mills
          - known_indels
      - id: reference
        source: reference
    out:
      - id: bqsr_table
    run: ../tools/bqsr.cwl
    label: create BQSR table
    'sbg:x': 992.990478515625
    'sbg:y': 246.5
  - id: index_bam
    in:
      - id: bam
        source: apply_bqsr/bqsr_bam
    out:
      - id: indexed_bam
    run: ../tools/index_bam.cwl
    label: samtools index
    'sbg:x': 1274.662353515625
    'sbg:y': 267.5
  - id: mark_duplicates_and_sort
    in:
      - id: bam
        source: name_sort/name_sorted_bam
    out:
      - id: metrics_file
      - id: sorted_bam
    run: ../tools/mark_duplicates_and_sort.cwl
    label: Mark duplicates and Sort
    'sbg:x': 804.0577392578125
    'sbg:y': 260.5
  - id: merge
    in:
      - id: bams
        source:
          - sequence_align_and_tag/aligned_bam
      - id: name
        source: final_bam_name
    out:
      - id: merged_bam
    run: ../tools/merge_bams_samtools.cwl
    label: 'Samtools: merge'
    'sbg:x': 387.171875
    'sbg:y': 260.5
  - id: name_sort
    in:
      - id: bam
        source: merge/merged_bam
    out:
      - id: name_sorted_bam
    run: ../tools/name_sort.cwl
    label: sort BAM by name
    'sbg:x': 589.7608642578125
    'sbg:y': 267.5
  - id: sequence_align_and_tag
    in:
      - id: bam
        source: bam
      - id: fastq1
        source: fastq1
      - id: fastq2
        source: fastq2
      - id: readgroup
        source: readgroup
      - id: reference
        source: reference
    out:
      - id: aligned_bam
    run: ../tools/sequence_align_and_tag.cwl
    label: align with bwa_mem and tag
    'sbg:x': 209.07745361328125
    'sbg:y': 372.0339660644531
requirements:
  - class: MultipleInputFeatureRequirement
