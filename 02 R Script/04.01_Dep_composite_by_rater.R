

library(dplyr)
library(psych)

# Create Dep Composite for ICC: ----
# 1. Create z-scores for each variable by rater, 
# 2. multiply each z-score by its factor loading from the earlier component analysis 
# 3. sum the products. 


##%######################################################%##
#                                                          #
####  1. Create z-scores for each variable by rater     ####
#                                                          #
##%######################################################%##
df_complete %>% select(
  # RATER 1
  SCID1.CMDS.A1r, SCID1.CMDS.A2r, 
  SCID1.CMDS.A3r, SCID1.CMDS.A4r, 
  SCID1.CMDS.A5r, SCID1.CMDS.A6r,
  SCID1.CMDS.A7r, SCID1.CMDS.A8r, 
  SCID1.CMDS.A9r, 
  BPRS1.05, BPRS1.09,
  # RATER 2
  SCID2.CMDS.A1r, SCID2.CMDS.A2r, 
  SCID2.CMDS.A3r, SCID2.CMDS.A4r, 
  SCID2.CMDS.A5r, SCID2.CMDS.A6r,
  SCID2.CMDS.A7r, SCID2.CMDS.A8r, 
  SCID2.CMDS.A9r, 
  BPRS2.05, BPRS2.09) %>% 
  summarytools::dfSummary() %>% summarytools::view()

df_dep_comp <- df_complete %>% select(
                       # RATER 1
                       SCID1.CMDS.A1r, SCID1.CMDS.A2r, 
                       SCID1.CMDS.A3r, SCID1.CMDS.A4r, 
                       SCID1.CMDS.A5r, SCID1.CMDS.A6r,
                       SCID1.CMDS.A7r, SCID1.CMDS.A8r, 
                       SCID1.CMDS.A9r, 
                       BPRS1.05, BPRS1.09,
                       # RATER 2
                       SCID2.CMDS.A1r, SCID2.CMDS.A2r, 
                       SCID2.CMDS.A3r, SCID2.CMDS.A4r, 
                       SCID2.CMDS.A5r, SCID2.CMDS.A6r,
                       SCID2.CMDS.A7r, SCID2.CMDS.A8r, 
                       SCID2.CMDS.A9r, 
                       BPRS2.05, BPRS2.09) %>% 
  haven::zap_labels() %>% 
  # haven::zap_label() %>% 
  mutate(across(everything(), ~as.numeric(scale(.x)), 
                .names = "{.col}_z"))

df_dep_comp %>% select(ends_with("_z")) %>% names

fa.parallel(df_dep_comp)


report::report_packages()
##%######################################################%##
#                                                          #
####          2. multiply each z-score by its           ####
#### factor loading from the earlier component analysis ####
#                                                          #
##%######################################################%##

# Component

cms_pca # from 04_Dep_composite.R file
pca_loadings <- cms_pca$loadings[,"PC1"] %>% as_tibble(rownames = "items") %>% rename(loading = value)


# Multiplying

df_dep_comp2 <- df_dep_comp %>% 
  select(ends_with("_z")) %>% 
  mutate(across(contains("CMDS.A1r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A1r") %>% select(loading) %>% pull()}),
         across(contains("CMDS.A2r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A2r") %>% select(loading) %>% pull()}),
         across(contains("CMDS.A3r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A3r") %>% select(loading) %>% pull()}),
         across(contains("CMDS.A4r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A4r") %>% select(loading) %>% pull()}),
         across(contains("CMDS.A5r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A5r") %>% select(loading) %>% pull()}),
         across(contains("CMDS.A6r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A6r") %>% select(loading) %>% pull()}),
         across(contains("CMDS.A7r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A7r") %>% select(loading) %>% pull()}),
         across(contains("CMDS.A8r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A8r") %>% select(loading) %>% pull()}),
         across(contains("CMDS.A9r"), ~.x*{pca_loadings %>% filter(items == "SCID.CMDS.A9r") %>% select(loading) %>% pull()}),
         across(contains(".05"), ~.x*{pca_loadings %>% filter(items == "BPRS.05") %>% select(loading) %>% pull()}),
         across(contains(".09"), ~.x*{pca_loadings %>% filter(items == "BPRS.09") %>% select(loading) %>% pull()}))


##%######################################################%##
#                                                          #
####                3. sum the products                 ####
#                                                          #
##%######################################################%##

df_dep_comp3 <- df_dep_comp2 %>% 
  rowwise() %>% 
  mutate(Dep_rater1 = sum(across(c(contains("SCID1"), contains("BPRS1")), na.rm = T)),
         Dep_rater2 = sum(across(c(contains("SCID2"), contains("BPRS2")), na.rm = T))) %>% 
  select(starts_with("Dep")) %>% 
  ungroup()

df_dep_comp3 %>%
  na.omit() %>% 
  ICC()

rm(df_dep_comp, df_dep_comp2)



#########################################################################################
#################### FOR CURIOSITY ######################################################
#########################################################################################

df_complete %>% select(
  # RATER 1
  SCID1.CMDS.A1r, SCID1.CMDS.A2r, 
  SCID1.CMDS.A3r, SCID1.CMDS.A4r, 
  SCID1.CMDS.A5r, SCID1.CMDS.A6r,
  SCID1.CMDS.A7r, SCID1.CMDS.A8r, 
  SCID1.CMDS.A9r, 
  BPRS1.05, BPRS1.09,
  # RATER 2
  SCID2.CMDS.A1r, SCID2.CMDS.A2r, 
  SCID2.CMDS.A3r, SCID2.CMDS.A4r, 
  SCID2.CMDS.A5r, SCID2.CMDS.A6r,
  SCID2.CMDS.A7r, SCID2.CMDS.A8r, 
  SCID2.CMDS.A9r, 
  BPRS2.05, BPRS2.09) %>% 
  haven::zap_labels()

# Depressive composite Rater1 
cms_pca_1 <- df_complete %>% select(SCID1.CMDS.A1r, SCID1.CMDS.A2r, 
                                  SCID1.CMDS.A3r, SCID1.CMDS.A4r, 
                                  SCID1.CMDS.A5r, SCID1.CMDS.A6r,
                                  SCID1.CMDS.A7r, SCID1.CMDS.A8r, 
                                  SCID1.CMDS.A9r, 
                                  BPRS1.05, BPRS1.09) %>%  
  pca(nfactors = 1)

cms_pca_1

cms_pca_1$loadings[,"PC1"] %>% as_tibble(rownames = "items") %>% rename(loading = value) %>% 
  arrange(-loading) %>%  describe()

cms_pca_1$scores 

df_complete$Dep_PC_r1 <- cms_pca_1$scores %>% as.vector()

df_complete %>% glimpse()

# Depressive composite Rater2
cms_pca_2 <- df_complete %>% select(SCID2.CMDS.A1r, SCID2.CMDS.A2r, 
                                    SCID2.CMDS.A3r, SCID2.CMDS.A4r, 
                                    SCID2.CMDS.A5r, SCID2.CMDS.A6r,
                                    SCID2.CMDS.A7r, SCID2.CMDS.A8r, 
                                    SCID2.CMDS.A9r, 
                                    BPRS2.05, BPRS2.09) %>%  
  pca(nfactors = 1)

cms_pca_2

cms_pca_2$loadings[,"PC1"] %>% as_tibble(rownames = "items") %>% rename(loading = value) %>% 
  arrange(-loading) %>%  describe()

cms_pca_2$scores 

df_complete$Dep_PC_r2 <- cms_pca_2$scores %>% as.vector()

df_complete %>% 
  select(starts_with("Dep_PC_"), starts_with("Dep_r")) %>% 
  correlation()


df_complete %>% 
  select(starts_with("Dep_r")) %>% 
  na.omit() %>% 
  ICC()

df_complete %>% 
  select(starts_with("Dep_PC_")) %>% 
  na.omit() %>% 
  ICC()


library(writexl)

cms_pca_1$loadings[,"PC1"] %>% as_tibble(rownames = "item_rater_1") %>% rename(loading_rater_1 = value) %>% 
  bind_cols(cms_pca_2$loadings[,"PC1"] %>% as_tibble(rownames = "item_rater_2") %>% rename(loading_rater_2 = value) ) %>% 
  writexl::write_xlsx("04 Output/loading Dep composite by rater.xlsx")
