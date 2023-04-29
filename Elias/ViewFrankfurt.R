library(sf)
library(tidyverse)
library(mapview)
setwd("~/GitHub/dlrproject")


ffm_buildings <- st_read("drive/data/buildings/Buildings_Frankfurt_am_Main.gpkg")
ffm_landprices <- st_read("drive/data/landprices/Land_Prices_Neighborhood_Frankfurt_am_Main.gpkg")
ffm_osm <- st_read("drive/data/osm/OSM_Frankfurt_am_Main.gpkg")
ffm_zensus <- st_read("drive/data/zensus/Zensus_Frankfurt_am_Main_Grid_100m.gpkg")
# ffm_neighborhoods <- st_read("drive/data/neighborhoods/Neighborhoods_Frankfurt_am_Main.gpkg")
# doesn't contain any new data

layers <- list(ffm_buildings, ffm_landprices, ffm_zensus)
joined <- layers |> reduce(st_join)

mapview(joined)
mapview(ffm_landprices, zcol="Land_Value")


test <- read_delim("drive/data/zensus/Zensus_Frankfurt_am_Main_Population.csv", delim=";")

hosps <- ffm_buildings |>
  filter(Building_Type == "hospital")
mapview(hosps)

