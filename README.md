# MangrovesInVest

Spatial analysis for quantifying Marine Blue Carbon in Mangroves, Salt Marshes and Seagrasses. Natural Capital Project InVest and the PrioritzR package are used together for developing conservation frameworks in two region of the Baja California Peninsula, Mexico: The Magdalena Bay Coastal Lagoon Complex and San Quintin coastal lagoon.



### InVest Folder

Contains all the R scripts related to processing InVest inputs and outputs


01-Map-layout: Automatic Mapping for InVest Outputs

##### San_quintin/
00-crop_raster: Crop a raster using shp extent

01-san_quintin_adjust_shp: Standarize INEGI's* land cover/use classes

02-san_quintin_fix_land_class: Fix land cover land use table for InVest

03-salt_marsh_rasterize: Rasterize INEGI's fixed land cover shp containng salt marshes vegetation polygons

03-seagrasses_rasterize: Rasterize seagrasses extension shapefiles



### PrioritizR Folder

R Scripts for wrangling conservation features and conservation planning framework


#### Magadalena_bay/

00-rasterizing_land_use_types: Rasterizing each land cover class from INEGI's shapefile

01-wrangling_features: Resample, adjust and normalize raster features

02-conservation_plannng: Run PrioritzR model for spatial planning




###### *INEGI: Instituto Nacional de Estadística, Geografía e Informática (México)


### Sources

##### Magdalena Bay

Land Cover Land Use associated to mangroves shapefiles:

http://www.conabio.gob.mx/informacion/gis/

##### San Quintin

Land Cover Land Use for vegetation types shapefiles:

https://www.inegi.org.mx/temas/usosuelo/#Descargas


