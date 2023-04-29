library(tidyverse)
setwd("~/GitHub/dlrproject")

cities <- c("Frankfurt_am_Main", "Berlin", "Bremen", "Dresden", "Köln")

data_paths <- cities |> purrr::map_chr(
  \(x)(sprintf("drive/aggregates/%s/%s_agg.csv", x, x))
)

data_list <- data_paths |> purrr::map(read_csv)

dataset <- bind_rows(data_list, .id="city_id")|>
  mutate(id = paste(city_id, Neighborhood_FID)) |> 
  select_if(~ !any(is.na(.)))

