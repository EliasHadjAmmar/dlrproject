library(sf)
library(tidyverse)
setwd("~/GitHub/dlrproject")

grid <- st_read("drive/data/zensus/Zensus_Frankfurt_am_Main_Grid_100m.gpkg")
nbs <- st_read("drive/data/landprices/Land_Prices_Neighborhood_Frankfurt_am_Main.gpkg")
census <- read_delim("drive/data/zensus/Zensus_Frankfurt_am_Main_Population.csv", delim=";")

# Spatially join grid cells to neighbourhoods
keys <- grid |> st_join(nbs, join=st_intersects)

# Join the census data from the csv to the already-joined grid cells
matched_grid_data <- keys |> left_join(census, by="Grid_Code")

# Group by neighbourhood and sum group population counts
nbs_popsums <- matched_grid_data |> 
  group_by(Neighborhood_FID) |> 
  st_drop_geometry() |> 
  summarise(
    across(-c(Grid_Code, City_Code, Land_Value, Area_Types, Area_Count, City_Name, ...1), 
           sum))

# Compute shares for groups
census_pop <- nbs_popsums |> 
  mutate(across(-c(Neighborhood_FID, population_total_units), \(x) (x/population_total_units)))

# Write to drive
write_csv(census_pop, "drive/aggregates/census_pop.csv")
