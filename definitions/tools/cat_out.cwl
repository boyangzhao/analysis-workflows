class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /bin/cat
inputs:
  - id: pindel_outs
    type: 'File[]'
    inputBinding:
      position: 1
outputs:
  - id: pindel_out
    type: File
    outputBinding:
      glob: per_chromosome_pindel.out
doc: |-
  Modifications
  - change stdout to glob
requirements:
  - class: ResourceRequirement
    ramMin: 4000
  - class: DockerRequirement
    dockerPull: 'ubuntu:xenial'
stdout: per_chromosome_pindel.out
