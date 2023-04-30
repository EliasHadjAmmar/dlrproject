library(tidyverse)
library(sf)
library(segregation)
setwd("~/GitHub/dlrproject")

city <- "Frankfurt_am_Main"

# Glue together path names
path_grid <- sprintf("drive/data/zensus/Zensus_%s_Grid_100m.gpkg", city)
path_neighborhoods <- sprintf("drive/data/landprices/Land_Prices_Neighborhood_%s.gpkg", city)
path_dataset <- sprintf("drive/data/zensus/Zensus_%s_Population.csv", city)
writepath <- sprintf("drive/aggregates/%s/Segregation.csv", city)

# Read spatial data
grid <- st_read(path_grid)
nbs <- st_read(path_neighborhoods)

# Spatially join grid cells to neighbourhoods
keys <- grid |> st_join(nbs, join=st_intersects)|> 
  select(Grid_Code, Neighborhood_FID) |> 
  distinct(Grid_Code, .keep_all=TRUE)

# Read the actual census dataset
census_pop <- read_delim(sprintf(path_dataset), delim=";")

# Extract dimensions of racial segregation from the dataset
cutoff <- 10

origincountries <- census_pop |> 
  filter(population_total_units >= cutoff) |> 
  mutate(sh_foreign = population_total_units - sh_germany) |> 
  select(Grid_Code, sh_foreign, sh_germany) |> 
  pivot_longer(!Grid_Code, names_to="country", ) |> 
  mutate(country=str_sub(country, start=4, end=-1)) |> 
  rename(n=value)

segregation::mutual_total(origincountries, "country", "Grid_Code", weight = "n")

# this is for the city overall, but we want it for the different neighborhoods.

origincountries_joined <- origincountries |> left_join(keys, by="Grid_Code")

segregation::mutual_within(origincountries_joined, "country", "Grid_Code", 
                           within="Neighborhood_FID", weight="n", wide=TRUE)


