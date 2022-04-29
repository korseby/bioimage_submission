#!/usr/bin/env Rscript



# ---------- Preparations ----------
# Load libraries
#library(parallel)               # Detect number of cpu cores
#library(foreach)                # For multicore parallel
#library(doMC)                   # For multicore parallel
library(exiftoolr)               # For reading XMP files

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
if (length(args) < 5) {
	print("Error! No or not enough arguments given.")
	print("Usage: $0 _liverworts_photos_list.tsv input_idr_dir input_processed_dir input_directory output_directory")
	quit(save="no", status=1, runLast=FALSE)
}

# Arguments
input_photo_list_filename <- args[1] # "/Volumes/micromoss_04/micromoss_riccia_upload/BioStudies/_liverworts_photos_list.tsv"
input_dir <- args[2] # "/Volumes/micromoss_04/micromoss_riccia_upload/BioStudies/Riccia bifurca"
input_idr_dir <- args[3] # "/Volumes/micromoss_04/micromoss_riccia_upload/IDR/Riccia bifurca"
input_processed_dir <- args[4] # "/Volumes/scratch/___processing___/2021-09-23 Riccia bifurca"
output_dir <- args[5] # "/Volumes/micromoss_04/micromoss_riccia_upload/BioStudies"



# ---------- Read input data ----------
# Generate species IDs
species_id <- gsub(x=tolower(gsub(x=gsub(x=gsub(x=basename(input_dir), pattern="\\.tsv.*", replacement=""), pattern="subsp", replacement="ssp"), pattern=" s\\.l\\.", replacement="")), pattern=" ", replacement="_")
species_name <- gsub(x=gsub(x=gsub(x=basename(input_dir), pattern="\\.tsv.*", replacement=""), pattern="subsp", replacement="ssp"), pattern=" s\\.l\\.", replacement="")
print(paste0(species_name, " (", species_id, ")"))

# (Translated) Input CSV list containing a list of all the processed images + meta-data
input_photo_list <- read.table(file=input_photo_list_filename, header=TRUE, sep="\t", quote="\"", comment.char="", fill=FALSE, dec=".", stringsAsFactors=FALSE)#, encoding="UTF-8", fileEncoding="UTF-8")

# Get raw images
input_files <- gsub(x=list.files(input_dir, pattern="*.CR3"), pattern=".CR3", replacement="")

# Create output objects
output_files <- paste0(species_name, " files.txt")
output_tables <- paste0(species_name, ".tsv")



# ---------- Prepare meta-data ----------
# Get relevant entries
photo_list_idx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))[1]
photo_list_fileidx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))

# Bug: Riccia bifurca
if (species_id == "riccia_bifurca") {
	photo_list_idx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))[grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_"))) %in% grep(x=input_photo_list$X.http...rs.tdwg.org.dwc.terms.EarliestDateCollected.Collection.Date, pattern="2021")][1]
	photo_list_fileidx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))[grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_"))) %in% grep(x=input_photo_list$X.http...rs.tdwg.org.dwc.terms.EarliestDateCollected.Collection.Date, pattern="2021")]
}

# Bug: s.l.
if (species_id == "scapania_irrigua") {
	photo_list_fileidx <- photo_list_fileidx[!grepl(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name[photo_list_fileidx], pattern="_ssp")]
	photo_list_idx <- photo_list_fileidx[1]
	species_name <- "Scapania irrigua s.l."
}

# Bug: ssp.
if (grepl(x=species_id, pattern="ssp")) {
	species_name <- gsub(x=species_name, pattern="ssp", replacement="subsp")
}

# Bug: Wrong spelling
if (species_id == "scapania_spitzbergensis") {
	species_id <- "scapania_spitsbergensis"
	species_name <- "Scapania spitsbergensis"
	photo_list_idx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))[1]
	photo_list_fileidx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))
}



# ---------- Create file list ----------
tab_files <- data.frame("Files" = list.files(input_dir, pattern="*"),
						"Treatment" = species_name)



# ---------- Read XMP meta-data ----------
xmp_data <- exif_read(path=paste0(input_dir,"/",list.files(input_dir, pattern="*.xmp")), pipeline="json")
xmp_data[,c("ExifToolVersion","FileSize","FileTypeExtension","SourceFile","FileName","Directory","FilePermissions","FileType","MIMEType")] <- list(NULL)
for (i in 1:nrow(xmp_data)) {
	for (j in 1:ncol(xmp_data)) {
		xmp_data[i,j] <- paste0(unlist(xmp_data[i,j]),collapse="")
	}
}
for (j in 1:ncol(xmp_data)) {
	xmp_data[,j] <- as.character(xmp_data[,j])
}
xmp_data <- as.data.frame(xmp_data)



# ---------- Associate files with meta-data ----------
# Create tables with meta-data
tab_meta <- data.frame("Species" = species_id,
					   "Taxon" = input_photo_list$X.http...rs.tdwg.org.dwc.terms.acceptedScientificName.Species.name[photo_list_idx],
					   "Acquisition Date" = xmp_data$DateTimeOriginal,
					   "Voucher record identifier" = input_photo_list$X.http...rs.tdwg.org.dwc.terms.PreservedSpecimen.Voucher.specimen[photo_list_idx],
					   "File list" = paste0(species_name, "/", list.files(input_dir, pattern="*.CR3")),
					   "Raw Camera file list" = list.files(input_dir, pattern="*.CR3"),
					   "Derived raw file list" = list.files(input_dir, pattern="*.TIF"),
					   "Raw settings file list" = list.files(input_dir, pattern="*.xmp"),
					   "Stack name" = "",
					   "Stitch name" = "",
					   "Description" = gsub(x=unlist(lapply(strsplit(x=input_files, split=" "), FUN=function(x){x<-x[-(1:3)];x<-paste(x,collapse=" ")})), pattern=" \\(.*", replacement=""),
					   "Collector" = input_photo_list$X.http...rs.tdwg.org.dwc.terms.recordedBy.Collector[photo_list_idx],
					   "Identified By" = input_photo_list$X.http...rs.tdwg.org.dwc.terms.identifiedBy.Determined[photo_list_idx],
					   "Geodetic Datum" = input_photo_list$X.http...rs.tdwg.org.dwc.terms.geodeticDatum.Geodetic.datum[photo_list_idx],
					   "Latitude" = input_photo_list$X.http...www.ebi.ac.uk.efo.EFO_0005020.Latitude[photo_list_idx],
					   "Longitude" = input_photo_list$X.http...www.ebi.ac.uk.efo.EFO_0005021.Longitude[photo_list_idx],
					   "Elevation" = input_photo_list$X.http...rs.tdwg.org.dwc.terms.verbatimElevation..Elevation[photo_list_idx],
					   "Precision" = input_photo_list$X.http...rs.tdwg.org.dwc.terms.coordinatePrecision.Precision[photo_list_idx],
					   "Magnification" = { x=gsub(x=input_files, pattern="(.*\\(|\\))", replacement="", perl=TRUE); x=gsub(x=x, pattern="IMG.*", replacement=""); x },
					   "Contrast Method" = "",
					   "Instrument" = "",
					   "Objective" = paste(xmp_data$Make, xmp_data$LensModel),
					   "Camera" = xmp_data$Model,
					   "Treatment" = species_id)

# Stack name
img_stacks <- gsub(x=list.files(input_idr_dir, pattern="*"), pattern="(IMG_|\\ .*)", replacement="")
img_stacks_names <- gsub(x=list.files(input_idr_dir, pattern="*"), pattern="(.*\\d\\d\\d\\d\\ |\\.ome.*)", replacement="")

for (i in img_stacks) {
	stack_range = c(as.numeric(gsub(x=i, pattern="\\-.*", replacement="")):as.numeric(gsub(x=i, pattern=".*\\-", replacement="")))
	for (j in 1:length(tab_meta$File.list)) {
		if (as.numeric(gsub(x=tab_meta$Raw.Camera.file.list[j], pattern="(.*\\_|\\ .*)", replacement="")) %in% stack_range) {
			tab_meta$Stack.name[j] <- paste0("IMG_",img_stacks[which(img_stacks==i)]," ",img_stacks_names[which(img_stacks==i)],".TIF")
		}
	}
}

# Stitch name
img_stitch_files <- unique(gsub(x=gsub(x=list.files(input_processed_dir, pattern="*"), pattern="\\.JPG", replacement=""), pattern="\\)\\ \\(.*", replacement="\\)"))
img_stitch <- unique(gsub(x=img_stitch_files, pattern="(IMG_|\\ .*)", replacement=""))
img_stitch_names <- gsub(x=img_stitch_files, pattern="(.*\\d\\d\\d\\d\\ |\\.ome.*)", replacement="")

for (i in img_stitch) {
	stack_range = c(as.numeric(gsub(x=i, pattern="\\-.*", replacement="")):as.numeric(gsub(x=i, pattern=".*\\-", replacement="")))
	for (j in 1:length(tab_meta$File.list)) {
		if (as.numeric(gsub(x=tab_meta$Raw.Camera.file.list[j], pattern="(.*\\_|\\ .*)", replacement="")) %in% stack_range) {
			tab_meta$Stitch.name[j] <- paste0("IMG_",img_stitch[which(img_stitch==i)]," ",img_stitch_names[which(img_stitch==i)],".TIF")
		}
	}
}

# Contrast Method
tab_meta$Contrast.Method[grep(x={ x=gsub(x=input_files, pattern="(.*\\(|\\))", replacement="", perl=TRUE); x=gsub(x=x, pattern="IMG.*", replacement=""); x }, pattern="DIC")] <- "DIC"

# Instrument
tab_meta$Instrument[grep(x=tab_meta$Magnification, pattern="2.5x")] <- "Zeiss Axio Scope.A1"
tab_meta$Instrument[grep(x=tab_meta$Magnification, pattern="5x")] <- "Zeiss Axio Scope.A1"
tab_meta$Instrument[grep(x=tab_meta$Magnification, pattern="10x")] <- "Zeiss Axio Scope.A1"
tab_meta$Instrument[grep(x=tab_meta$Magnification, pattern="20x")] <- "Zeiss Axio Scope.A1"
tab_meta$Instrument[grep(x=tab_meta$Magnification, pattern="40x")] <- "Zeiss Axio Scope.A1"

# Objectives
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="2.5x")] <- "Zeiss EC Plan-Neofluar 2.5x/0.075"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="5x")] <- "Zeiss Plan-Apochromat 5x/0.16"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="10x")] <- "Zeiss Plan-Apochromat 10x/0.45"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="20x")] <- "Zeiss Plan-Apochromat 20x/0.8"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="40x")] <- "Zeiss Plan-Apochromat 40x/0.95 KORR"

tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 0.5x")] <- "Venus Laowa 85mm 5.6 2x Ultra-Macro APO"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 0.75x")] <- "Venus Laowa 85mm 5.6 2x Ultra-Macro APO"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 1.0x")] <- "Venus Laowa 85mm 5.6 2x Ultra-Macro APO"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 1.5x")] <- "Venus Laowa 85mm 5.6 2x Ultra-Macro APO"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 2.0x")] <- "Venus Laowa 85mm 5.6 2x Ultra-Macro APO"

tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 2.5x")] <- "Venus Laowa 25mm 2.8 2.5-5.0x Ultra-Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 3.0x")] <- "Venus Laowa 25mm 2.8 2.5-5.0x Ultra-Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 3.5x")] <- "Venus Laowa 25mm 2.8 2.5-5.0x Ultra-Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 4.0x")] <- "Venus Laowa 25mm 2.8 2.5-5.0x Ultra-Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 4.5x")] <- "Venus Laowa 25mm 2.8 2.5-5.0x Ultra-Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="Laowa 5.0x")] <- "Venus Laowa 25mm 2.8 2.5-5.0x Ultra-Macro"

tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="MP-E 1x")] <- "Canon MP-E 65mm 2.8 1-5x Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="MP-E 2x")] <- "Canon MP-E 65mm 2.8 1-5x Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="MP-E 3x")] <- "Canon MP-E 65mm 2.8 1-5x Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="MP-E 4x")] <- "Canon MP-E 65mm 2.8 1-5x Macro"
tab_meta$Objective[grep(x=tab_meta$Magnification, pattern="MP-E 5x")] <- "Canon MP-E 65mm 2.8 1-5x Macro"

# Attach XMP data
tab_meta <- cbind(tab_meta, xmp_data)


# ---------- Save output files ----------
write.table(tab_files, file=paste0(output_dir,"/",species_name," files.tsv"), sep="\t", row.names=FALSE)
write.table(tab_meta, file=paste0(output_dir,"/",species_name,".tsv"), sep="\t", row.names=FALSE)

