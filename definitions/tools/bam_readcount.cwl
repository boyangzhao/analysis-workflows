class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /usr/bin/python
  - /usr/bin/bam_readcount_helper.py
inputs:
  - id: bam
    type: File
    inputBinding:
      position: -5
    secondaryFiles:
      - .bai
  - default: 20
    id: min_base_quality
    type: int?
    inputBinding:
      position: -2
  - default: 0
    id: min_mapping_quality
    type: int?
    inputBinding:
      position: -1
  - default: NOPREFIX
    id: prefix
    type: string?
    inputBinding:
      position: -4
  - id: reference_fasta
    type: string
    inputBinding:
      position: -6
  - id: sample
    type: string
    inputBinding:
      position: -7
  - id: vcf
    type: File
    inputBinding:
      position: -8
outputs:
  - id: indel_bam_readcount_tsv
    type: File
    outputBinding:
      glob: |
        ${
            var name = "_bam_readcount_indel.tsv";
            if (inputs.prefix == "NOPREFIX") {
                name = inputs.sample + name;
            }
            else {
                name = inputs.prefix + "_" + inputs.sample + name;
            }
            return name;
        }
  - id: snv_bam_readcount_tsv
    type: File
    outputBinding:
      glob: |
        ${
            var name = "_bam_readcount_snv.tsv";
            if (inputs.prefix == "NOPREFIX") {
                name = inputs.sample + name;
            }
            else {
                name = inputs.prefix + "_" + inputs.sample + name;
            }
            return name;
        }
doc: |-
  ####Modifications
  - changed "equals" to "==" in glob, for output ports
label: run bam-readcount
arguments:
  - position: -3
    valueFrom: $(runtime.outdir)
requirements:
  - class: ResourceRequirement
    ramMin: 16000
  - class: DockerRequirement
    dockerPull: 'mgibio/bam_readcount_helper-cwl:1.1.1'
  - class: InlineJavascriptRequirement
stdout: $(inputs.sample)_bam_readcount.tsv
