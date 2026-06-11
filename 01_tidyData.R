
# Install libraries -------------------------------------------------------
install.packages('pacman') # Run once
library(pacman)
p_load(terra, fs, sf, glue, tidyverse, ggspatial, geodata, RColorBrewer)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Vector data -------------------------------------------------------------
mex0 <- geodata::gadm(country = 'MEX', level = 0, path = tempdir())
mex1 <- geodata::gadm(country = 'MEX', level = 1, path = tempdir())
mex2 <- geodata::gadm(country = 'MEX', level = 2, path = tempdir())

# Raster data -------------------------------------------------------------

## 
dirs <- dir_ls('./data/binarios', type = 'directory')
dirs <- as.character(dirs)

## 
map(dirs, dir_ls)

## Periods
prds <- map(dirs, dir_ls) %>% 
  map(basename) %>% 
  unlist() %>% 
  unique() %>% 
  gsub('.asc', '', .)

# Function to make the analysis -------------------------------------------
prdo <- prds[1]

make.multi <- function(prdo){
  
  ## To filter 
  cat('To process: ', prdo, '\n')
  fles <- dir_ls(dirs) %>% 
    as.character() %>% 
    grep(prdo, x = ., value = T)
  
  ## To read as a raster 
  rstr <- map(fles, rast)
  
  ## A plot 
  for(i in 1:length(rstr)){
    plot(rstr[[i]], main = basename(fles))
    Sys.sleep(time = 3)
  }
  
  
}





