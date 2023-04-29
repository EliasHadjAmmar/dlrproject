library(sf)
library(tidyverse)
library(mapview)
setwd("~/GitHub/dlrproject")

grid <- st_read("drive/data/zensus/Zensus_Frankfurt_am_Main_Grid_100m.gpkg")
nbs <- st_read("drive/data/landprices/Land_Prices_Neighborhood_Frankfurt_am_Main.gpkg")
census <- read_delim("drive/data/zensus/Zensus_Frankfurt_am_Main_Population.csv", delim=";")

keys <- grid |> st_join(nbs, join=st_intersects)
matched_grid_data <- keys |> left_join(census, by="Grid_Code")


nbs_popsums <- matched_grid_data |> 
  group_by(Neighborhood_FID) |> 
  st_drop_geometry() |> 
  summarise(
    across(-c(Grid_Code, City_Code, Land_Value, Area_Types, Area_Count, City_Name, ...1), 
           sum))

nbs_popshares <- nbs_popsums |> 
  mutate(across(-Neighborhood_FID, \(x) (x/population_total_units)))

census_pop <- nbs_popshares |> 
  mutate(population_total_units = nbs_popsums$population_total_units)

write_csv(census_pop, "drive/aggregates/census_pop.csv")
