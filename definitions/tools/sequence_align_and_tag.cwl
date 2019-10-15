class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /bin/bash
  - sequence_alignment_helper.sh
inputs:
  - id: bam
    type: File?
    inputBinding:
      position: 0
      prefix: '-b'
  - id: fastq1
    type: File?
    inputBinding:
      position: 0
      prefix: '-1'
  - id: fastq2
    type: File?
    inputBinding:
      position: 0
      prefix: '-2'
  - id: readgroup
    type: string
    inputBinding:
      position: 0
      prefix: '-g'
  - id: reference
    type: string
    inputBinding:
      position: 4
      prefix: '-r'
    doc: bwa-indexed reference file
outputs:
  - id: aligned_bam
    type: File
    outputBinding:
      glob: '*.bam'
doc: >-
  Due to workflow runner limitations, use sequence_align_and_tag_adapter.cwl
  subworkflow to call this


  Modifications

  - modified output to include glob for *.bam and changed type from stdout to
  file
label: align with bwa_mem and tag
arguments:
  - position: 5
    prefix: '-n'
    valueFrom: $(runtime.cores)
requirements:
  - class: SchemaDefRequirement
    types:
      - fields:
          readgroup:
            type: string
          sequence:
            type:
              - fields:
                  bam:
                    type: File
                name: bam
                type: record
              - fields:
                  fastq1:
                    type: File
                  fastq2:
                    type: File
                name: fastqs
                type: record
        label: sequence data with readgroup information
        name: sequence_data
        type: record
  - class: ResourceRequirement
    ramMin: 20000
    coresMin: 8
  - class: DockerRequirement
    dockerPull: 'mgibio/alignment_helper-cwl:1.0.0'
  - class: InitialWorkDirRequirement
    listing:
      - entryname: sequence_alignment_helper.sh
        entry: |
          set -o pipefail
          set -o errexit
          set -o nounset

          while getopts "b:?1:?2:?g:r:n:" opt; do
              case "$opt" in
                  b)
                      MODE=bam
                      BAM="$OPTARG"
                      ;;
                  1)
                      MODE=fastq
                      FASTQ1="$OPTARG"
                      ;;
                  2)  
                      MODE=fastq
                      FASTQ2="$OPTARG"
                      ;;
                  g)
                      READGROUP="$OPTARG"
                      ;;
                  r)
                      REFERENCE="$OPTARG"
                      ;;
                  n)
                      NTHREADS="$OPTARG"
                      ;;
              esac
          done

          if [[ "$MODE" == 'fastq' ]]; then
              /usr/local/bin/bwa mem -K 100000000 -t "$NTHREADS" -Y -R "$READGROUP" "$REFERENCE" "$FASTQ1" "$FASTQ2" | /usr/local/bin/samblaster -a --addMateTags | /opt/samtools/bin/samtools view -b -S /dev/stdin
          fi
          if [[ "$MODE" == 'bam' ]]; then
              /usr/bin/java -Xmx4g -jar /opt/picard/picard.jar SamToFastq I="$BAM" INTERLEAVE=true INCLUDE_NON_PF_READS=true FASTQ=/dev/stdout | /usr/local/bin/bwa mem -K 100000000 -t "$NTHREADS" -Y -p -R "$READGROUP" "$REFERENCE" /dev/stdin | /usr/local/bin/samblaster -a --addMateTags | /opt/samtools/bin/samtools view -b -S /dev/stdin
          fi
        writable: false
  - class: InlineJavascriptRequirement
stdout: refAlign.bam
