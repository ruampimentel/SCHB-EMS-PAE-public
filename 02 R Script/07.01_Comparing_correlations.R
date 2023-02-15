library(cocor)
library(dplyr)
library(correlation)

##%######################################################%##
#                                                          #
####                      Study 1                       ####
#                                                          #
##%######################################################%##

# cocor doesn't work well with tibble. Convert to tibbles to Data.Frame before running!

# Compare two correlations based on two dependent groups
# The correlations are overlapping

cocor::cocor(~contrast2 + SCHB_pct_sqrt | contrast3 + SCHB_pct_sqrt, 
             as.data.frame(df_complete)) 

cocor::cocor(~contrast2 + SCHB1_pct_sqrt | contrast3 + SCHB1_pct_sqrt, 
             as.data.frame(df_complete))

cocor::cocor(~contrast2 + SCHB2_pct_sqrt | contrast3 + SCHB2_pct_sqrt, 
             as.data.frame(df_complete))

cocor::cocor(~contrast2 + EMS_pct_sqrt | contrast3 + EMS_pct_sqrt, 
             as.data.frame(df_complete))
 
cocor::cocor(~contrast2 + PAE_pct_sqrt | contrast3 + PAE_pct_sqrt, 
             as.data.frame(df_complete)) 

cocor::cocor(~contrast2 + MOR_pct_sqrt | contrast3 + MOR_pct_sqrt, 
             as.data.frame(df_complete))


# Exploring diff between SCHB corrs vs MOR
cocor::cocor(~SCHB_pct_sqrt + Dep_PC1 | MOR_pct_sqrt + Dep_PC1, 
             as.data.frame(df_complete)) # no diff

cocor::cocor(~SCHB1_pct_sqrt + Dep_PC1 | MOR_pct_sqrt + Dep_PC1, 
             as.data.frame(df_complete)) # no diff
cocor::cocor(~SCHB2_pct_sqrt + Dep_PC1 | MOR_pct_sqrt + Dep_PC1, 
             as.data.frame(df_complete)) # no diff

cocor::cocor(~SCHB_pct_sqrt + BPRS.05 | MOR_pct_sqrt + BPRS.05, 
             as.data.frame(df_complete)) # no diff

cocor::cocor(~SCHB_pct_sqrt + BPRS.09 | MOR_pct_sqrt + BPRS.09, 
             as.data.frame(df_complete)) # no diff

cocor::cocor(~SCHB_pct_sqrt + SCID.CMDS.A1r | MOR_pct_sqrt + SCID.CMDS.A1r, 
             as.data.frame(df_complete)) # no diff

cocor::cocor(~SCHB_pct_sqrt + SCID.CMDS.A9r | MOR_pct_sqrt + SCID.CMDS.A9r, 
             as.data.frame(df_complete)) # no diff




# Compare two correlations based on two independet groups

my_cocor.indep.groups(c(contrast1, SCHB_pct_sqrt),
                      c(contrast2, SCHB_pct_sqrt))

my_cocor.indep.groups(c(contrast1, SCHB1_pct_sqrt),
                      c(contrast2, SCHB1_pct_sqrt))

my_cocor.indep.groups(c(contrast1, SCHB2_pct_sqrt),
                      c(contrast2, SCHB2_pct_sqrt))

my_cocor.indep.groups(c(contrast1, EMS_pct_sqrt),
                      c(contrast2, EMS_pct_sqrt))

my_cocor.indep.groups(c(contrast1, PAE_pct_sqrt),
                      c(contrast2, PAE_pct_sqrt))

my_cocor.indep.groups(c(contrast1, MOR_pct_sqrt),
                      c(contrast2, MOR_pct_sqrt))


##%######################################################%##
#                                                          #
####                      Study 2                       ####
#                                                          #
##%######################################################%##
# cocor.indep.groups()
# cocor.dep.groups.overlap()
# cocor.dep.groups.nonoverlap()


# P vs. C 
df_complete %>% 
  select(SCHB1_pct_sqrt, SCHB2_pct_sqrt, Group3) %>%
  correlation()

cocor.dep.groups.overlap(.58, .65,
                         .44, 
                         n = 140)

# D vs. C
df_complete %>% 
  select(SCHB1_pct_sqrt, SCHB2_pct_sqrt, Group3) %>%
  filter(Group3 %in% c(0,2)) %>% 
  correlation()

cocor.dep.groups.overlap(.63, .93,
                         .54, 
                         n = 99)

# Psyc vs. C
df_complete %>% 
  select(SCHB1_pct_sqrt, SCHB2_pct_sqrt, Group3) %>% 
  filter(Group3 %in% c(0,1)) %>% 
  correlation()

cocor.dep.groups.overlap(.49, .38,
                         .28, 
                         n = 111)

# D vs. Psyc
df_complete %>% 
  select(SCHB1_pct_sqrt, SCHB2_pct_sqrt, Group3) %>% 
  filter(Group3 %in% c(1,1)) %>% 
  correlation()

cocor.dep.groups.overlap(.18, .63,
                         .27, 
                         n = 41)



comp_r <- tibble::tribble(
  # from excel "Tables for Manuscript RP12 GM3.xlsx" sheet 'Table 4d'
  ~Variables, ~P.vs..C, ~D.vs..C, ~Psychotic.vs..C, ~D.vs..Psychotic,
    "SCHB %",     0.69,     0.79,             0.55,              0.3,
   "SCHB1 %",     0.58,     0.63,             0.49,             0.18,
   "SCHB2 %",     0.65,     0.93,             0.38,             0.63,
     "EMS %",    -0.05,     0.05,            -0.11,             0.17,
     "PAE %",      0.1,     0.14,             0.06,             0.08,
     "MOR %",     0.06,     0.09,             0.03,             0.06,
       "F %",      0.3,     0.21,             0.34,            -0.12,
         "R",    -0.06,     0.01,            -0.11,             0.13
  ) %>% clean_names()


comp_r2 <- comp_r %>% 
  pivot_longer(p_vs_c:d_vs_psychotic) %>% 
  mutate(p = 70, c = 70, d = 29, psychotic = 41)

comp_r2 %>% filter(str_detect(variables, "SCHB %"))

library(tidyverse)

# Create a new dataset with all possible 2 by 2 combinations of "name" values
comp_expan <- comp_r2 %>% 
  select(name) %>%
  distinct() %>%
  expand(name1 = name, name2 = name) %>%
  filter(name1 != name2) %>% full_join(comp_r2, by = c( "name1" = "name")) %>% 
  # rename_with( ~paste0(., "_1"), .cols = c(-ends_with("2"), -ends_with("1"), -variables) ) %>%   
  filter(variables == "SCHB %") %>% 
  full_join(comp_r2, by = c( "name2" = "name"), suffix = c(".1", ".2"))


# SCHB comparisons across contrasts
study2_cocor.indep.groups <- function(comparison1 = "p_vs_c", 
                                      comparison2 = "d_vs_c",
                                      only_z_and_p = F) {
  row_to_work <- comp_expan %>% 
    filter(variables.1 == variables.2,
           name1 == comparison1,
           name2 == comparison2)
  
  r1 <- row_to_work$value.1
  r2 <- row_to_work$value.2
  
  name1_1 <- row_to_work$name1 %>% str_extract("^[a-z]*")
  name2_1 <- row_to_work$name1 %>% str_extract("[a-z]*$")
  name1_2 <- row_to_work$name2 %>% str_extract("^[a-z]*")
  name2_2 <- row_to_work$name2 %>% str_extract("[a-z]*$")
  
  n1_1 <- row_to_work %>% select(starts_with(name1_1)) %>% pull(1)
  n1_2 <- row_to_work %>% select(starts_with(name2_1)) %>% pull(1)
  n2_1 <- row_to_work %>% select(starts_with(name1_2)) %>% pull(1)
  n2_2 <- row_to_work %>% select(starts_with(name2_2)) %>% pull(1)
  
  result <- cocor.indep.groups(r1, r2,
                               n1 = (n1_1 + n1_2),
                               n2 = (n2_1 + n2_2)) 
  
  
  result_tbl <- cocor::get.cocor.results(result)
  result_tbl$fisher1925$statistic
  result_tbl$fisher1925$p
  if (only_z_and_p == T) {
    return(c(z = result_tbl$fisher1925$statistic,
             p = result_tbl$fisher1925$p))
  } else {
    print(result)  
  }
  
}



study2_cocor.indep.groups("p_vs_c", "d_vs_c")
study2_cocor.indep.groups("p_vs_c", "psychotic_vs_c")           
study2_cocor.indep.groups("p_vs_c", "d_vs_psychotic")           
study2_cocor.indep.groups("d_vs_c", "psychotic_vs_c")           
study2_cocor.indep.groups("d_vs_c", "d_vs_psychotic")           
study2_cocor.indep.groups("psychotic_vs_c", "d_vs_psychotic") 


cocor.indep.groups(.69, .79,
                   n1 = 99, n2 = 70)

# SCHB% in D_vs_C VS Psyc_vs_C
df_complete %>% count(Group3)

cocor.indep.groups(.79, .55,
                   n1 = 99, n2 = 70)

# SCHB% in P_vs_C VS D_vs_C
df_complete %>% count(Group3)

cocor.indep.groups(.69, .79,
                   n1 = 140, n2 = 99)

comp_report <- tibble::tribble(
  ~comp1,            ~comp2, ~`SCHB%`,
  "P vs. C",         "D vs. C",       NA,
  "P vs. C", "Psychotic vs. C",       NA,
  "P vs. C", "D vs. Psychotic",       NA,
  "D vs. C", "Psychotic vs. C",       NA,
  "D vs. C", "D vs. Psychotic",       NA,
  "Psychotic vs. C", "D vs. Psychotic",       NA
) %>% clean_names() %>% 
  mutate(across(comp1:comp2, snakecase::to_snake_case))

