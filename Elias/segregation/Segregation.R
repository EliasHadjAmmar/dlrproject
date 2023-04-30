library(tidyverse)
library(sf)
library(segregation)
setwd("~/GitHub/dlrproject")

Main <- function(){
  cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")
  segreg_list <- cities |> map(SegregForOneCity)
}

SegregForOneCity <- function(city){
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
  CUTOFF <- 10
  
  origincountries <- census_pop |> 
    filter(population_total_units >= CUTOFF) |> 
    mutate(sh_foreign = population_total_units - sh_germany) |> 
    select(Grid_Code, sh_foreign, sh_germany) |> 
    pivot_longer(!Grid_Code, names_to="country", ) |> 
    mutate(country=str_sub(country, start=4, end=-1)) |> 
    rename(n=value)
  
  # Join census data to neighborhoods and compute within-neighborhood segregation
  origincountries_nbs <- origincountries |> left_join(keys, by="Grid_Code")
  
  segreg <- segregation::mutual_within(origincountries_nbs, "country", "Grid_Code", 
                             within="Neighborhood_FID", weight="n", wide=TRUE)
  
  # Write to drive
  write_csv(segreg, sprintf("drive/aggregates/%s/Segregation.csv", city))
}

Main()


