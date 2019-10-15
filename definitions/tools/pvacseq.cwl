class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - ln
  - '-s'
inputs:
  - id: additional_report_columns
    type:
      - 'null'
      - type: enum
        symbols:
          - sample_name
        name: additional_report_columns
    inputBinding:
      position: 0
      prefix: '-a'
  - id: allele_specific_binding_thresholds
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--allele-specific-binding-thresholds'
  - id: alleles
    type: 'string[]'
  - id: binding_threshold
    type: int?
    inputBinding:
      position: 0
      prefix: '-b'
  - id: downstream_sequence_length
    type: string?
    inputBinding:
      position: 0
      prefix: '-d'
  - id: epitope_lengths
    type: 'int[]?'
    inputBinding:
      position: 0
      prefix: '-e'
      separate: false
      itemSeparator: ','
  - id: exclude_nas
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--exclude-NAs'
  - id: expn_val
    type: float?
    inputBinding:
      position: 0
      prefix: '--expn-val'
  - id: fasta_size
    type: int?
    inputBinding:
      position: 0
      prefix: '-s'
  - id: iedb_retries
    type: int?
    inputBinding:
      position: 0
      prefix: '-r'
  - id: input_vcf
    type: File
    inputBinding:
      position: 1
    secondaryFiles:
      - .tbi
  - id: keep_tmp_files
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-k'
  - id: maximum_transcript_support_level
    type:
      - 'null'
      - type: enum
        symbols:
          - '1'
          - '2'
          - '3'
          - '4'
          - '5'
        name: maximum_transcript_support_level
    inputBinding:
      position: 0
      prefix: '--maximum-transcript-support-level'
  - id: minimum_fold_change
    type: float?
    inputBinding:
      position: 0
      prefix: '-c'
  - default: 8
    id: n_threads
    type: int?
    inputBinding:
      position: 0
      prefix: '--n-threads'
  - id: net_chop_method
    type:
      - 'null'
      - type: enum
        symbols:
          - cterm
          - 20s
        name: net_chop_method
    inputBinding:
      position: 0
      prefix: '--net-chop-method'
  - id: net_chop_threshold
    type: float?
    inputBinding:
      position: 0
      prefix: '--net-chop-threshold'
  - id: netmhc_stab
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--netmhc-stab'
  - id: normal_cov
    type: int?
    inputBinding:
      position: 0
      prefix: '--normal-cov'
  - id: normal_sample_name
    type: string?
    inputBinding:
      position: 0
      prefix: '--normal-sample-name'
  - id: normal_vaf
    type: float?
    inputBinding:
      position: 0
      prefix: '--normal-vaf'
  - id: peptide_sequence_length
    type: int?
    inputBinding:
      position: 0
      prefix: '-l'
  - id: phased_proximal_variants_vcf
    type: File?
    inputBinding:
      position: 0
      prefix: '-p'
    secondaryFiles:
      - .tbi
  - id: prediction_algorithms
    type: 'string[]'
    inputBinding:
      position: 4
  - id: sample_name
    type: string
    inputBinding:
      position: 2
  - id: tdna_cov
    type: int?
    inputBinding:
      position: 0
      prefix: '--tdna-cov'
  - id: tdna_vaf
    type: float?
    inputBinding:
      position: 0
      prefix: '--tdna-vaf'
  - id: top_score_metric
    type:
      - 'null'
      - type: enum
        symbols:
          - lowest
          - median
        name: top_score_metric
    inputBinding:
      position: 0
      prefix: '-m'
  - id: trna_cov
    type: int?
    inputBinding:
      position: 0
      prefix: '--trna-cov'
  - id: trna_vaf
    type: float?
    inputBinding:
      position: 0
      prefix: '--trna-vaf'
outputs:
  - id: combined_all_epitopes
    type: File?
    outputBinding:
      glob: combined/$(inputs.sample_name).all_epitopes.tsv
  - id: combined_filtered_epitopes
    type: File?
    outputBinding:
      glob: combined/$(inputs.sample_name).filtered.tsv
  - id: combined_ranked_epitopes
    type: File?
    outputBinding:
      glob: combined/$(inputs.sample_name).filtered.condensed.ranked.tsv
  - id: mhc_i_all_epitopes
    type: File?
    outputBinding:
      glob: MHC_Class_I/$(inputs.sample_name).all_epitopes.tsv
  - id: mhc_i_filtered_epitopes
    type: File?
    outputBinding:
      glob: MHC_Class_I/$(inputs.sample_name).filtered.tsv
  - id: mhc_i_ranked_epitopes
    type: File?
    outputBinding:
      glob: MHC_Class_I/$(inputs.sample_name).filtered.condensed.ranked.tsv
  - id: mhc_ii_all_epitopes
    type: File?
    outputBinding:
      glob: MHC_Class_II/$(inputs.sample_name).all_epitopes.tsv
  - id: mhc_ii_filtered_epitopes
    type: File?
    outputBinding:
      glob: MHC_Class_II/$(inputs.sample_name).filtered.tsv
  - id: mhc_ii_ranked_epitopes
    type: File?
    outputBinding:
      glob: MHC_Class_II/$(inputs.sample_name).filtered.condensed.ranked.tsv
doc: >-
  ####Modifications

  - in order for this to be compatible with SB, the alleles was changed from
  input port to as arguments. In input port, the * is causing problems
label: run pVACseq
arguments:
  - position: 0
    shellQuote: false
    valueFrom: $TMPDIR
  - /tmp/pvacseq
  - position: 0
    shellQuote: false
    valueFrom: ' && '
  - export
  - TMPDIR=/tmp/pvacseq
  - position: 0
    shellQuote: false
    valueFrom: ' && '
  - /opt/conda/bin/pvacseq
  - run
  - '--iedb-install-directory'
  - /opt/iedb
  - '--pass-only'
  - position: 5
    valueFrom: $(runtime.outdir)
  - position: 3
    prefix: ''
    valueFrom: '${     return [].concat(inputs.alleles).join() }'
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 16000
    coresMin: $(inputs.n_threads)
  - class: DockerRequirement
    dockerPull: 'griffithlab/pvactools:1.5.1'
  - class: InlineJavascriptRequirement
