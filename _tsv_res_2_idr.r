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
if (length(args) < 3) {
	print("Error! No or not enough arguments given.")
	print("Usage: $0 input_raw.tsv photo_list.tsv output")
	quit(save="no", status=1, runLast=FALSE)
}

# Arguments
input_raw_tsv_filename <- args[1]
input_photo_list_filename <- args[2]
assays_output_tsv_filename <- paste0(args[3],"_assays.tsv")

#Scapania spitzbergensis
#setwd("/Volumes/scratch/___processing___/__IDR/_tsv-raw")
#input_raw_tsv_filename <- "3-res/Scapania spitzbergensis.tsv"
#input_photo_list_filename <- "./_liverworts_photos_list.tsv"
#assays_output_tsv_filename <- paste0("./5-idr/", "Scapania spitzbergensis", "_assays.tsv")

# Generate species IDs
species_id <- gsub(x=tolower(gsub(x=gsub(x=gsub(x=basename(input_raw_tsv_filename), pattern="\\.tsv.*", replacement=""), pattern="subsp", replacement="ssp"), pattern=" s\\.l\\.", replacement="")), pattern=" ", replacement="_")
species_name <- gsub(x=gsub(x=gsub(x=basename(input_raw_tsv_filename), pattern="\\.tsv.*", replacement=""), pattern="subsp", replacement="ssp"), pattern=" s\\.l\\.", replacement="")
print(paste0(species_name, " (", species_id, ")"))



# ---------- translate photo name ----------
translate_photo_name <- function(name) {
	name <- gsub(x=name, pattern="sporen_elateren", replacement="spores_and_elaters")
	name <- gsub(x=name, pattern="blatt_querschnitt", replacement="leaf_lobes_cross_section")
	name <- gsub(x=name, pattern="blatt_quer", replacement="leaf_lobes_cross_section")
	name <- gsub(x=name, pattern="ansatzstelle", replacement="")
	name <- gsub(x=name, pattern="antheridienstand", replacement="antheridiophore")
	name <- gsub(x=name, pattern="antheridien", replacement="antheridia")
	name <- gsub(x=name, pattern="antheridiumgameten", replacement="gametophytes")
	name <- gsub(x=name, pattern="antheridium", replacement="antheridium")
	name <- gsub(x=name, pattern="archegonienstand", replacement="archegoniophore")
	name <- gsub(x=name, pattern="archegonien", replacement="archegonia")
	name <- gsub(x=name, pattern="archegonium", replacement="archegonium")
	name <- gsub(x=name, pattern="aufsicht", replacement="anterior_view")
	name <- gsub(x=name, pattern="balgen", replacement="macro_bellow")
	name <- gsub(x=name, pattern="balgengeraet", replacement="macro_bellow")
	name <- gsub(x=name, pattern="basales", replacement="basal")
	name <- gsub(x=name, pattern="basaler", replacement="basal")
	name <- gsub(x=name, pattern="basalen", replacement="basal")
	name <- gsub(x=name, pattern="basale", replacement="basal")
	name <- gsub(x=name, pattern="blattachsel", replacement="leaf_axis")
	name <- gsub(x=name, pattern="blattbasis", replacement="leaf_base")
	name <- gsub(x=name, pattern="blattgrund", replacement="leaf_base")
	name <- gsub(x=name, pattern="blattlappen", replacement="leaf_lobes")
	name <- gsub(x=name, pattern="blattmitte", replacement="leaf_center")
	name <- gsub(x=name, pattern="blattrand", replacement="leaf_margin")
	name <- gsub(x=name, pattern="blattsaum", replacement="bordered_margin")
	name <- gsub(x=name, pattern="blattspitze", replacement="leaf_apex")
	name <- gsub(x=name, pattern="blatt", replacement="leaf lobes")
	name <- gsub(x=name, pattern="breit", replacement="wide")
	name <- gsub(x=name, pattern="brutblatt", replacement="perigon_leaf")
	name <- gsub(x=name, pattern="brutgemmen", replacement="gemmae")
	name <- gsub(x=name, pattern="brutgemme", replacement="gemmae")
	name <- gsub(x=name, pattern="brutkoerper", replacement="gemmae")
	name <- gsub(x=name, pattern="elateren", replacement="elaters")
	name <- gsub(x=name, pattern="elatere", replacement="elater")
	name <- gsub(x=name, pattern="erweitertes", replacement="extended")
	name <- gsub(x=name, pattern="erweiterter", replacement="extended")
	name <- gsub(x=name, pattern="erweiterte", replacement="extended")
	name <- gsub(x=name, pattern="erweitert", replacement="extended")
	name <- gsub(x=name, pattern="flankenblatt", replacement="lateral_leaf")
	name <- gsub(x=name, pattern="gemmen", replacement="gemmae")
	name <- gsub(x=name, pattern="geoeffneten", replacement="opened")
	name <- gsub(x=name, pattern="geoeffnete", replacement="opened")
	name <- gsub(x=name, pattern="geoeffnet", replacement="opened")
	name <- gsub(x=name, pattern="geoffnete", replacement="opened")
	name <- gsub(x=name, pattern="gerundetes", replacement="rounded")
	name <- gsub(x=name, pattern="gerundeter", replacement="rounded")
	name <- gsub(x=name, pattern="gerundete", replacement="rounded")
	name <- gsub(x=name, pattern="gerundet", replacement="rounded")
	name <- gsub(x=name, pattern="gerundere", replacement="rounded")
	name <- gsub(x=name, pattern="gesaeumter", replacement="bordered")
	name <- gsub(x=name, pattern="gesaeumtes", replacement="bordered")
	name <- gsub(x=name, pattern="gesaeumte", replacement="bordered")
	name <- gsub(x=name, pattern="gesaeumt", replacement="bordered")
	name <- gsub(x=name, pattern="gezaehntes", replacement="toothed")
	name <- gsub(x=name, pattern="gezaehnter", replacement="toothed")
	name <- gsub(x=name, pattern="gezaehnte", replacement="toothed")
	name <- gsub(x=name, pattern="gezaehnt", replacement="toothed")
	name <- gsub(x=name, pattern="habitus", replacement="stature")
	name <- gsub(x=name, pattern="herablaufendes", replacement="winged")
	name <- gsub(x=name, pattern="herablaufender", replacement="winged")
	name <- gsub(x=name, pattern="herablaufende", replacement="winged")
	name <- gsub(x=name, pattern="herablaufend", replacement="winged")
	name <- gsub(x=name, pattern="herbarbeleg", replacement="voucher_specimen")
	name <- gsub(x=name, pattern="herbarbeleg", replacement="voucher_specimen")
	name <- gsub(x=name, pattern="innenseite", replacement="interior_side")
	name <- gsub(x=name, pattern="kapsel", replacement="capsule")
	name <- gsub(x=name, pattern="kollenchymatisch_verdickt", replacement="collenchym")
	name <- gsub(x=name, pattern="maennliches", replacement="male")
	name <- gsub(x=name, pattern="maennlichen", replacement="male")
	name <- gsub(x=name, pattern="maennliche", replacement="male")
	name <- gsub(x=name, pattern="maennlich", replacement="male")
	name <- gsub(x=name, pattern="mittelrippe", replacement="vitta")
	name <- gsub(x=name, pattern="mittleres", replacement="middle")
	name <- gsub(x=name, pattern="mittlerer", replacement="middle")
	name <- gsub(x=name, pattern="mittlere", replacement="middle")
	name <- gsub(x=name, pattern="mittler", replacement="middle")
	name <- gsub(x=name, pattern="mit", replacement="with")
	name <- gsub(x=name, pattern="oberes", replacement="upper")
	name <- gsub(x=name, pattern="oberer", replacement="upper")
	name <- gsub(x=name, pattern="obere", replacement="upper")
	name <- gsub(x=name, pattern="ober-", replacement="antical")
	name <- gsub(x=name, pattern="oberlappen", replacement="antical_lobe")
	name <- gsub(x=name, pattern="oberseite", replacement="ventral_side")
	name <- gsub(x=name, pattern="papillen", replacement="papillae")
	name <- gsub(x=name, pattern="papille", replacement="papille")
	name <- gsub(x=name, pattern="paraphysen", replacement="paraphyses")
	name <- gsub(x=name, pattern="perianthmuendung", replacement="perianth_mouth")
	name <- gsub(x=name, pattern="perianthien", replacement="perianths")
	name <- gsub(x=name, pattern="perianth", replacement="perianth")
	name <- gsub(x=name, pattern="perichaetialblatt", replacement="perichaetial_leaf")
	name <- gsub(x=name, pattern="pflanzenspitze", replacement="plant_apex")
	name <- gsub(x=name, pattern="pflanzen", replacement="plants")
	name <- gsub(x=name, pattern="querschnitt", replacement="cross_section")
	name <- gsub(x=name, pattern="quer", replacement="cross_section")
	name <- gsub(x=name, pattern="rand", replacement="margin")
	name <- gsub(x=name, pattern="rippe", replacement="vitta")
	name <- gsub(x=name, pattern="saum", replacement="bordered_margin")
	name <- gsub(x=name, pattern="seitenansicht", replacement="lateral_side")
	name <- gsub(x=name, pattern="sporogonen", replacement="sporphytes")
	name <- gsub(x=name, pattern="sporogon", replacement="sporophyte")
	name <- gsub(x=name, pattern="sporophyt", replacement="sporophyte")
	name <- gsub(x=name, pattern="sporenkapseln", replacement="spore_capsules")
	name <- gsub(x=name, pattern="sporenkapsel", replacement="spore_capsule")
	name <- gsub(x=name, pattern="sporen", replacement="spores")
	name <- gsub(x=name, pattern="spore", replacement="spore")
	name <- gsub(x=name, pattern="staemmchen", replacement="stem")
	name <- gsub(x=name, pattern="stamm", replacement="stem")
	name <- gsub(x=name, pattern="thallus", replacement="thallus")
	name <- gsub(x=name, pattern="und", replacement="and")
	name <- gsub(x=name, pattern="unreifes", replacement="immature")
	name <- gsub(x=name, pattern="unreifer", replacement="immature")
	name <- gsub(x=name, pattern="unreifen", replacement="immature")
	name <- gsub(x=name, pattern="unreife", replacement="immature")
	name <- gsub(x=name, pattern="unreif", replacement="immature")
	name <- gsub(x=name, pattern="unterblatt", replacement="underleaf")
	name <- gsub(x=name, pattern="unteres", replacement="lower")
	name <- gsub(x=name, pattern="unterer", replacement="lower")
	name <- gsub(x=name, pattern="untere", replacement="lower")
	name <- gsub(x=name, pattern="unterlappen", replacement="postical_lobe")
	name <- gsub(x=name, pattern="unterseite", replacement="dorsal_side")
	name <- gsub(x=name, pattern="weibliches", replacement="female")
	name <- gsub(x=name, pattern="weiblichen", replacement="female")
	name <- gsub(x=name, pattern="weibliche", replacement="female")
	name <- gsub(x=name, pattern="weiblich", replacement="female")
	name <- gsub(x=name, pattern="zaehne", replacement="teeth")
	name <- gsub(x=name, pattern="zahn", replacement="tooth")
	name <- gsub(x=name, pattern="zellen", replacement="cells")
	
	name <- gsub(x=name, pattern="andulata", replacement="undulata")
	name <- gsub(x=name, pattern="tandrae", replacement="tundrae")
	
	return(name)
}



# ---------- translate photo list ----------
if (FALSE) {
	# Input CSV list containing a list of all the segmented images + meta-data
	input_photo_list <- read.table(file="./_liverworts_photos_list.csv", header=TRUE, sep=";", quote="\"", comment.char="", fill=FALSE, dec=".", stringsAsFactors=FALSE)#, encoding="UTF-8", fileEncoding="UTF-8")
	
	input_photo_list$X.http...edamontology.org.data_1060.File.base.name <- translate_photo_name(input_photo_list$X.http...edamontology.org.data_1060.File.base.name)
	
	# Save translated photo file
	write.table(input_photo_list, file=gsub(x=input_photo_list_filename, pattern="\\.csv", replacement="\\.tsv"), sep="\t", row.names=FALSE)
}



# ---------- idr0000-scapaniaceae-assays ----------
# Input TSV list containing a table of all the raw image files + meta-data
input_raw_tsv <- read.table(file=input_raw_tsv_filename, header=TRUE, sep="\t", quote="\"", comment.char="", fill=TRUE, dec=".", stringsAsFactors=FALSE)#, encoding="UTF-8", fileEncoding="UTF-8")

# (Translated) Input CSV list containing a list of all the processed images + meta-data
input_photo_list <- read.table(file=input_photo_list_filename, header=TRUE, sep="\t", quote="\"", comment.char="", fill=FALSE, dec=".", stringsAsFactors=FALSE)#, encoding="UTF-8", fileEncoding="UTF-8")

# Get relevant entries
photo_list_idx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))[1]
photo_list_fileidx <- grep(x=input_photo_list$X.http...edamontology.org.data_1060.File.base.name, pattern=tolower(gsub(x=gsub(x=species_id,pattern="\\.",replacement=""), pattern=" ", replacement="_")))
image_extension <- "ome.tiff"

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
						"Experimental Condition [Collector]"="",
						"Experimental Condition [Collection Date]"="",
						"Experimental Condition [Identified By]"="",
						"Characteristics [Geodetic.datum]"="",
						"Characteristics [Latitude]"="",
						"Characteristics [Longitude]"="",
						"Characteristics [Elevation]"="",
						"Characteristics [Coordinate Precision]"="",
						"Protocol REF"="image acquisition and feature extraction protocol",
						"Assay Name"=species_name,
						"Experimental Condition [Microscope]"=input_photo_list$X.http...rs.tdwg.org.dwc.terms.measurementMethod.Measurement.Method[photo_list_idx],
						"Experimental Condition [Microscope Instrument]"=input_photo_list$X.http...www.openmicroscopy.org.rdf.2016.06.ome_core.Instrument.[photo_list_idx],
						"Experimental Condition [Microscope Contrast Method]"=apply(X=as.matrix(grepl(x=input_raw_tsv$Magnification, pattern="DIC")), MARGIN=1, FUN=function(x) { if (x==FALSE) x<-"" else x<-"DIC" } ),
						"Experimental Condition [Microscope Magnification]"=gsub(x=input_raw_tsv$Magnification, pattern=" DIC", replacement=""),
						"Experimental Condition [Microscope Objective]"="",
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


