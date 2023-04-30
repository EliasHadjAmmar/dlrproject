library(tidyverse)
setwd("~/GitHub/dlrproject")

Main <- function(city){
  cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")
  
  for (i in cities){
    AggregateOneCity(i)
  }
  return(0)
}

AggregateOneCity <- function(city){
  
  # List the data to be imported
  data_names <- c("GeoBuildings", "Buildings", "Families", "Households", "Population")
  
  # Turn to paths
  data_paths <- data_names |> purrr::map_chr(
    \(x)(sprintf("drive/aggregates/%s/%s_agg.csv", city, x))
      )
  
  # Import the data
  data_list <- data_paths |> purrr::map(read_csv)
  
  # Recursively join
  joined <- data_list |> purrr::reduce(
    \(df1, df2) (left_join(df1, df2, by="Neighborhood_FID"))
    )
  
  writepath <- sprintf("drive/aggregates/%s/%s_agg.csv", city, city)
  write_csv(joined, writepath)
  return(0)
}

Main()
