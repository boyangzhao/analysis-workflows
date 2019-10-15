class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /usr/bin/perl
  - /usr/bin/intervals_to_bed.pl
inputs:
  - id: interval_list
    type: File
    inputBinding:
      position: 1
outputs:
  - id: interval_bed
    type: File
    outputBinding:
      glob: interval_list.bed
doc: |-
  Modification
  - changed stdout to glob
requirements:
  - class: ResourceRequirement
    ramMin: 4000
  - class: DockerRequirement
    dockerPull: 'mgibio/perl_helper-cwl:1.0.0'
stdout: interval_list.bed
