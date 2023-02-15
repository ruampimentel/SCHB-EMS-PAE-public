library(haven)
library(dplyr)
library(readxl)
library(stringr)
library(sjmisc)
library(sjlabelled)
library(labelled)
library(janitor)
library(readr)
library(magrittr)

# Descriptives, Correlation, and ICC - given data------
interrater_rxx <- function(data) {
  data %>% psych::describe() %>% print()
  data %>% correlation::correlation() %>% print()
  data %>% na.omit() %>% as.matrix() %>% psych::ICC() %>% print()
  
  # Example
  # df_complete %>% select(SCID1.CMDS.composite, SCID2.CMDS.composite) %>% 
  # interrater_rxx()
}

# Descriptives, Correlation, and ICC specific for df_complete dataset - given variable names -----
interrater_rxx2 <- function(...) {
  data <- df_complete %>% select(...)
  data %>% psych::describe() %>% print()
  data %>% correlation::correlation() %>% print()
  data %>% na.omit() %>% as.matrix() %>%  psych::ICC() %>% print()
  
  # Example
  # interrater_rxx2(SCID1.CMDS.composite, SCID2.CMDS.composite)
}

# Descriptives, Correlation, and ICC specific for df_complete dataset - given dataset and variable names -----
interrater_rxx3 <- function(data, ...) {
  data2 <- data %>% select(...)
  data2 %>% psych::describe() %>% print()
  data2 %>% correlation::correlation() %>% print()
  data2 %>% na.omit() %>% as.matrix() %>%  psych::ICC() %>% print()
  
  # Example
  # df_complete %>% interrater_rxx3(BPRS1.02, BPRS2.02) 
}
# organize correlation of all listed variables - specific to df_complete dataset.
  org_correlation <- function(...) {
  df_complete %>% dplyr::select(...) %>% 
    correlation::correlation() %>% 
    arrange(-abs(r))
  
  # Example
  # org_correlation(BPRS.03, BPRS.13, BPRS.16, BPRS.17, BPRS.05, BPRS.09) %>% 
  # filter(p<.05)
}


# get data from ICC
icc_focused <- function(data, var_name, ...) {
  data2 <- data %>% 
    select(...) %>% 
    na.omit() %>% as.matrix() %>%  psych::ICC() 
  
  data2$results %>% 
    as_tibble(rownames = "ICC_type") %>% 
    mutate(var = var_name) %>% 
    mutate( n.obs = data2$n.obs,
            n.judge = data2$n.judge) %>% 
    select(var, everything())
  
}




multiple_t_tests <- function(data_long,
                             data_wide,
                             formula,
                             group2,
                             ...
                             
) {
  ## homogeneity test - Levene's test
  ## `nh` = (nonhomogenous)
  
  nh <- data_long %>% 
    dplyr::group_by(name) %>%   
    levene_test(formula) %>% 
    filter(p < .05)
  
  ## Equal Variance (ev) t test -----
  ev_t <- data_long %>% 
    dplyr::group_by(name) %>%   
    rstatix::t_test(formula, var.equal = T) %>% 
    filter(!name %in% nh$name)
  
  ## Non equal variance (neq) t test ------
  nev_t <- data_long %>% 
    dplyr::group_by(name) %>%   
    rstatix::t_test(formula, var.equal = F)  %>% 
    filter(name %in% nh$name)
  
  res_t <- ev_t %>% full_join(nev_t) 
  
  
  # Effect sizes ------
  funs <- c(cohens_d = cohens_d,
            hedges_g = hedges_g,
            glass_delta = glass_delta)
  args <- list(y = group2, data = data_wide)
  
  res_es <- data_wide %>% select(...) %>%  
    # mutate(control) %>% 
    map_df(~ funs %>%
             map(exec, .x, !!!args), .id = "var") 
  
  res_es_clean <- tibble(name = res_es$var, 
                         cohens_d = res_es$cohens_d$Cohens_d,
                         hedges_g = res_es$hedges_g$Hedges_g,
                         glass_delta = res_es$glass_delta$Glass_delta)
  
  # merge results ------
  res <- res_t %>% left_join(res_es_clean) %>% 
    select(-`.y.`) %>%
    rename(t = statistic)
  
  res %>%  # patients (group 1) have more SCHB than control (group 2)
    rstatix::adjust_pvalue()
  
  # example
  # multiple_t_tests(data_long = s2a_df_longer, 
  # data_wide = s2a,
  # formula = value ~ control,
  # group2 = "control",
  # -control, -Group3, -Dep_PC1 )
  
  
}


es <- function(data_wide, group2, ...) {
  # Effect sizes ------
  funs <- c(cohens_d = cohens_d,
            hedges_g = hedges_g,
            glass_delta = glass_delta)
  args <- list(y = group2, data = data_wide)
  
  res_es <- data_wide %>% select(...) %>%  
    # mutate(control) %>% 
    map_df(~ funs %>%
             map(exec, .x, !!!args), .id = "var") 
  
  tibble(name =        res_es$var, 
         cohens_d =    res_es$cohens_d$Cohens_d,
         d_low =       res_es$cohens_d$CI_low,
         d_high =      res_es$cohens_d$CI_high,
         hedges_g =    res_es$hedges_g$Hedges_g,
         g_low =       res_es$hedges_g$CI_low,
         g_high =      res_es$hedges_g$CI_high,
         glass_delta = res_es$glass_delta$Glass_delta,
         delta_low =   res_es$glass_delta$CI_low,
         delta_high =  res_es$glass_delta$CI_high)
  
}


describe_raw_skew_sqrt_by_groups <- function(data = df_complete,
                                             group_var
) {
  
  raw_group_desc <- data %>%  
    select(group_var, MOR_pct:EMS_PAE_pct, 
           SCID.CMDS.composite = SCID1.CMDS.composite, 
           BPRS.05, BPRS.09) %>% 
    describeBy(group = group_var) %>% 
    map_dfr( ~ .x %>% 
               as_tibble(rownames = "var"), .id = group_var) %>% 
    separate(var, c("a", "b")) %>% 
    select(group_var, a, b, n, mean, sd, min, max, skew, kurtosis)
  
  sqrt_group_desc <- data %>% 
    select(group_var, MOR_pct_sqrt:EMS_PAE_pct_sqrt) %>% 
    describeBy(group = group_var) %>% 
    map_dfr( ~ .x %>% 
               as_tibble(rownames = "var"), .id = group_var) %>% 
    rename_with(~paste0(.x, "_sqrt"),
                .cols =  n:se) %>% 
    select(group_var, var, n_sqrt, mean_sqrt, sd_sqrt, skew_sqrt) %>% 
    separate(var, c("a", "b", "c"))
  
  
  desc_group_report <- raw_group_desc %>% full_join(sqrt_group_desc)  %>% 
    unite("variables", a, b, c, sep = "_", na.rm = T) %>% 
    select(group_var, variables:max, kurtosis, skew, skew_sqrt) %>% 
    mutate(variables = case_when(variables == "SCID_CMDS" ~ "SCID.CMDS.composite",
                                 variables == "BPRS_05" ~ "BPRS.05",
                                 variables == "BPRS_09" ~ "BPRS.09",
                                 TRUE ~ variables))
  
  return(desc_group_report)
  
  # Example
  # 
  # describe_raw_skew_sqrt_by_groups(group_var = "Group2")
  # describe_raw_skew_sqrt_by_groups(group_var = "control")
  # describe_raw_skew_sqrt_by_groups(group_var = "Group3")
}

describe_raw_skew_sqrt_by_groups2 <- function(data = df_complete,
                                              group_var
) {
  
  raw_group_desc <- data %>%  
    select(group_var, MOR_pct:EMS_PAE_pct, 
           SCID.CMDS.composite = SCID1.CMDS.composite, 
           Dep_PC1,
           BPRS.05, BPRS.09, 
           SCIDCMDS.A1r = SCID.CMDS.A1r, 
           SCIDCMDS.A7r = SCID.CMDS.A7r) %>% 
    describeBy(group = group_var) %>% 
    map_dfr( ~ .x %>% 
               as_tibble(rownames = "var"), .id = group_var) %>% 
    separate(var, c("a", "b")) %>% 
    select(group_var, a, b, n, mean, sd, min, max, skew, kurtosis)
  
  sqrt_group_desc <- data %>% 
    select(group_var, MOR_pct_sqrt:EMS_PAE_pct_sqrt) %>% 
    describeBy(group = group_var) %>% 
    map_dfr( ~ .x %>% 
               as_tibble(rownames = "var"), .id = group_var) %>% 
    rename_with(~paste0(.x, "_sqrt"),
                .cols =  n:se) %>% 
    select(group_var, var, n_sqrt, mean_sqrt, sd_sqrt, skew_sqrt) %>% 
    separate(var, c("a", "b", "c"))
  
  
  desc_group_report <- raw_group_desc %>% full_join(sqrt_group_desc)  %>% 
    unite("variables", a, b, c, sep = "_", na.rm = T) %>% 
    select(group_var, variables:max, kurtosis, skew, skew_sqrt) %>% 
    mutate(variables = case_when(variables == "SCID_CMDS" ~ "SCID.CMDS.composite",
                                 variables == "BPRS_05" ~ "BPRS.05",
                                 variables == "BPRS_09" ~ "BPRS.09",
                                 TRUE ~ variables))
  
  return(desc_group_report)
  
  # Example
  # 
  # describe_raw_skew_sqrt_by_groups(group_var = "Group2")
  # describe_raw_skew_sqrt_by_groups(group_var = "control")
  # describe_raw_skew_sqrt_by_groups(group_var = "Group3")
}


describe_sqrt_by_groups <- function(data = df_complete,
                                    group_var
) {
  
  data %>% 
    select(group_var, MOR_pct_sqrt:EMS_PAE_pct_sqrt, F_pct_sqrt, F_pct, R) %>% 
    describeBy(group = group_var) %>% 
    map_dfr( ~ .x %>% 
               as_tibble(rownames = "var"), .id = group_var) %>% 
    select(group_var, var, n, mean, sd, min, max, skew, kurtosis) %>% 
    rename_with(~paste0(.x, "_sqrt"),
                .cols =  n:kurtosis)  
  
  # Example
  #
  # describe_sqrt_by_groups(group_var = "Group2")
  # describe_sqrt_by_groups(group_var = "control")
  # describe_sqrt_by_groups(group_var = "Group3")
  
}





