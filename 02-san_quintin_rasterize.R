library(sf)
library(raster)
library(tidyverse)

shp <- list.files("data/san_quintin/adjusted/", pattern=".shp", 
                  recursive=T,
                  full.names=T)

make.raster <- function(x){
  dir.create("data/san_quintin/raster/", showWarnings = F)
  path="data/san_quintin/raster/"
  
  ext <- st_read("data/study_area/san_quintin.shp")
  
  ext <- raster::extent(ext)
  
  gridsize <- 0.0001
  
  r <- raster::raster(ext, res=gridsize)
       
  y <- read_sf(x)
  
  rast <- raster::rasterize(y, r, field= "class")
  crs(rast) <- "+proj=longlat"
  
  raster::writeRaster(rast,
                      paste0(str_remove(
                        paste0(path, str_remove(
                          x, "data/san_quintin/adjusted/"
                        )), ".shp"
                      ),
                      "_adj.tif"),
                      overwrite = TRUE)
  
}

lapply(shp, make.raster)
