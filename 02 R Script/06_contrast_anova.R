library(car)

# Study 1 Contrast Anova (ca)
s1_ca <- df_complete %>% select(Group3, SCHB_pct_sqrt, SCHB2_pct_sqrt, EMS_pct_sqrt, PAE_pct_sqrt, MOR_pct_sqrt) %>% 
  mutate(Group3 = factor(Group3))

aov1 <- aov(SCHB_pct_sqrt ~ Group3, data = df_complete)

Anova(aov1, type = "III")
levels(s1_ca$Group3) <- c("Control", "SA and Sz", "Dep")
levels(s1_ca$Group3)

# s1_ca %>% 
#   mutate(Group3 = factor(Group3, 
#                          labels = c("Control", "SA and Sz", "Dep"),
#                          levels = c(0, 1, 2)))
# 
s1_ca %>% count(Group3) 


contrasts(s1_ca$Group3) <- cbind(contrast) 
contrasts(s1_ca$Group3)

aov2 <- aov(SCHB_pct_sqrt ~ Group3, data = df_complete)
summary.lm(aov2)
