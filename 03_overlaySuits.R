

# Install libraries -------------------------------------------------------
library(pacman)
p_load(terra, fs, sf, glue, tidyverse, ggspatial, geodata, RColorBrewer)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Data --------------------------------------------------------------------

# Vector data 
# mex0 <- geodata::gadm(country = 'MEX', level = 0, path = tempdir())
# mex1 <- geodata::gadm(country = 'MEX', level = 1, path = tempdir())
# mex2 <- geodata::gadm(country = 'MEX', level = 2, path = tempdir())

wrld <- terra::vect('./data/gpkg/all_countries.gpkg')
mex0 <- wrld[wrld$ISO3 == 'MEX',]

# Raster data -------------------------------------------------------------

## Directories
dirs <- dir_ls('./data/binarios', type = 'directory')
dirs <- as.character(dirs)

## Files
fles <- map(dirs, dir_ls) %>% 
  unlist() %>% 
  as.character() %>% 
  grep('stack_binary.tif$', ., value = T)

## Species
spcs <- basename(dirs)
prds <- c('actual', 'bcc_245', 'bcc_370', 'miro_245', 'miro_370')
# prdo <- 'actual'

# To overlay  -------------------------------------------------------------
make.overlay <- function(prdo){
  
  ## To start
  cat('To start: ', prdo, '\n')
  rst <- map(fles, rast)
  rst <- map(1:length(rst), function(i){
    cat('Layer #', i, '\n')
    rs <- rst[[i]][[grep(prdo, names(rst[[i]]))]]
    return(rs)
  })
  map(rst, ext)
  
  ## Extent adjust
  rst <- map(1:length(rst), function(i){
    r <- rst[[i]]
    r <- terra::resample(r, rst[[1]], method = 'near')
    return(r)
  })
  
  ## To reduce as a stack
  rst <- reduce(rst, c)
  
  ## To change the names
  nms <- basename(dirname(fles))
  names(rst) <- glue('{nms}__{prdo}')
  
  ## To write the rasters
  out <- './data/binarios_stack'
  dir_create(out)
  terra::writeRaster(x = rst, filename = glue('{out}/stack_{prdo}.tif'), overwrite = TRUE)
  
  ## Finish 
  cat('Done!\n')
  return()
  
}
purrr::walk(prds, make.overlay)

for(z in prds){
  make.overlay(prdo = z)
}
#
