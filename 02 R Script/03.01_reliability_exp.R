
load("01 Processed data/df_complete.Rdata")

library(correlation)
library(psych)
library(dplyr)


# Reliability - Only Patient dataset!!! -----
## SCID #####################################
interrater_rxx2(SCID1.CMDS.composite, SCID2.CMDS.composite)
interrater_rxx2(SCID1.CMDS.A1r, SCID2.CMDS.A1r)
interrater_rxx2(SCID1.CMDS.A7r, SCID2.CMDS.A7r) 

org_correlation(SCID.CMDS.A1r, SCID.CMDS.A2r, SCID.CMDS.A3r,
                SCID.CMDS.A4r, SCID.CMDS.A5r, SCID.CMDS.A6r,
                SCID.CMDS.A7r, SCID.CMDS.A8r, SCID.CMDS.A9r)
# fair-strong relationships overall.

## BPRS #########################################################
df_complete %>% interrater_rxx3(BPRS1.02, BPRS2.02) 
df_complete %>% interrater_rxx3(BPRS1.03, BPRS2.03) 
df_complete %>% interrater_rxx3(BPRS1.05, BPRS2.05) 
df_complete %>% interrater_rxx3(BPRS1.09, BPRS2.09) 
df_complete %>% interrater_rxx3(BPRS1.10, BPRS2.10) 
df_complete %>% interrater_rxx3(BPRS1.13, BPRS2.13) 
df_complete %>% interrater_rxx3(BPRS1.16, BPRS2.16) 
df_complete %>% interrater_rxx3(BPRS1.17, BPRS2.17) 

org_correlation(BPRS.03, BPRS.13, BPRS.16, BPRS.17, BPRS.05, BPRS.09) %>% 
  filter(p < .05)
# highest corr depressive mood and guilt feelings (r = .637).
# and excitement and blunted affect (r= -.609)
# everything else was lower than .41.


### BPRS and SCID ----
df_complete %>% 
  correlation(select = c("BPRS.03", "BPRS.13", "BPRS.16", "BPRS.17", "BPRS.05", "BPRS.09"),
              select2 = c("SCID.CMDS.A1r", "SCID.CMDS.A2r", "SCID.CMDS.A3r",
                          "SCID.CMDS.A4r", "SCID.CMDS.A5r", "SCID.CMDS.A6r",
                          "SCID.CMDS.A7r", "SCID.CMDS.A8r", "SCID.CMDS.A9r")) %>% 
  arrange(-abs(r)) %>% 
  filter(p < .05)

# fair-strong relationships between guilt/depressive mood and SCID (.36 to .793, most of it was >.45).
# poor-fair relationships between emotiona withdrawal/motor retardation with SCID (.22 to .326)
# no sig. corr between blunted affect/excitement and SCIDs, except one r = .256.



## SCHB, EMS, PAE ###############################################
# coders dataset
kline_55 <- read_sav("01 Processed data/Interrater Reliability - fourth, fifth, sixth - 55.sav")


kline_55 %>% interrater_rxx3(starts_with("SCHB"))
kline_55 %>% interrater_rxx3(starts_with("EMS"))
kline_55 %>% interrater_rxx3(starts_with("PAE"))




