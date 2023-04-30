library(sf)
library(tidyverse)
library(mapview)
setwd("~/GitHub/dlrproject")

Main <- function(){
  predictions <- read_csv("drive/output/predicted_values.csv")
  cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")
  
  map <- AggregateLandPrices()
  st_geometry(predictions) <- map$geom
  

  prediction_map <- predictions |> 
    select(city_id, Neighborhood_FID, Land_Value, 
           Land_Value_predicted, buildings_total_units, n_vacant)
  
  #mapview(prediction_map)
  #st_write(prediction_map, "drive/output/prediction_map.gpkg") # to output one with 5 cities
  
  # to get 5 separate maps (messy but it works):
  1:5 |> map(
    \(x)(write_sf(
      prediction_map |> filter(city_id == x), 
      sprintf("drive/output/%s_map.gpkg", cities[x])
      )
  ))
}

AggregateLandPrices <- function(){
  # List the data to be imported
  cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")
  
  # Turn to paths
  data_paths <- cities |> purrr::map_chr(
    \(x)(sprintf("drive/data/landprices/Land_Prices_Neighborhood_%s.gpkg", x))
  )
  
  # Import the data for all cities
  data_list <- data_paths |> purrr::map(read_sf)
  
  # Concatenate data for all cities
  concatenated <- data_list |> bind_rows(.id="city_id")
  
  return(concatenated)
}


Main()
