# Run from the figurer repository root.
Sys.setenv(FIGURER_HOME = normalizePath("."))
source(file.path(Sys.getenv("FIGURER_HOME"), "R", "figurer.R"))
source(file.path(Sys.getenv("FIGURER_HOME"), "R", "recipes_core.R"))

library(ggplot2)

# 1) General statistical plot
p1 <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 2, alpha = 0.85) +
  scale_color_figurer() +
  labs(x = "Weight", y = "Miles per gallon", color = "Cylinders") +
  theme_figurer("journal_clean", "paper_double_column")

# 2) Embedding-style plot from a simple coordinate table
set.seed(1)
embedding <- data.frame(
  x = c(rnorm(200, -1), rnorm(200, 1)),
  y = c(rnorm(200, 0), rnorm(200, 0.5)),
  cell_type = rep(c("Myeloid", "EC"), each = 200)
)

p2 <- fig_embedding_categorical(
  embedding,
  x = "x",
  y = "y",
  group = "cell_type",
  identity_colors = TRUE
) + labs(color = "Cell type")

# 3) Compose and export
if (requireNamespace("patchwork", quietly = TRUE)) {
  fig <- compose_figurer(p1, p2, ncol = 2, tag_levels = "A")
  save_figurer(fig, "gallery/quickstart_R.pdf", profile = "paper_double_column")
} else {
  save_figurer(p1, "gallery/quickstart_R_plot.pdf", profile = "paper_double_column")
}
