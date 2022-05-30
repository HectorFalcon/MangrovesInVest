library(tidyverse)
library(sf)
library(prioritizr)
library(RStoolbox)


pu <- st_read("planning_units/pu_lockedin.shp")


features <- stack(list.files("features/", pattern = ".tif", full.names = T))

features <- normImage(features, norm = T)
features <- (features - features@data@min)/(features@data@max - features@data@min)

plot(features)
pu$cost_column <- 1

# create problem
p1 <- problem(pu, features = features, cost_column = "cost_column") %>%
          add_min_set_objective() %>% 
          add_relative_targets(0.3) %>%  ### 100 porciento en las islas y 30 porciento en la tierra
          add_binary_decisions() %>%
          #(number_solutions = 1000, pool_gap = 0.1) %>%
          add_default_solver(verbose = FALSE)

# solve the problem
s1 <- solve(p1)

# plot the solution
plot(s1)

# calculate feature representation
r1 <- eval_feature_representation_summary(p1, s1[, "solution_1"])
print(r1)

# find column numbers with the solutions
solution_columns <- which(grepl("solution", names(s1)))

# calculate selection frequencies
s1$selection_frequencies <- rowSums(as.matrix(s1@data[, solution_columns]))

# plot spatial distribution of the selection frequencies

fins1 <- s1[s1@data$status < 2, ]

selection_frequencies <- st_as_sf(fins1[, "selection_frequencies"])

hist(selection_frequencies$selection_frequencies)
