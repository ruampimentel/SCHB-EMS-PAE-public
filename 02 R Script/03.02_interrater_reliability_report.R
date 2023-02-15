
load("01 Processed data/df_complete.Rdata")
source("02 R Script/00_functions.R")

library(correlation)
library(psych)
library(dplyr)
library(haven)

kline_55 <- read_sav("01 Processed data/Interrater Reliability - fourth, fifth, sixth - 55.sav")

# Run all ICCs
icc_SCID.CMDS.composite <- df_complete %>% 
  icc_focused(var_name = "SCID.CMDS.composite",
              SCID1.CMDS.composite, SCID2.CMDS.composite) 
# the message: boundary (singular) fit: see help('isSingular') is just a warining. Everything is ok.
icc_SCID.CMDS.composite

icc_BPRS.05 <- df_complete %>% icc_focused(var_name = "BPRS.05", BPRS1.05, BPRS2.05)
icc_BPRS.09 <- df_complete %>% icc_focused(var_name = "BPRS.09", BPRS1.09, BPRS2.09) 

icc_SCID.CMDS.A1r <- df_complete %>% icc_focused(var_name = "SCID.CMDS.A1r", SCID1.CMDS.A1r, SCID2.CMDS.A1r) 
icc_SCID.CMDS.A7r <- df_complete %>% icc_focused(var_name = "SCID.CMDS.A7r", SCID1.CMDS.A7r, SCID2.CMDS.A7r) 

icc_dep_composite <- df_complete %>% icc_focused(var_name = "Dep_raters", Dep_rater1, Dep_rater2)

icc_SCHB <- kline_55 %>% icc_focused(var_name = "SCHB", starts_with("SCHB")) 
icc_EMS <- kline_55 %>% icc_focused(var_name = "EMS", starts_with("EMS")) 
icc_PAE <- kline_55 %>% icc_focused(var_name = "PAE", starts_with("PAE")) 



# Merge ICCs -----------------
# Organized by ICC size
icc_report <- icc_SCHB %>% 
  full_join(icc_EMS) %>% 
  full_join(icc_PAE) %>% 
  full_join(icc_SCID.CMDS.composite) %>% 
  full_join(icc_BPRS.05) %>% 
  full_join(icc_BPRS.09) %>% 
  full_join(icc_SCID.CMDS.A1r) %>% 
  full_join(icc_SCID.CMDS.A7r) %>% 
  full_join(icc_dep_composite) %>% 
  filter(type == "ICC2") %>% 
  arrange(-ICC) 

icc_report
rm(icc_BPRS.05, icc_BPRS.09, icc_EMS, icc_PAE, icc_SCHB, icc_SCID.CMDS.composite, icc_dep_composite)
