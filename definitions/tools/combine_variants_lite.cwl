class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /usr/bin/java
  - '-Xmx8g'
  - '-jar'
  - /opt/GenomeAnalysisTK.jar
  - '-T'
  - CombineVariants
inputs:
  - id: mutect_vcf
    type: File
    inputBinding:
      position: 2
      prefix: '--variant:mutect'
    secondaryFiles:
      - .tbi
  - id: reference
    type: string
    inputBinding:
      position: 1
      prefix: '-R'
  - id: strelka_vcf
    type: File
    inputBinding:
      position: 4
      prefix: '--variant:strelka'
    secondaryFiles:
      - .tbi
  - id: varscan_vcf
    type: File
    inputBinding:
      position: 3
      prefix: '--variant:varscan'
    secondaryFiles:
      - .tbi
outputs:
  - id: combined_vcf
    type: File
    outputBinding:
      glob: combined.vcf.gz
    secondaryFiles:
      - .tbi
doc: |-
  ####Modifications
  - created a new, to only combine mutect, varscan, and strelka
  - added secondary file .tbi as required, for output
label: CombineVariants (GATK 3.6)
arguments:
  - '-genotypeMergeOptions'
  - PRIORITIZE
  - '--rod_priority_list'
  - 'mutect,varscan,strelka'
  - '-o'
  - position: 0
    valueFrom: $(runtime.outdir)/combined.vcf.gz
requirements:
  - class: ResourceRequirement
    ramMin: 9000
    tmpdirMin: 25000
  - class: DockerRequirement
    dockerPull: 'mgibio/cle:v1.3.1'
  - class: InlineJavascriptRequirement
