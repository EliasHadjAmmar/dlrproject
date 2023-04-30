library(tidyverse)
setwd("~/GitHub/dlrproject")

# I decided to include all available features here, and to take care of missing values later
# when it comes to actually preprocessing the data for ML.

Main <- function(){
  
  data_names <- c("Buildings", "Families", "Households", "Population", 
                  "Segregation", "GeoBuildings")
  data_paths <- data_names |> purrr::map_chr(
    \(x)(sprintf("drive/aggregates/%s.csv", x))
  )
  data_list <- data_paths |> map(read_csv)
  
  joined <- data_list |> reduce(
    \(x, y) (left_join(x, y, by=c("city_id", "Neighborhood_FID")))
    ) # |> select_if(~ !any(is.na(.))) # gets rid of Segregation and GeoBuildings
  
  joined_with_keys <- joined |> # only keep this line to avoid breaking stuff
    mutate(id = paste(city_id, Neighborhood_FID, sep="_")) 
  
  write_csv(joined_with_keys, "drive/aggregates/alldata.csv")
}

Main()

