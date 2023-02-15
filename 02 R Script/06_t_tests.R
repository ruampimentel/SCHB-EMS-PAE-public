
load("01 Processed data/df_complete.Rdata")

library(tidyr)
library(hrbrthemes)
library(ggplot2)
library(summarytools)
library(ggpubr)
library(sjlabelled)
library(dplyr)
library(psych)
library(rstatix)
library(labelled)
library(effectsize)
library(purrr)

# Note!!!
# SCHB, PAE, and EMS effect sizes might be slightly different from ISR 2022 because I reviewed some of my coding. And changed my coding.

############################################################################### #
# Study 2a #######################################################################
############################################################################### #
df_complete$F_pct_sqrt
s2_df <- df_complete %>% # use entire dataset 
  select(control, Group3, SCHB_pct_sqrt, SCHB1_pct_sqrt, SCHB2_pct_sqrt, 
         EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt, F_pct_sqrt, R)  

s2 <- s2_df %>% remove_all_labels() %>% 
  mutate(across(control:Group3, ~as.factor(.x))) %>% 
  as_tibble()  

s2_df_longer <- s2_df %>% remove_all_labels() %>%  
  mutate(across(control:Group3, ~as.factor(.x))) %>% 
  pivot_longer(SCHB_pct_sqrt:R, 
               names_to = "name",
               values_to = "value") 

# Graphs -----
p1 <- s2_df_longer %>% 
  ggplot(aes(x=value, group=control, fill=control)) +
  geom_histogram(alpha=.5, position = "dodge") +
  facet_wrap( ~name, scale = "free") +
  theme_ipsum()

ggsave("04 Output/histograms.png", p1, width = 20, height = 10, bg = "white")

p2 <- s2_df_longer %>% 
  ggplot(aes(x = value, group = control, fill = control)) +
  geom_density(adjust = 1.5, alpha = .4) +
  facet_wrap( ~name, scale = "free") +
  theme_ipsum()

ggsave("04 Output/density_plots.png", p2, width = 20, height = 10, bg = "white")


################################################################################################### #
# Study 2a ##########################################################################################
################################################################################################### #

s2_df %>% 
  count(control) ### start by checking the groups just to be sure.

s2_df %>% describeBy(group = "control")


multiple_t_tests(data_long = s2_df_longer ,
                 data_wide = s2,
                 formula = value ~ control,
                 group2 = "control",
                 -control, -Group3 )



################################################################################################### #
# Study 2b ##########################################################################################
################################################################################################### #
s2_df %>% count(Group3)

s2b_df_longer <- s2_df_longer %>%  
  filter(Group3 %in% c(0, 2)) %>% 
  mutate(Group3 = if_else(Group3 == 0, 2, 0),
         Group3 = factor(Group3))

s2b_wide <- s2 %>%  
  filter(Group3 %in% c(0, 2)) %>% 
  mutate(Group3 = if_else(Group3 == 0, 2, 0),
         Group3 = factor(Group3)) 

s2b_wide %>% describeBy(group = "Group3")

multiple_t_tests(data_long = s2b_df_longer,
                 data_wide = s2b_wide,
                 formula = value ~ Group3,
                 group2 = "Group3",
                 -control, -Group3 ) %>% 
  mutate(group1 = "Dep",
         group2 = "control")


################################################################################################### #
# Study 2c ##########################################################################################
################################################################################################### #
s2_df %>% count(Group3)

s2c_df_longer <- s2_df_longer %>%  
  filter(Group3 %in% c(0, 1)) %>% 
  mutate(Group3 = if_else(Group3 == 0, 1, 0),
         Group3 = factor(Group3))

s2c_wide <- s2 %>%  
  filter(Group3 %in% c(0, 1)) %>% 
  mutate(Group3 = if_else(Group3 == 0, 1, 0),
         Group3 = factor(Group3)) 

s2c_wide %>% describeBy(group = "Group3")

multiple_t_tests(data_long = s2c_df_longer,
                 data_wide = s2c_wide,
                 formula = value ~ Group3,
                 group2 = "Group3",
                 -control, -Group3 ) %>% 
  mutate(group1 = "Psycotic",
         group2 = "Dep")



################################################################################################### #
# Study 2d ##########################################################################################
################################################################################################### #
s2_df %>% count(Group3)

s2d_df_longer <- s2_df_longer %>%  
  filter(Group3 %in% c(1, 2)) %>% 
  mutate(Group3 = if_else(Group3 == 1, 2, 0), # psychotic as the control group here
         Group3 = factor(Group3))

s2d_wide <- s2 %>%  
  filter(Group3 %in% c(1, 2)) %>% 
  mutate(Group3 = if_else(Group3 == 1, 2, 0),
         Group3 = factor(Group3)) 

s2d_wide %>% describeBy(group = "Group3")

multiple_t_tests(data_long = s2d_df_longer,
                 data_wide = s2d_wide,
                 formula = value ~ Group3,
                 group2 = "Group3",
                 -control, -Group3 ) %>% 
  mutate(group1 = "Dep", 
         group2 = "Psychotic")


