library(dplyr)
library(effectsize)
library(sjlabelled)
library(purrr)
library(psych)
library(tidyr)

load("01 Processed data/df_complete.Rdata")

s2_df <- df_complete %>% # use entire dataset 
  select(control, Group3, SCHB_pct_sqrt, SCHB1_pct_sqrt, SCHB2_pct_sqrt, 
         EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt, F_pct_sqrt, F_pct, R)  

s2 <- s2_df %>% remove_all_labels() %>% 
  mutate(across(control:Group3, ~as.factor(.x))) %>% 
  as_tibble()  

s2 %>% count(Group3)
df_complete %>% count(Group2)


################################################################################################### #
# Study 2a ##########################################################################################
################################################################################################### #


s2_df %>% 
  count(control) ### start by checking the groups just to be sure.

s2_df %>% describeBy(group = "control")

s2a <- es(data_wide = s2, group2 = "control", -control, -Group3 ) %>% 
  mutate(group1 = "Patient", group2 = "Control", study = 1)

library(ggplot2)
library(forcats)
## Reordering s2a$name

s2a %>% 
  mutate(name = fct_relevel(name,
    "MOR_pct_sqrt", "SCHB_pct_sqrt", "SCHB1_pct_sqrt", "SCHB2_pct_sqrt",
    "PAE_pct_sqrt", "EMS_pct_sqrt", "F_pct_sqrt", "F_pct", "R"
  )) %>% 
  ggplot(aes(x = name, y = glass_delta, ymin = delta_low, ymax = delta_high)) +
  geom_pointrange() +
  theme(panel.grid.major = element_line(colour = "gray80", linetype = "dashed"), 
    axis.title = element_text(size = 14, face = "italic"), 
    plot.title = element_text(size = 18, hjust = 0.5),
    panel.background = element_rect(fill = "white")) +
  labs(title = "Glass's delta by Rorschach variables comparing patients vs control",
       x = NULL, 
       y = "Glass's delta",
       subtitle = "Positive values indicate Patient > Control") +
  coord_flip()

# Study 2b ##########################################################################################
s2_df %>% count(Group3)

s2b_wide <- s2 %>%  
  filter(Group3 %in% c(0, 2)) %>% 
  mutate(Group3 = if_else(Group3 == 0, 2, 0),
         Group3 = factor(Group3)) 

s2b_wide %>% describeBy(group = "Group3")

s2b <- es(data_wide = s2b_wide, group2 = "Group3", -control, -Group3 ) %>% 
  mutate(group1 = "Dep", group2 = "Control", study = 2) 

s2b %>% 
  filter(str_detect(name, "F_pct")) %>% View



# Study 2c ##########################################################################################
s2_df %>% count(Group3)

s2c_wide <- s2 %>%  
  filter(Group3 %in% c(0, 1)) %>% 
  mutate(Group3 = if_else(Group3 == 0, 1, 0),
         Group3 = factor(Group3)) 

s2c_wide %>% describeBy(group = "Group3")

s2c <- es(data_wide = s2c_wide, group2 = "Group3", -control, -Group3 ) %>% 
  mutate(group1 = "Psychotic", group2 = "Control", study = 3)

# Study 2d ##########################################################################################
s2_df %>% count(Group3)

s2d_wide <- s2 %>%  
  filter(Group3 %in% c(1, 2)) %>% 
  mutate(Group3 = if_else(Group3 == 1, 2, 0),
         Group3 = factor(Group3)) 

s2d_wide %>% describeBy(group = "Group3")

s2d <- es(data_wide = s2d_wide, group2 = "Group3", -control, -Group3 ) %>% 
  mutate(group1 = "Dep", group2 = "Psychotic", study = 4)

############################################################################# #
# Report ######################################################################
############################################################################# #

study_2 <- s2a %>% full_join(s2b) %>% full_join(s2c) %>% full_join(s2d) %>% 
  rowwise() %>% 
  mutate( comparison = paste(group1, "vs.", group2),
          blank = "") %>% 
  select(study, comparison, name,
         hedges_g, g_low, g_high, 
         blank, 
         glass_delta, delta_low, delta_high, 
         -group1, -group2, -cohens_d, -d_low, -d_high)

study_2 %>% View

library(stringr)

eff_siz <- study_2 %>% 
  ungroup() %>% 
  select(comparison, name, hedges_g, glass_delta) %>% 
  separate(comparison, into = c("g1", "vs", "g2")) %>% 
  mutate(comparison = paste0(str_sub(g1, 1, 2), str_sub(g2, 1, 2))) %>% 
  select(-g1, -vs, -g2) %>% 
  pivot_wider(names_from = "comparison",
              values_from = c(hedges_g, glass_delta))

  

ci <- study_2 %>% 
  select(-blank, -study) %>% select(-hedges_g, -glass_delta) %>% 
  separate(comparison, into = c("g1", "vs", "g2")) %>% 
  mutate(comparison = paste0(str_sub(g1, 1, 2), str_sub(g2, 1, 2))) %>% 
  select(-g1, -vs, -g2)  %>% 
  pivot_wider(names_from = "comparison", 
              values_from = c(ends_with("_low"), ends_with("_high")),
              names_vary = "fastest") %>%
  mutate(across(is.numeric, ~round(.x, 2) )) %>% 
  mutate(
            CI_g_PaCo = paste0("[", g_low_PaCo, ", ", g_high_PaCo, "]"),
         CI_delta_PaCo = paste0("[", delta_low_PaCo, ", ", delta_high_PaCo, "]"),
         CI_g_DeCo = paste0("[", g_low_DeCo, ", ", g_high_DeCo, "]"),
         CI_delta_DeCo = paste0("[", delta_low_DeCo, ", ", delta_high_DeCo, "]"),
         CI_g_PsCo = paste0("[", g_low_PsCo, ", ", g_high_PsCo, "]"),
         CI_delta_PsCo = paste0("[", delta_low_PsCo, ", ", delta_high_PsCo, "]"),
         CI_g_DePs = paste0("[", g_low_DePs, ", ", g_high_DePs, "]"),
         CI_delta_DePs = paste0("[", delta_low_DePs, ", ", delta_high_DePs, "]")) %>% 
  select(name, starts_with("CI_g"), starts_with("CI_delta"))

ci
# eff_siz %>% full_join(ci) %>% xlsx::write.xlsx("04 Output/Tables for Manuscript 2.xlsx", 
#                                           sheetName = "es and ci" ,
#                                           append = T)

library(stringr)
study_2 %>% filter(!str_detect(comparison, "Control"))

s2_df %>% count(Group3)

DPs_delta <- s2_df %>% labelled::to_factor() %>% 
  describeBy(group = "Group3") %>% 
  map_dfr(., ~.x %>% as_tibble(rownames = "var"),
          .id = "group") %>% 
  mutate(group = gsub('\\b(\\pL)\\pL{2,}|.', '\\U\\1',group,perl = TRUE),
         group = case_when(group == "A" ~ "Ps",
                           TRUE ~ group)) %>% 
  select(group, group, var, n, mean, sd, se) %>%   
  filter(!str_detect(var, "\\*")) %>% 
  pivot_wider(names_from = "group", 
              values_from = n:se) %>% 
  mutate(delta_DPs = (mean_D - mean_Ps) / sd_C )
  

patients_descriptives <- s2_df %>% labelled::to_factor() %>% 
  describeBy(group = "control") %>% 
  map_dfr(., ~.x %>% as_tibble(rownames = "var"),
          .id = "group") %>% 
  filter(group != "Control") %>% 
  select(group, group, var, n, mean, sd, se) %>%   
  filter(!str_detect(var, "\\*")) %>% 
  pivot_wider(names_from = "group", 
              values_from = n:se)


general_descriptives <- DPs_delta %>% 
  left_join(patients_descriptives) %>% 
  select(var, starts_with("n_"),starts_with("mean_"), starts_with("sd_"), starts_with("se_"), everything())

xlsx::write.xlsx(general_descriptives, "04 Output/Tables for Manuscript 3.xlsx", sheetName = "sqrt_descriptives_delta")

# DPs_delta %>% xlsx::write.xlsx("04 Output/Tables for Manuscript 2.xlsx", 
#                                sheetName = "sqrt_descriptive_delta" ,
#                                append = T)
  select(var, delta_DPs) 

n1 <- DPs_delta$n_Ps[1]
n2 <- DPs_delta$n_D[1]
nC <- DPs_delta$n_C[1]
effectsize::glass_delta()
DPs_delta$mean_Ps[1]
DPs_delta$mean_D[1]
DPs_delta$mean_C[1]

DPs_delta$se_C

t_DPs <- (DPs_delta$mean_D[1] - DPs_delta$mean_Ps[1]) / DPs_delta$se_C[1]
  
# Table 4

s2_df %>% describeBy(group = "control") %>% 
  map_dfr(., ~ .x %>% as_tibble( rownames = "var"),
          .id = "group") %>% 
  mutate(group = case_when(group == 0 ~ "Patients",
                           group == 1 ~ "Control")) %>% 
  print(n = 22)

s2b_wide %>% describeBy(group = "Group3") %>% 
  map_dfr(., ~ .x %>% as_tibble( rownames = "var"),
          .id = "group") %>% 
  mutate(group = case_when(group == 0 ~ "Dep",
                           group == 2 ~ "Control")) %>% 
  print(n = 22)

s2c_wide %>% describeBy(group = "Group3") %>% 
  map_dfr(., ~ .x %>% as_tibble( rownames = "var"),
          .id = "group") %>% 
  mutate(group = case_when(group == 0 ~ "Psychotic",
                           group == 1 ~ "Control")) %>% 
  print(n = 22)

s2d_wide %>% describeBy(group = "Group3") %>% 
  map_dfr(., ~ .x %>% as_tibble( rownames = "var"),
          .id = "group") %>% 
  mutate(group = case_when(group == 0 ~ "Dep",
                           group == 2 ~ "Psychotic")) %>% 
  print(n = 22)



