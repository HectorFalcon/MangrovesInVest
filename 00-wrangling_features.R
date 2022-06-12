library(raster)
library(tidyverse)


## Create function for resampling and normalizing rasters

adjust.rasters <- function(features) {
        dir.create("data/features/adjusted/", showWarnings = F)
        path = "data/features/adjusted/"
        control <- raster::raster("data/features/01_agri_pec.tif")
        r <- raster::raster(features)
        r_adj <- raster::resample(r, control)
        
        if (r_adj@data@min == r_adj@data@max) {
                raster::writeRaster(r_adj,
                                    paste0(str_remove(
                                            paste0(path, str_remove(
                                                    features, "data/features/"
                                            )), ".tif"
                                    ),
                                    "_adj.tif"),
                                    overwrite = TRUE)
                
        } else if (r_adj@data@min != r_adj@data@max) {
                r <- base::round(r_adj, 4) 
                        norm <- (r - r@data@min) / (r@data@max - r@data@min)
                
                raster::writeRaster(norm,
                                    paste0(str_remove(
                                            paste0(path, str_remove(
                                                    features, "data/features/"
                                            )), ".tif"
                                    ),
                                    "_adj.tif"),
                                    overwrite = TRUE)
        } else {
                stop(print("Check your rasters"))
        }
        
}

## Load raster files

features <- list.files("data/features", 
                             pattern = ".tif",
                             full.names = T)

## Apply adjust function

lapply(features, adjust.rasters)




# END ---------------------------------------------------------------------


