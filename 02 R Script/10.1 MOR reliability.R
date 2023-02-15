source("02 R Script/00_functions.R")
load("01 Processed data/df_complete.Rdata")


# Check "02 R Script/MOR reliability.qmd" file for final output

##%######################################################%##
#                                                          #
####                        ICC                         ####
#                                                          #
##%######################################################%##

# ICC general for all 30 cases
df_complete %>% 
  select(ID, starts_with("MOR") ) %>% 
  select(MOR, MOR_2nd) %>%
  filter(!is.na(MOR_2nd)) %>% 
  interrater_rxx()
# ?psych::ICC()

library(ggplot2)

# Nice Graph
p1 <- ggplot(df_complete, aes(x = MOR, y = MOR_2nd)) +
  geom_jitter(size = 1.5) +
  theme_minimal() +
  xlim(-1, 6) +
  ylim(-1, 6)

ggExtra::ggMarginal(
  p = p1,
  type = 'densigram',
  margins = 'both',
  size = 5,
  colour = 'black',
  fill = '#BA80D9'
)


# ICC for Greg Meyer cases
df_complete %>% 
  select(ID, starts_with("MOR") )  %>% 
  filter(MOR_2nd_coder == "GM") %>% 
  select(MOR, MOR_2nd) %>%
  interrater_rxx()

# ICC for all Giselle Pianowski cases
df_complete %>% 
  select(ID, starts_with("MOR") )  %>% 
  filter(MOR_2nd_coder == "GP") %>% 
  select(MOR, MOR_2nd) %>%
  interrater_rxx()

# ICC for Ruam Pimentel cases
df_complete %>% 
  select(ID, starts_with("MOR") )  %>% 
  filter(MOR_2nd_coder == "RP") %>% 
  select(MOR, MOR_2nd) %>%
  interrater_rxx()
