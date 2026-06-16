

# Install libraries -------------------------------------------------------
library(pacman)
p_load(terra, fs, sf, glue, tidyverse, ggspatial, geodata, RColorBrewer)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Data --------------------------------------------------------------------

wrld <- terra::vect('./data/gpkg/all_countries.gpkg')
mex0 <- wrld[wrld$ISO3 == 'MEX',]

# Raster data -------------------------------------------------------------
