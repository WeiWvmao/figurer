# Figurer Recipes

Recipes are **small reusable plotting patterns**, not a universal framework. They describe the scientific grammar of a figure and the simplest data contract needed to render it.

## General rule

Do not reshape every project into one Figurer object. Adapt only the columns/matrix needed for the current figure.

## Initial recipe map

| Recipe | Minimal input contract | Preferred backend | Typical upstream tool |
|---|---|---|---|
| `embedding.categorical` | table: x, y, category | native project backend | ggplot2 / scanpy / matplotlib |
| `embedding.continuous` | table: x, y, value | native project backend | ggplot2 / scanpy / matplotlib |
| `grouped.distribution` | table: group, value, optional subject | R | ggplot2 + ggdist/ggbeeswarm |
| `line.uncertainty` | table: x, estimate, lower, upper, group | R or Python | ggplot2 / matplotlib |
| `composition.stacked` | table: sample/group/category/fraction | R | ggplot2 |
| `dotplot.matrix` | table: row, column, size, color | R | ggplot2 |
| `heatmap.simple` | numeric matrix | either | ComplexHeatmap / Marsilea / PyComplexHeatmap |
| `heatmap.annotated` | matrix + row/column annotation tables | R | ComplexHeatmap |
| `enrichment.bubble` | term, group, effect/enrichment, significance | R | ggplot2 |
| `volcano` | effect size, p/FDR, label | R or Python | ggplot2 / matplotlib |
| `spatial.categorical` | x, y, category; optional histology image | Python when analysis is Python-native | matplotlib / scanpy |
| `spatial.continuous` | x, y, value; optional histology image | Python when analysis is Python-native | matplotlib / scanpy |
| `adjacency.heatmap` | square matrix + labels | either | ComplexHeatmap / matplotlib |
| `forest` | label, estimate, lower, upper; optional subgroup | R | ggplot2 |
| `survival.km` | time, event, group or fitted survival object | R | survival/survminer or custom ggplot |

## Recipe-quality defaults

### Embeddings (UMAP/t-SNE)

- Remove axes/ticks when coordinates have no direct quantitative interpretation.
- Preserve equal aspect ratio when appropriate.
- Use small points for large cell counts; rasterize dense layers when needed.
- Avoid giant legends; order biologically related categories deliberately.
- Do not label every cluster if labels overlap. Use direct labels only when they improve reading.
- For highlights, render background cells in a quiet neutral color and foreground cells at higher opacity.

### Grouped continuous data

Prefer showing the observed distribution rather than bars of mean ± error alone.

Useful grammars:

- raw points + median/IQR;
- raw points + mean/CI;
- violin/half-eye + box/interval + points;
- paired trajectories when observations are paired.

The statistical test and the visual summary must describe the same estimand.

### Heatmaps

- Choose clustering intentionally; do not cluster by default when biological ordering matters.
- Put major biological metadata in annotation tracks rather than encoding everything in row/column labels.
- Use a meaningful center for diverging scales.
- For large matrices, consider rasterizing only the heatmap body while preserving vector text/annotations.
- `ComplexHeatmap` is the default for publication figures with several annotations.

### Dot/bubble plots

- Use area, not radius, to represent magnitude.
- Keep the size legend interpretable.
- Avoid simultaneously encoding several unrelated variables with size, color, alpha, and shape.
- Sort rows/columns by biological logic whenever possible.

### Spatial maps

- Maintain the physical aspect ratio.
- State or retain scale bars when distances matter.
- When overlaid on histology, control opacity so both tissue structure and molecular signal remain readable.
- Rasterize dense spot/cell layers when necessary while keeping text and scale bars vector.
- For categorical maps, stable biological identity colors are preferred.

### Multi-panel figures

A figure should have one visual hierarchy. Before composing panels, decide which panel is the anchor and which panels provide evidence/detail.

- align panel bounds where comparisons are intended;
- use shared legends when the mapping is identical;
- use consistent category colors across all panels;
- keep panel lettering outside data regions where practical;
- use whitespace to separate concepts rather than decorative boxes.

## When to promote project code into Figurer

Promote a plotting pattern when at least one is true:

1. it recurs across projects;
2. it solves a common biomedical figure grammar particularly well;
3. it requires enough non-obvious composition/styling that AI repeatedly gets it wrong;
4. it establishes a visual convention we want to keep stable.

Otherwise keep the adapter/project-specific layer in the downstream repository.