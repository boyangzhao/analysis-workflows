class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /opt/samtools/bin/samtools
  - view
  - '-C'
inputs:
  - id: bam
    type: File
    inputBinding:
      position: 2
  - id: reference
    type: string
    inputBinding:
      position: 1
      prefix: '-T'
outputs:
  - id: cram
    type: File
    outputBinding:
      glob: $(inputs.bam.nameroot).cram
doc: |-
  ####Modifications
  - change stdout to glob
label: BAM to CRAM conversion
requirements:
  - class: ResourceRequirement
    ramMin: 4000
  - class: DockerRequirement
    dockerPull: 'mgibio/samtools-cwl:1.0.0'
  - class: InlineJavascriptRequirement
stdout: $(inputs.bam.nameroot).cram
