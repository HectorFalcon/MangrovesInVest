library(raster)
library(sf)



# San Quintin -------------------------------------------------------------


#Load Mexican Ramsar Sites shapefile
ramsar <- st_read("data/study_area/ramsar_site_sq.shp") %>% 
  st_transform(., CRS=4326)


#Use a Land Use raster for extent
t <- raster("data/san_quintin/raster/uso-de-suelo-vegetacion_serie_I_adj_1991.tif")

#Crop Ramsar Sites to San Quintin
nt <- crop(t, extent(ramsar))


