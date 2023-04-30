setwd("~/GitHub/dlrproject")

library(tidyverse)
data <- read_csv("alldata_with_prices.csv")
data <- data |> 
  select_if(~ !any(is.na(.))) |> 
  mutate(City_Name = case_when(
    city_id == 1 ~ "Frankfurt_am_Main",
    city_id == 2 ~ "Berlin",
    city_id == 3 ~ "Bremen",
    city_id == 4 ~ "Dresden",
    city_id == 5 ~ "Köln"
  ))

data |> write_csv("finalmodeldata.csv")
