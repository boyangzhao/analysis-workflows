class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand: []
inputs:
  - id: bam
    type: File
outputs:
  - id: indexed_bam
    type: File
    outputBinding:
      glob: $(inputs.bam.basename)
    secondaryFiles:
      - .bai
      - ^.bai
doc: |-
  Modifications
  - removed cp
label: samtools index
arguments:
  - /opt/samtools/bin/samtools
  - index
  - $(runtime.outdir)/$(inputs.bam.basename)
  - $(runtime.outdir)/$(inputs.bam.basename).bai
requirements:
  - class: ResourceRequirement
    ramMin: 4000
  - class: DockerRequirement
    dockerPull: 'mgibio/samtools-cwl:1.0.0'
  - class: InitialWorkDirRequirement
    listing:
      - '${ var f = inputs.bam; delete f.secondaryFiles; return f }'
  - class: InlineJavascriptRequirement
