library(sf)
library(tidyverse)
library(fastDummies)
setwd("~/GitHub/dlrproject")

buildings <- st_read("drive/data/buildings/Buildings_Frankfurt_am_Main.gpkg") |> 
  st_drop_geometry()

buildings_dummies <- buildings |>
  fastDummies::dummy_cols(select_columns = "Building_Type") |> 
  fastDummies::dummy_cols(select_columns = "Building_TypeGen") |> 
  select(-Building_Type, -Building_TypeGen)

buildings_summary <- buildings_dummies |> 
  group_by(Neighborhood_FID) |> 
  summarise(across(-c(Build_ID, Building_Height, Building_Age, Neighborhood_Name, City_Name),
                   \(x) sum(x, na.rm = TRUE)))

counts <- buildings |> group_by(Neighborhood_FID) |> summarise(buildings_count = n())

buildings_agg <- counts |> left_join(buildings_summary, by="Neighborhood_FID")

write_csv(buildings_agg, "drive/aggregates/buildings.csv")
