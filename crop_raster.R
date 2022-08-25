library(raster)
library(sf)

ramsar <- st_read("data/study_area/ramsar_site_sq.shp") %>% 
  st_transform(., CRS=4326)


t <- raster("data/san_quintin/raster/uso-de-suelo-vegetacion_serie_I_adj_1991.tif")


nt <- crop(t, extent(ramsar))


