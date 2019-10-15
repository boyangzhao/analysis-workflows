class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /opt/htslib/bin/bgzip
inputs:
  - id: file
    type: File
    inputBinding:
      position: 1
outputs:
  - id: bgzipped_file
    type: File
    outputBinding:
      glob: $(inputs.file.basename).gz
doc: |-
  Modifications
  - modified stdout to that with file glob
label: bgzip VCF
arguments:
  - '-c'
requirements:
  - class: ResourceRequirement
    ramMin: 4000
  - class: DockerRequirement
    dockerPull: 'mgibio/samtools-cwl:1.0.0'
  - class: InlineJavascriptRequirement
stdout: $(inputs.file.basename).gz
