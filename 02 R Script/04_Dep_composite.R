
load("01 Processed data/df_complete.Rdata")

library(correlation)
library(psych)
library(dplyr)
library(stringr)

###################################################### #
# Depressive Composite #################################
###################################################### #

# composite created by the following variables
org_correlation(SCID.CMDS.A1r, SCID.CMDS.A2r, 
                SCID.CMDS.A3r, SCID.CMDS.A4r, 
                SCID.CMDS.A5r, SCID.CMDS.A6r,
                SCID.CMDS.A7r, SCID.CMDS.A8r, 
                SCID.CMDS.A9r, BPRS.05, BPRS.09)

org_correlation(SCID.CMDS.A1r, SCID.CMDS.A2r, 
                SCID.CMDS.A3r, SCID.CMDS.A4r, 
                SCID.CMDS.A5r, SCID.CMDS.A6r,
                SCID.CMDS.A7r, SCID.CMDS.A8r, 
                SCID.CMDS.A9r, BPRS.05, BPRS.09)
df_complete %>% select(SCHB_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt) %>% 
  correlation::correlation()

df_complete %>% 
  select(SCID.CMDS.A1r, SCID.CMDS.A2r, 
         SCID.CMDS.A3r, SCID.CMDS.A4r, 
         SCID.CMDS.A5r, SCID.CMDS.A6r,
         SCID.CMDS.A7r, SCID.CMDS.A8r, 
         SCID.CMDS.A9r,
         starts_with("BPRS.")) %>% 
  correlation::correlation() %>% 
  filter(str_detect(Parameter2, "BPRS"),
         !str_detect(Parameter1, "BPRS")) %>% 
  arrange(-abs(r)) %>% 
  filter(str_detect(Parameter2, ".05|.09")) %>% 
  as_tibble() %>% describe()

df_complete %>% select(SCID.CMDS.A1r, SCID.CMDS.A2r, 
                       SCID.CMDS.A3r, SCID.CMDS.A4r, 
                       SCID.CMDS.A5r, SCID.CMDS.A6r,
                       SCID.CMDS.A7r, SCID.CMDS.A8r, 
                       SCID.CMDS.A9r, BPRS.05, BPRS.09) %>% 
  omega(nfactors = 1)

df_complete %>% select(SCID.CMDS.A1r, SCID.CMDS.A2r, 
                       SCID.CMDS.A3r, SCID.CMDS.A4r, 
                       SCID.CMDS.A5r, SCID.CMDS.A6r,
                       SCID.CMDS.A7r, SCID.CMDS.A8r, 
                       SCID.CMDS.A9r, BPRS.05, BPRS.09) %>% 
  alpha()

# Depressive composite
cms_pca <- df_complete %>% select(SCID.CMDS.A1r, SCID.CMDS.A2r, 
                                  SCID.CMDS.A3r, SCID.CMDS.A4r, 
                                  SCID.CMDS.A5r, SCID.CMDS.A6r,
                                  SCID.CMDS.A7r, SCID.CMDS.A8r, 
                                  SCID.CMDS.A9r, BPRS.05, BPRS.09) %>%  
  pca(nfactors = 1)

cms_pca

cms_pca$loadings[,"PC1"] %>% as_tibble(rownames = "items") %>% rename(loading = value) %>% 
  arrange(-loading) %>%  describe()

cms_pca$scores 

df_complete$Dep_PC2 <- cms_pca$scores %>% as.vector()

# checking whether we get the same variables we got from SPSS
df_complete %>% select(Dep_PC1,Dep_PC2) %>% correlation() 
# yes we did get the same values from SPSS!
# Dep_PC1 and Dep_PC2 are identicals!

df_complete %>% select(Dep_PC1,Dep_PC2) %>% apaTables::apa.cor.table(show.conf.interval = FALSE)
