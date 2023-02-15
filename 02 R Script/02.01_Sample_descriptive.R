library(report)
library(dplyr)
library(labelled)
library(psych)

load("01 Processed data/df_complete.Rdata")

# All Participants 
df_complete %>% 
  select(Age, Gender, EdLevel, control, Group3) %>% 
  unlabelled() %>% 
  # summarytools::dfSummary() %>% 
  summarytools::view() %>% 
  identity()

# Participants by Group3
df_complete %>% select(Age, Gender, EdLevel, control, Group3) %>% 
  unlabelled() %>% 
  group_by(Group3) %>% 
  summarytools::dfSummary() %>% 
  # summarytools::view() %>% 
  identity()

# Participants by control
df_complete %>% 
  select(Age, Gender, EdLevel, control, Group3, Group2) %>% 
  unlabelled() %>% 
  group_by(control) %>% 
  summarytools::dfSummary() %>% 
  summarytools::view() %>% 
  identity()

pwr::pwr.t2n.test(n1 = 70,
                  n2 = 70,
                  power = .80)

df_complete %>%
  select(R, F_pct ) %>% 
  arrange(R)
  
