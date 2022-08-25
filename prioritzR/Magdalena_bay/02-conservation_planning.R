library(tidyverse)
library(sf)
library(prioritizr)
library(RStoolbox)
library(raster)
library(gurobi)
library(Matrix)


# Planning Units ----------------------------------------------------------


## Load our planning units: Bahia Magdalena land portion

pu <- st_read("data/planning_units/Magdalena_bay/pu_land.shp") %>% 
        st_transform(., crs=4326) %>% 
  dplyr::rename(locked_in=lockd_n)%>% 
  mutate(locked_in= ifelse(is.na(locked_in), 0, locked_in))


# # Visualize Planning Units
# ggplot()+
#         geom_sf(data=pu, aes(fill=locked_in))+
#         coord_sf()



## Add cost column

#All values are set to 1
pu$cost_column <- 1


## Extract planning unit with an existing conservation status

locked_in <- pu[pu$locked_in == 1, ]



# Features ----------------------------------------------------------------

## Raster stack of conservation features

features <- stack(list.files("data/features/adjusted/", 
                             pattern = "_adj.tif",
                             full.names = T)[-c(1:3)]
)


 
## Define specific conservation targets for each feature (%)

t1 <- c(
        # 0.1,#Desarrollo Antropico
        0.3,#Habitat richness
        0.3, #islands
        0.3,#Disturbed Mangrove
        0.3,#Mangrove
        0.3,#other vegetation
        0.3,#Other wetlands
        0.3,#Seagrasses
        0.1,#No veg
        0.3,#indice de degradacion ecologica
        0.3,#indice de impacto antropogenico
        0.1,#indice de antropizacion
        0.3,#Total net carbon sequestration
        0.3, #carbon stock at 2050
        0.3 #Carbon emissions
        )





# Linear Penalties --------------------------------------------------------



## Penalize Anthropization Index raster layer
# (Penalize solutions with higher values of anthropic development)

ant_penalties <- subset(features, 11) %>%
        as.data.frame(., xy = TRUE) %>%
        mutate(penalty_data = X14_anthropization_index_adj) %>%
        na.omit() %>%
        filter(penalty_data != 0) %>%
        dplyr::select(-X14_anthropization_index_adj) %>%
        st_as_sf(., coords = c("x", "y"), crs = 4326)


# Create a raster template
r <- raster(extent(pu), res = 0.01)

# Rasterize anthropic penalties
ant_penalties <- rasterize(ant_penalties, r, field = "penalty_data")

crs(ant_penalties) <- "+proj=longlat"

## Visualize penalties
# plot(ant_penalties)



# Connectivity penalties --------------------------------------------------

## Penalize solutions with low connectivity between planning units   


## Create matrix form connectivity penalties
# 
# #Rescale function
# rescale <-
#         function(x,
#                  to = c(0, 1),
#                  from = range(x, na.rm = TRUE)) {
#                 (x - from[1]) / diff(from) * diff(to) + to[1]
#         }
# 
# 
# # a)
# 
# ## Create a symmetric connectivity matrix where the connectivity between
# # two planning units corresponds to their spatial proximity
# # i.e., planning units that are further apart share less connectivity
# 
# 
# centroids <- rgeos::gCentroid(spgeom = methods::as(object = pu,
#                                                    Class = "Spatial"),
#                               byid = TRUE)
# 
# a_matrix <- (1 / (as(dist(centroids@coords), "Matrix") + 1))
# 
# a_matrix[] <- rescale(a_matrix[])
# 
# a_matrix[a_matrix< 0.7] <- 0
# 
# a_penalties <- c(1, 5)
# 
# 
# 
# # image(matrix) DO NOT RUN! it takes a while
# 
# 
# #b)
# 
# # create a symmetric connectivity matrix where the connectivity between
# # two planning units corresponds to their shared boundary length
# b_matrix <- boundary_matrix(pu)
# 
# # standardize matrix values to lay between zero and one
# b_matrix[] <- rescale(b_matrix[])
# 
# b_penalties <- c(10, 25)
# 
# 


#Connectivity data: Add linear constraints
#Ensure 30% of connectivity
feat_con <- features[[nlayers(features)]]
threshold <- cellStats(feat_con, "sum")*0.5


# Defining the conservation problem ---------------------------------------


#Base problem
p0 <- problem(pu, features = features, cost_column = "cost_column") %>%
          add_min_set_objective() %>% 
          #Relative conservation targets for each feature
          add_relative_targets(t1) %>% 
          add_binary_decisions() %>%
          #Planning units with an existing conservation status        
          add_locked_in_constraints(locked_in) %>%
          #Anthropic penalization
          # add_linear_penalties(100, data=ant_penalties$layer) %>%
  # add_contiguity_constraints() %>%
  add_neighbor_constraints(k = 2) %>%
          add_linear_constraints(data=feat_con, threshold=threshold, sense=">=") %>% 
          add_gap_portfolio(number_solutions = 1000, pool_gap = 0.1) %>%
          add_gurobi_solver(verbose = FALSE) 

#Connectivity penalties a)
# p1 <-  p0 %>% 
#         #Connectivity penalization
#         add_connectivity_penalties(a_penalties[1], data=a_matrix) 
# 
# #Connectivity penalties b)
# p2 <-  p0 %>% 
#         add_connectivity_penalties(b_penalties[1], data=b_matrix)   



# Problem Solution --------------------------------------------------------

## Solve problem

s0 <- solve(p0)
# s1 <- solve(p1)
# s2 <- solve(p2)

## Plot one solution


# s0 %>%
#         
#         dplyr::select(solution_10) %>%
#         ggplot() +
#         geom_sf(aes(fill = solution_10))
       

## Calculate feature representation for a solution

r1 <- eval_feature_representation_summary(p1, s1[, "solution_1"])

#Visualize
print(r1)


# #calculate irreplaceability
# 
# rc <- p1 %>% 
#         eval_replacement_importance(s1[, "solution_1"])

# rc$rc[rc$rc > 100] <- 1.09
# # plot the importance scores
# # planning units that are truly irreplaceable are shown in yellow
 
# plot(rc)
# title(main= "Irreplaceability", )



# Selection frequencies ---------------------------------------------------


## Find column numbers with the solutions
s1_df <- s0 %>% 
        as.data.frame()

solution_columns <- which(grepl("solution", names(s1_df)))


#Get the names string 
solution_columns <- colnames(s1_df[, solution_columns])



## Calculate selection frequency for each planning unit
s1_df $selection_frequencies <- rowSums(s1_df [, solution_columns ])


## Tranform it into simple feature
s1_df <- st_as_sf(s1_df)




## Visualize spatial distribution of selection frequencies
#Displaying only planning units selected 100(0) times out of 100(0)

mx <- st_read("C:/Users/fancy/CBMC Dropbox/Eduardo/R_projects/hypermarkets/data/shp/Mexico_States.shp")


priority%>%
        ggplot()+
        geom_sf(data=mx, fill="wheat1")+
        geom_sf(data=pu, fill="wheat4", col="wheat4")+
        geom_sf(aes(fill=Priority_unit), col="black")+
        labs(title= "Conservation priority units in Magadalena Bay \n (matrix b)", x="Longitude", y="Latitude")+
        theme_light()+
        xlim(-112.3, -111.3)+ ylim(24.2, 25.75)+
        theme(title = element_text(face="bold",hjust = 0.5, size=15, vjust = 0.5),
              panel.border = element_rect(),
              panel.grid = element_line(colour = NA),
              panel.background = element_rect(fill="aliceblue"))+
        ggsn::north(symbol = 10, location = "bottomleft", y.min =24 , 
                    y.max=24.4 , x.min = -112.3, x.max = -112.2, scale = 1)+
        ggsn::scalebar( data = s1_df, dist=6, dist_unit = "km", 
                        transform = TRUE, model="WGS84", location="bottomright" 
        )+
        ggeasy::easy_center_title()


priority <- s1_df %>% 
  dplyr::select(selection_frequencies, locked_in) %>% 
  mutate(Priority_unit= ifelse(selection_frequencies==1000, 1, 0)) %>% 
  dplyr::select(-selection_frequencies)


st_write(priority, "data/outputs/Magdalena_Bay_Priority_zones.shp")

dir.create("figs/", showWarnings = F)
ggsave("figs/03_priorization_b_matrix.tiff", dpi=600, height = 12, width = 10)


# fins1 <- s1[s1@data$status < 2, ]

# selection_frequencies <- st_as_sf(fins1[, "selection_frequencies"])

# hist(s1_df$selection_frequencies)




# END ---------------------------------------------------------------------





