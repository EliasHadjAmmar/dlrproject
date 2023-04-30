library(sf)
library(tidyverse)
setwd("~/GitHub/dlrproject")

grid <- st_read("drive/data/zensus/Zensus_Frankfurt_am_Main_Grid_100m.gpkg")
nbs <- st_read("drive/data/landprices/Land_Prices_Neighborhood_Frankfurt_am_Main.gpkg")

# Spatially join grid cells to neighbourhoods
keys <- grid |> st_join(nbs, join=st_intersects)

# Read the census data on buildings
census_families <- read_delim("drive/data/zensus/Zensus_Frankfurt_am_Main_Families.csv", delim=";")

# Join the census data from the csv to the already-joined grid cells
matched_grid_data <- keys |> left_join(census_families, by="Grid_Code")

# Group by neighbourhood and sum building type counts
nbs_famcounts <- matched_grid_data |> 
  group_by(Neighborhood_FID) |> 
  st_drop_geometry() |> 
  summarise(
    across(-c(Grid_Code, City_Code, Land_Value, Area_Types, Area_Count, City_Name, ...1), 
           sum))

# Compute shares for groups
census_families_agg <- nbs_famcounts |> 
  mutate(across(-c(Neighborhood_FID, families_total_units), \(x) (x/families_total_units)))

# Write to drive
write_csv(census_families_agg, "drive/aggregates/census_families.csv")
