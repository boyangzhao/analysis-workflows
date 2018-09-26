#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "run pVACseq"

baseCommand: ["pvacseq", "run"]
requirements:
    - class: DockerRequirement
      dockerPull: "http://registry.gsc.wustl.edu/zskidmor/pvactools:1.1.0d"
arguments:
    - position: 5
      valueFrom: $(runtime.outdir)
    - position: 6
      valueFrom: "--iedb-install-directory"
    - position: 7
      valueFrom: "/"
inputs:
    input_file:
        type: File
        inputBinding:
            position: 1
    sample_name:
        type: string
        inputBinding:
            position: 2
    alleles:
        type: string[]
        inputBinding:
            position: 3
            itemSeparator: ','
            separate: false
            prefix: ""
    prediction_algorithms:
        type: string[]
        inputBinding:
            position: 4
    epitope_lengths:
        type: int[]?
        inputBinding:
            prefix: "-e"
            itemSeparator: ','
            separate: false
    binding_threshold:
        type: int?
        inputBinding:
            prefix: "-b"
    allele_specific_binding_thresholds:
        type: boolean?
        inputBinding:
            prefix: "--allele-specific-binding-thresholds"
    iedb_retries:
        type: int?
        inputBinding:
            prefix: "-r"
    keep_tmp_files:
        type: boolean?
        inputBinding:
            prefix: "-k"
    peptide_sequence_length:
        type: int?
        inputBinding:
            prefix: "-l"
        default: 21
    normal_sample_name:
        type: string?
        inputBinding:
            prefix: "--normal-sample-name"
    net_chop_method:
        type:
            - "null"
            - type: enum
              symbols: ["cterm", "20s"]
        inputBinding:
            prefix: "--net-chop-method"
    netmhc_stab:
        type: boolean?
        inputBinding:
            prefix: "--netmhc-stab"
    top_score_metric:
        type:
            - "null"
            - type: enum
              symbols: ["lowest", "median"]
        inputBinding:
            prefix: "-m"
    net_chop_threshold:
        type: float?
        inputBinding:
            prefix: "--net-chop-threshold"
    additional_report_columns:
        type:
            - "null"
            - type: enum
              symbols: ["sample_name"]
        inputBinding:
            prefix: "-a"
    fasta_size:
        type: int?
        inputBinding:
            prefix: "-s"
    downstream_sequence_length:
        type: string?
        inputBinding:
            prefix: "-d"
    exclude_nas:
        type: boolean?
        inputBinding:
            prefix: "--exclude-NAs"
    phased_proximal_variants_vcf:
        type: File?
        secondaryFiles: [".tbi"]
        inputBinding:
            prefix: "-p"
    minimum_fold_change:
        type: int?
        inputBinding:
            prefix: "-c"
    normal_cov:
        type: int?
        inputBinding:
            prefix: "--normal-cov"
    tdna_cov:
        type: int?
        inputBinding:
            prefix: "--tdna-cov"
    trna_cov:
        type: int?
        inputBinding:
            prefix: "--trna-cov"
    normal_vaf:
        type: int?
        inputBinding:
            prefix: "--normal-vaf"
    tdna_vaf:
        type: int?
        inputBinding:
            prefix: "--tdna-vaf"
    trna_vaf:
        type: int?
        inputBinding:
            prefix: "--trna-vaf"
    expn_val:
        type: int?
        inputBinding:
            prefix: "--expn-val"
    maximum_transcript_support_level:
        type:
            - "null"
            - type: enum
              symbols: [1, 2, 3, 4, 5]
        inputBinding:
            prefix: "--maximum-transcript-support-level"
    pass_only:
        type: boolean?
        inputBinding:
            prefix: "--pass-only"
outputs:
    mhc_i_all_epitopes:
        type: File?
        outputBinding:
            glob: "MHC_Class_I/$(input.sample_name).combined.parsed.tsv"
    mhc_i_filtered_epitopes:
        type: File?
        outputBinding:
            glob: "MHC_Class_I/$(input.sample_name).filtered.tsv"
    mhc_i_ranked_epitopes:
        type: File?
        outputBinding:
            glob: "MHC_Class_I/$(input.sample_name).filtered.condensed.ranked.tsv"
    mhc_ii_all_epitopes:
        type: File?
        outputBinding:
            glob: "MHC_Class_II/$(input.sample_name).combined.parsed.tsv"
    mhc_ii_filtered_epitopes:
        type: File?
        outputBinding:
            glob: "MHC_Class_II/$(input.sample_name).filtered.tsv"
    mhc_ii_ranked_epitopes:
        type: File?
        outputBinding:
            glob: "MHC_Class_II/$(input.sample_name).filtered.condensed.ranked.tsv"
    combined_all_epitopes:
        type: File?
        outputBinding:
            glob: "combined/$(input.sample_name).combined.parsed.tsv"
    combined_filtered_epitopes:
        type: File?
        outputBinding:
            glob: "combined/$(input.sample_name).filtered.tsv"
    combined_ranked_epitopes:
        type: File?
        outputBinding:
            glob: "combined/$(input.sample_name).filtered.condensed.ranked.tsv"
