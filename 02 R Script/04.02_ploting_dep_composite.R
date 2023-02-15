
library(ggplot2)
library(ggExtra)
df_complete


# Correlation between Rater 1 and 2 - Dep composite following Greg's step by step from 04.01_Dep_composite_by_rater.R file
p1 <- ggplot(df_complete) +
  aes(x = Dep_rater1, y = Dep_rater2) +
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  theme_minimal()

ggExtra::ggMarginal(
  p = p1,
  type = 'densigram',
  margins = 'both',
  size = 2.5,
  colour = 'black',
  fill = 'gray'
)

# Checking distribution of original composite Dep_PC1
ggplot(df_complete) +
  aes(x = Dep_PC1) +
  geom_histogram(bins = 30L, fill = "#112446") +
  theme_minimal()
