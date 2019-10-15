class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /usr/bin/java
  - '-Xmx16g'
  - '-jar'
  - /opt/GenomeAnalysisTK.jar
  - '-T'
  - PrintReads
inputs:
  - id: bam
    type: File
    inputBinding:
      position: 2
      prefix: '-I'
    secondaryFiles:
      - .bai
  - id: bqsr_table
    type: File
    inputBinding:
      position: 3
      prefix: '-BQSR'
  - default: Final.bam
    id: output_name
    type: string?
  - id: reference
    type: string
    inputBinding:
      position: 1
      prefix: '-R'
outputs:
  - id: bqsr_bam
    type: File
    outputBinding:
      glob: $(inputs.output_name)
    secondaryFiles:
      - ^.bai
label: apply BQSR
arguments:
  - '-o'
  - position: 0
    prefix: ''
    valueFrom: $(runtime.outdir)/$(inputs.output_name)
  - '-preserveQ'
  - '6'
  - '-SQQ'
  - '10'
  - '-SQQ'
  - '20'
  - '-SQQ'
  - '30'
  - '-nct'
  - '8'
  - '--disable_indel_quals'
requirements:
  - class: ResourceRequirement
    ramMin: 18000
  - class: DockerRequirement
    dockerPull: 'mgibio/gatk-cwl:3.6.0'
  - class: InlineJavascriptRequirement
