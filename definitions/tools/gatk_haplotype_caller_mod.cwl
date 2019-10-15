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
  - HaplotypeCaller
inputs:
  - id: bam
    type: File
    inputBinding:
      position: 2
      prefix: '-I'
    secondaryFiles:
      - ^.bai
  - id: contamination_fraction
    type: string?
    inputBinding:
      position: 7
      prefix: '-contamination'
  - id: dbsnp_vcf
    type: File?
    inputBinding:
      position: 6
      prefix: '--dbsnp'
    secondaryFiles:
      - .tbi
  - id: emit_reference_confidence
    type: string
    inputBinding:
      position: 3
      prefix: '-ERC'
  - id: gvcf_gq_bands
    type:
      type: array
      items: string
      inputBinding:
        prefix: '-GQB'
    inputBinding:
      position: 4
  - id: intervals
    type: File
    inputBinding:
      position: 5
      prefix: '-L'
  - default: output.g.vcf.gz
    id: output_file_name
    type: string
    inputBinding:
      position: 8
      prefix: '-o'
  - id: reference
    type: string
    inputBinding:
      position: 1
      prefix: '-R'
outputs:
  - id: gvcf
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)
    secondaryFiles:
      - .tbi
doc: >-
  ####Modifications

  - created anew; based on original gatk_haplotype_caler.cwl; changed intervals
  to be of type File (instead of string array), to make this compatible with
  custom scatter of intervals files (instead of scatter by string)
label: GATK HaplotypeCaller
requirements:
  - class: ResourceRequirement
    ramMin: 10000
  - class: DockerRequirement
    dockerPull: 'mgibio/gatk-cwl:3.5.0'
  - class: InlineJavascriptRequirement
