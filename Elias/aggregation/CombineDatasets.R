library(tidyverse)
setwd("~/GitHub/dlrproject")

# I have an issue: if I join all the datasets for all cities together, and keep
# only columns without missing values, then only 7 features remain.
# I want to find out why that happens, and what I can do to fix it.

data_names_all <- c("GeoBuildings", "Buildings", "Families", "Households", "Population")
data_paths_all <- data_names_all |> purrr::map_chr(
  \(x)(sprintf("drive/aggregates/%s.csv", x))
)
data_list_all <- data_paths_all |> map(read_csv)

data_list_all |> map(
  \(x)(x |> select_if(~ !any(is.na(.))) |> ncol())
  
) # this tells me that GeoBuildings is the problem!
# GeoBuildings only has 7 columns that do not contain an NA.
# The census datasets are fine! They all have the same columns.
# I say screw GeoBuildings, just use the census data.

data_names <- c("Buildings", "Families", "Households", "Population")
data_paths <- data_names |> purrr::map_chr(
  \(x)(sprintf("drive/aggregates/%s.csv", x))
)
data_list <- data_paths |> map(read_csv)

joined <- data_list |> reduce(left_join)

# joined |> select_if(~ !any(is.na(.))) |> ncol() # 163

joined_with_keys <- joined |> 
  mutate(id = paste(city_id, Neighborhood_FID, sep="_"))

write_csv(joined_with_keys, "drive/aggregates/alldata.csv")


