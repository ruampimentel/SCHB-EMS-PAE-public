library(huxtable)
library(dplyr)
library(stringr)

# Table 1 - Descriptives
# df created at `02.03_var_desc_report.R`


desc_t1 <- describe_raw_skew_sqrt_by_groups2(group_var = "control") %>% 
  mutate(control = case_when(control == 0 ~ "Patient",
                             control == 1 ~ "Control")) %>% 
  separate(variables, c("a", "b", "c"), remove = F)


icc_t1 <- icc_report %>% 
  select(var, ICC, n.obs, n.judge) %>% 
  separate(var, c("a", "b", "c"), remove = F) %>% 
  mutate(b = ifelse(a %in% c("SCHB", "EMS", "PAE"), "pct", b),
         c = ifelse(a %in% c("SCHB", "EMS", "PAE"), "sqrt", c),
         a = ifelse(c %in% c("A1r", "A7r"), "SCIDCMDS", a),
         b = ifelse(c %in% c("A1r", "A7r"), c, b),
         c = ifelse(c %in% c("A1r", "A7r"), NA, c),
         b = ifelse(b == "raters", "PC1", b))

desc_t1 %>% print(n = 15)
icc_t1 %>% distinct(var)

t1_report <- desc_t1 %>% full_join(icc_t1) %>% 
  filter(!variables %in% c("SCHB1_pct_sqrt", "SCHB2_pct_sqrt", "EMS_PAE_pct", "control"),
         !is.na(mean)) %>% 
  mutate(var = case_when(str_detect(b, "A1r|A7r") ~ paste(a, b, sep = "."),
                         is.na(var) ~ a,
                         TRUE ~ var)) %>% 
  select(control, var, n:skew_sqrt, ICC:n.judge) %>% 
  mutate(var = case_when(var == "MOR" ~ "MOR %",
                         var == "SCHB" ~ "SCHB %",
                         var == "EMS" ~ "EMS %",
                         var == "PAE" ~ "PAE %",
                         TRUE ~ var))

t1_report %>% xlsx::write.xlsx("04 Output/Tables for Manuscript 2.xlsx")

stat_sqrt_all_groups %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx", 
                                          sheetName = "Descriptive sqrt Groups"  ,
                                          append = T)
browseURL("04 Output")

################################################################################# #
# Table 2 - Correlation ##################################################
################################################################################# #

# df from `05_correlations.R` file
library(tidyr)  

r_report %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx", sheetName = "Table 2_r", append = T)
p_report %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx", sheetName = "Table 2_p", append = T)

browseURL("04 Output")
################################################################################# #
# Table 3 - Multiple comparisons ##################################################
################################################################################# #
# df created at `07_multiple_comparisons_effect_sizes.R`

# study_2 %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx", sheetName = "Table 3", append = T)

# Currenlty using this (Aug, 29)
es %>% full_join(ci) %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx", 
                                          sheetName = "es and ci" ,
                                          append = T)


################################################################################# #
# Table 4 - Descriptive sqrt Group short##########################################
################################################################################# #
stat_sqrt_all_groups_short # from 02.03_var_desc_report.R file

stat_sqrt_all_groups_short %>% xlsx::write.xlsx("04 Output/Tables for Manuscript 2.xlsx", 
                                                sheetName = "Desc sqrt Groups short2"  ,
                                                append = T)
