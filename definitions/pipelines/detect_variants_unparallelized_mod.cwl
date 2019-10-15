class: Workflow
cwlVersion: v1.0
doc: >-
  ####Modifications (this workflow)

  - made VEP pick input not as port, but as exposed (port throws error on sb
  platform)

  - in addition to unparallelized version, here also removed the final
  selectvariant+vep_annotator for generating the tsv table, which was throwing
  errors on sb platform)


  ####Modifications (other individual components)

  - docm_add_variants.cwl: added .tbi as required secondary file

  - combine_variants.cwl: added .tbi as required secondary file

  - bam_readcount.cwl: changed "equals" to "==" in glob, for output ports


  ####Modifications (mutect workflow)

  - mutect was unparallelized (modified mutect.cwl, calling the new
  mutect_unparallelized.cwl), and also removed scatter in this workflow


  ####Modifications (varscan workflow)

  - bgzip.cwl stdout modified with glob

  - vcf_sanitize.cwl: changed "equals" to "==" in glob, for output ports


  ####Modifications (pindel workflow)

  - cat_all.cwl and cat_out.cwl: changed stdout to glob


  ####Modifications (filter vcf workflow)

  - filter_vcf_depth.cwl: changed base command /usr/bin/depth_filter.py to
  depth_filter2.py (embedded); original code throws error when DP is empty (but
  DP as a field exists), added additional check to handle empty values (None or
  [] in value), in the new depth_filter.2py code

  - filter_vcf_somatic_llr.cwl: changed base command
  /usr/bin/somatic_llr_filter.py to somatic_llr_filter2.py (embedded); original
  code throws error when DP is empty (but DP as a field exists), added
  additional check to handle empty values (None or [] in value), and also added
  additional checks for AD being empty ([]) or with less than two elements in
  array, in the new somatic_llr_filter2.py code
label: Detect Variants workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: annotate_coding_only
    type: boolean?
    'sbg:x': 1384.740966796875
    'sbg:y': 1444.5
  - id: cle_vcf_filter
    type: boolean?
    default: false
    'sbg:x': 2818.475830078125
    'sbg:y': 1658.5
  - id: custom_clinvar_vcf
    type: File?
    secondaryFiles:
      - .tbi
    'sbg:x': 0
    'sbg:y': 2782
  - id: custom_gnomad_vcf
    type: File?
    secondaryFiles:
      - .tbi
    'sbg:x': 0
    'sbg:y': 2675
  - id: docm_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 0
    'sbg:y': 2568
  - id: filter_docm_variants
    type: boolean?
    default: true
    'sbg:x': 0
    'sbg:y': 2461
  - id: filter_gnomADe_maximum_population_allele_frequency
    type: float?
    default: 0.001
    'sbg:x': 2818.475830078125
    'sbg:y': 1551.5
  - id: filter_mapq0_threshold
    type: float?
    default: 0.15
    'sbg:x': 2818.475830078125
    'sbg:y': 1444.5
  - id: filter_minimum_depth
    type: int?
    default: 1
    'sbg:x': 2818.475830078125
    'sbg:y': 1337.5
  - id: filter_somatic_llr_threshold
    type: float?
    default: 5
    'sbg:x': 2818.475830078125
    'sbg:y': 1230.5
  - id: interval_list
    type: File
    'sbg:x': 0
    'sbg:y': 2354
  - id: normal_bam
    type: File
    secondaryFiles:
      - .bai
      - ^.bai
    'sbg:x': 0
    'sbg:y': 2140
  - id: pindel_insert_size
    type: int
    default: 400
    'sbg:x': 0
    'sbg:y': 2033
  - id: readcount_minimum_base_quality
    type: int?
    'sbg:x': 1609.834716796875
    'sbg:y': 1314
  - id: readcount_minimum_mapping_quality
    type: int?
    'sbg:x': 1609.834716796875
    'sbg:y': 1207
  - id: reference
    type: string
    'sbg:x': 0
    'sbg:y': 1926
  - id: strelka_cpu_reserved
    type: int?
    default: 8
    'sbg:x': 0
    'sbg:y': 1819
  - id: strelka_exome_mode
    type: boolean
    'sbg:x': 0
    'sbg:y': 1712
  - id: synonyms_file
    type: File?
    'sbg:x': 0
    'sbg:y': 1605
  - id: tumor_bam
    type: File
    secondaryFiles:
      - .bai
      - ^.bai
    'sbg:x': 0
    'sbg:y': 1498
  - id: varscan_max_normal_freq
    type: float?
    'sbg:x': 0
    'sbg:y': 1177
  - id: varscan_min_coverage
    type: int?
    default: 8
    'sbg:x': 0
    'sbg:y': 1070
  - id: varscan_min_var_freq
    type: float?
    default: 0.1
    'sbg:x': 0
    'sbg:y': 963
  - id: varscan_p_value
    type: float?
    default: 0.99
    'sbg:x': 0
    'sbg:y': 856
  - id: varscan_strand_filter
    type: int?
    default: 0
    'sbg:x': 0
    'sbg:y': 749
  - id: vep_cache_dir
    type: string
    'sbg:x': 0
    'sbg:y': 642
  - id: vep_ensembl_assembly
    type: string
    doc: 'genome assembly to use in vep. Examples: GRCh38 or GRCm38'
    'sbg:x': 0
    'sbg:y': 535
  - id: vep_ensembl_species
    type: string
    doc: >-
      ensembl species - Must be present in the cache directory. Examples:
      homo_sapiens or mus_musculus
    'sbg:x': 0
    'sbg:y': 428
  - id: vep_ensembl_version
    type: string
    doc: 'ensembl version - Must be present in the cache directory. Example: 95'
    'sbg:x': 0
    'sbg:y': 321
  - id: plugins
    type:
      type: array
      items: string
      inputBinding:
        prefix: '--plugin'
    'sbg:exposed': true
  - id: pick
    type:
      - 'null'
      - type: enum
        symbols:
          - pick
          - flag_pick
          - pick_allele
          - per_gene
          - pick_allele_gene
          - flag_pick_allele
          - flag_pick_allele_gene
        name: pick
    'sbg:exposed': true
  - id: scatter_count
    type: int
    'sbg:x': -0.4084782302379608
    'sbg:y': 1368.94873046875
outputs:
  - id: docm_filtered_vcf
    outputSource:
      - docm/docm_variants_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 1737.5
  - id: final_filtered_vcf
    outputSource:
      - annotated_filter_index/indexed_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 4197.830078125
    'sbg:y': 1392.7362060546875
  - id: final_vcf
    outputSource:
      - index/indexed_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 3316.678955078125
    'sbg:y': 1288.5
  - id: mutect_filtered_vcf
    outputSource:
      - mutect/filtered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 1630.5
  - id: mutect_unfiltered_vcf
    outputSource:
      - mutect/unfiltered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 1523.5
  - id: normal_indel_bam_readcount_tsv
    outputSource:
      - normal_bam_readcount/indel_bam_readcount_tsv
    type: File
    'sbg:x': 2407.288330078125
    'sbg:y': 1416.5
  - id: normal_snv_bam_readcount_tsv
    outputSource:
      - normal_bam_readcount/snv_bam_readcount_tsv
    type: File
    'sbg:x': 2407.288330078125
    'sbg:y': 1309.5
  - id: pindel_filtered_vcf
    outputSource:
      - pindel/filtered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 1416.5
  - id: pindel_unfiltered_vcf
    outputSource:
      - pindel/unfiltered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 1309.5
  - id: strelka_filtered_vcf
    outputSource:
      - strelka/filtered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 1202.5
  - id: strelka_unfiltered_vcf
    outputSource:
      - strelka/unfiltered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 1095.5
  - id: tumor_indel_bam_readcount_tsv
    outputSource:
      - tumor_bam_readcount/indel_bam_readcount_tsv
    type: File
    'sbg:x': 2407.288330078125
    'sbg:y': 1202.5
  - id: tumor_snv_bam_readcount_tsv
    outputSource:
      - tumor_bam_readcount/snv_bam_readcount_tsv
    type: File
    'sbg:x': 2407.288330078125
    'sbg:y': 1095.5
  - id: varscan_filtered_vcf
    outputSource:
      - varscan/filtered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 988.5
  - id: varscan_unfiltered_vcf
    outputSource:
      - varscan/unfiltered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 680.1975708007812
    'sbg:y': 881.5
  - id: vep_summary
    outputSource:
      - annotate_variants/vep_summary
    type: File
    'sbg:x': 2018.057373046875
    'sbg:y': 1228
steps:
  - id: add_docm_variants
    in:
      - id: callers_vcf
        source: combine/combined_vcf
      - id: docm_vcf
        source: docm/docm_variants_vcf
      - id: reference
        source: reference
    out:
      - id: merged_vcf
    run: ../tools/docm_add_variants.cwl
    label: CombineVariants (GATK 3.6)
    'sbg:x': 953.365966796875
    'sbg:y': 1377
  - id: add_normal_bam_readcount_to_vcf
    in:
      - id: data_type
        default: DNA
      - id: indel_bam_readcount_tsv
        source: normal_bam_readcount/indel_bam_readcount_tsv
      - id: sample_name
        default: NORMAL
      - id: snv_bam_readcount_tsv
        source: normal_bam_readcount/snv_bam_readcount_tsv
      - id: vcf
        source: add_tumor_bam_readcount_to_vcf/annotated_bam_readcount_vcf
    out:
      - id: annotated_bam_readcount_vcf
    run: ../subworkflows/vcf_readcount_annotator.cwl
    label: Add snv and indel bam-readcount files to a vcf
    'sbg:x': 2407.288330078125
    'sbg:y': 1672.5
  - id: add_tumor_bam_readcount_to_vcf
    in:
      - id: data_type
        default: DNA
      - id: indel_bam_readcount_tsv
        source: tumor_bam_readcount/indel_bam_readcount_tsv
      - id: sample_name
        default: TUMOR
      - id: snv_bam_readcount_tsv
        source: tumor_bam_readcount/snv_bam_readcount_tsv
      - id: vcf
        source: annotate_variants/annotated_vcf
    out:
      - id: annotated_bam_readcount_vcf
    run: ../subworkflows/vcf_readcount_annotator.cwl
    label: Add snv and indel bam-readcount files to a vcf
    'sbg:x': 2407.288330078125
    'sbg:y': 1537.5
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
      - id: pick
        source: pick
      - id: plugins
        source:
          - plugins
      - id: reference
        source: reference
      - id: synonyms_file
        source: synonyms_file
      - id: vcf
        source: decompose_index/indexed_vcf
    out:
      - id: annotated_vcf
      - id: vep_summary
    run: ../tools/vep.cwl
    label: Ensembl Variant Effect Predictor
    'sbg:x': 1609.834716796875
    'sbg:y': 1498
  - id: annotated_filter_bgzip
    in:
      - id: file
        source: filter_vcf/filtered_vcf
    out:
      - id: bgzipped_file
    run: ../tools/bgzip.cwl
    label: bgzip VCF
    'sbg:x': 3836.649658203125
    'sbg:y': 1391
  - id: annotated_filter_index
    in:
      - id: vcf
        source: annotated_filter_bgzip/bgzipped_file
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 4014.555908203125
    'sbg:y': 1391
  - id: combine
    in:
      - id: mutect_vcf
        source: mutect/filtered_vcf
      - id: pindel_vcf
        source: pindel/filtered_vcf
      - id: reference
        source: reference
      - id: strelka_vcf
        source: strelka/filtered_vcf
      - id: varscan_vcf
        source: varscan/filtered_vcf
    out:
      - id: combined_vcf
    run: ../tools/combine_variants.cwl
    label: CombineVariants (GATK 3.6)
    'sbg:x': 680.1975708007812
    'sbg:y': 1872.5
  - id: decompose
    in:
      - id: vcf
        source: add_docm_variants/merged_vcf
    out:
      - id: decomposed_vcf
    run: ../tools/vt_decompose.cwl
    label: run vt decompose
    'sbg:x': 1186.959716796875
    'sbg:y': 1391
  - id: decompose_index
    in:
      - id: vcf
        source: decompose/decomposed_vcf
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1384.740966796875
    'sbg:y': 1337.5
  - id: docm
    in:
      - id: docm_vcf
        source: docm_vcf
      - id: filter_docm_variants
        source: filter_docm_variants
      - id: interval_list
        source: interval_list
      - id: normal_bam
        source: normal_bam
      - id: reference
        source: reference
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: docm_variants_vcf
    run: ../subworkflows/docm_cle.cwl
    label: Detect Docm variants
    'sbg:x': 323.21875
    'sbg:y': 1696
  - id: filter_vcf
    in:
      - id: do_cle_vcf_filter
        source: cle_vcf_filter
      - id: filter_gnomADe_maximum_population_allele_frequency
        source: filter_gnomADe_maximum_population_allele_frequency
      - id: filter_mapq0_threshold
        source: filter_mapq0_threshold
      - id: filter_minimum_depth
        source: filter_minimum_depth
      - id: filter_somatic_llr_threshold
        source: filter_somatic_llr_threshold
      - id: reference
        source: reference
      - id: sample_names
        default: 'NORMAL,TUMOR'
      - id: tumor_bam
        source: tumor_bam
      - id: vcf
        source: index/indexed_vcf
    out:
      - id: filtered_vcf
    run: ../subworkflows/filter_vcf.cwl
    label: Apply filters to VCF file
    'sbg:x': 3316.678955078125
    'sbg:y': 1444.5
  - id: index
    in:
      - id: vcf
        source: add_normal_bam_readcount_to_vcf/annotated_bam_readcount_vcf
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 2818.475830078125
    'sbg:y': 1123.5
  - id: mutect
    in:
      - id: interval_list
        source: interval_list
      - id: normal_bam
        source: normal_bam
      - id: reference
        source: reference
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_vcf
      - id: unfiltered_vcf
    run: ../subworkflows/mutect_unparallelized.cwl
    label: mutect workflow
    'sbg:x': 323.21875
    'sbg:y': 1526
  - id: normal_bam_readcount
    in:
      - id: bam
        source: normal_bam
      - id: min_base_quality
        source: readcount_minimum_base_quality
      - id: min_mapping_quality
        source: readcount_minimum_mapping_quality
      - id: reference_fasta
        source: reference
      - id: sample
        default: NORMAL
      - id: vcf
        source: annotate_variants/annotated_vcf
    out:
      - id: indel_bam_readcount_tsv
      - id: snv_bam_readcount_tsv
    run: ../tools/bam_readcount.cwl
    label: run bam-readcount
    'sbg:x': 2018.057373046875
    'sbg:y': 1526
  - id: pindel
    in:
      - id: insert_size
        source: pindel_insert_size
      - id: interval_list
        source: interval_list
      - id: normal_bam
        source: normal_bam
      - id: reference
        source: reference
      - id: scatter_count
        source: scatter_count
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_vcf
      - id: unfiltered_vcf
    run: ../subworkflows/pindel.cwl
    label: pindel parallel workflow
    'sbg:x': 323.21875
    'sbg:y': 1363
  - id: strelka
    in:
      - id: cpu_reserved
        source: strelka_cpu_reserved
      - id: exome_mode
        source: strelka_exome_mode
      - id: interval_list
        source: interval_list
      - id: normal_bam
        source: normal_bam
      - id: reference
        source: reference
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_vcf
      - id: unfiltered_vcf
    run: ../subworkflows/strelka_and_post_processing.cwl
    label: strelka workflow
    'sbg:x': 323.21875
    'sbg:y': 1193
  - id: tumor_bam_readcount
    in:
      - id: bam
        source: tumor_bam
      - id: min_base_quality
        source: readcount_minimum_base_quality
      - id: min_mapping_quality
        source: readcount_minimum_mapping_quality
      - id: reference_fasta
        source: reference
      - id: sample
        default: TUMOR
      - id: vcf
        source: annotate_variants/annotated_vcf
    out:
      - id: indel_bam_readcount_tsv
      - id: snv_bam_readcount_tsv
    run: ../tools/bam_readcount.cwl
    label: run bam-readcount
    'sbg:x': 2018.057373046875
    'sbg:y': 1363
  - id: varscan
    in:
      - id: interval_list
        source: interval_list
      - id: max_normal_freq
        source: varscan_max_normal_freq
      - id: min_coverage
        source: varscan_min_coverage
      - id: min_var_freq
        source: varscan_min_var_freq
      - id: normal_bam
        source: normal_bam
      - id: p_value
        source: varscan_p_value
      - id: reference
        source: reference
      - id: strand_filter
        source: varscan_strand_filter
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: filtered_vcf
      - id: unfiltered_vcf
    run: ../subworkflows/varscan_pre_and_post_processing.cwl
    label: Varscan Workflow
    'sbg:x': 323.21875
    'sbg:y': 995
requirements:
  - class: SubworkflowFeatureRequirement
