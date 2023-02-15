
load("01 Processed data/df_complete.Rdata")

library(dplyr)
library(psych)
library(haven)
library(magrittr)
library(purrr)
library(tidyr)


## Focal variables----
## Include BPRS and SCID items here, as well as the depressive composite made out of them.
df_complete %>%  select(control, Group3, 
                        F_pct:EMS_PAE_pct,
                        MOR_pct_sqrt:EMS_PAE_pct_sqrt) %>% 
  describe()

## By Groups
df_complete %>%  select(control, Group3, F_pct:EMS_PAE_pct, MOR_pct_sqrt:EMS_PAE_pct_sqrt) %>% 
  describeBy(group = "Group3")

df_complete %>%  
  select(control, R_n) %>% 
  describeBy(group = "control") 

df_complete %>%  
  select(RID, ID, control, R) %>% 
  group_by(control) %>% 
  count(R)

## Appendix or supplemental materials if requested by reivewers (Aug, 31, 2022) -------

df_complete %>% count(Group2) # Constrast 1 
df_complete %>% count(control) # Constrast 2
df_complete %>% count(Group3) # Constrast 3

### Raw Scores -----
describe_raw_skew_sqrt_by_groups(group_var = "Group2") %>% 
  mutate(Group2 = case_when(Group2 == 0 ~ "Control",
                            Group2 == 1 ~ "Dep",
                            Group2 == 2 ~ "Bip",
                            Group2 == 3 ~ "SA and Scz")) 

describe_raw_skew_sqrt_by_groups(group_var = "control") %>% 
  mutate(control = case_when(control == 0 ~ "Patient",
                             control == 1 ~ "Control"))

describe_raw_skew_sqrt_by_groups(group_var = "Group3") %>% 
  mutate(Group3 = case_when(Group3 == 0 ~ "Control",
                            Group3 == 1 ~ "Psychotic",
                            Group3 == 2 ~ "Dep"))
df_complete %>% 
  select(control, MOR_pct, F_pct) %>% 
  describeBy("control")


### SqRt Scores -----
g4 <- describe_sqrt_by_groups(group_var = "Group2") %>% 
  mutate(Group2 = case_when(Group2 == 0 ~ "Control",
                            Group2 == 1 ~ "Dep",
                            Group2 == 2 ~ "Bip",
                            Group2 == 3 ~ "SA and Scz")) %>% 
  rename(group = Group2)

g2 <- describe_sqrt_by_groups(group_var = "control") %>% 
  mutate(control = case_when(control == 0 ~ "Patient",
                             control == 1 ~ "Control")) %>% 
  rename(group = control)

g3 <- describe_sqrt_by_groups(group_var = "Group3") %>% 
  mutate(Group3 = case_when(Group3 == 0 ~ "Control",
                            Group3 == 1 ~ "Psychotic",
                            Group3 == 2 ~ "Dep")) %>% 
  rename(group = Group3)

stat_sqrt_all_groups <- g2 %>% full_join(g3) %>% 
  full_join(g4) 

library(forcats)

stat_sqrt_all_groups_short <- stat_sqrt_all_groups %>% 
  select(group, var, n_sqrt, mean_sqrt, sd_sqrt) %>% 
  pivot_longer(n_sqrt:sd_sqrt, names_to = "stats", values_to = "value" ) %>% 
  pivot_wider(names_from = "group",
              values_from = "value") %>% 
  na.omit() %>% 
  arrange(stats) %>% 
  mutate(var = if_else(as.character(stats) == "n_sqrt", NA_character_, as.character(var)),
         var = fct_relevel(var,
                           "SCHB_pct_sqrt", "SCHB1_pct_sqrt", "SCHB2_pct_sqrt", "EMS_pct_sqrt",
                           "PAE_pct_sqrt", "EMS_PAE_pct_sqrt", "MOR_pct_sqrt", "F_pct_sqrt",
                           "F_pct",
                           "R"),
         stats = fct_relevel(stats, 
                             "n_sqrt", "mean_sqrt", "sd_sqrt"),
         # across(where(is.numeric),~round(.x, 2))
         ) %>% 
  unique() %>% 
  arrange(stats, var) %>% 
  select(var, stats, Control, Patient, Dep, Psychotic, `SA and Scz`, Bip)

stat_sqrt_all_groups_short %>% print(n = 28)

##### Selected variables - better skew #####
df_complete %>%
  select(control, Group3, MOR_pct_sqrt:EMS_PAE_pct_sqrt) %>% 
  describeBy(group = "Group3") 

raw_desc <- df_complete %>%
  select(MOR_pct:EMS_PAE_pct, 
         SCID.CMDS.composite = SCID1.CMDS.composite, 
         BPRS.05, BPRS.09) %>% 
  describe() %>% as_tibble(rownames = "variables") %>% 
  separate(variables, c("a", "b")) %>% 
  select(a, b, n, mean, sd, min, max, skew, kurtosis)
  
sqrt_desc <- df_complete %>% 
  select(MOR_pct_sqrt:EMS_PAE_pct_sqrt) %>% 
  describe() %>% as_tibble(rownames = "variables") %>% 
  rename_with(~paste0(.x, "_sqrt"),
              .cols =  n:se) %>% 
  select(variables, n_sqrt, mean_sqrt, sd_sqrt, skew_sqrt) %>% 
  separate(variables, c("a", "b", "c"))


raw_desc %>% full_join(sqrt_desc)  %>% 
  unite("variables", a, b, c, sep = "_", na.rm = T) %>% 
  select(variables:max, kurtosis, skew, skew_sqrt) %>% 
  mutate(variables = case_when(variables == "SCID_CMDS" ~ "SCID.CMDS.composite",
                               variables == "BPRS_05" ~ "BPRS.05",
                               variables == "BPRS_09" ~ "BPRS.09",
                               TRUE ~ variables))
