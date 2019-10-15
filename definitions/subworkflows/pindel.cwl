class: Workflow
cwlVersion: v1.0
doc: |-
  Modifications
  - cat_all.cwl and cat_out.cwl: changed stdout to glob
label: pindel parallel workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: insert_size
    type: int
    default: 400
    'sbg:x': 156.25
    'sbg:y': 221
  - id: interval_list
    type: File
    'sbg:x': 0
    'sbg:y': 221
  - id: normal_bam
    type: File
    secondaryFiles:
      - ^.bai
    'sbg:x': 156.25
    'sbg:y': 114
  - id: reference
    type: string
    'sbg:x': 709.6949462890625
    'sbg:y': 60.5
  - id: scatter_count
    type: int
    default: 50
    'sbg:x': 0
    'sbg:y': 114
  - id: tumor_bam
    type: File
    secondaryFiles:
      - ^.bai
    'sbg:x': 0
    'sbg:y': 7
outputs:
  - id: filtered_vcf
    outputSource:
      - filter/filtered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 2218.347412109375
    'sbg:y': 167.5
  - id: unfiltered_vcf
    outputSource:
      - filter/unfiltered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 2218.347412109375
    'sbg:y': 60.5
steps:
  - id: bgzip
    in:
      - id: file
        source: somaticfilter/vcf
    out:
      - id: bgzipped_file
    run: ../tools/bgzip.cwl
    label: bgzip VCF
    'sbg:x': 1268.174560546875
    'sbg:y': 114
  - id: cat_all
    in:
      - id: region_pindel_outs
        source:
          - pindel_cat/per_region_pindel_out
    out:
      - id: all_region_pindel_head
    run: ../tools/cat_all.cwl
    'sbg:x': 709.6949462890625
    'sbg:y': 167.5
  - id: filter
    in:
      - id: bam
        source: tumor_bam
      - id: reference
        source: reference
      - id: variant_caller
        valueFrom: pindel
      - id: vcf
        source: reindex/indexed_vcf
    out:
      - id: filtered_vcf
      - id: unfiltered_vcf
    run: fp_filter.cwl
    label: fp_filter workflow
    'sbg:x': 1981.112060546875
    'sbg:y': 100
  - id: index
    in:
      - id: vcf
        source: bgzip/bgzipped_file
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1446.080810546875
    'sbg:y': 114
  - id: pindel_cat
    in:
      - id: insert_size
        source: insert_size
      - id: normal_bam
        source: normal_bam
      - id: reference
        source: reference
      - id: region_file
        source: split_interval_list_to_bed/split_beds
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: per_region_pindel_out
    run: pindel_cat.cwl
    label: Per-region pindel
    scatter:
      - region_file
    'sbg:x': 383.5577697753906
    'sbg:y': 86
  - id: reindex
    in:
      - id: vcf
        source: remove_end_tags/processed_vcf
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1809.330810546875
    'sbg:y': 114
  - id: remove_end_tags
    in:
      - id: vcf
        source: index/indexed_vcf
    out:
      - id: processed_vcf
    run: ../tools/remove_end_tags.cwl
    label: remove END INFO tags
    'sbg:x': 1617.862060546875
    'sbg:y': 114
  - id: somaticfilter
    in:
      - id: pindel_output_summary
        source: cat_all/all_region_pindel_head
      - id: reference
        source: reference
    out:
      - id: vcf
    run: ../tools/pindel_somatic_filter.cwl
    label: pindel somatic filter v1
    'sbg:x': 1023.5699462890625
    'sbg:y': 107
  - id: split_interval_list_to_bed
    in:
      - id: interval_list
        source: interval_list
      - id: scatter_count
        source: scatter_count
    out:
      - id: split_beds
    run: ../tools/split_interval_list_to_bed.cwl
    'sbg:x': 156.25
    'sbg:y': 0
requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
