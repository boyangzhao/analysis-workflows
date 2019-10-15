class: Workflow
cwlVersion: v1.0
doc: >-
  Modifications

  - filter_vcf_dept.cwl: changed base command /usr/bin/depth_filter.py to
  depth_filter2.py (embedded); original code throws error when DP is empty (but
  DP as a field exists), added additional check to handle empty values (None or
  [] in value), in the new depth_filter.2py code
label: Apply filters to VCF file
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: do_cle_vcf_filter
    type: boolean
    'sbg:x': 862.4952392578125
    'sbg:y': 267.5
  - id: filter_gnomADe_maximum_population_allele_frequency
    type: float
    'sbg:x': 0
    'sbg:y': 428
  - id: filter_mapq0_threshold
    type: float
    'sbg:x': 498.203125
    'sbg:y': 267.5
  - id: filter_minimum_depth
    type: int
    'sbg:x': 1194.8546142578125
    'sbg:y': 267.5
  - id: filter_somatic_llr_threshold
    type: float
    'sbg:x': 1415.8233642578125
    'sbg:y': 267.5
  - id: reference
    type: string
    'sbg:x': 0
    'sbg:y': 321
  - id: sample_names
    type: string
    'sbg:x': 0
    'sbg:y': 214
  - id: tumor_bam
    type: File
    secondaryFiles:
      - .bai
    'sbg:x': 0
    'sbg:y': 107
  - id: vcf
    type: File
    'sbg:x': 0
    'sbg:y': 0
outputs:
  - id: filtered_vcf
    outputSource:
      - set_final_vcf_name/replacement
    type: File
    'sbg:x': 2395.214111328125
    'sbg:y': 214
steps:
  - id: filter_vcf_cle
    in:
      - id: filter
        source: do_cle_vcf_filter
      - id: vcf
        source: filter_vcf_mapq0/mapq0_filtered_vcf
    out:
      - id: cle_filtered_vcf
    run: ../tools/filter_vcf_cle.cwl
    label: cle_annotated_vcf_filter
    'sbg:x': 1194.8546142578125
    'sbg:y': 153.5
  - id: filter_vcf_depth
    in:
      - id: minimum_depth
        source: filter_minimum_depth
      - id: sample_names
        source: sample_names
      - id: vcf
        source: filter_vcf_cle/cle_filtered_vcf
    out:
      - id: depth_filtered_vcf
    run: ../tools/filter_vcf_depth.cwl
    label: filter variants at sites below a given sequence depth in each sample
    'sbg:x': 1415.8233642578125
    'sbg:y': 146.5
  - id: filter_vcf_gnomADe_allele_freq
    in:
      - id: maximum_population_allele_frequency
        source: filter_gnomADe_maximum_population_allele_frequency
      - id: vcf
        source: vcf
    out:
      - id: filtered_vcf
    run: ../tools/filter_vcf_gnomADe_allele_freq.cwl
    label: gnomADe_AF filter
    'sbg:x': 498.203125
    'sbg:y': 153.5
  - id: filter_vcf_mapq0
    in:
      - id: reference
        source: reference
      - id: threshold
        source: filter_mapq0_threshold
      - id: tumor_bam
        source: tumor_bam
      - id: vcf
        source: filter_vcf_gnomADe_allele_freq/filtered_vcf
    out:
      - id: mapq0_filtered_vcf
    run: ../tools/filter_vcf_mapq0.cwl
    label: filter vcf for variants with high percentage of mapq0 reads
    'sbg:x': 862.4952392578125
    'sbg:y': 139.5
  - id: filter_vcf_somatic_llr
    in:
      - id: threshold
        source: filter_somatic_llr_threshold
      - id: vcf
        source: filter_vcf_depth/depth_filtered_vcf
    out:
      - id: somatic_llr_filtered_vcf
    run: ../tools/filter_vcf_somatic_llr.cwl
    label: use the binomial/llr somatic filter to weed out low confidence variants
    'sbg:x': 1804.6046142578125
    'sbg:y': 207
  - id: set_final_vcf_name
    in:
      - id: name
        valueFrom: annotated_filtered.vcf
      - id: original
        source: filter_vcf_somatic_llr/somatic_llr_filtered_vcf
    out:
      - id: replacement
    run: ../tools/staged_rename.cwl
    label: Staged Renamer
    'sbg:x': 2199.120361328125
    'sbg:y': 214
requirements: []
