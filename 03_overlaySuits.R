

# Install libraries -------------------------------------------------------
library(pacman)
p_load(terra, fs, sf, glue, tidyverse, ggspatial, geodata, RColorBrewer)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Data --------------------------------------------------------------------

# Vector data 
mex0 <- geodata::gadm(country = 'MEX', level = 0, path = tempdir())
mex1 <- geodata::gadm(country = 'MEX', level = 1, path = tempdir())
mex2 <- geodata::gadm(country = 'MEX', level = 2, path = tempdir())

wrld <- terra::vect('./data/gpkg/all_countries.gpkg')

# Raster data -------------------------------------------------------------

## Directories
dirs <- dir_ls('./data/binarios', type = 'directory')
dirs <- as.character(dirs)

## Files
fles <- map(dirs, dir_ls) %>% 
  unlist() %>% 
  as.character() %>% 
  grep('stack_binary.tif', ., value = T)

## Species
spcs <- basename(dirs)
prds <- c('actual', 'bcc_245', 'bcc_370', 'miro_245', 'miro_370')
prdo <- 'actual'

# To overlay  -------------------------------------------------------------
make.overlay <- function(prdo){
  
  ## To start
  cat('To start: ', prdo, '\n')
  rst <- map(fles, rast)
  rst <- rast(fls)

  
  ## Finish 
  cat('Done!\n')
  return()
  
}



#
