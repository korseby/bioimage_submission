#!/usr/bin/env Rscript



# ---------- Preparations ----------
# Load libraries
#library(parallel)               # Detect number of cpu cores
#library(foreach)                # For multicore parallel
#library(doMC)                   # For multicore parallel

# Setup R error handling to go to stderr
#options(show.error.messages=F, error=function() { cat(geterrmessage(), file=stderr()); q("no",1,F) } )

# Set locales and encoding
#loc <- Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")
#loc <- Sys.setlocale(category="LC_ALL", locale="C")
#options(encoding="UTF-8")

# Set options
options(stringAsfactors=FALSE, useFancyQuotes=FALSE)

# Multicore parallel
#nSlaves <- detectCores(all.tests=FALSE, logical=FALSE)
#nSlaves <- 16
#registerDoMC(nSlaves)



# ---------- User variables ----------
# Take in trailing command line arguments
args <- commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
	print("Error! No or not enough arguments given.")
	print("Usage: $0 input_dir output_tsv")
	quit(save="no", status=1, runLast=FALSE)
}

# Arguments
#input_dirname <- "./_tsv-raw/5-idr"
input_dirname <- args[1]
#output_tsv_filename <- "idr0000-scapaniaceae-assays.tsv"
output_tsv_filename <- args[2]



# ---------- MAIN ----------
#setwd("/Volumes/scratch/___processing___/__IDR/_tsv-raw")

# Read tsv files in directory
input_filenames <- list.files(input_dirname, pattern="*.tsv", recursive=FALSE, full.names=TRUE)

# Append TSV files
output_tsv <- NULL
for (i in input_filenames) {
	tmp = read.table(file=i, header=TRUE, sep="\t", quote="\"", comment.char="", fill=TRUE, dec=".", stringsAsFactors=FALSE)#, encoding="UTF-8", fileEncoding="UTF-8")
	output_tsv <- rbind(output_tsv, tmp)
}

# Fix header names
output_header <- readLines(i)[[1]]
output_header <- as.character(unlist(strsplit(x=gsub(x=output_header, pattern='(\\\\|")', replacement="", perl=T), split="\t")))
colnames(output_tsv) <- output_header

# Fix NAs
output_tsv[is.na(output_tsv)] <- ""

# Write resulting tsv file
write.table(output_tsv, file=output_tsv_filename, sep="\t", row.names=FALSE)


