library(sf)
library(raster)
library(tidyverse)

shp <- list.files("data/san_quintin/adjusted/", pattern=".shp", 
                  recursive=T,
                  full.names=T)



make.raster <- function(x){
  dir.create("data/san_quintin/raster/", showWarnings = F)
  path="data/san_quintin/raster/"
  
  ext <- st_read("data/study_area/ramsar_site_sq.shp") %>% 
    st_transform(., crs=32611)
  
  ext <- raster::extent(ext)
  
  gridsize <- 100
  
  r <- raster::raster(ext, res=gridsize)
       
  y <- st_read(x)%>% 
    st_transform(., crs=32611) 
  
  rast <- raster::rasterize(y, r, field= "class")
  crs(rast) <- "+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
  
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


r <- raster("data/san_quintin/raster/uso-de-suelo-vegetacion_serie_VII_adj.tif")
plot(r)