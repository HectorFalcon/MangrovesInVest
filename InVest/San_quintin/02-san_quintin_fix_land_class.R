library(tidyverse)

lulc_sq <- readxl::read_excel("data/san_quintin/raster/lulc_san-quintin.xlsx") %>% 
  rename(ID= class) %>% 
  mutate(class= case_when(ID==0~"Cuerpo de agua",
                          ID==1~"Matorral rosetofilo costero",
                          ID==2~"Vegetacion de dunas costeras",
                          ID==3~"Riego",
                          ID==4~"Pastizal halofilo",
                          ID==5~"Pastizal inducido",
                          ID==6~"Riego suspendido",
                          ID==7~"Temporal",
                          ID==8~"Vegetacion Halofila",
                          ID==9~"Vegetacion de galeria",
                          ID==10~"No aplicable",
                          ID==11~"Zona Urbana",
                          ID==12~"Sin vegetacion aparente",
                          ID==13~"Matorral desertico microfilo",
                          ID==14~"Vegetacion halofila xerofila",
                          ID==15~"Asentamientos Humanos",
                          ID==16~"Agricultura de riego anual",
                          ID==17~"Vegetacion halofila hidrofila",
                          ID==18~"Agricultura de temporal anual"),
         )

writexl::write_xlsx(lulc_sq,"data/san_quintin/raster/lulc_san-quintin.xlsx")


