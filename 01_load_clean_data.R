# Source: https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Inpatient2016.html

library(tidyverse)
library(janitor)
library(lubridate)
library(readxl)


# INPATIENT ------------------------------------------------

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
saveRDS(inp_data, "processed_data/inp_data_processed.rds")



# OUTPATIENT ------------------------------------------------



raw_out_1 <- read_excel("raw_data/outpatient/Medicare_OPPS_CY2016_Provider_APC.xlsx", skip = 4,
                                                             col_types = c("text", "text", "text", 
                                                                           "text", "text", "text", "text", "text", 
                                                                           "text", "text", "numeric", "numeric", 
                                                                           "numeric", "numeric", "numeric")) 


raw_out_2 <- read_excel("raw_data/outpatient/Medicare_OPPS_CY2015_Provider_APC.xlsx", skip = 4,
                        col_types = c("text", "text", "text", 
                                      "text", "text", "text", "text", "text", 
                                      "text", "text", "numeric", "numeric", 
                                      "numeric", "numeric", "numeric")) 


raw_out_1$year <- "FY2016"
raw_out_2$year <- "FY2015"

out_combined <- bind_rows(raw_out_1, raw_out_2)

outp_data <- out_combined %>% 
  clean_names() %>% 
  select(year, everything())

#save to RDS
saveRDS(outp_data, "processed_data/outp_data_processed.rds")

