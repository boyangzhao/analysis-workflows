class: Workflow
cwlVersion: v1.0
doc: >-
  ####Modifications

  - created anew, based on bam_to_trimmed_fastq_and_hisat_alignment, to accept
  directly fastq inputs; i.e. removed the bam_to_trimmed_fastq.cwl step
label: trimmed fastqs and HISAT alignments
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: adapter_min_overlap
    type: int
    'sbg:x': 192.6875
    'sbg:y': 549
  - id: adapter_trim_end
    type: string
    'sbg:x': 192.6875
    'sbg:y': 442
  - id: adapters
    type: File
    'sbg:x': 192.6875
    'sbg:y': 335
  - id: max_uncalled
    type: int
    'sbg:x': 192.6875
    'sbg:y': 107
  - id: min_readlength
    type: int
    'sbg:x': 192.6875
    'sbg:y': 0
  - id: read_group_fields
    type: 'string[]'
    'sbg:x': 0
    'sbg:y': 381.5
  - id: read_group_id
    type: string
    'sbg:x': 0
    'sbg:y': 274.5
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
    'sbg:y': 167.5
  - id: strand
    type:
      - 'null'
      - type: enum
        symbols:
          - first
          - second
          - unstranded
    'sbg:x': 0
    'sbg:y': 60.5
  - id: reads2
    type: File
    'sbg:x': -1
    'sbg:y': 500
  - id: reads1
    type: File
    'sbg:x': 3
    'sbg:y': 617
outputs:
  - id: aligned_bam
    outputSource:
      - hisat2_align/aligned_bam
    type: File
    'sbg:x': 1023.076416015625
    'sbg:y': 274.5
  - id: fastqs
    outputSource:
      - trim_fastq/fastqs
    type: 'File[]'
    'sbg:x': 699.5140380859375
    'sbg:y': 328
steps:
  - id: hisat2_align
    in:
      - id: fastq1
        source: trim_fastq/fastqs
        valueFrom: '$(self[0])'
      - id: fastq2
        source: trim_fastq/fastqs
        valueFrom: '$(self[1])'
      - id: read_group_fields
        source:
          - read_group_fields
      - id: read_group_id
        source: read_group_id
      - id: reference_index
        source: reference_index
      - id: strand
        source: strand
    out:
      - id: aligned_bam
    run: ../tools/hisat2_align.cwl
    label: 'HISAT2: align'
    'sbg:x': 699.5140380859375
    'sbg:y': 186
  - id: trim_fastq
    in:
      - id: adapter_min_overlap
        source: adapter_min_overlap
      - id: adapter_trim_end
        source: adapter_trim_end
      - id: adapters
        source: adapters
      - id: max_uncalled
        source: max_uncalled
      - id: min_readlength
        source: min_readlength
      - id: reads1
        source: reads1
      - id: reads2
        source: reads2
    out:
      - id: fastq1
      - id: fastq2
      - id: fastqs
    run: ../tools/trim_fastq.cwl
    label: Trim FASTQ (flexbar)
    'sbg:x': 410.65625
    'sbg:y': 232.5
requirements: []
