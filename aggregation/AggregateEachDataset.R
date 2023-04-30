library(tidyverse)
setwd("~/GitHub/dlrproject")

Main <- function(){
  data_names <- c("GeoBuildings", "Buildings", "Families", "Households", "Population", "Segregation")
  for (i in data_names){
    AggregateOneDataset(i)
  }
  return(0)
}

AggregateOneDataset <- function(dataset){
  # List the data to be imported
  cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")
  
  # Turn to paths
  data_paths <- cities |> purrr::map_chr(
    \(x)(sprintf("drive/aggregates/%s/%s_agg.csv", x, dataset))
  )
  
  # Import the data for all cities
  data_list <- data_paths |> purrr::map(read_csv)
  
  # Concatenate data for all cities
  concatenated <- data_list |> bind_rows(.id="city_id")

  # Write
  writepath <- sprintf("drive/aggregates/%s.csv", dataset)
  write_csv(concatenated, writepath)
  return(0)
}

Main()
