class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: bwa_mem_bamsormadup
baseCommand: []
inputs:
  - default: false
    id: interleaved_fastq
    type: boolean?
    inputBinding:
      position: 8
      prefix: '--interleaved_fastq'
    doc: >-
      This option must be set to true if a single, interleaved paired-end reads
      file is being used
  - default: true
    id: mark_as_secondary
    type: boolean
    inputBinding:
      position: 5
      prefix: '--mark_as_secondary'
    doc: >-
      If long reads are split among multiple locations in the genome (because
      different parts of the same read align to different locations), select
      this to mark the shorter ones as secondary alignments. This will ensure
      better downstream compatibility with Picard and GATK, as some of these
      tools are not designed for multiple primary split alignments. This will
      supply the '-M' option to 'bwa mem'.
  - id: output_name
    type: string?
    inputBinding:
      position: 7
      prefix: '--output_name'
    doc: >-
      A name after which the output files will be called (name.bam, etc.). If
      not given, the output files will be named after the reads file.
  - id: read_group_id
    type: string?
    inputBinding:
      position: 4
      prefix: '--read_group_id'
    doc: >-
      (Optional) A string (without spaces) denoting the read group id (usually a
      flowcell and a lane) which will appear in the read group information in
      the BAM file. If not given, the read group id will be assigned the same
      value as the sample id.
  - id: reads
    type: File
    inputBinding:
      position: 1
      prefix: '--reads'
    doc: >-
      A gzipped FASTQ file (may be interleaved paired reads) with the reads to
      be processed.
  - id: reads2
    type: File?
    inputBinding:
      position: 2
      prefix: '--reads2'
    doc: >-
      For paired reads, the gzipped FASTQ file with the second mates of the
      reads (non-interleaved format)
  - id: sample
    type: string
    inputBinding:
      position: 3
      prefix: '--sample'
    doc: >-
      A string (without spaces) describing the sample, which will appear in the
      read group information in the BAM file and in the sample information in
      the VCF file.
  - default: true
    id: use_hs37d5
    type: boolean
    inputBinding:
      position: 6
      prefix: '--use_hs37d5'
    doc: >-
      Select this to use the hs37d5 reference genome (i.e. GRCh37 plus decoy
      sequences and EBV).
outputs:
  - id: duplication_metrics
    doc: >-
      A file containing duplication metrics (statistics) as output by
      bamsormadup.
    type: File
    outputBinding:
      glob: duplication_metrics/*
  - id: sorted_bai
    doc: The associated BAM index file.
    type: File
    outputBinding:
      glob: sorted_bai/*
  - id: sorted_bam
    doc: A BAM file with the resulting mappings (sorted and duplicates-marked).
    type: File
    outputBinding:
      glob: sorted_bam/*
label: bwa-mem
requirements:
  - class: DockerRequirement
    dockerOutputDirectory: /data/out
    dockerPull: 'pfda2dockstore/bwa_mem_bamsormadup:3'
's:author':
  class: 's:Person'
  's:name': Mark Wright
