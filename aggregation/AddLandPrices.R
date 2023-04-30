library(tidyverse)
library(sf)
setwd("~/GitHub/dlrproject")

cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")


path_list <- cities |> map(
  \(x) sprintf("drive/data/landprices/Land_Prices_Neighborhood_%s.gpkg", x)
  )

data_list <- path_list |> map(read_sf)

dataset <- bind_rows(data_list, .id="city_id")|>
  mutate(id = paste(city_id, Neighborhood_FID, sep="_")) |> 
  select(id, Land_Value) |> 
  st_drop_geometry()

features <- read_csv("drive/aggregates/alldata.csv")
joined <- dataset |> left_join(features, by="id")

write_csv(joined, "drive/aggregates/alldata_with_prices.csv")
