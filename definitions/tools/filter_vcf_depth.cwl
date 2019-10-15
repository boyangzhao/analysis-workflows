class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - /opt/conda/bin/python3
  - depth_filter2.py
inputs:
  - id: minimum_depth
    type: int
    inputBinding:
      position: -3
      prefix: '--minimum_depth'
  - id: sample_names
    type: string
    inputBinding:
      position: -1
  - id: vcf
    type: File
    inputBinding:
      position: -2
outputs:
  - id: depth_filtered_vcf
    type: File
    outputBinding:
      glob: depth_filtered.vcf
doc: >-
  Modifications

  - changed base command /usr/bin/depth_filter.py to depth_filter2.py
  (embedded); original code throws error when DP is empty (but DP as a field
  exists), added additional check to handle empty values (None or [] in value),
  in the new depth_filter2.py code
label: filter variants at sites below a given sequence depth in each sample
arguments:
  - position: 0
    valueFrom: $(runtime.outdir)/depth_filtered.vcf
requirements:
  - class: ResourceRequirement
    ramMin: 4000
  - class: DockerRequirement
    dockerPull: 'mgibio/depth-filter:0.1.2'
  - class: InitialWorkDirRequirement
    listing:
      - entryname: depth_filter2.py
        entry: |-
          import argparse
          import sys
          import os
          import re
          import vcfpy
          import tempfile
          import csv
          import math
          from collections import OrderedDict

          def define_parser():
              parser = argparse.ArgumentParser('depth-filter')
              parser.add_argument(
                  "input_vcf",
                  help="A VCF file with at least two samples (tumor and normal) and readcount information"
              )
              parser.add_argument(
                  "sample_names",
                  help="comma-separated list of samples to which depth filter will be applied",
              )
              parser.add_argument(
                  "output_vcf",
                  help="Path to write the output VCF file"
              )
              parser.add_argument(
                  "--minimum_depth",
                  help="minimum depth for a variant",
                  type=int,
              )
              parser.add_argument(
                  "--site-depth-field",
                  help="field corresponding to site depth - default DP",
                  default="DP"
              )
              parser.add_argument(
                  "--filter-field",
                  help="if variant doesn't have a given depth, then failing variants will have this string added to their FILTER field",
                  default="DEPTH"
              )
              return parser


          def create_vcf_reader(args):
              vcf_reader = vcfpy.Reader.from_path(args.input_vcf)
              #do some sanity checking
              sample_names = vcf_reader.header.samples.names

              sample_args=args.sample_names.split(",")
              for samp in sample_args:
                  if not samp in sample_names:
                      raise Exception("Could not find sample name {} in VCF sample names".format(samp))

              #check for needed format field
              if not args.site_depth_field in vcf_reader.header.format_ids():
                  vcf_reader.close()
                  raise Exception("No {} format field found. Annotate your VCF with depth info first".format(args.site_depth_field))
              return vcf_reader


          def create_vcf_writer(args, vcf_reader):
              output_file = args.output_vcf
              new_header = vcf_reader.header.copy()

              #check/add FILTER field in header
              if not args.filter_field in vcf_reader.header.filter_ids():
                  od = OrderedDict([('ID', args.filter_field), ('Description', 'Site is below minimum depth')])
                  new_header.add_filter_line(od)

              return vcfpy.Writer.from_path(output_file, new_header)


          def main(args_input = sys.argv[1:]):
              parser = define_parser()
              args = parser.parse_args(args_input)
              vcf_reader  = create_vcf_reader(args)
              vcf_writer = create_vcf_writer(args, vcf_reader)
              na_err=True
              empty_err=True

              for entry in vcf_reader:
                  def getFormatField(sample_name, field_name):
                      if(sample_name in entry.call_for_sample and field_name in entry.call_for_sample[sample_name].data):
                          val = entry.call_for_sample[sample_name].data[field_name]
                          if val:  #added this additional check
                              return val
                          return("empty")
                      return("NA")

                  filter=False
                  for samp in args.sample_names.split(","):
                      depth = getFormatField(samp,args.site_depth_field)
                      if(depth=="NA"):
                          if na_err:
                              print("WARNING: One or more sites lack the {} field. Those are being treated as zero and filtered".format(args.site_depth_field))
                              na_err=False
                          filter=True
                      if(depth=="empty"):
                          if empty_err:
                              print("WARNING: One or more sites in the {} field is empty. Those are being treated as zero and filtered".format(args.site_depth_field))
                              empty_err=False
                          filter=True
                      elif(depth < args.minimum_depth):
                          filter=True

                  if filter==True:
                      entry.add_filter(args.filter_field);

                  vcf_writer.write_record(entry)

              vcf_reader.close()
              vcf_writer.close()

          if __name__ == '__main__':
              main()
        writable: false
  - class: InlineJavascriptRequirement
