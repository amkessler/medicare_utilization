# Source: https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Inpatient2016.html

library(tidyverse)
library(janitor)
library(lubridate)

# find all file inpatient csv files
csv_files <- fs::dir_ls("raw_data/inpatient", regexp = "\\.csv$")
csv_files

#import them in and combine to one table
raw_combined <- csv_files %>%
  map_dfr(read_csv, col_types = cols(.default = "c"), .id = "source") 

#clean up names and formats
inp_data <- raw_combined %>% 
  clean_names() 

inp_data <- inp_data %>% 
  mutate(
    total_discharges = as.integer(total_discharges),
    average_covered_charges = parse_number(average_covered_charges),
    average_total_payments = parse_number(average_total_payments),
    average_medicare_payments = parse_number(average_medicare_payments)
  )
  

#pull out fiscal year from source column
inp_data$year <- str_sub(inp_data$source, -10, -5)

inp_data <- inp_data %>% 
  select(year, everything(), -source)


#save to RDS
saveRDS(inp_data, "processed_data/inp_data_2014to2016.rds")
