# Figurer: lightweight R helpers
#
# Intended usage from another repository:
#   source("path/to/figurer/R/figurer.R")
#   p <- ggplot2::ggplot(...) + ... + theme_figurer()
#   save_figurer(p, "figure.pdf")
#
# Dependencies: ggplot2, yaml. patchwork is optional for composition.

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0) y else x
}

.figurer_pt_to_mm <- function(x) as.numeric(x) * 25.4 / 72

.figurer_require <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(sprintf("Figurer requires package '%s' for this operation.", pkg), call. = FALSE)
  }
}

figurer_root <- function(start = getwd()) {
  env_root <- Sys.getenv("FIGURER_HOME", unset = "")
  if (nzchar(env_root) && file.exists(file.path(env_root, "PROJECT_CHARTER.md"))) {
    return(normalizePath(env_root, mustWork = TRUE))
  }

  current <- normalizePath(start, mustWork = FALSE)
  repeat {
    if (file.exists(file.path(current, "PROJECT_CHARTER.md"))) return(current)
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }

  stop(
    "Could not locate Figurer root. Set FIGURER_HOME or call from inside the cloned figurer repository.",
    call. = FALSE
  )
}

.figurer_yaml <- function(relative_path, root = figurer_root()) {
  .figurer_require("yaml")
  path <- file.path(root, relative_path)
  if (!file.exists(path)) stop(sprintf("Missing Figurer config: %s", path), call. = FALSE)
  yaml::read_yaml(path)
}

figurer_profile <- function(name = "paper_double_column", root = figurer_root()) {
  cfg <- .figurer_yaml("profiles/output_profiles.yml", root)
  out <- cfg$profiles[[name]]
  if (is.null(out)) stop(sprintf("Unknown Figurer output profile: %s", name), call. = FALSE)
  out
}

figurer_theme_tokens <- function(name = "journal_clean", root = figurer_root()) {
  cfg <- .figurer_yaml("styles/themes.yml", root)
  out <- cfg$themes[[name]]
  if (is.null(out)) stop(sprintf("Unknown Figurer theme: %s", name), call. = FALSE)
  out
}

figurer_palette <- function(name = "qualitative_8", root = figurer_root()) {
  cfg <- .figurer_yaml("styles/palettes.yml", root)
  pal <- cfg$palettes[[name]]
  if (is.null(pal)) stop(sprintf("Unknown Figurer palette: %s", name), call. = FALSE)
  unlist(pal$colors, use.names = !is.null(names(pal$colors)))
}

figurer_identities <- function(
    group = "cell_classes",
    root = figurer_root(),
    include_aliases = TRUE) {
  cfg <- .figurer_yaml("styles/identities.yml", root)
  ids <- cfg[[group]]
  if (is.null(ids)) stop(sprintf("Unknown Figurer identity group: %s", group), call. = FALSE)
  out <- unlist(ids, use.names = TRUE)

  if (identical(group, "cell_classes") && include_aliases && !is.null(cfg$common_aliases)) {
    aliases <- unlist(cfg$common_aliases, use.names = TRUE)
    for (alias in names(aliases)) {
      canonical <- aliases[[alias]]
      if (!is.null(out[[canonical]])) out[[alias]] <- out[[canonical]]
    }
  }

  out
}

theme_figurer <- function(
    theme = "journal_clean",
    profile = "paper_double_column",
    root = figurer_root()) {
  .figurer_require("ggplot2")

  t <- figurer_theme_tokens(theme, root)
  p <- figurer_profile(profile, root)

  line_scale <- p$line_scale %||% 1
  axis_lw <- .figurer_pt_to_mm(t$axis_line_width_pt) * line_scale
  tick_lw <- .figurer_pt_to_mm(t$tick_line_width_pt) * line_scale

  ggplot2::theme_classic(
    base_size = as.numeric(p$base_size_pt),
    base_family = t$font_family %||% "sans"
  ) +
    ggplot2::theme(
      text = ggplot2::element_text(color = t$text_color),
      plot.title = ggplot2::element_text(
        size = as.numeric(p$title_size_pt),
        face = t$title_weight %||% "bold",
        color = t$text_color,
        hjust = 0,
        margin = ggplot2::margin(b = 4)
      ),
      plot.subtitle = ggplot2::element_text(
        size = as.numeric(p$base_size_pt),
        color = t$muted_text_color,
        hjust = 0,
        margin = ggplot2::margin(b = 5)
      ),
      axis.title = ggplot2::element_text(
        size = as.numeric(p$axis_title_size_pt),
        color = t$text_color
      ),
      axis.text = ggplot2::element_text(
        size = as.numeric(p$tick_size_pt),
        color = t$text_color
      ),
      axis.line = ggplot2::element_line(
        color = t$axis_color,
        linewidth = axis_lw
      ),
      axis.ticks = ggplot2::element_line(
        color = t$axis_color,
        linewidth = tick_lw
      ),
      axis.ticks.length = grid::unit(as.numeric(t$tick_length_pt), "pt"),
      panel.grid = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = t$panel_background, color = NA),
      plot.background = ggplot2::element_rect(fill = t$background, color = NA),
      legend.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      legend.title = ggplot2::element_text(
        size = as.numeric(p$legend_size_pt),
        face = "bold",
        color = t$text_color
      ),
      legend.text = ggplot2::element_text(
        size = as.numeric(p$legend_size_pt),
        color = t$text_color
      ),
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(
        size = as.numeric(p$base_size_pt),
        face = "bold",
        color = t$text_color
      ),
      plot.caption = ggplot2::element_text(
        size = max(as.numeric(p$tick_size_pt) - 0.5, 5),
        color = t$muted_text_color,
        hjust = 0
      ),
      plot.margin = ggplot2::margin(5, 5, 5, 5)
    )
}

scale_color_figurer <- function(palette = "qualitative_8", ..., root = figurer_root()) {
  .figurer_require("ggplot2")
  ggplot2::scale_color_manual(values = figurer_palette(palette, root), ...)
}

scale_fill_figurer <- function(palette = "qualitative_8", ..., root = figurer_root()) {
  .figurer_require("ggplot2")
  ggplot2::scale_fill_manual(values = figurer_palette(palette, root), ...)
}

scale_color_figurer_continuous <- function(
    palette = "sequential_viridis_like", ..., root = figurer_root()) {
  .figurer_require("ggplot2")
  ggplot2::scale_color_gradientn(colors = figurer_palette(palette, root), ...)
}

scale_fill_figurer_continuous <- function(
    palette = "sequential_viridis_like", ..., root = figurer_root()) {
  .figurer_require("ggplot2")
  ggplot2::scale_fill_gradientn(colors = figurer_palette(palette, root), ...)
}

scale_color_figurer_identity <- function(
    group = "cell_classes", ..., root = figurer_root()) {
  .figurer_require("ggplot2")
  ggplot2::scale_color_manual(values = figurer_identities(group, root), ...)
}

scale_fill_figurer_identity <- function(
    group = "cell_classes", ..., root = figurer_root()) {
  .figurer_require("ggplot2")
  ggplot2::scale_fill_manual(values = figurer_identities(group, root), ...)
}

compose_figurer <- function(
    ...,
    ncol = NULL,
    nrow = NULL,
    widths = NULL,
    heights = NULL,
    guides = "collect",
    tag_levels = "A") {
  .figurer_require("patchwork")

  patchwork::wrap_plots(
    ...,
    ncol = ncol,
    nrow = nrow,
    widths = widths,
    heights = heights,
    guides = guides
  ) +
    patchwork::plot_annotation(tag_levels = tag_levels)
}

save_figurer <- function(
    plot,
    filename,
    profile = "paper_double_column",
    root = figurer_root(),
    width_mm = NULL,
    height_mm = NULL,
    dpi = NULL,
    bg = "white",
    ...) {
  .figurer_require("ggplot2")
  p <- figurer_profile(profile, root)

  width_mm <- width_mm %||% as.numeric(p$width_mm)
  height_mm <- height_mm %||% as.numeric(p$height_mm)
  dpi <- dpi %||% as.numeric(p$dpi)

  dir.create(dirname(filename), recursive = TRUE, showWarnings = FALSE)

  ggplot2::ggsave(
    filename = filename,
    plot = plot,
    width = width_mm,
    height = height_mm,
    units = "mm",
    dpi = dpi,
    bg = bg,
    limitsize = FALSE,
    ...
  )

  invisible(normalizePath(filename, mustWork = FALSE))
}
