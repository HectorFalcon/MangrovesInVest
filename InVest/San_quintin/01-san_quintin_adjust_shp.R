library(tidyverse)
library(sf)
library(raster)

test <- c("TIPO", "TIP_VEG", "DESCRIPCIO")
path="data/san_quintin/adjusted/"
s1 <- st_read("data/san_quintin/crop_shp/uso_suelo-vegetacion_serie_I.shp") %>% 
  st_transform(., crs=4326)%>% 
  rename(TIP_VEG = TIPO)%>% 
  mutate(class= case_when(TIP_VEG== "Cuerpo de agua"~0,
                          TIP_VEG== "Matorral rosetofilo costero"~1,
                          TIP_VEG== "Vegetacion de dunas costeras"~2,
                          TIP_VEG== "riego"~3,
                          TIP_VEG== "Pastizal halofilo"~4,
                          TIP_VEG== "Pastizal inducido"~5,
                          TIP_VEG=="riego suspendido"~6,
                          TIP_VEG=="temporal"~3,
                          TIP_VEG=="Vegetacion halofila"~4,
                          TIP_VEG=="Vegetacion de galeria"~9,
                          TIP_VEG=="no aplicable"~10,
                          TIP_VEG=="Zona Urbana"~11,
                          TIP_VEG=="NO APLICABLE"~10,
                          TIP_VEG=="MATORRAL ROSETOFILO COSTERO"~1,
                          TIP_VEG=="VEGETACION DE DUNAS COSTERAS"~2,
                          TIP_VEG== "PASTIZAL HALOFILO"~4,
                          TIP_VEG=="SIN VEGETACION APARENTE"~12,
                          TIP_VEG=="VEGETACION HALOFILA"~4,
                          TIP_VEG=="PASTIZAL INDUCIDO"~5,
                          TIP_VEG=="SIN VEGETACIÓN APARENTE"~12,
                          TIP_VEG=="MATORRAL DESÉRTICO MICRÓFILO"~13,
                          TIP_VEG=="MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="PASTIZAL HALÓFILO"~4,
                          TIP_VEG=="VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN DE DUNAS COSTERAS"~2,
                          TIP_VEG=="ASENTAMIENTOS HUMANOS"~15,
                          TIP_VEG== "CUERPO DE AGUA"~0,
                          TIP_VEG=="AGRICULTURA DE RIEGO ANUAL"~3,
                          TIP_VEG=="VEGETACIÓN HALÓFILA HIDRÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA HERBÁCEA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="AGRICULTURA DE TEMPORAL ANUAL"~3
  )) %>% 
  st_write(., dsn= paste0(path, "uso-de-suelo-vegetacion_serie_I.shp"))

s2 <- st_read("data/san_quintin/crop_shp/uso_suelo-vegetacion_serie_II.shp") %>% 
  st_transform(., crs=4326) %>% 
  rename(TIP_VEG = TIPO)%>% 
  mutate(class= case_when(TIP_VEG== "Cuerpo de agua"~0,
                          TIP_VEG== "Matorral rosetofilo costero"~1,
                          TIP_VEG== "Vegetacion de dunas costeras"~2,
                          TIP_VEG== "riego"~3,
                          TIP_VEG== "Pastizal halofilo"~4,
                          TIP_VEG== "Pastizal inducido"~5,
                          TIP_VEG=="riego suspendido"~6,
                          TIP_VEG=="temporal"~3,
                          TIP_VEG=="Vegetacion halofila"~4,
                          TIP_VEG=="Vegetacion de galeria"~9,
                          TIP_VEG=="no aplicable"~10,
                          TIP_VEG=="Zona Urbana"~11,
                          TIP_VEG=="NO APLICABLE"~10,
                          TIP_VEG=="MATORRAL ROSETOFILO COSTERO"~1,
                          TIP_VEG=="VEGETACION DE DUNAS COSTERAS"~2,
                          TIP_VEG== "PASTIZAL HALOFILO"~4,
                          TIP_VEG=="SIN VEGETACION APARENTE"~12,
                          TIP_VEG=="VEGETACION HALOFILA"~4,
                          TIP_VEG=="PASTIZAL INDUCIDO"~5,
                          TIP_VEG=="SIN VEGETACIÓN APARENTE"~12,
                          TIP_VEG=="MATORRAL DESÉRTICO MICRÓFILO"~13,
                          TIP_VEG=="MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="PASTIZAL HALÓFILO"~4,
                          TIP_VEG=="VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN DE DUNAS COSTERAS"~2,
                          TIP_VEG=="ASENTAMIENTOS HUMANOS"~15,
                          TIP_VEG== "CUERPO DE AGUA"~0,
                          TIP_VEG=="AGRICULTURA DE RIEGO ANUAL"~3,
                          TIP_VEG=="VEGETACIÓN HALÓFILA HIDRÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA HERBÁCEA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="AGRICULTURA DE TEMPORAL ANUAL"~3
  )) %>% 
  st_write(., dsn= paste0(path, "uso-de-suelo-vegetacion_serie_II.shp"))

s3 <- st_read("data/san_quintin/crop_shp/uso_suelo-vegetacion_serie_III.shp") %>% 
  st_transform(., crs=4326) %>% 
  rename(TIP_VEG = any_of(test) )%>% 
  mutate(class= case_when(TIP_VEG== "Cuerpo de agua"~0,
                          TIP_VEG== "Matorral rosetofilo costero"~1,
                          TIP_VEG== "Vegetacion de dunas costeras"~2,
                          TIP_VEG== "riego"~3,
                          TIP_VEG== "Pastizal halofilo"~4,
                          TIP_VEG== "Pastizal inducido"~5,
                          TIP_VEG=="riego suspendido"~6,
                          TIP_VEG=="temporal"~3,
                          TIP_VEG=="Vegetacion halofila"~4,
                          TIP_VEG=="Vegetacion de galeria"~9,
                          TIP_VEG=="no aplicable"~10,
                          TIP_VEG=="Zona Urbana"~11,
                          TIP_VEG=="NO APLICABLE"~10,
                          TIP_VEG=="MATORRAL ROSETOFILO COSTERO"~1,
                          TIP_VEG=="VEGETACION DE DUNAS COSTERAS"~2,
                          TIP_VEG== "PASTIZAL HALOFILO"~4,
                          TIP_VEG=="SIN VEGETACION APARENTE"~12,
                          TIP_VEG=="VEGETACION HALOFILA"~4,
                          TIP_VEG=="PASTIZAL INDUCIDO"~5,
                          TIP_VEG=="SIN VEGETACIÓN APARENTE"~12,
                          TIP_VEG=="MATORRAL DESÉRTICO MICRÓFILO"~13,
                          TIP_VEG=="MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="PASTIZAL HALÓFILO"~4,
                          TIP_VEG=="VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN DE DUNAS COSTERAS"~2,
                          TIP_VEG=="ASENTAMIENTOS HUMANOS"~15,
                          TIP_VEG== "CUERPO DE AGUA"~0,
                          TIP_VEG=="AGRICULTURA DE RIEGO ANUAL"~3,
                          TIP_VEG=="VEGETACIÓN HALÓFILA HIDRÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA HERBÁCEA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="AGRICULTURA DE TEMPORAL ANUAL"~3
  )) %>% 
  st_write(., dsn= paste0(path, "uso-de-suelo-vegetacion_serie_III.shp"))

s5 <- st_read("data/san_quintin/crop_shp/uso_suelo-vegetacion_serie_V.shp") %>% 
  st_transform(., crs=4326)%>% 
  mutate(class= case_when(TIP_VEG== "Cuerpo de agua"~0,
                          TIP_VEG== "Matorral rosetofilo costero"~1,
                          TIP_VEG== "Vegetacion de dunas costeras"~2,
                          TIP_VEG== "riego"~3,
                          TIP_VEG== "Pastizal halofilo"~4,
                          TIP_VEG== "Pastizal inducido"~5,
                          TIP_VEG=="riego suspendido"~6,
                          TIP_VEG=="temporal"~3,
                          TIP_VEG=="Vegetacion halofila"~4,
                          TIP_VEG=="Vegetacion de galeria"~9,
                          TIP_VEG=="no aplicable"~10,
                          TIP_VEG=="Zona Urbana"~11,
                          TIP_VEG=="NO APLICABLE"~10,
                          TIP_VEG=="MATORRAL ROSETOFILO COSTERO"~1,
                          TIP_VEG=="VEGETACION DE DUNAS COSTERAS"~2,
                          TIP_VEG== "PASTIZAL HALOFILO"~4,
                          TIP_VEG=="SIN VEGETACION APARENTE"~12,
                          TIP_VEG=="VEGETACION HALOFILA"~4,
                          TIP_VEG=="PASTIZAL INDUCIDO"~5,
                          TIP_VEG=="SIN VEGETACIÓN APARENTE"~12,
                          TIP_VEG=="MATORRAL DESÉRTICO MICRÓFILO"~13,
                          TIP_VEG=="MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="PASTIZAL HALÓFILO"~4,
                          TIP_VEG=="VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN DE DUNAS COSTERAS"~2,
                          TIP_VEG=="ASENTAMIENTOS HUMANOS"~15,
                          TIP_VEG== "CUERPO DE AGUA"~0,
                          TIP_VEG=="AGRICULTURA DE RIEGO ANUAL"~3,
                          TIP_VEG=="VEGETACIÓN HALÓFILA HIDRÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA HERBÁCEA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="AGRICULTURA DE TEMPORAL ANUAL"~3
  )) %>% 
  st_write(., dsn= paste0(path, "uso-de-suelo-vegetacion_serie_V.shp"))

s6 <- st_read("data/san_quintin/crop_shp/uso_suelo-vegetacion_serie_VI.shp") %>% 
  st_transform(., crs=4326)%>% 
  mutate(class= case_when(TIP_VEG== "Cuerpo de agua"~0,
                          TIP_VEG== "Matorral rosetofilo costero"~1,
                          TIP_VEG== "Vegetacion de dunas costeras"~2,
                          TIP_VEG== "riego"~3,
                          TIP_VEG== "Pastizal halofilo"~4,
                          TIP_VEG== "Pastizal inducido"~5,
                          TIP_VEG=="riego suspendido"~6,
                          TIP_VEG=="temporal"~3,
                          TIP_VEG=="Vegetacion halofila"~4,
                          TIP_VEG=="Vegetacion de galeria"~9,
                          TIP_VEG=="no aplicable"~10,
                          TIP_VEG=="Zona Urbana"~11,
                          TIP_VEG=="NO APLICABLE"~10,
                          TIP_VEG=="MATORRAL ROSETOFILO COSTERO"~1,
                          TIP_VEG=="VEGETACION DE DUNAS COSTERAS"~2,
                          TIP_VEG== "PASTIZAL HALOFILO"~4,
                          TIP_VEG=="SIN VEGETACION APARENTE"~12,
                          TIP_VEG=="VEGETACION HALOFILA"~4,
                          TIP_VEG=="PASTIZAL INDUCIDO"~5,
                          TIP_VEG=="SIN VEGETACIÓN APARENTE"~12,
                          TIP_VEG=="MATORRAL DESÉRTICO MICRÓFILO"~13,
                          TIP_VEG=="MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="PASTIZAL HALÓFILO"~4,
                          TIP_VEG=="VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN DE DUNAS COSTERAS"~2,
                          TIP_VEG=="ASENTAMIENTOS HUMANOS"~15,
                          TIP_VEG== "CUERPO DE AGUA"~0,
                          TIP_VEG=="AGRICULTURA DE RIEGO ANUAL"~3,
                          TIP_VEG=="VEGETACIÓN HALÓFILA HIDRÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA HERBÁCEA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="AGRICULTURA DE TEMPORAL ANUAL"~3
  )) %>%  
  st_write(., dsn= paste0(path, "uso-de-suelo-vegetacion_serie_VI.shp"))

s7 <- st_read("data/san_quintin/crop_shp/uso_suelo-vegetacion_serie_VII.shp") %>% 
  st_transform(., crs=4326) %>% 
  rename(TIP_VEG= any_of(test)) %>% 
  mutate(class= case_when(TIP_VEG== "Cuerpo de agua"~0,
                          TIP_VEG== "Matorral rosetofilo costero"~1,
                          TIP_VEG== "Vegetacion de dunas costeras"~2,
                          TIP_VEG== "riego"~3,
                          TIP_VEG== "Pastizal halofilo"~4,
                          TIP_VEG== "Pastizal inducido"~5,
                          TIP_VEG=="riego suspendido"~6,
                          TIP_VEG=="temporal"~3,
                          TIP_VEG=="Vegetacion halofila"~4,
                          TIP_VEG=="Vegetacion de galeria"~9,
                          TIP_VEG=="no aplicable"~10,
                          TIP_VEG=="Zona Urbana"~11,
                          TIP_VEG=="NO APLICABLE"~10,
                          TIP_VEG=="MATORRAL ROSETOFILO COSTERO"~1,
                          TIP_VEG=="VEGETACION DE DUNAS COSTERAS"~2,
                          TIP_VEG== "PASTIZAL HALOFILO"~4,
                          TIP_VEG=="SIN VEGETACION APARENTE"~12,
                          TIP_VEG=="VEGETACION HALOFILA"~4,
                          TIP_VEG=="PASTIZAL INDUCIDO"~5,
                          TIP_VEG=="SIN VEGETACIÓN APARENTE"~12,
                          TIP_VEG=="MATORRAL DESÉRTICO MICRÓFILO"~13,
                          TIP_VEG=="MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="PASTIZAL HALÓFILO"~4,
                          TIP_VEG=="VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN DE DUNAS COSTERAS"~2,
                          TIP_VEG=="ASENTAMIENTOS HUMANOS"~15,
                          TIP_VEG== "CUERPO DE AGUA"~0,
                          TIP_VEG=="AGRICULTURA DE RIEGO ANUAL"~3,
                          TIP_VEG=="VEGETACIÓN HALÓFILA HIDRÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA HERBÁCEA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="AGRICULTURA DE TEMPORAL ANUAL"~3
  )) %>% 
  st_write(., dsn= paste0(path, "uso-de-suelo-vegetacion_serie_VII.shp"))














classes <- data.frame(TIP_VEG=unique(c(s1$TIP_VEG, s2$TIP_VEG, s3$TIP_VEG, s5$TIP_VEG, s6$TIP_VEG, s7$TIP_VEG))) %>% 
  mutate(class= case_when(TIP_VEG== "Cuerpo de agua"~0,
                          TIP_VEG== "Matorral rosetofilo costero"~1,
                          TIP_VEG== "Vegetacion de dunas costeras"~2,
                          TIP_VEG== "riego"~3,
                          TIP_VEG== "Pastizal halofilo"~4,
                          TIP_VEG== "Pastizal inducido"~5,
                          TIP_VEG=="riego suspendido"~6,
                          TIP_VEG=="temporal"~3,
                          TIP_VEG=="Vegetacion halofila"~4,
                          TIP_VEG=="Vegetacion de galeria"~9,
                          TIP_VEG=="no aplicable"~10,
                          TIP_VEG=="Zona Urbana"~11,
                          TIP_VEG=="NO APLICABLE"~10,
                          TIP_VEG=="MATORRAL ROSETOFILO COSTERO"~1,
                          TIP_VEG=="VEGETACION DE DUNAS COSTERAS"~2,
                          TIP_VEG== "PASTIZAL HALOFILO"~4,
                          TIP_VEG=="SIN VEGETACION APARENTE"~12,
                          TIP_VEG=="VEGETACION HALOFILA"~4,
                          TIP_VEG=="PASTIZAL INDUCIDO"~5,
                          TIP_VEG=="SIN VEGETACIÓN APARENTE"~12,
                          TIP_VEG=="MATORRAL DESÉRTICO MICRÓFILO"~13,
                          TIP_VEG=="MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="PASTIZAL HALÓFILO"~4,
                          TIP_VEG=="VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN DE DUNAS COSTERAS"~2,
                          TIP_VEG=="ASENTAMIENTOS HUMANOS"~15,
                          TIP_VEG== "CUERPO DE AGUA"~0,
                          TIP_VEG=="AGRICULTURA DE RIEGO ANUAL"~3,
                          TIP_VEG=="VEGETACIÓN HALÓFILA HIDRÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE MATORRAL ROSETÓFILO COSTERO"~1,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="VEGETACIÓN SECUNDARIA HERBÁCEA DE VEGETACIÓN HALÓFILA XERÓFILA"~4,
                          TIP_VEG=="AGRICULTURA DE TEMPORAL ANUAL"~3
  )) %>% 
  dplyr::select(class, TIP_VEG) %>% 
  arrange(class)

writexl::write_xlsx(classes, "data/lulc_san-quintin.xlsx")

# 
# add_class <- function(list){
#   
#     vegetation_columns= c("TIPO", "TIP_VEG")
#     
#     x <- st_read(list) %>% 
#       st_transform(crs=4326) %>% 
#       rename(TIP_VEG = any_of(vegetation_columns) )
#     
#       dir.create("data/san_quintin/adjusted/", showWarnings = F)
#    x <- x %>% 
#       mutate(class= case_when(TIP_VEG== "Cuerpo de agua"~0,
#                               TIP_VEG== "Matorral rosetofilo costero"~1,
#                               TIP_VEG== "Vegetacion de dunas costeras"~2,
#                               TIP_VEG== "riego"~3,
#                               TIP_VEG== "Pastizal halofilo"~4,
#                               TIP_VEG== "Pastizal inducido"~5,
#                               TIP_VEG=="riego suspendido"~6,
#                               TIP_VEG=="temporal"~7,
#                               TIP_VEG=="Vegetacion halofila"~8,
#                               TIP_VEG=="Vegetacion de galeria"~9,
#                               TIP_VEG=="no aplicable"~10,
#                               TIP_VEG=="Zona Urbana"~11,
#                               TIP_VEG=="NO APLICABLE"~10,
#                               TIP_VEG=="MATORRAL ROSETOFILO COSTERO"~1,
#                               TIP_VEG=="VEGETACION DE DUNAS COSTERAS"~2,
#                               TIP_VEG== "PASTIZAL HALOFILO"~4,
#                               TIP_VEG=="SIN VEGETACION APARENTE"~12,
#                               TIP_VEG=="VEGETACION HALOFILA"~8,
#                               TIP_VEG=="PASTIZAL INDUCIDO"~5,
#                               TIP_VEG=="SIN VEGETACIÓN APARENTE"~12,
#                               TIP_VEG=="MATORRAL DESÉRTICO MICRÓFILO"~13,
#                               TIP_VEG=="MATORRAL ROSETÓFILO COSTERO"~1,
#                               TIP_VEG=="PASTIZAL HALÓFILO"~4,
#                               TIP_VEG=="VEGETACIÓN HALÓFILA XERÓFILA"~14,
#                               TIP_VEG=="VEGETACIÓN DE DUNAS COSTERAS"~2,
#                               TIP_VEG=="ASENTAMIENTOS HUMANOS"~15,
#                               TIP_VEG== "CUERPO DE AGUA"~0,
#                               TIP_VEG=="AGRICULTURA DE RIEGO ANUAL"~16,
#                               TIP_VEG=="VEGETACIÓN HALÓFILA HIDRÓFILA"~17,
#                               TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE MATORRAL ROSETÓFILO COSTERO"~1,
#                               TIP_VEG=="VEGETACIÓN SECUNDARIA ARBUSTIVA DE VEGETACIÓN HALÓFILA XERÓFILA"~14,
#                               TIP_VEG=="VEGETACIÓN SECUNDARIA HERBÁCEA DE VEGETACIÓN HALÓFILA XERÓFILA"~14
#                               )) 
#    
#     path="data/san_quintin/adjusted/"
#     st_write(x,dsn= paste0( str_remove( paste0(path, 
#                                                str_remove(list, "data/san_quintin/")),
#                                         ".shp"),
#                             "_adj.shp")
#              ) 
#   }
#   
# 
# 
# 
# list <- list.files(path = "data/san_quintin/crop_shp/", pattern = ".shp", recursive = T, full.names = T)
# 
# lapply(list, add_class)
