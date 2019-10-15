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
  - GenotypeGVCFs
inputs:
  - id: gvcfs
    type:
      type: array
      items: File
      inputBinding:
        prefix: '--variant'
    inputBinding:
      position: 2
  - id: reference
    type: string
    inputBinding:
      position: 1
      prefix: '-R'
outputs:
  - id: genotype_vcf
    type: File
    outputBinding:
      glob: genotype.vcf.gz
    secondaryFiles:
      - .tbi
doc: >-
  ####Modifications

  - changed name; originally called "GATK HaplotypeCaller", but this cwl was not
  calling the GATK HaplotypeCaller, but GenotypeGVCFs, in merging the gvcfs
label: merge GVCFs
arguments:
  - '-o'
  - genotype.vcf.gz
requirements:
  - class: ResourceRequirement
    ramMin: 9000
  - class: DockerRequirement
    dockerPull: 'mgibio/gatk-cwl:3.5.0'
  - class: InlineJavascriptRequirement
