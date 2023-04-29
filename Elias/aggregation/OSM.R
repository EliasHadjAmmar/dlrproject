library(sf)
library(tidyverse)
library(fastDummies)
library(mapview)
setwd("~/GitHub/dlrproject")

osm <- st_read("drive/data/osm/OSM_Frankfurt_am_Main.gpkg")
mapview(osm)


