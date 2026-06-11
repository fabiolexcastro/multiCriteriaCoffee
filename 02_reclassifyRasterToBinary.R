
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
get.graph <- function(spce){
  
  ## To filter 
  cat('To process: ', spce, '\n')
  dire <- grep(spce, dirs, value = T)
  fles <- dir_ls(dire)
  fles <- as.character(fles)
  
  ## Presences
  occr <- grep('.csv$', fles, value = T)
  occr <- read_csv(occr, show_col_types = FALSE)
  
  ## Raster data 
  
  ### Current
  crnt <- grep('actual', fles, value = T)
  crnt <- rast(crnt)
  
  ### Future
  bcc  <- grep('bcc', fles, value = T)
  bcc  <- rast(bcc)
  mir  <- grep('mir', fles, value = T)
  mir  <- rast(mir)
  
  ## Extract values for the presences
  vles <- terra::extract(crnt, occr[,2:3])
  vles <- pull(vles, 2)
  vles <- na.omit(vles)
  vles <- as.numeric(vles)
  
  ## Percentiles
  qntl <- quantile(vles, seq(0, 1, 0.01))
  qntl <- rownames_to_column(as.data.frame(qntl))
  qntl <- mutate(qntl, percentage = parse_number(rowname))
  
  ## A simple plot 
  g.qntl <- ggplot(data = qntl, aes(x = percentage, y = qntl))  +
    geom_point() + 
    geom_line(col = 'grey30') + 
    labs(x = 'Porcentaje', y = 'Cuantil') + 
    ggtitle(label = paste0('Especie: ', spce), 
            subtitle = paste0('Línea base')) +
    theme_bw() +
    theme(
      axis.text.y = element_text(angle = 90, hjust = 0.5), 
      plot.title = element_text(hjust = 0.5, size = 12), 
      plot.subtitle = element_text(hjust = 0.5, size = 10)
    )
  
  g.qntl
  
  ## To save the graph
  dout <- glue('./png/graphs/quantiles')
  ggsave(
    plot = g.qntl, 
    filename = glue('{dout}/gg_{spce}.jpg'), 
    units = 'in', width = 7, height = 5, dpi = 300, create.dir = T
  )

  ## To save the table 
  dout <- glue('./tbl/quantile_vals'); dir_create(dout)
  write.csv(qntl, glue('{dout}/values_{spce}.csv'), row.names = FALSE)
  
  ## Finish 
  cat('Done!\n')
  
}

# Draw the graphs ---------------------------------------------------------
purrr::walk(basename(dirs), get.graph)

# Save a table  -----------------------------------------------------------
dcsn <- tibble(specie = basename(dirs), threshold = 0)
write.csv(dcsn, './tbl/thresholds.csv', row.names = FALSE)


