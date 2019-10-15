class: Workflow
cwlVersion: v1.0
doc: >-
  ####Modifications (this workflow)

  - removed the final selectvariant+vep_annotator for generating the tsv table,
  which was throwing errors on sb platform)

  - removed selectvariant for limited_vcf after final_vcf

  - replaced scatter method gatk_haplotypecaller_iterator.cwl with a scatter
  method by interval lists. Now interval list is a file (instead of string), and
  is splitted into mutliple interval list files (based on scatter count) and
  distributed into gatk_haplotype_caller_mod.cwl


  ####Modifications (individual files)

  - gatk_haplotype_caller_mod.cwl: created anew; based on original
  gatk_haplotype_caler.cwl; changed intervals to be of type File (instead of
  string array), to make this compatible with custom scatter of intervals files
  (instead of scatter by string)
label: germline variant detection
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: annotate_coding_only
    type: boolean?
    'sbg:x': 816.41845703125
    'sbg:y': 700.390625
  - id: bam
    type: File
    'sbg:x': 242.234375
    'sbg:y': 693.3359375
  - id: custom_clinvar_vcf
    type: File?
    secondaryFiles:
      - .tbi
    'sbg:x': 0
    'sbg:y': 1173.3671875
  - id: custom_gnomad_vcf
    type: File?
    secondaryFiles:
      - .tbi
    'sbg:x': 0
    'sbg:y': 1066.6875
  - id: emit_reference_confidence
    type: string
    'sbg:x': 242.234375
    'sbg:y': 586.7109375
  - id: gvcf_gq_bands
    type: 'string[]'
    'sbg:x': 0
    'sbg:y': 959.953125
  - id: intervals
    type: File
    'sbg:x': 0
    'sbg:y': 853.2734375
  - id: reference
    type: string
    'sbg:x': 0
    'sbg:y': 746.6484375
  - id: synonyms_file
    type: File?
    'sbg:x': 0
    'sbg:y': 533.34375
  - id: vep_cache_dir
    type: string
    'sbg:x': 0
    'sbg:y': 426.6640625
  - id: vep_ensembl_assembly
    type: string
    doc: 'genome assembly to use in vep. Examples: GRCh38 or GRCm38'
    'sbg:x': 0
    'sbg:y': 319.984375
  - id: vep_ensembl_species
    type: string
    doc: >-
      ensembl species - Must be present in the cache directory. Examples:
      homo_sapiens or mus_musculus
    'sbg:x': 0
    'sbg:y': 213.3046875
  - id: vep_ensembl_version
    type: string
    doc: 'ensembl version - Must be present in the cache directory. Example: 95'
    'sbg:x': 0
    'sbg:y': 106.6796875
  - id: vep_plugins
    type: 'string[]?'
    default:
      - Downstream
      - Wildtype
    'sbg:x': 0
    'sbg:y': 0
  - id: scatter_count
    type: int
    'sbg:x': 0
    'sbg:y': 640.0234375
outputs:
  - id: coding_vcf
    outputSource:
      - index_coding_vcf/indexed_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 1967.447998046875
    'sbg:y': 586.65625
  - id: final_vcf
    outputSource:
      - index_annotated_vcf/indexed_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 1795.666748046875
    'sbg:y': 640.0234375
  - id: vep_summary
    outputSource:
      - annotate_variants/vep_summary
    type: File
    'sbg:x': 1439.854248046875
    'sbg:y': 479.921875
  - id: gvcf
    outputSource:
      - gatk_haplotype_caller_mod/gvcf
    type: File
    'sbg:x': 816.41845703125
    'sbg:y': 472.921875
steps:
  - id: annotate_variants
    in:
      - id: cache_dir
        source: vep_cache_dir
      - id: coding_only
        source: annotate_coding_only
      - id: custom_clinvar_vcf
        source: custom_clinvar_vcf
      - id: custom_gnomad_vcf
        source: custom_gnomad_vcf
      - id: ensembl_assembly
        source: vep_ensembl_assembly
      - id: ensembl_species
        source: vep_ensembl_species
      - id: ensembl_version
        source: vep_ensembl_version
      - id: plugins
        source:
          - vep_plugins
      - id: reference
        source: reference
      - id: synonyms_file
        source: synonyms_file
      - id: vcf
        source: genotype_gvcfs/genotype_vcf
    out:
      - id: annotated_vcf
      - id: vep_summary
    run: ../tools/vep.cwl
    label: Ensembl Variant Effect Predictor
    'sbg:x': 1041.49658203125
    'sbg:y': 516.7109375
  - id: bgzip_annotated_vcf
    in:
      - id: file
        source: annotate_variants/annotated_vcf
    out:
      - id: bgzipped_file
    run: ../tools/bgzip.cwl
    label: bgzip VCF
    'sbg:x': 1439.854248046875
    'sbg:y': 693.390625
  - id: bgzip_coding_vcf
    in:
      - id: file
        source: coding_variant_filter/filtered_vcf
    out:
      - id: bgzipped_file
    run: ../tools/bgzip.cwl
    label: bgzip VCF
    'sbg:x': 1617.760498046875
    'sbg:y': 640.0234375
  - id: coding_variant_filter
    in:
      - id: vcf
        source: annotate_variants/annotated_vcf
    out:
      - id: filtered_vcf
    run: ../tools/filter_vcf_coding_variant.cwl
    label: Coding Variant filter
    'sbg:x': 1439.854248046875
    'sbg:y': 586.65625
  - id: genotype_gvcfs
    in:
      - id: gvcfs
        source:
          - gatk_haplotype_caller_mod/gvcf
      - id: reference
        source: reference
    out:
      - id: genotype_vcf
    run: ../tools/gatk_genotypegvcfs.cwl
    label: merge GVCFs
    'sbg:x': 816.41845703125
    'sbg:y': 586.65625
  - id: index_annotated_vcf
    in:
      - id: vcf
        source: bgzip_annotated_vcf/bgzipped_file
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1617.760498046875
    'sbg:y': 533.34375
  - id: index_coding_vcf
    in:
      - id: vcf
        source: bgzip_coding_vcf/bgzipped_file
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1795.666748046875
    'sbg:y': 533.3984375
  - id: split_interval_list
    in:
      - id: interval_list
        source: intervals
      - id: scatter_count
        source: scatter_count
    out:
      - id: split_interval_lists
    run: ../tools/split_interval_list.cwl
    'sbg:x': 242.234375
    'sbg:y': 472.8984375
  - id: gatk_haplotype_caller_mod
    in:
      - id: bam
        source: bam
      - id: emit_reference_confidence
        source: emit_reference_confidence
      - id: gvcf_gq_bands
        source:
          - gvcf_gq_bands
      - id: intervals
        source: split_interval_list/split_interval_lists
      - id: reference
        source: reference
    out:
      - id: gvcf
    run: ../tools/gatk_haplotype_caller_mod.cwl
    label: GATK HaplotypeCaller
    scatter:
      - intervals
    'sbg:x': 508.75
    'sbg:y': 558.5234375
requirements:
  - class: ScatterFeatureRequirement
