class: Workflow
cwlVersion: v1.0
doc: |-
  Modifications
  - bgzip.cwl stdout modified with glob
  - vcf_sanitize.cwl: changed "equals" to "==" in glob, for output ports
label: Varscan Workflow
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: interval_list
    type: File
    'sbg:x': 0
    'sbg:y': 428
  - id: max_normal_freq
    type: float?
    'sbg:x': 142.515625
    'sbg:y': 749
  - id: min_coverage
    type: int?
    default: 8
    'sbg:x': 142.515625
    'sbg:y': 642
  - id: min_var_freq
    type: float?
    default: 0.1
    'sbg:x': 142.515625
    'sbg:y': 535
  - id: normal_bam
    type: File
    secondaryFiles:
      - ^.bai
    'sbg:x': 142.515625
    'sbg:y': 428
  - id: p_value
    type: float?
    default: 0.99
    'sbg:x': 142.515625
    'sbg:y': 321
  - id: reference
    type: string
    'sbg:x': 142.515625
    'sbg:y': 214
  - id: strand_filter
    type: int?
    default: 0
    'sbg:x': 142.515625
    'sbg:y': 107
  - id: tumor_bam
    type: File
    secondaryFiles:
      - ^.bai
    'sbg:x': 142.515625
    'sbg:y': 0
outputs:
  - id: filtered_vcf
    outputSource:
      - filter/filtered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 1964.391357421875
    'sbg:y': 481.5
  - id: unfiltered_vcf
    outputSource:
      - filter/unfiltered_vcf
    type: File
    secondaryFiles:
      - .tbi
    'sbg:x': 1964.391357421875
    'sbg:y': 374.5
steps:
  - id: bgzip_and_index_hc_indels
    in:
      - id: vcf
        source: varscan/somatic_hc_indels
    out:
      - id: indexed_vcf
    run: bgzip_and_index.cwl
    label: bgzip and index VCF
    'sbg:x': 771.982666015625
    'sbg:y': 588.5
  - id: bgzip_and_index_hc_snvs
    in:
      - id: vcf
        source: varscan/somatic_hc_snvs
    out:
      - id: indexed_vcf
    run: bgzip_and_index.cwl
    label: bgzip and index VCF
    'sbg:x': 771.982666015625
    'sbg:y': 481.5
  - id: bgzip_and_index_indels
    in:
      - id: vcf
        source: varscan/somatic_indels
    out:
      - id: indexed_vcf
    run: bgzip_and_index.cwl
    label: bgzip and index VCF
    'sbg:x': 771.982666015625
    'sbg:y': 374.5
  - id: bgzip_and_index_snvs
    in:
      - id: vcf
        source: varscan/somatic_snvs
    out:
      - id: indexed_vcf
    run: bgzip_and_index.cwl
    label: bgzip and index VCF
    'sbg:x': 771.982666015625
    'sbg:y': 267.5
  - id: filter
    in:
      - id: bam
        source: tumor_bam
      - id: min_var_freq
        source: min_var_freq
      - id: reference
        source: reference
      - id: variant_caller
        valueFrom: varscan
      - id: vcf
        source: index/indexed_vcf
    out:
      - id: filtered_vcf
      - id: unfiltered_vcf
    run: fp_filter.cwl
    label: fp_filter workflow
    'sbg:x': 1696.607666015625
    'sbg:y': 407
  - id: index
    in:
      - id: vcf
        source: merge/merged_vcf
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1524.826416015625
    'sbg:y': 428
  - id: index_indels
    in:
      - id: vcf
        source: merge_indels/merged_vcf
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1176.717041015625
    'sbg:y': 481.5
  - id: index_snvs
    in:
      - id: vcf
        source: merge_snvs/merged_vcf
    out:
      - id: indexed_vcf
    run: ../tools/index_vcf.cwl
    label: vcf index
    'sbg:x': 1176.717041015625
    'sbg:y': 374.5
  - id: intervals_to_bed
    in:
      - id: interval_list
        source: interval_list
    out:
      - id: interval_bed
    run: ../tools/intervals_to_bed.cwl
    'sbg:x': 142.515625
    'sbg:y': 856
  - id: merge
    in:
      - id: vcfs
        source:
          - index_snvs/indexed_vcf
          - index_indels/indexed_vcf
    out:
      - id: merged_vcf
    run: ../tools/merge_vcf.cwl
    label: vcf merge
    'sbg:x': 1348.498291015625
    'sbg:y': 428
  - id: merge_indels
    in:
      - id: filtered_vcf
        source: bgzip_and_index_hc_indels/indexed_vcf
      - id: reference
        source: reference
      - id: vcf
        source: bgzip_and_index_indels/indexed_vcf
    out:
      - id: merged_vcf
    run: ../tools/set_filter_status.cwl
    label: create filtered VCF
    'sbg:x': 943.763916015625
    'sbg:y': 481.5
  - id: merge_snvs
    in:
      - id: filtered_vcf
        source: bgzip_and_index_hc_snvs/indexed_vcf
      - id: reference
        source: reference
      - id: vcf
        source: bgzip_and_index_snvs/indexed_vcf
    out:
      - id: merged_vcf
    run: ../tools/set_filter_status.cwl
    label: create filtered VCF
    'sbg:x': 943.763916015625
    'sbg:y': 346.5
  - id: varscan
    in:
      - id: max_normal_freq
        source: max_normal_freq
      - id: min_coverage
        source: min_coverage
      - id: min_var_freq
        source: min_var_freq
      - id: normal_bam
        source: normal_bam
      - id: p_value
        source: p_value
      - id: reference
        source: reference
      - id: roi_bed
        source: intervals_to_bed/interval_bed
      - id: strand_filter
        source: strand_filter
      - id: tumor_bam
        source: tumor_bam
    out:
      - id: germline_hc_indels
      - id: germline_hc_snvs
      - id: germline_indels
      - id: germline_snvs
      - id: indels
      - id: loh_hc_indels
      - id: loh_hc_snvs
      - id: loh_indels
      - id: loh_snvs
      - id: snvs
      - id: somatic_hc_indels
      - id: somatic_hc_snvs
      - id: somatic_indels
      - id: somatic_snvs
    run: varscan.cwl
    label: varscan somatic workflow
    'sbg:x': 399.93121337890625
    'sbg:y': 766.7686767578125
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
