library(sf)
library(raster)
library(tidyverse)

  x <- list.files("data/san_quintin/invest/", pattern=".tif", 
                  recursive=T,
                  full.names=T)



crop.raster <- function(x){
  dir.create("data/outputs_InVest/", showWarnings = F)
  path="data/outputs_InVest/"
  
  r <- raster(x)
  
  shp <- st_read("data/study_area/ramsar_site_sq.shp")#SHP DEL AREA DE ESTUDIO
  
  rast <- crop(r, extent(shp))
  
  
  raster::writeRaster(rast,
                      paste0(str_remove(
                        paste0(path, str_remove(
                          x, "data/san_quintin/invest/"
                        )), ".tif"
                      ),
                      "_adj.tif"),
                      overwrite = TRUE)
  
}

lapply(x, crop.raster)
