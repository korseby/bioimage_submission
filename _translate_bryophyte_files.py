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
parser = argparse.ArgumentParser(description='Rename image files and translate german terms to english term.')
parser.add_argument('-v', '--version', action='version', version='Translate bryophyte files Version 0.3',
                   help='show version')
parser.add_argument('-V', '--verbose', dest='verbose', action='store_true', required=False,
                   help='be verbose and show what is being done')
parser.add_argument('-n', '--dry-run', dest='dryrun', action='store_true', required=False,
                   help='show what would be done')
parser.add_argument('-d', '--dir', metavar='dest_dir', dest='dest_dir', required=True,
                   help='destination directory of image files')
parser.add_argument('-r', '--recursive', dest='recursive', action='store_true', required=False,
                   help='recurse into subdirectories and also rename subdirectories')

args = parser.parse_args()

# Verbosity
__DEBUG__ = args.verbose

# Dry-run
__DRY_RUN__ = args.dryrun

# Recursive
__RECURSIVE__ = args.recursive

# Destination image directory
dest_dir = args.dest_dir



# -------------------- Rename files --------------------
def rename_files(dest_files):
	# Rename files
	old_names = [str(Path(i)) for i in dest_files]
	new_names = [str(Path(i)) for i in dest_files]
	
	new_names = [re.sub("_Ansatzstelle", "", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Antheridienstand", "_antheridiophore", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Antheridien", "_antheridia", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Antheridiumgameten", "_gametophytes", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Antheridium", "_antheridium", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Archegonienstand", "_archegoniophore", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Archegonien", "_archegonia", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Archegonium", "_archegonium", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Aufsicht", "_anterior_view", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Balgen", "_macro_bellow", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Balgengeraet", "_macro_bellow", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_basales", "_basal", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_basaler", "_basal", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_basalen", "_basal", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_basale", "_basal", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blatt Querschnitt", "_leaf_cross_section", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blattachsel", "_leaf_axis", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blattbasis", "_leaf_base", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blattgrund", "_leaf_base", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blattlappen", "_leaf_lobes", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blattmitte", "_leaf_center", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blattrand", "_leaf_margin", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blattsaum", "_bordered_margin", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blattspitze", "_leaf_apex", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Blatt", "_leaf", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_breit", "_wide", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Brutblatt", "_perigon_leaf", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Brutgemmen", "_gemmae", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Brutgemme", "_gemmae", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Brutkoerper", "_gemmae", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Elateren", "_elaters", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Elatere", "_elater", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_erweitertes", "_extended", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_erweiterter", "_extended", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_erweiterte", "_extended", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_erweitert", "_extended", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Flankenblatt", "_lateral_leaf", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Gemmen", "_gemmae", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_geoeffneten", "_opened", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_geoeffnete", "_opened", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_geoeffnet", "_opened", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_geoffnete", "_opened", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gerundetes", "_rounded", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gerundeter", "_rounded", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gerundete", "_rounded", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gerundet", "_rounded", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gerundere", "_rounded", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gesaeumter", "_bordered", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gesaeumtes", "_bordered", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gesaeumte", "_bordered", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gesaeumt", "_bordered", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gezaehntes", "_toothed", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gezaehnter", "_toothed", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gezaehnte", "_toothed", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_gezaehnt", "_toothed", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Habitus", "_stature", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_herablaufendes", "_winged", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_herablaufender", "_winged", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_herablaufende", "_winged", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_herablaufend", "_winged", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Herbarbeleg", "_voucher_specimen", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Herbarbeleg", "_voucher_specimen", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Innenseite", "_interior_side", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Kapsel", "_capsule", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_kollenchymatisch_verdickt", "_collenchym", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_maennliches", "_male", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_maennlichen", "_male", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_maennliche", "_male", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_maennlich", "_male", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Mittelrippe", "_vitta", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_mittleres", "_middle", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_mittlerer", "_middle", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_mittlere", "_middle", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_mittler", "_middle", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_mit", "_with", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_oberes", "_upper", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_oberer", "_upper", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_obere", "_upper", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Ober-", "_antical", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Oberlappen", "_antical_lobe", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Oberseite", "_ventral_side", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Papillen", "_papillae", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Papille", "_papille", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Paraphysen", "_paraphyses", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Perianthmuendung", "_perianth_mouth", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Perianthien", "_perianths", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Perianth", "_perianth", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Perichaetialblatt", "_perichaetial_leaf", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Pflanzenspitze", "_plant_apex", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Pflanzen", "_plants", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Querschnitt", "_cross_section", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Quer", "_cross_section", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Rand", "_margin", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Rippe", "_vitta", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Saum", "_bordered_margin", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Seitenansicht", "_lateral_side", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Sporogonen", "_sporphytes", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Sporogon", "_sporophyte", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Sporophyt", "_sporophyte", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Sporenkapseln", "_spore_capsules", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Sporenkapsel", "_spore_capsule", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Sporen", "_spores", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Spore", "_spore", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Stamm", "_stem", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Staemmchen", "_stem", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Thallus", "_thallus", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_und", "_and", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_unreifes", "_immature", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_unreifer", "_immature", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_unreifen", "_immature", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_unreife", "_immature", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_unreif", "_immature", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Unterblatt", "_underleaf", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_unteres", "_lower", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_unterer", "_lower", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_untere", "_lower", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Unterlappen", "_postical_lobe", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Unterseite", "_dorsal_side", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_weibliches", "_female", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_weiblichen", "_female", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_weibliche", "_female", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_weiblich", "_female", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Zaehne", "_teeth", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Zahn", "_tooth", i, flags=re.IGNORECASE) for i in new_names]
	new_names = [re.sub("_Zellen", "_cells", i, flags=re.IGNORECASE) for i in new_names]
	
	new_names = [re.sub("_andulata", "_undulata", i, flags=re.IGNORECASE) for i in new_names]
		
	# Show renaming action
	if (__DRY_RUN__):
		print("The following renaming in batches will be done:")
		base_names = [re.sub("(IMG_\d\d\d\d |IMG_\d\d\d\d-\d\d\d\d |\.CR(2|3)|\.TIF|\.JPG|\.xmp)", "", i, flags=re.IGNORECASE) for i in new_names]
		for i, label in enumerate(dict.fromkeys(base_names), start=0):
			print( label )
	
	# Perform renaming of files on drive
	if (__DRY_RUN__ == False) or (__DEBUG__ == True):
		if (len(old_names) != len(new_names)):
			print("Error! Number of old files (" + str(len(old_names)) + ") does not match number of new files (" + str(len(new_names)) + ").")
			exit(3)
		else:
			if (__DEBUG__ == True):
				for j in range(0, len(old_names)):
					if (os.path.isfile(old_names[j])) or (os.path.isdir(old_names[j])):
						print('mv' + ' ' + '\"' + old_names[j] + '\"' + ' ' + '\"' + new_names[j] + '\"')
			if (__DRY_RUN__ == False):
				for j in range(0, len(old_names)):
					if (os.path.isfile(old_names[j])) or (os.path.isdir(old_names[j])):
						os.rename(old_names[j], new_names[j])
	
	if (__DEBUG__ == True): print("Renaming of " + str(len(new_names)) + " files done.")



# -------------------- MAIN --------------------
if (__RECURSIVE__ == False):
	# Rename files
	dest_files = sorted( filter(lambda p: p.suffix in {".CR2", ".CR3", ".DNG", ".TIF", ".JPG", ".jpeg", ".xmp", ".XMP"}, Path(dest_dir).glob("*")) )
	rename_files(dest_files)
else:
	# Rename directories first
	dest_dirs = sorted( glob.glob(f'{dest_dir}/*/**/', recursive=True) )
	rename_files(dest_dirs)
	
	# Rename files afterwards in all subdirectories
	dest_files = sorted( filter(lambda p: p.suffix in {".CR2", ".CR3", ".DNG", ".TIF", ".JPG", ".xmp", ".XMP"}, Path(dest_dir).rglob("*")) )
	rename_files(dest_files)


