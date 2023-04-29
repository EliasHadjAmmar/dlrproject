library(sf)
library(tidyverse)
library(fastDummies)
setwd("~/GitHub/dlrproject")

Main <- function(){
  cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")
  datasets <- c("Buildings", "Families", "Households", "Population")
  
  for (i in cities){
    for (j in datasets)
      AggregateCensus(i, j)
  }
  
  return(0)
}

AggregateCensus <- function(city, dataset){
  
  # Glue together path names
  path_grid <- sprintf("drive/data/zensus/Zensus_%s_Grid_100m.gpkg", city)
  path_neighborhoods <- sprintf("drive/data/landprices/Land_Prices_Neighborhood_%s.gpkg", city)
  path_dataset <- sprintf("drive/data/zensus/Zensus_%s_%s.csv", city, dataset)
  writepath <- sprintf("drive/aggregates/%s/%s_agg.csv", city, dataset)
  
  # Read spatial data
  grid <- st_read(path_grid)
  nbs <- st_read(path_neighborhoods)
  
  # Spatially join grid cells to neighbourhoods
  keys <- grid |> st_join(nbs, join=st_intersects)
  
  # Read the actual census dataset
  census_buildings <- read_delim(path_dataset, delim=";")
  
  # Join the census data from the csv to the already-joined grid cells
  matched_grid_data <- keys |> left_join(census_buildings, by="Grid_Code")
  
  # Group by neighbourhood and sum building type counts
  group_counts <- matched_grid_data |> 
    group_by(Neighborhood_FID) |> 
    st_drop_geometry() |> 
    summarise(
      across(-c(Grid_Code, City_Code, Land_Value, Area_Types, Area_Count, City_Name, ...1), 
             sum))

  # Compute shares for groups
  total_string <- paste(tolower(dataset), "_total_units", sep = "")
  group_shares <- group_counts |> 
    mutate(across(-c(Neighborhood_FID, !!sym(total_string)), 
                  \(x) (x/!!sym(total_string))))
  
  write_csv(group_shares, writepath)
  return(0)
}

Main()
