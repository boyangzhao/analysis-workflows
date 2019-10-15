class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /bin/cat
inputs:
  - id: region_pindel_outs
    type: 'File[]'
    inputBinding:
      position: -1
outputs:
  - id: all_region_pindel_head
    type: File
    outputBinding:
      glob: all_region_pindel.head
doc: |-
  Modifications
  - change stdout to glob
arguments:
  - position: 0
    shellQuote: false
    valueFrom: '|'
  - /bin/grep
  - ChrID
  - /dev/stdin
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 4000
  - class: DockerRequirement
    dockerPull: 'ubuntu:xenial'
stdout: all_region_pindel.head
