# Plot function -----------------------------------------------------------

mapear <- function(raster, titulo){
  library(raster)
  library(tidyverse)
  library(sf)
  library(rgdal)
  #Load your shp layers:
  ##Ejidos-Bahia Magdalena
  df_ejidos <- st_read("data/shp/Ejidos union.shp") %>% 
    st_transform(crs = 4326)
  ##Mexican States
  df_mexico <- st_read("data/shp/estados.shp") %>% 
    st_transform(crs = 4326)
  #Remove NAs from raster
  r <- as.data.frame(raster, xy=TRUE) %>% 
    na.omit()
  #Remove all 0 values
  r <- r %>% 
    filter(r[3]!= 0)
  
  #Plot
  plot <- ggplot()+
    geom_sf(data = df_mexico, fill= "#E0EEEE",)+
    geom_sf(data = df_ejidos, aes(col= NOMBRE),fill= NA)+
    coord_sf()+
    xlim (-112.3, -111.5)+ ylim (24.4, 25.7)+
    geom_raster(data= r, aes(x=x, y=y, fill= r[,3]))+
    scale_fill_gradient(
      low = "#8B2323",
      high = "#458B00",
      space = "Lab",
      na.value = "grey50",
      guide = "colourbar",
      aesthetics = "fill"
    )+
    labs(x= "Longitud", y= "Latitud", 
         title = titulo, 
         fill= "Mg eC per Ha",
         col="Ejidos")
  
  dir.create("figs/", showWarnings = F)
  ggsave(filename =paste0("figs/", titulo, ".png"), 
         dpi=300, height = 10, width = 12)
  
  
  plot
  
}




## Example
#load your raster
seq_81_50 <- raster("data/rasters/TNC_seque_81_50_ AR.tif")

#Test plot function
mapear(seq_81_50, #This is your raster
       "Total Net Carbon Sequestration 1981-2050" #This is your plot title
)