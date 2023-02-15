library(huxtable)
library(dplyr)


# Table 1 - Descriptives
# df created at `02.03_var_desc_report.R`

desc_t1 <- desc_group_report %>% 
  separate(variables, c("a", "b", "c"), remove = F)


icc_t1 <- icc_report %>% 
  select(var, ICC, n.obs, n.judge) %>% 
  separate(var, c("a", "b", "c"), remove = F) %>% 
  mutate(b = ifelse(a %in% c("SCHB", "EMS", "PAE"), "pct", b),
         c = ifelse(a %in% c("SCHB", "EMS", "PAE"), "sqrt", c))
desc_t1

t1_report <- desc_t1 %>% full_join(icc_t1) %>% 
  filter(!variables %in% c("SCHB1_pct_sqrt", "SCHB2_pct_sqrt", "EMS_PAE_pct", "control"),
         !is.na(mean)) %>% 
  mutate(var = case_when(is.na(var) ~ a,
                         TRUE ~ var)) %>% 
  select(control, var, n:skew_sqrt, ICC:n.judge) %>% 
  mutate(var = case_when(var == "MOR" ~ "MOR %",
                         var == "SCHB" ~ "SCHB %",
                         var == "EMS" ~ "EMS %",
                         var == "PAE" ~ "PAE %",
                         TRUE ~ var))

t1_report %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx")

t1_report %>% names() %>% paste0(collapse = " ")

column_names_t1 <- data.frame(
  var = c("", "Variables"),
  n = c("", "n"),
  mean = c("", "M"),
  sd = c("", "SD"),
  min = c("", "Min"),
  max = c("", "Max"),
  kurtosis = c("", "Kurtosis"),
  skew = c("", "Skew"),
  skew_sqrt = c("", "Skew 2"),
  ICC = c("Interrater reliability", "ICC"),
  n.obs = c("", "n of obs"),
  n.judge = c("", "n of judges")
)


t1_report %>% 
  rbind(column_names_t1, .) %>% 
  as_hux(add_colnames = FALSE) 
merge_cells(row = 1, col = 5:6 ) %>% 
  merge_cells(row = 1, col = 9:10 ) %>%
  set_bottom_border( row = 2, col = 1:10, value = 1) %>% 
  set_top_border(row = 1, col = 1:10, 1) %>% 
  set_bottom_border(row = 1, col = 5:6, 1) %>% 
  set_bottom_border(row = 1, col = 9:10, 1) %>% 
  set_bottom_border(row = (nrow(study_2)+2), col = 1:10, 1) %>% 
  set_italic(row = 2, col = 4:10) %>% 
  set_italic(row = 1, col = 1:10) %>% 
  set_number_format(row = 3:(nrow(study_2)+2), col = 4:10, value = 2) %>% 
  set_bold(row = 1:2, col = 1:10) %>% 
  set_col_width(col =4:10, .05) %>% 
  set_col_width(col = 7, value = .01) %>% 
  add_footnote("Note. Rorschach protocols had n of") %>% 
  quick_xlsx()

################################################################################# #
# Table 2 - Correlation ##################################################
################################################################################# #
# df from `05_correlations.R` file
library(tidyr)  
# r values  
r_report <- corr_all %>% as_tibble() %>% select(Parameter1:r) %>% 
  pivot_wider(names_from = "Parameter2", values_from = "r")

# p values 
p_report <- corr_all %>% as_tibble() %>% select(Parameter1, Parameter2, p) %>% 
  pivot_wider(names_from = "Parameter2", values_from = "p")

# p values - after bonferroni correction
corr_all %>% as_tibble() %>% select(Parameter1, Parameter2, p.adj) %>% 
  pivot_wider(names_from = "Parameter2", values_from = "p.adj")



r_report %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx", sheetName = "Table 2 r", append = T)
p_report %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx", sheetName = "Table 2 p", append = T)

################################################################################# #
# Table 3 - Multiple comparisons ##################################################
################################################################################# #
# df created at `07_multiple_comparisons_effect_sizes.R`

study_2 %>% xlsx::write.xlsx("04 Output/Tables for Manuscript.xlsx", sheetName = "Table 3", append = T)

column_names <- data.frame(
  study = c("", "Study"),
  comparison = c("", "Comparison"),
  name = c("", "Variable"),
  hedges_g = c("", "g"),
  g_low = c("95 CI", "low"),
  g_high = c("", "high"),
  blank = c("",""),
  glass_delta = c("", "Glass Delta"),
  delta_low = c("95 CI", "low"),
  delta_high = c("", "high")
)

study_2 %>% names %>% paste0(collapse = " ")

study_2 %>% 
  rbind(column_names, .) %>% 
  as_hux(add_colnames = FALSE) %>% 
  merge_cells(row = 1, col = 5:6 ) %>% 
  merge_cells(row = 1, col = 9:10 ) %>%
  set_bottom_border( row = 2, col = 1:10, value = 1) %>% 
  set_top_border(row = 1, col = 1:10, 1) %>% 
  set_bottom_border(row = 1, col = 5:6, 1) %>% 
  set_bottom_border(row = 1, col = 9:10, 1) %>% 
  set_bottom_border(row = (nrow(study_2)+2), col = 1:10, 1) %>% 
  set_italic(row = 2, col = 4:10) %>% 
  set_italic(row = 1, col = 1:10) %>% 
  set_number_format(row = 3:(nrow(study_2)+2), col = 4:10, value = 2) %>% 
  set_bold(row = 1:2, col = 1:10) %>% 
  set_col_width(col =4:10, .05) %>% 
  set_col_width(col = 7, value = .01) %>% 
  add_footnote("Note. g = Hedge's g. CI = Confident interval. In all comparisons, the second group was used as the control group for Glass' Delta. All comparisons were made with the square-root transformed value of the designated variable. Control n = 70, Patient n = 70 (Dep n = 29, Psychotic n = 41).") %>% 
  quick_xlsx()
