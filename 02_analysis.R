# Source: https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Inpatient2016.html

# At these hospitals, bills for these procedures or ones like them: 
#   •	mri of the spine
# •	gal bladder surgery
# •	heart stent placement procedure
# •	x-ray of broken arm 
# Hospitals: 
#   •	Carlsbad Medical Center in Carlsbad, New Mexico
# •	Artesia General Hospital in Artesia, New Mexico
# •	Queens Medical Center in Honolulu, Hawaii
# •	Johns Hopkins Medical Center in Baltimore, Maryland
# •	Yale Medical Center in New Haven, Connecticut
# •	Mass General in Boston, Mass.
# •	The Mount Sinai Hospital in Manhattan (not Mount Sinai/Beth Israel)
# •	The national average 


library(tidyverse)
library(janitor)
library(lubridate)


#load combined inpatient file from step 01
inp_data <- readRDS("processed_data/inp_data_2014to2016.rds")

#load combined outpatient file from step 01
outp_data <- readRDS("processed_data/outp_data_processed.rds")


inp_data %>% 
  count(drg_definition) 

outp_data %>% 
  count(apc_description) 


#NM hospitals
inp_data %>% 
  filter(provider_state == "NM") %>% 
  count(provider_name) %>% 
  View()


#NM target hospitals
nm_targets_inp <- inp_data %>% 
  filter(provider_state == "NM",
         provider_name %in% c("CARLSBAD MEDICAL CENTER", "ARTESIA GENERAL HOSPITAL"))

nm_targets_inp %>% 
  count(drg_definition) %>% 
  View()


nm_targets_outp <- outp_data %>% 
  mutate(
    provider_name = str_to_upper(provider_name)
  ) %>% 
  filter(provider_name %in% c("CARLSBAD MEDICAL CENTER", "ARTESIA GENERAL HOSPITAL"))

nm_targets_outp %>% 
  count(apc_description)

