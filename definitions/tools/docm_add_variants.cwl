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
  - id: callers_vcf
    type: File
    inputBinding:
      position: 2
      prefix: '--variant:callers'
    secondaryFiles:
      - .tbi
  - id: docm_vcf
    type: File
    inputBinding:
      position: 3
      prefix: '--variant:docm'
  - id: reference
    type: string
    inputBinding:
      position: 1
      prefix: '-R'
outputs:
  - id: merged_vcf
    type: File
    outputBinding:
      glob: merged.vcf.gz
    secondaryFiles:
      - .tbi
doc: |-
  ####Modifications
  - added secondary file .tbi as required, for output
label: CombineVariants (GATK 3.6)
arguments:
  - '-genotypeMergeOptions'
  - PRIORITIZE
  - '--rod_priority_list'
  - 'callers,docm'
  - '--setKey'
  - 'null'
  - '-o'
  - position: 0
    valueFrom: $(runtime.outdir)/merged.vcf.gz
requirements:
  - class: ResourceRequirement
    ramMin: 9000
    tmpdirMin: 25000
  - class: DockerRequirement
    dockerPull: mgibio/cle
  - class: InlineJavascriptRequirement
