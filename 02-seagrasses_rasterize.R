library(tidyverse)
library(sf)
library(raster)

pastos2017 <- read_sf("data/shp/pastos 2017.shp")

unique(pastos2017$Clase)
pastos <- pastos2017 %>% 
  mutate(Clase= case_when(Clase=="pastos"~"pasto_perdido",
                          Clase=="pasto perdido"~"pasto"),
         id= case_when(id=="pastos"~ 2,
                       Clase=="pasto_perdido"~2,
                       Clase=="pasto"~1))

st_write(pastos, "data/san_quintin/adjusted/pastos_2017.shp")

pastos1999 <- read_sf("data/san_quintin/adjusted/seagrasses/Pastos 1999.shp")
pastos2019 <- read_sf("data/shp/pastos 2019.shp")

unique(pastos2017$Clase)
# pastos2 <- pastos2017 %>% 
#   mutate(Clase= case_when(Clase=="pastos"~"pasto_perdido",
#                           Clase=="pasto perdido"~"pasto"),
#          id= case_when(id=="pastos"~ 2,
#                        Clase=="pasto_perdido"~2,
#                        Clase=="pasto"~1))

st_write(pastos2019, "data/san_quintin/adjusted/pastos_2019.shp")



pastos2017 <- pastos %>% 
  rename(class= id)

pastos2019 <- pastos2019 %>% 
  rename(class= id)

pastos1999 <- pastos1999 %>% 
  rename(class= id)


s2017 <- st_read( "data/san_quintin/adjusted/seagrasses/pastos_2017.shp")
s2019 <- st_read("data/san_quintin/adjusted/seagrasses/pastos_2019.shp")
s1999 <- st_read("data/san_quintin/adjusted/seagrasses/pastos_1999.shp")




# Rasterize ---------------------------------------------------------------

seagrasses <- list.files("data/san_quintin/adjusted/seagrasses/", pattern=".shp", 
                   recursive=T,
                   full.names=T)
names(s2017)


x <- "data/san_quintin/adjusted/seagrasses/pastos_2017.shp"


make.raster(x)





ext <- st_read("data/study_area/ramsar_site_sq.shp")

ext <- raster::extent(ext)

gridsize <- 0.0001

r <- raster::raster(ext, res=gridsize)


s2<- s2017[!st_is_empty(s2017),,drop=FALSE]

y <- s2 %>% 
  mutate(class= as.numeric(class))

rast <- raster::rasterize(y, r, field= "class")
crs(rast) <- "+proj=longlat"

raster::writeRaster(rast,
                    "data/san_quintin/raster/pastos_2017_adj.tif",
                    overwrite = TRUE)
