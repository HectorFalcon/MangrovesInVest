library(sf)
library(tidyverse)

Uso_suelo <- st_read("data/shp/uso_de_suelo_2020/uso de suelo 2020.shp") %>% 
  st_transform(crs = 4326)

unique(Uso_suelo$Descrip)
### Desarrollo antropico ----

extraer <- function(shp, clase){
        
        uso_suelo <- shp %>% 
                filter(Descrip==clase)
}



des_ant <- extraer(Uso_suelo, "Desarrollo antropico")





plot(Des.antr)

### Agricola_Pecuaria ----

Agricola.pec <- Uso_suelo %>% 
  filter(Descrip=="Agricola - Pecuaria") %>% 
  st_write(.,"Rasters/Agri_Pec.shp")

### Otra vegetacion  ----

Otra.veg <- Uso_suelo %>% 
  filter(Descrip=="Otra vegetacion") %>% 
  st_write(.,"Rasters/Otra.veg.shp")

### Sin vegetacion  ----

Sin.veg <- Uso_suelo %>% 
  filter(Descrip=="Sin vegetacion") %>% 
  st_write(.,"Rasters/Sin.veg.shp")

### Manglar  ----

Manglar <- Uso_suelo %>% 
  filter(Descrip=="Manglar") %>% 
  st_write(.,"Rasters/Manglar.shp")

### Manglar perturbado ----

Mangl_pert <- Uso_suelo %>% 
  filter(Descrip=="Manglar perturbado") %>% 
  st_write(.,"Rasters/Mangl_Pert.shp")

### Otros humedaleso ----

Otros_humd <- Uso_suelo %>% 
  filter(Descrip=="Otros humedales") %>% 
  st_write(.,"Rasters/Otros_hum.shp")

### Cuerpos de agua ----

Cuerp_de_agua <- Uso_suelo %>% 
  filter(Descrip=="Cuerpos de agua") %>% 
  st_write(.,"Rasters/Cuerpo_agua.shp")

