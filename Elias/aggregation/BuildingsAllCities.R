library(sf)
library(tidyverse)
library(fastDummies)
setwd("~/GitHub/dlrproject")

Main <- function(){
  cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")
  
  for (i in cities){
    AggregateBuildingsGeo(i)
  }
  
  return(0)
}

AggregateBuildingsGeo <- function(city){
  
  readpath <- sprintf("drive/data/buildings/Buildings_%s.gpkg", city)
  writepath <- sprintf("drive/aggregates/%s/GeoBuildings_agg.csv", city)
  
  buildings <- st_read(readpath) |> 
    st_drop_geometry()
  
  buildings_dummies <- buildings |>
    select(Build_ID, Neighborhood_FID, Building_Type, Building_TypeGen) |> 
    fastDummies::dummy_cols(select_columns = "Building_Type") |> 
    fastDummies::dummy_cols(select_columns = "Building_TypeGen") |> 
    select(-Building_Type, -Building_TypeGen)
  
  buildings_groupcounts <- buildings_dummies |> 
    group_by(Neighborhood_FID) |> 
    summarise(across(-Build_ID,
                     \(x) sum(x, na.rm = TRUE)))
  
  buildings_avgs <- buildings |> 
    select(Build_ID, Neighborhood_FID, Building_Age, Building_Height) |> 
    group_by(Neighborhood_FID) |> 
    summarise(
      buildings_count = n(),
      #mean_building_age = mean(Building_Age, na.rm=T), # don't have it for Berlin
      mean_building_height = mean(Building_Height, na.rm=T),
      mean_sq_building_height = sqrt(mean(Building_Height^2, na.rm=T))
    )
  
  buildings_agg <- buildings_avgs |> left_join(buildings_groupcounts, by="Neighborhood_FID")
  
  write_csv(buildings_agg, writepath)
  return(0)
}

Main()
