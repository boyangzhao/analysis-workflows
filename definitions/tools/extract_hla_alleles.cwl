class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /usr/bin/awk
  - '{getline; printf "HLA-"$2 " HLA-"$3 " HLA-"$4 " HLA-"$5 " HLA-"$6 " HLA-"$7}'
inputs:
  - id: allele_file
    type: File
    inputBinding:
      position: -1
outputs:
  - id: allele_string
    type: 'string[]'
    outputBinding:
      loadContents: true
      glob: helper.txt
      outputEval: '$(self[0].contents.split(" "))'
arguments:
  - position: 0
    shellQuote: false
    valueFrom: '>'
  - helper.txt
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 2000
  - class: DockerRequirement
    dockerPull: 'ubuntu:xenial'
  - class: InlineJavascriptRequirement
