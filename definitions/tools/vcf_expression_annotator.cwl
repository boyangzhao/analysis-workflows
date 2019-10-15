class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - vcf-expression-annotator
inputs:
  - id: data_type
    type: string
    inputBinding:
      position: 4
  - id: expression_file
    type: File
    inputBinding:
      position: 2
  - id: expression_tool
    type: string
    inputBinding:
      position: 3
  - id: sample_name
    type: string
    inputBinding:
      position: 0
      prefix: '-s'
  - id: vcf
    type: File
    inputBinding:
      position: 1
  - id: ignore_transcript_version
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--ignore-transcript-version'
outputs:
  - id: annotated_expression_vcf
    type: File
    outputBinding:
      glob: annotated.expression.vcf.gz
doc: |-
  ####Modifications
  - added ignore-transcript-version as an optional boolean input
label: add expression info to vcf
arguments:
  - '-o'
  - position: 0
    valueFrom: $(runtime.outdir)/annotated.expression.vcf.gz
requirements:
  - class: ResourceRequirement
    ramMin: 4000
  - class: DockerRequirement
    dockerPull: 'griffithlab/vatools:3.1.0'
  - class: InlineJavascriptRequirement
