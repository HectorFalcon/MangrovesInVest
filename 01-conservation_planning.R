library(tidyverse)
library(sf)
library(prioritizr)
library(RStoolbox)
library(raster)
library(gurobi)

pu <- st_read("data/planning_units/pu_lockedin.shp")

features <- stack(list.files("data/features/adjusted/", 
                             pattern = "_adj.tif",
                             full.names = T)
)

#Conservation target (%)
t1 <- c(0, #Agricola/Pecuaria
        0,#Cuerpos de Agua
        0.1,#Desarrollo Antropico
        0.3,#Habitat richness
        1,#Islands
        0.3,#Disturbed Mangrove
        0.3,#Mangrove
        0.3,#other vegetation
        0.3,#Other wetlands
        0.3,#Seagrasses
        0.1,#No veg
        0.1,#indice
        0.1,#indice
        0.1#indice 
        )




pu$cost_column <- 1

# create problem
locked_in <- pu[pu$locked_in == 1, ]
p1 <- problem(pu, features = features, cost_column = "cost_column") %>%
          add_min_set_objective() %>% 
          add_relative_targets(t1) %>%  ### 100 porciento en las islas y 30 porciento en la tierra
          add_binary_decisions() %>%
          add_locked_in_constraints(locked_in) %>%
        add_gap_portfolio(number_solutions = 1000, pool_gap = 0.1) %>%
          add_gurobi_solver(verbose = FALSE)

# solve the problem

s1 <- solve(p1)

# plot the solution
 plot(s1)



# calculate feature representation
r1 <- eval_feature_representation_summary(p1, s1[, "solution_1"])
print(r1)

# find column numbers with the solutions
s1_df <- s1 %>% 
        as.data.frame()

solution_columns <- which(grepl("solution", names(s1_df)))


#Get the names string 
solution_columns <- colnames(s1_df[, solution_columns])



# calculate selection frequencies
s1_df $selection_frequencies <- rowSums(s1_df [, solution_columns ])


s1_df <- st_as_sf(s1_df)


# plot spatial distribution of the selection frequencies

fins1 <- s1[s1@data$status < 2, ]

selection_frequencies <- st_as_sf(fins1[, "selection_frequencies"])

hist(selection_frequencies$selection_frequencies)
