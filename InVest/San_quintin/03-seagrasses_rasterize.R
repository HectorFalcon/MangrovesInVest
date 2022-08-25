library(tidyverse)
library(sf)
library(raster)


# Function ----------------------------------------------------------------
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
                          x, "data/san_quintin/adjusted/seagrasses/"
                        )), ".shp"
                      ),
                      "_adj.tif"),
                      overwrite = TRUE)
  
}






# Rasterize ---------------------------------------------------------------

seagrasses <- list.files("data/san_quintin/adjusted/seagrasses/", pattern=".shp", 
                   recursive=T, full.names = T)

lapply(seagrasses, make.raster)



# Legacy ------------------------------------------------------------------

# pastos2017 <- read_sf("data/shp/pastos 2017.shp")
# 
# unique(pastos2017$Clase)
# pastos <- pastos2017 %>% 
#   mutate(Clase= case_when(Clase=="pastos"~"pasto_perdido",
#                           Clase=="pasto perdido"~"pasto"),
#          id= case_when(id=="pastos"~ 2,
#                        Clase=="pasto_perdido"~2,
#                        Clase=="pasto"~1))
# 
# st_write(pastos, "data/san_quintin/adjusted/pastos_2017.shp")
# 
# pastos1999 <- read_sf("data/san_quintin/adjusted/seagrasses/Pastos 1999.shp")
# pastos2019 <- read_sf("data/shp/pastos 2019.shp")
# 
# unique(pastos2017$Clase)
# # pastos2 <- pastos2017 %>% 
# #   mutate(Clase= case_when(Clase=="pastos"~"pasto_perdido",
# #                           Clase=="pasto perdido"~"pasto"),
# #          id= case_when(id=="pastos"~ 2,
# #                        Clase=="pasto_perdido"~2,
# #                        Clase=="pasto"~1))
# 
# st_write(pastos2019, "data/san_quintin/adjusted/pastos_2019.shp")
# 
# 
# 
# pastos2017 <- pastos %>% 
#   rename(class= id)
# 
# pastos2019 <- pastos2019 %>% 
#   rename(class= id)
# 
# pastos1999 <- pastos1999 %>% 
#   rename(class= id)

