class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /bin/bash
  - sanitize.sh
inputs:
  - id: vcf
    type: File
    inputBinding:
      position: 1
outputs:
  - id: sanitized_vcf
    type: File
    outputBinding:
      glob: |-
        ${
          if(inputs.vcf.nameext == ".gz"){
            return inputs.vcf.nameroot.replace(/.vcf$/, "") + ".sanitized.vcf.gz";
          }
          return inputs.vcf.nameroot + ".sanitized.vcf.gz";
        }
    secondaryFiles:
      - .tbi
doc: |-
  ####Modifications
  - changed "equals" to "==" in glob, for output ports
label: Sanitize a VCF
requirements:
  - class: ResourceRequirement
    ramMin: 4000
    coresMin: 1
  - class: DockerRequirement
    dockerPull: 'mgibio/samtools-cwl:1.0.0'
  - class: InitialWorkDirRequirement
    listing:
      - entryname: sanitize.sh
        entry: >
          set -eou pipefail


          # 1) removes lines containing non ACTGN bases, as they conflict with
          the VCF spec

          # and cause GATK to choke

          # 2) removes mutect-specific format tags containing underscores, which
          are likewise

          # illegal in the vcf spec

          base=`basename $1`

          outbase=`echo $base | perl -pe 's/.vcf(.gz)?$//g'`

          echo "$1   $base    $outbase"

          if [[ "$1" =~ ".gz" ]];then
              #gzipped input
              gunzip -c "$1" | perl -a -F'\t' -ne 'print $_ if $_ =~ /^#/ || $F[3] !~ /[^ACTGNactgn]/' | sed -e "s/ALT_F1R2/ALTF1R2/g;s/ALT_F2R1/ALTF2R1/g;s/REF_F1R2/REFF1R2/g;s/REF_F2R1/REFF2R1/g" >$outbase.sanitized.vcf
          else
              #non-gzipped input
              cat "$1" | perl -a -F'\t' -ne 'print $_ if $_ =~ /^#/ || $F[3] !~ /[^ACTGNactgn]/' | sed -e "s/ALT_F1R2/ALTF1R2/g;s/ALT_F2R1/ALTF2R1/g;s/REF_F1R2/REFF1R2/g;s/REF_F2R1/REFF2R1/g" >$outbase.sanitized.vcf
          fi

          /opt/htslib/bin/bgzip $outbase.sanitized.vcf

          tabix -p vcf $outbase.sanitized.vcf.gz
        writable: false
  - class: InlineJavascriptRequirement
