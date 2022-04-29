#!/usr/bin/env Rscript



# ---------- Preparations ----------
# Set options
options(stringAsfactors=FALSE, useFancyQuotes=FALSE)



# ---------- User variables ----------
# Take in trailing command line arguments
args <- commandArgs(trailingOnly=TRUE)
if (length(args) < 1) {
	print("Error! No or not enough arguments given.")
	print("Usage: $0 liverworts_photos_list.csv ")
	quit(save="no", status=1, runLast=FALSE)
}

# Arguments
input_photo_list_filename <- args[1]
output_photo_list_filename <- gsub(x=input_photo_list_filename, pattern="csv", replacement="tsv")



# ---------- translate photo name ----------
translate_photo_name <- function(name) {
	name <- gsub(x=name, pattern="blatt_querschnitt", replacement="leaf_lobes_cross_section")
	name <- gsub(x=name, pattern="blatt_quer", replacement="leaf_lobes_cross_section")
	name <- gsub(x=name, pattern="flankenblatt", replacement="lateral_leaf")
	name <- gsub(x=name, pattern="sporen_elateren", replacement="spores_and_elaters")
	name <- gsub(x=name, pattern="oberblatt", replacement="antical_leaf")
	name <- gsub(x=name, pattern="oberlappen", replacement="antical_lobe")
	name <- gsub(x=name, pattern="unterblatt", replacement="underleaf")
	name <- gsub(x=name, pattern="unterlappen", replacement="postical_lobe")
	
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
	name <- gsub(x=name, pattern="frisch", replacement="fresh")
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
	name <- gsub(x=name, pattern="standort", replacement="habitat")
	name <- gsub(x=name, pattern="thallus", replacement="thallus")
	name <- gsub(x=name, pattern="und", replacement="and")
	name <- gsub(x=name, pattern="unreifes", replacement="immature")
	name <- gsub(x=name, pattern="unreifer", replacement="immature")
	name <- gsub(x=name, pattern="unreifen", replacement="immature")
	name <- gsub(x=name, pattern="unreife", replacement="immature")
	name <- gsub(x=name, pattern="unreif", replacement="immature")
	name <- gsub(x=name, pattern="unteres", replacement="lower")
	name <- gsub(x=name, pattern="unterer", replacement="lower")
	name <- gsub(x=name, pattern="untere", replacement="lower")
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
# Input CSV list containing a list of all the segmented images + meta-data
input_photo_list <- read.table(file=input_photo_list_filename, header=TRUE, sep=";", quote="\"", comment.char="", fill=FALSE, dec=".", stringsAsFactors=FALSE)#, encoding="UTF-8", fileEncoding="UTF-8")

input_photo_list$X.http...edamontology.org.data_1060.File.base.name <- translate_photo_name(input_photo_list$X.http...edamontology.org.data_1060.File.base.name)

# Save translated photo file
write.table(input_photo_list, file=output_photo_list_filename, sep="\t", row.names=FALSE)



