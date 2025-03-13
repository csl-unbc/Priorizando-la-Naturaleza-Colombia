
# define and save the current directory of this script
SCRIPTS_DIR="/home/xavier/Projects/UNBC/Priorizando la Naturaleza - Colombia/Priorizando-la-Naturaleza-Colombia/inst/scripts"

# original data directory
# https://tnc.app.box.com/s/1my6ug09frxo95ixj9838cnbnqaiccxb/folder/268868257485
ORIG_DIR="/run/media/xavier/SSD-Data/UNBC-UNDP/Priorizando la Naturaleza - Colombia/Data"

# output data directory
OUT_DIR="/home/xavier/Projects/UNBC/Priorizando la Naturaleza - Colombia/Priorizando-la-Naturaleza-Colombia/inst/extdata/data/Nacional/Layers"
cd $OUT_DIR

#### PLANING UNITS ####

# PU Nacional

gdal_calc.py --calc "1*A!=0" -A="${ORIG_DIR}/PUs/PUs_Nacional_1km.tif" --outfile temp.tif
gdalwarp -overwrite -ot Byte -of GTiff temp.tif temp2.tif
gdal_translate -of GTiff -a_nodata 0 temp2.tif PU_Nacional_1km.tif
rm temp.tif temp2.tif

#### FEATURES ####

# id elements for prioritization, features list: 4, 6, 7, 11, 12, 15, 21, 24

# 4,24,6,7,21,11,12,15

# Ecosistemas IAVH 1
# TODO: many ecosystems for the webtool and for complete runs it necessary define different targets by ecosystem

# Ecosistemas estratégicos	Páramo	4
gdal_calc.py --calc="numpy.where(A == 1, 1, 0)" -A="$ORIG_DIR/features/4/paramos.tif" --outfile temp.tif
Rscript "$SCRIPTS_DIR/utils/prepare_binary_layer.R" temp.tif paramos.tif
rm temp.tif

# Ecosistemas estratégicos	Manglar	24  # TODO: original image seems moved/bad reprojected or using another Colombia shape, need to fix
Rscript "$SCRIPTS_DIR/utils/prepare_binary_layer.R" "$ORIG_DIR/features/24/Manglares INVEMAR.tif" manglares.tif

# Ecosistemas estratégicos	Humedales	6
gdal_calc.py --calc="numpy.where(A == 1, 1, 0)" -A="$ORIG_DIR/features/6/humedales.tif" --outfile temp.tif
Rscript "$SCRIPTS_DIR/utils/prepare_binary_layer.R" temp.tif humedales.tif
rm temp.tif

# Ecosistemas estratégicos	Bosque seco	7  #todo: burn 0 in the background for colombia?
gdal_calc.py --calc="numpy.where(A == 1, 1, 0)" -A="$ORIG_DIR/features/7/bosque_seco.tif" --outfile temp.tif
Rscript "$SCRIPTS_DIR/utils/prepare_binary_layer.R" temp.tif bosque_seco.tif
rm temp.tif

# Especies	Especies (8754)	21  # TODO: original image seems moved/bad reprojected or using another Colombia shape, need to fix
# https://github.com/SMByC/StackComposed
# using StackComposed to sum the species richness in parallel and memory efficient way
ulimit -n 65536
/home/xavier/Projects/SMBYC/StackComposed/bin/stack-composed -stat sum -preproc ==1 -nodata 0 -bands 1 -chunks 100 -p 4 -o species_richness.tif $ORIG_DIR/features/21/*.tif
Rscript "$SCRIPTS_DIR/utils/prepare_float_layer.R" species_richness riqueza_especies.tif

# Servicios ecosistémicos / Almacenamiento de carbono	Carbono orgánico en suelos	11
Rscript "$SCRIPTS_DIR/utils/prepare_float_layer.R" "$ORIG_DIR/features/11/GSOC_v1.5_fixed_1km.tif" carbono_organico_suelos.tif

# Servicios ecosistémicos / Almacenamiento de carbono	Biomasa aérea más biomasa subterránea	12
Rscript "$SCRIPTS_DIR/utils/prepare_float_layer.R" "$ORIG_DIR/features/12/agb_plus_bgb_spawn_2020_fixed_1km.tif" biomasa_aerea_mas_subterranea.tif

# Servicios ecosistémicos / Provisión de agua	Recarga de agua subterranea	15  #todo: burn 0 in the background for colombia?
Rscript "$SCRIPTS_DIR/utils/prepare_binary_layer.R" "$ORIG_DIR/features/15/recarga_agua_subterranea_moderado_alto.tif" recarga_agua_subterranea.tif

#### COST LAYERS ####

# human footprint 2022
Rscript "$SCRIPTS_DIR/utils/prepare_float_layer.R" "$ORIG_DIR/Cambio_Global/input/rasters/costs_and_constraints/IHEH_2022.tif" IHEH_2022.tif

#### INCLUDES ####

# RUNAP
gdal_calc.py --calc="numpy.where(((A==3) & (B==1)), 1, 0)" -A="$ORIG_DIR/costs_and_constraints/RUNAP_23.tif" -B="PU_Nacional_1km.tif" --NoDataValue 0 --outfile temp.tif
Rscript "$SCRIPTS_DIR/utils/prepare_binary_layer.R" temp.tif RUNAP2.tif
rm temp.tif

# OMECs
gdal_calc.py --calc="numpy.where(((A!=3) & (B==1)), 1, 0)" -A="$ORIG_DIR/costs_and_constraints/RUNAP_23.tif" -B="PU_Nacional_1km.tif" --NoDataValue 0 --outfile temp.tif
Rscript "$SCRIPTS_DIR/utils/prepare_binary_layer.R" temp.tif OMECs2.tif
rm temp.tif






