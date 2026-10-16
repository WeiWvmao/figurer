# First lightweight Figurer recipes for R.
# Source R/figurer.R before using this file.
# These functions intentionally accept simple data.frames + column names.

.figurer_sym <- function(x) {
  .figurer_require("rlang")
  rlang::sym(x)
}

fig_embedding_categorical <- function(
    data,
    x,
    y,
    group,
    point_size = 0.5,
    alpha = 0.85,
    identity_colors = FALSE,
    palette = "qualitative_8",
    show_axes = FALSE,
    equal_aspect = TRUE,
    theme = "journal_clean",
    profile = "paper_double_column",
    root = figurer_root()) {
  .figurer_require("ggplot2")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = !!.figurer_sym(x),
      y = !!.figurer_sym(y),
      color = !!.figurer_sym(group)
    )
  ) +
    ggplot2::geom_point(size = point_size, alpha = alpha, stroke = 0) +
    theme_figurer(theme, profile, root)

  if (identity_colors) {
    p <- p + scale_color_figurer_identity(root = root)
  } else {
    p <- p + scale_color_figurer(palette = palette, root = root)
  }

  if (equal_aspect) p <- p + ggplot2::coord_equal()

  if (!show_axes) {
    p <- p + ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank()
    )
  }

  p
}

fig_embedding_continuous <- function(
    data,
    x,
    y,
    value,
    point_size = 0.5,
    alpha = 0.9,
    palette = "sequential_viridis_like",
    show_axes = FALSE,
    equal_aspect = TRUE,
    theme = "journal_clean",
    profile = "paper_double_column",
    root = figurer_root()) {
  .figurer_require("ggplot2")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = !!.figurer_sym(x),
      y = !!.figurer_sym(y),
      color = !!.figurer_sym(value)
    )
  ) +
    ggplot2::geom_point(size = point_size, alpha = alpha, stroke = 0) +
    ggplot2::scale_color_gradientn(colors = figurer_palette(palette, root)) +
    theme_figurer(theme, profile, root)

  if (equal_aspect) p <- p + ggplot2::coord_equal()

  if (!show_axes) {
    p <- p + ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank()
    )
  }

  p
}

fig_grouped_distribution <- function(
    data,
    group,
    value,
    color_by = group,
    show_box = TRUE,
    show_points = TRUE,
    point_size = 1.4,
    point_alpha = 0.75,
    identity_colors = FALSE,
    palette = "qualitative_8",
    theme = "journal_clean",
    profile = "paper_double_column",
    root = figurer_root()) {
  .figurer_require("ggplot2")

  mapping <- ggplot2::aes(
    x = !!.figurer_sym(group),
    y = !!.figurer_sym(value),
    color = !!.figurer_sym(color_by)
  )

  p <- ggplot2::ggplot(data, mapping)

  if (show_box) {
    p <- p + ggplot2::geom_boxplot(
      width = 0.28,
      outlier.shape = NA,
      fill = "white",
      linewidth = 0.5,
      alpha = 0.9
    )
  }

  if (show_points) {
    if (requireNamespace("ggbeeswarm", quietly = TRUE)) {
      p <- p + ggbeeswarm::geom_quasirandom(
        width = 0.18,
        size = point_size,
        alpha = point_alpha,
        stroke = 0
      )
    } else {
      p <- p + ggplot2::geom_jitter(
        width = 0.12,
        height = 0,
        size = point_size,
        alpha = point_alpha
      )
    }
  }

  if (identity_colors) {
    p <- p + scale_color_figurer_identity(root = root)
  } else {
    p <- p + scale_color_figurer(palette, root = root)
  }

  p +
    theme_figurer(theme, profile, root) +
    ggplot2::theme(legend.position = "none")
}

fig_bubble <- function(
    data,
    x,
    y,
    size,
    color,
    color_palette = "sequential_viridis_like",
    size_range = c(1.2, 6.5),
    theme = "journal_clean",
    profile = "paper_double_column",
    root = figurer_root()) {
  .figurer_require("ggplot2")

  ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = !!.figurer_sym(x),
      y = !!.figurer_sym(y),
      size = !!.figurer_sym(size),
      color = !!.figurer_sym(color)
    )
  ) +
    ggplot2::geom_point(alpha = 0.9) +
    ggplot2::scale_size(range = size_range) +
    ggplot2::scale_color_gradientn(colors = figurer_palette(color_palette, root)) +
    theme_figurer(theme, profile, root) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      panel.grid.major = ggplot2::element_line(color = "#ECECEC", linewidth = 0.35)
    )
}

fig_composition <- function(
    data,
    x,
    category,
    value,
    identity_colors = FALSE,
    palette = "qualitative_8",
    theme = "journal_clean",
    profile = "paper_double_column",
    root = figurer_root()) {
  .figurer_require("ggplot2")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = !!.figurer_sym(x),
      y = !!.figurer_sym(value),
      fill = !!.figurer_sym(category)
    )
  ) +
    ggplot2::geom_col(width = 0.82) +
    theme_figurer(theme, profile, root)

  if (identity_colors) {
    p <- p + scale_fill_figurer_identity(root = root)
  } else {
    p <- p + scale_fill_figurer(palette, root = root)
  }

  p
}
