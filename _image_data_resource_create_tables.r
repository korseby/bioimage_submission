#!/usr/bin/env Rscript



# ---------- Preparations ----------
# Set options
options(stringAsfactors=FALSE, useFancyQuotes=FALSE)



# ---------- User variables ----------
# Take in trailing command line arguments
args <- commandArgs(trailingOnly=TRUE)
if (length(args) < 3) {
	print("Error! No or not enough arguments given.")
	print("Usage: $0 biostudies_input_raw.tsv _liverworts_photo_list.tsv output")
	quit(save="no", status=1, runLast=FALSE)
}

# Arguments
input_raw_tsv_filename <- args[1] # "/Volumes/micromoss_04/micromoss_riccia_upload/BioStudies/Riccia\ bifurca.tsv"
input_photo_list_filename <- args[2] # "/Volumes/micromoss_04/micromoss_riccia_upload/IDR/_liverworts_photos_list.tsv"
assays_output_tsv_filename <- paste0(args[3],"_assays.tsv") # "Riccia bifurca_assays.tsv"

# Generate species IDs
species_id <- gsub(x=tolower(gsub(x=gsub(x=gsub(x=basename(input_raw_tsv_filename), pattern="\\.tsv.*", replacement=""), pattern="subsp", replacement="ssp"), pattern=" s\\.l\\.", replacement="")), pattern=" ", replacement="_")
species_name <- gsub(x=gsub(x=gsub(x=basename(input_raw_tsv_filename), pattern="\\.tsv.*", replacement=""), pattern="subsp", replacement="ssp"), pattern=" s\\.l\\.", replacement="")
print(paste0(species_name, " (", species_id, ")"))



# ---------- IDR assays ----------
# Input TSV list containing a table of all the raw image files + meta-data from BioStudies
input_raw_tsv <- read.table(file=input_raw_tsv_filename, header=TRUE, sep="\t", quote="\"", comment.char="", fill=TRUE, dec=".", stringsAsFactors=FALSE)#, encoding="UTF-8", fileEncoding="UTF-8")

# (Translated) Input CSV list containing a list of all the processed images + meta-data
input_photo_list <- read.table(file=input_photo_list_filename, header=TRUE, sep="\t", quote="\"", comment.char="", fill=FALSE, dec=".", stringsAsFactors=FALSE)#, encoding="UTF-8", fileEncoding="UTF-8")

# Get relevant entries
photo_list_idx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))[1]
photo_list_fileidx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))
image_extension <- "ome.tiff"

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

# Raw files
raw_files <- data.frame("Source Name"=species_name,
						"Characteristics [Organism]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.acceptedScientificName.Species.name[photo_list_idx],
						"Term Source 1 REF"="NCBI Taxon",
						"Term Source 1 Accession"=gsub(x=input_photo_list$X.http...rs.tdwg.org.dwc.terms.TaxonID.TaxonID[photo_list_idx], pattern="\\,.*", replacement=""),
						"Characteristics [GBIF Taxonomy]"=gsub(x=gsub(x=input_photo_list$X.http...rs.tdwg.org.dwc.terms.TaxonID.TaxonID[photo_list_idx], pattern=".*GBIF", replacement="GBIF"), pattern="\\,.*", replacement=""),
						"Characteristics [Open Tree Taxonomy]"=gsub(x=input_photo_list$X.http...rs.tdwg.org.dwc.terms.TaxonID.TaxonID[photo_list_idx], pattern=".*\\, ", replacement=""),
						"Characteristics [Description]"=input_raw_tsv$Description,
						"Characteristics [Basis of Record]"="Preserved Specimen",
						"Characteristics [Voucher Specimen]"=input_raw_tsv$Voucher.record.identifier,
						"Experimental Condition [Collector]"=input_raw_tsv$Collector,
						"Experimental Condition [Collection Date]"=input_raw_tsv$Acquisition.Date,
						"Experimental Condition [Identified By]"=input_raw_tsv$Identified.By,
						"Characteristics [Geodetic.datum]"=input_raw_tsv$Geodetic.Datum,
						"Characteristics [Latitude]"=input_raw_tsv$Latitude,
						"Characteristics [Longitude]"=input_raw_tsv$Longitude,
						"Characteristics [Elevation]"=input_raw_tsv$Elevation,
						"Characteristics [Coordinate Precision]"=input_raw_tsv$Precision,
						"Protocol REF"="image acquisition and feature extraction protocol",
						"Assay Name"=species_name,
						"Experimental Condition [Microscope]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.measurementMethod.Measurement.Method[photo_list_idx],
						"Experimental Condition [Microscope Instrument]"=input_raw_tsv$Instrument,
						"Experimental Condition [Microscope Contrast Method]"=apply(X=as.matrix(grepl(x=input_raw_tsv$Magnification, pattern="DIC")), MARGIN=1, FUN=function(x) { if (x==FALSE) x<-"" else x<-"DIC" } ),
						"Experimental Condition [Microscope Magnification]"=gsub(x=input_raw_tsv$Magnification, pattern=" DIC", replacement=""),
						"Experimental Condition [Microscope Objective]"=input_raw_tsv$Objective,
						"Dataset Name"=species_name,
						"Image File"=gsub(x=input_raw_tsv$Stack.name, pattern="zip", replacement="ome.tiff"),
						"Comment [Image File]"="Raw",
						"Comment [Multi-Focus Image Fusion Stack]"=gsub(x=input_raw_tsv$Stack.name, pattern="\\.(zip|ZIP|TIF|TIFF|tif|tiff|JPG|jpg|jpeg).*", replacement="", perl=TRUE),
						"Comment [Image Stitching Stack]"=gsub(x=input_raw_tsv$Stitch.name, pattern="\\.(zip|ZIP|TIF|TIFF|tif|tiff|JPG|jpg|jpeg).*", replacement="", perl=TRUE),
						"Phenotype"="round cell",
						"Phenotype Term Accession"="CMPU_0000118",
						"Protocol REF"="data analysis protocol",
						"Processed Data File"=""
)
raw_files[is.na(raw_files)] <- ""

# Slim down raw files table to only contain files in IDR
raw_files <- raw_files[!duplicated(raw_files[,"Image.File"]), ]
rownames(raw_files) <- NULL


# Processed files
processed_files <- data.frame()
for (i in c(1,2)) {
	if (i==1) { image_extension <- "jpeg" }
	else { image_extension <- "tiff" }
	processed_files <- rbind(processed_files, data.frame("Source Name"=paste0(species_name, " Processed"),
														 "Characteristics [Organism]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.acceptedScientificName.Species.name[photo_list_fileidx],
														 "Term Source 1 REF"="NCBI Taxon",
														 "Term Source 1 Accession"=gsub(x=input_photo_list$X.http...rs.tdwg.org.dwc.terms.TaxonID.TaxonID[photo_list_idx], pattern="\\,.*", replacement=""),
														 "Characteristics [GBIF Taxonomy]"=gsub(x=gsub(x=input_photo_list$X.http...rs.tdwg.org.dwc.terms.TaxonID.TaxonID[photo_list_idx], pattern=".*GBIF", replacement="GBIF"), pattern="\\,.*", replacement=""),
														 "Characteristics [Open Tree Taxonomy]"=gsub(x=input_photo_list$X.http...rs.tdwg.org.dwc.terms.TaxonID.TaxonID[photo_list_idx], pattern=".*\\, ", replacement=""),
														 "Characteristics [Description]"=gsub(x=gsub(x=gsub(x=gsub(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name[photo_list_fileidx], pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")), replacement=""), pattern="^_", replacement=""), pattern="_", replacement=" "), pattern="\\d$", replacement=""),
														 "Characteristics [Basis of Record]"="Preserved Specimen",
														 "Characteristics [Voucher Specimen]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.PreservedSpecimen.Voucher.specimen[photo_list_fileidx],
														 "Experimental Condition [Collector]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.recordedBy.Collector[photo_list_fileidx],
														 "Experimental Condition [Collection Date]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.EarliestDateCollected.Collection.Date[photo_list_fileidx],
														 "Experimental Condition [Identified By]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.identifiedBy.Determined[photo_list_fileidx],
														 "Characteristics [Geodetic.datum]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.geodeticDatum.Geodetic.datum[photo_list_fileidx],
														 "Characteristics [Latitude]"=input_photo_list$X.http...www.ebi.ac.uk.efo.EFO_0005020.Latitude[photo_list_fileidx],
														 "Characteristics [Longitude]"=input_photo_list$X.http...www.ebi.ac.uk.efo.EFO_0005021.Longitude[photo_list_fileidx],
														 "Characteristics [Elevation]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.verbatimElevation..Elevation[photo_list_fileidx],
														 "Characteristics [Coordinate Precision]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.coordinatePrecision.Precision[photo_list_fileidx],
														 "Protocol REF"="image acquisition and feature extraction protocol",
														 "Assay Name"=paste0(species_name, " Processed"),
														 "Experimental Condition [Microscope]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.measurementMethod.Measurement.Method[photo_list_fileidx],
														 "Experimental Condition [Microscope Instrument]"=input_photo_list$X.http...www.openmicroscopy.org.rdf.2016.06.ome_core.Instrument.[photo_list_fileidx],
														 "Experimental Condition [Microscope Contrast Method]"=input_photo_list$X.http...www.openmicroscopy.org.rdf.2016.06.ome_core.ContrastMethod.Contrast[photo_list_fileidx],
														 "Experimental Condition [Microscope Magnification]"=input_photo_list$X.http...www.openmicroscopy.org.rdf.2016.06.ome_core.nominalMagnification.Magnification[photo_list_fileidx],
														 "Experimental Condition [Microscope Objective]"=input_photo_list$X.http...www.openmicroscopy.org.rdf.2016.06.ome_core.Objective.Microscope.Objective[photo_list_fileidx],
														 "Dataset Name"=paste0(species_name, " Processed"),
														 "Image File"=paste0(input_photo_list$X.http...edamontology.org.data_1060.File.base.name[photo_list_fileidx], ".", image_extension),
														 "Comment [Image File]"="Processed",
														 "Comment [Multi-Focus Image Fusion Stack]"="",
														 "Comment [Image Stitching Stack]"="",
														 "Phenotype"="round cell",
														 "Phenotype Term Accession"="CMPU_0000118",
														 "Protocol REF"="data analysis protocol",
														 "Processed Data File"=paste0(input_photo_list$X.http...edamontology.org.data_1060.File.base.name[photo_list_fileidx], ".", image_extension)
	))
}
processed_files[is.na(processed_files)] <- ""

# Merge Raw and processed files
assays_output_tsv <- rbind(raw_files, processed_files)

# Correct colnames
colnames(assays_output_tsv) <- c("Source Name",
								 "Characteristics [Organism]",
								 "Term Source 1 REF",
								 "Term Source 1 Accession",
								 "Characteristics [GBIF Taxonomy]",
								 "Characteristics [Open Tree Taxonomy]",
								 "Characteristics [Description]",
								 "Characteristics [Basis of Record]",
								 "Characteristics [Voucher Specimen]",
								 "Experimental Condition [Collector]",
								 "Experimental Condition [Collection Date]",
								 "Experimental Condition [Identified By]",
								 "Characteristics [Geodetic.datum]",
								 "Characteristics [Latitude]",
								 "Characteristics [Longitude]",
								 "Characteristics [Elevation]",
								 "Characteristics [Coordinate Precision]",
								 "Protocol REF",
								 "Assay Name",
								 "Experimental Condition [Microscope]",
								 "Experimental Condition [Microscope Instrument]",
								 "Experimental Condition [Microscope Contrast Method]",
								 "Experimental Condition [Microscope Magnification]",
								 "Experimental Condition [Microscope Objective]",
								 "Dataset Name",
								 "Image File",
								 "Comment [Image File]",
								 "Comment [Multi-Focus Image Fusion Stack]",
								 "Comment [Image Stitching Stack]",
								 "Phenotype",
								 "Phenotype Term Accession",
								 "Protocol REF",
								 "Processed Data File"
)
assays_output_tsv[is.na(assays_output_tsv)] <- ""

# Save output file
write.table(assays_output_tsv, file=assays_output_tsv_filename, sep="\t", row.names=FALSE)


