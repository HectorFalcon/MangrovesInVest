library(raster)
library(tidyverse)
library(rgdal)
library(sf)


# Plot function -----------------------------------------------------------

mapear <- function(raster, titulo){
        library(raster)
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


# Polygon extraction function ---------------------------------------------

extraer <- function(shp, class){
        dir.create("data/features", showWarnings = F)
        path= "data/features/"
        #Intente hacer que class sea una lista de todas
        #las clases que queremos extraer del shp de uso de suelo
        #para que sea automatico todo
        for( i in length(class)){
               
        shp %>% 
                filter(Descrip==class[[i]]) %>% 
                sf::st_write( dsn = paste0(path, 
                                          str_replace(class[[i]], " ", "_"),
                                          ".shp"))
}
} 
##Example polygon extraction

#Load your main shp containing all classes
Uso_suelo <- st_read("data/shp/uso_de_suelo_2020/uso de suelo 2020.shp") %>% 
        st_transform(crs = 4326)

#Esta es la lista con las clases de uso de suelo
classes <- unique(Uso_suelo$Descrip)   

#Test function
    
#La funcion parece servir, solo que por alguna razon
#Solo exporta el shp de cuerpos de agua
extraer(Uso_suelo, classes) 


#NOT RUN
# agua <- sf::st_read("data/features/Cuerpos_de agua.shp")
# plot(agua)




library(tidyverse)
library(sf)
library(raster)


#Crop shp
islands <- read_sf("data/shp/islands/elementos_insulares_cdtim_v2_1_2018.shp") %>% 
        st_transform(., crs=4326) %>% 
        st_make_valid()

isl <- islands %>% 
        filter(REG_MAR%in% c("GOLFO DE CALIFORNIA","OCÉANO PACÍFICO NORTE" )) %>% 
        select(OBJECTID)


pu <- read_sf("data/planning_units/pu_lockedin.shp") %>% 
        st_transform(., crs=4326)


isl_bm <- pu[isl,]

isl_bm <- isl_bm %>% 
        select(id)


#Raster shp

BM <- read_sf("data/planning_units/pu_lockedin.shp")

ext <- raster::extent(BM)
gridsize <- 0.01
r <- raster::raster(ext, res=gridsize)

y <- isl_bm %>% 
        mutate(Constant=1)

rast <- raster::rasterize(y, r, field= "Constant")
crs(rast) <- "+proj=longlat"
plot(rast)

raster::writeRaster(rast, "data/features/islands_BM.tif", overwrite=T)


#Resample all rasters to same extent

# 
# t <- list.files("data/features", 
#                 pattern = ".tif",
#                 full.names = T)

adjust.rasters <- function(features){
        dir.create("data/features/adjusted/", showWarnings = F)
        path="data/features/adjusted/"
        control <- raster::raster("data/features/01_agri_pec.tif")
        r <- raster::raster(features)
        r_adj <- raster::resample(r, control)
        
        if (r_adj@data@min==r_adj@data@max){
                
                raster::writeRaster(r_adj, paste0( str_remove( paste0(path, str_remove(features, "data/features/")), ".tif"),
                                            "_adj.tif"),
                                    overwrite=TRUE)
                
        } else if(r_adj@data@min!=r_adj@data@max){
        
        r <- round(r_adj, 4)
        norm <- (r- r@data@min)/ (r@data@max- r@data@min )
        
                raster::writeRaster(norm, paste0( str_remove( paste0(path, str_remove(features, "data/features/")), ".tif"),
                                            "_adj.tif"),
                                            overwrite=TRUE)
        } else {stop( print("Check your rasters"))}
        
}

# lapply(t, adjust.rasters)



  