class: Workflow
cwlVersion: v1.0
label: mutect parallel workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: interval_list
    type: File
    'sbg:x': 0
    'sbg:y': 428
  - id: normal_bam
    type: File?
    secondaryFiles:
      - ^.bai
    'sbg:x': 0
    'sbg:y': 321
  - id: reference
    type: string
    'sbg:x': 0
    'sbg:y': 214
  - id: scatter_count
    type: int
    'sbg:x': 0
    'sbg:y': 107
  - id: tumor_bam
    type: File
    secondaryFiles:
      - ^.bai
    'sbg:x': 0
    'sbg:y': 0
outputs:
  - id: filtered_vcf
    outputSource:
      - filter/filtered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 1222.5389404296875
    'sbg:y': 267.5
  - id: unfiltered_vcf
    outputSource:
      - filter/unfiltered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 1222.5389404296875
    'sbg:y': 160.5
steps:
  - id: filter
    in:
      - id: bam
        source: tumor_bam
      - id: reference
        source: reference
      - id: variant_caller
        valueFrom: mutect
      - id: vcf
        source: index/indexed_vcf
    out:
      - id: filtered_vcf
      - id: unfiltered_vcf
    run: fp_filter.cwl
    label: fp_filter workflow
    'sbg:x': 985.3037109375
    'sbg:y': 200
  - id: index
    in:
      - id: vcf
        source: merge/merged_vcf
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 813.5224609375
    'sbg:y': 214
  - id: merge
    in:
      - id: vcfs
        source:
          - mutect/vcf
    out:
      - id: merged_vcf
    run: ../tools/merge_vcf.cwl
    label: vcf merge
    'sbg:x': 637.1943359375
    'sbg:y': 214
  - id: mutect
    in:
      - id: interval_list
        source: split_interval_list/split_interval_lists
      - id: normal_bam
        source: normal_bam
      - id: reference
        source: reference
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: vcf
    run: ../tools/mutect.cwl
    label: Mutect2 (GATK 4)
    scatter:
      - interval_list
    'sbg:x': 422.5577697753906
    'sbg:y': 193
  - id: split_interval_list
    in:
      - id: interval_list
        source: interval_list
      - id: scatter_count
        source: scatter_count
    out:
      - id: split_interval_lists
    run: ../tools/split_interval_list.cwl
    'sbg:x': 156.25
    'sbg:y': 207
requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
