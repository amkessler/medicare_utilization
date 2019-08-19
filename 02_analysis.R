# Source: https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Inpatient2016.html

library(tidyverse)
library(janitor)
library(lubridate)


#load combined inpatient file from step 01
inp_data <- readRDS("processed_data/inp_data_2014to2016.rds")