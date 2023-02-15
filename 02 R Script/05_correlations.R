
load("01 Processed data/df_complete.Rdata")

library(correlation)
library(apaTables)
library(dplyr)
library(ggplot2)
library(tidyr)
library(rstatix)
library(psych)


df_complete %>% count(control)
df_complete %>% count(Group3)
df_complete %>% count(Group2, Group3)


c_df <- df_complete %>% 
  select(control, Group3, 
         SCHB_pct_sqrt, SCHB1_pct_sqrt, SCHB2_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt, 
         Dep_PC1) %>% 
  correlation::correlation(partial = T) 
  

s <- summary(c_df, redundant = T)
plot(c_df)


df_complete %>% 
  select(control, Group2, 
         SCHB_pct_sqrt, SCHB1_pct_sqrt, SCHB2_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt, 
         Dep_PC1) %>% 
  filter(Group2 != 0) %>% 
  correlation::correlation(p_adjust = "none") %>% 
  arrange(-abs(r)) %>% 
  filter(Parameter1 == "Group2")

# Study 1 (s1) -------------------

s1_df <-df_complete %>%  haven::zap_label() %>%
  filter(control != 1) %>% # Don't use control data. Only Kline's dataset 
  select( Group3, patient, SCHB_pct_sqrt, SCHB2_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt, Dep_PC1)  

s1_df %>% 
  select(SCHB_pct_sqrt, SCHB2_pct_sqrt, MOR_pct_sqrt, Dep_PC1) %>% 
  correlation(p_adjust = "none")
s1_df %>% correlation() %>% arrange(-abs(r))
s1_df %>%
  # select(SCHB_pct_sqrt, SCHB2_pct_sqrt, MOR_pct_sqrt, Dep_PC1) %>% 
  select( SCHB_pct_sqrt, SCHB2_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt)  %>% 
  lowerCor()
s1_df %>% apaTables::apa.cor.table() # report this one


# Study 1 (s1) Post Hoc (ph) -------------------
s1_ph_df <- df_complete %>% 
  select(BPRS.05, # Guilt Feelings
         BPRS.09, # Depressive Mood
         SCID.CMDS.A1r, # Curr: Depressed mood
         SCID.CMDS.A7r, # Curr: Worthlessness or guilt
         SCHB_pct_sqrt, SCHB2_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt, Dep_PC1
         ) 


ef
s1_ph_df %>% correlation() %>% arrange(-abs(r))
s1_ph_df %>% correlation(partial = TRUE) %>% arrange(-abs(r))
s1_ph_df %>% corr.test() %>% .$r %>% round(2) %>% lowerCor()
s1_ph_df %>% apaTables::apa.cor.table() # report this one


df_complete %>% 
  filter(control == 0) %>% 
  # select(SCHB_pct_sqrt, SCHB2_pct_sqrt, MOR_pct_sqrt, Dep_PC1) %>% 
  select( SCHB_pct_sqrt, 
          EMS_pct_sqrt, PAE_pct_sqrt, 
          MOR_pct_sqrt)  %>% 
  correlation(p_adjust = "none")
  lowerCor()

library(PerformanceAnalytics)

zero_as_NA <- df_complete %>% 
  # select(SCHB_pct_sqrt, SCHB2_pct_sqrt, MOR_pct_sqrt, Dep_PC1) %>% 
  select( SCHB_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt) %>% 
  mutate(across(is.numeric, ~case_when(.x == 0 ~ NA_real_,
                                      TRUE ~ .x)) ) 
  

zero_as_NA_rorschach <- df_complete %>% 
  select(BPRS.05, # Guilt Feelings
         BPRS.09, # Depressive Mood
         SCID.CMDS.A1r, # Curr: Depressed mood
         SCID.CMDS.A7r, # Curr: Worthlessness or guilt
         SCHB_pct_sqrt, SCHB2_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt, Dep_PC1
  ) %>% 
  mutate(across(c(SCHB_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt), ~case_when(.x == 0 ~ NA_real_,
                                       TRUE ~ .x)) ) 
zero_as_NA_rorschach %>% 
  chart.Correlation(histogram=TRUE, pch=19)

zero_as_NA_rorschach %>% correlation() %>% 
  arrange(r) %>% 
  filter(r<.56)

# Ask Greg about these associations. !!!!! -----
zero_as_NA %>% 
  chart.Correlation(histogram=TRUE, pch=19)
  # RP: 
  # If someone gives EMS and PAE, they aer more likely to give another one (r = .46)
  # If someone give SCHB they are more likly to give PAE.
  # If someone gives EMS, more likely to give MOR (r = .38)
  # SCHB seems to be not be assocaited with MOR (r = .23 p<.05)
  # 
  # Another anlaysis: Group color by Patient vs non patient (patient or control variable)

zero_as_NA_rorschach %>% correlation(select =  c("BPRS.05", "BPRS.09", "SCID.CMDS.A1r", "SCID.CMDS.A7r", "Dep_PC1"),
                           select2 = c("SCHB_pct_sqrt", "EMS_pct_sqrt", "PAE_pct_sqrt", "MOR_pct_sqrt"))


# organizing table to manuscript ####################
################################################### #
corr_all <-  df_complete %>% correlation( select = c("Dep_PC1", "BPRS.05", "BPRS.09", "SCID.CMDS.A1r", "SCID.CMDS.A7r", "contrast1", "contrast2", "contrast3"),
                             select2 = c("SCHB_pct_sqrt", "SCHB1_pct_sqrt", "SCHB2_pct_sqrt", "EMS_pct_sqrt", 
                                         "PAE_pct_sqrt", "MOR_pct_sqrt"), 
                             p_adjust = "none",
                              ) %>%
  rstatix::adjust_pvalue()

df_complete %>% count( contrast1, Group2)
  
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


#################################################################################################
###################### Post Hoc - testing hypothesis ############################################
#################################################################################################

# Hypothesis (writing before running analysis 2022-09-20 1:46 pm)
# EMS and PAE will correlate positively with self-reports of mood state (e.g., PANAS). 
# Specifically, I would anticipate + correlation with The following PANAS items:
# PANAS03 - excited
# PANAS10 - pround
# PANAS09 - Enthusiatic
# PANAS14 - Inspired
# and other positive items...
# 
# and negatively with
# PANAS02 distressed
# PANAS 04 Upset
# PANAS11 Irritable
# PANAS13 Ashamed (correlated positively with SCHB - H)
# PANAS18 - Jittery
# amd other negative items...

df_complete %>% select(starts_with("PANAS"), SCHB_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, EMS_PAE_pct_sqrt, MOR_pct_sqrt) %>% 
  describe() %>% arrange(abs(skew)) #mostly normal distributed


df_complete %>%  correlation(select = c('PANAS01', 'PANAS02', 'PANAS03', 'PANAS04', 'PANAS05', 'PANAS06', 'PANAS07',
                                        'PANAS08', 'PANAS09', 'PANAS10', 'PANAS11', 'PANAS12', 'PANAS13', 'PANAS14',
                                        'PANAS15', 'PANAS16', 'PANAS17', 'PANAS18', 'PANAS19', 'PANAS20'),
                             select2 = c( "SCHB_pct_sqrt", "EMS_pct_sqrt", "PAE_pct_sqrt", "MOR_pct_sqrt"),
                             p_adjust = "none"
                             ) %>% 
  arrange(abs(r)) %>% 
  # filter(p<.05) %>%
  mutate(PANAS_item = case_when(Parameter1 == "PANAS05" ~ "Strong",
                                Parameter1 == "PANAS16" ~ "Determined",
                                Parameter1 == "PANAS01" ~ "Interested",
                                Parameter1 == "PANAS19" ~ "Active",
                                Parameter1 == "PANAS17" ~ "Attentive",
                                Parameter1 == "PANAS10" ~ "Proud")) %>% 
  select(Parameter1, PANAS_item, everything())

library(PerformanceAnalytics)

df_complete %>% 
  select(PANAS05, PANAS16, PANAS01, PANAS19, PANAS17, PANAS10, PAE_pct_sqrt) %>% 
  chart.Correlation(histogram=TRUE)

df_complete %>%
  count(Faces05)

df_complete %>% 
  select(SCHB1_pct_sqrt, SCHB2_pct_sqrt, control) %>% 
  correlation()


