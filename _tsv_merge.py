#!/usr/bin/env python

# Load modules
import errno
import sys
import os
import argparse
import glob
from pathlib import Path
import re



# -------------------- Arguments --------------------
# Parse arguments
parser = argparse.ArgumentParser(description='Merge columns of two TSV files.')
parser.add_argument('-v', '--version', action='version', version='merge TSV Version 0.2',
                   help='show version')
parser.add_argument('-i1', '--input1', metavar='input1', dest='input1', required=True,
                   help='First TSV file')
parser.add_argument('-i2', '--input2', metavar='input2', dest='input2', required=True,
                   help='Second TSV file which is appended to the first TSV file')
parser.add_argument('-o', '--output', metavar='output', dest='output', required=True,
                   help='destination TSV file')

args = parser.parse_args()

# Input TSV files
input_tsv_file_1 = args.input1
input_tsv_file_2 = args.input2

# Destination TSV file
output_tsv_file = args.output



# -------------------- MAIN --------------------
import pandas
pandas.set_option('mode.chained_assignment', None)

# Read input TSV files
input_tsv_left = pandas.read_csv(input_tsv_file_1, sep='\t', na_values=[''], low_memory=False)
input_tsv_right = pandas.read_csv(input_tsv_file_2, sep='\t', na_values=[''], low_memory=False)

# Drop first row and column of right input file (xmp data)
input_tsv_right = input_tsv_right.drop(input_tsv_right.index[[0]], axis=0)
input_tsv_right = input_tsv_right.drop(input_tsv_right.columns[[0]], axis=1)

input_tsv_right.to_csv(output_tsv_file, header=True, index=False, sep='\t', na_rep='')
input_tsv_right = pandas.read_csv(output_tsv_file, sep='\t', na_values=[''], low_memory=False)

# Merge the two input files next to each other
output_tsv = pandas.DataFrame.join(input_tsv_left, input_tsv_right, how='right')

# Save dataframe to TSV
output_tsv.to_csv(output_tsv_file, header=True, index=False, sep='\t', na_rep='')
