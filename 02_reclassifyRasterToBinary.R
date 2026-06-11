
# Install libraries -------------------------------------------------------
library(pacman)
p_load(terra, fs, sf, glue, tidyverse, ggspatial, geodata, RColorBrewer)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)


# Load data ---------------------------------------------------------------

# Vector data -------------------------------------------------------------
mex0 <- geodata::gadm(country = 'MEX', level = 0, path = tempdir())
mex1 <- geodata::gadm(country = 'MEX', level = 1, path = tempdir())
mex2 <- geodata::gadm(country = 'MEX', level = 2, path = tempdir())

# Raster data -------------------------------------------------------------

## 
dirs <- dir_ls('./data/continuos', type = 'directory')
dirs <- as.character(dirs)

# Function to classify  ---------------------------------------------------
spce <- 'C_arabica'

get.binary <- function(spce){
  
  ## To filter 
  cat('To process: ', spce, '\n')
  dire <- grep(spce, dirs, value = T)
  fles <- dir_ls(dire)
  fles <- as.character(fles)
  
  ## Presences
  occr <- grep('.csv$', fles, value = T)
  occr <- read_csv(occr, show_col_types = FALSE)
  
  ## Raster data 
  
  
  
  
}

