library(tidyverse)
setwd("~/GitHub/dlrproject")

geo_buildings <- read_csv("drive/aggregates/buildings.csv")
buildings <- read_csv("drive/aggregates/census_buildings.csv")
families <- read_csv("drive/aggregates/census_families.csv")
households <- read_csv("drive/aggregates/census_households.csv")
population <- read_csv("drive/aggregates/census_pop.csv")

landprices <- read_delim("drive/data/landprices/Land_Prices_Neighborhood_Frankfurt_am_Main.csv", delim=";") |> 
  select(Neighborhood_FID, Land_Value)

joined <- list(geo_buildings, buildings, families, households, population, landprices) |> 
  reduce(\(df1, df2) (left_join(df1, df2, by="Neighborhood_FID")))

write_csv(joined, "drive/aggregates/all.csv") 
