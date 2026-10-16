# Curated Visualization Stack

Last reviewed: 2026-10-16

Figurer should use mature open-source plotting ecosystems as building blocks. This document is the default decision guide for humans and AI agents.

## Default choices

| Figure need | Preferred tool | Why |
|---|---|---|
| General statistical figures | R `ggplot2` | mature grammar of graphics, strong extensions, predictable theming |
| Multi-panel ggplot composition | `patchwork` first; `cowplot` when lower-level alignment/image composition is useful | strong layout and shared-guide support |
| Complex annotated heatmaps | R `ComplexHeatmap` | exceptionally mature annotations, heatmap lists, genomics use cases |
| Publication-style statistical helpers | `ggpubr`, selectively | convenient annotations/standard figure types; do not let defaults override Figurer style |
| Distribution + uncertainty | `ggdist` | raincloud/half-eye/interval grammar |
| Dense raw-point group plots | `ggbeeswarm` | readable individual observations without naive jitter |
| Scientific palettes | Figurer palettes first; `ggsci` as optional source | journal-inspired palettes and broad palette library |
| Single-cell R plotting helpers | `scCustomize`, `dittoSeq` | reusable Seurat/SCE-oriented visualization utilities |
| Python-native embeddings/spatial | `scanpy` + `matplotlib` | direct integration with AnnData and analysis workflows |
| Python grammar-of-graphics | `plotnine` | ggplot-like semantics when this simplifies code |
| Python scientific style presets | `SciencePlots`, optional | useful Matplotlib style baselines; avoid mandatory LaTeX dependency |
| Python composable heatmaps | `Marsilea` | declarative composition of heatmaps + side plots |
| Python ComplexHeatmap-like workflows | `PyComplexHeatmap` | multimodal genomic heatmap support |

## Upstream projects

### R

- ggplot2 — https://github.com/tidyverse/ggplot2
- patchwork — https://github.com/thomasp85/patchwork
- cowplot — https://github.com/wilkelab/cowplot
- ComplexHeatmap — https://github.com/jokergoo/ComplexHeatmap
- ggpubr — https://github.com/kassambara/ggpubr
- ggprism — https://github.com/csdaw/ggprism
- ggdist — https://github.com/mjskay/ggdist
- ggbeeswarm — https://github.com/eclarke/ggbeeswarm
- ggsci — https://github.com/nanxstats/ggsci
- scCustomize — https://github.com/samuel-marsh/scCustomize
- dittoSeq — https://github.com/dtm2451/dittoSeq

### Python

- Matplotlib — https://github.com/matplotlib/matplotlib
- Scanpy — https://github.com/scverse/scanpy
- plotnine — https://github.com/has2k1/plotnine
- SciencePlots — https://github.com/garrettj403/SciencePlots
- Marsilea — https://github.com/Marsilea-viz/marsilea
- PyComplexHeatmap — https://github.com/DingWB/PyComplexHeatmap

## Practical policy

### 1. Do not vendor upstream libraries

Figurer stores configuration, wrappers, adapters, recipes, prompts, and examples. It should not copy whole implementations from upstream repositories.

### 2. Prefer native objects when that saves conversion

Examples:

- An AnnData UMAP can stay in Python.
- A Seurat object can use an R-native helper.
- A standalone program-by-sample matrix can go directly to ComplexHeatmap.

Moving data between languages is worthwhile only if figure quality or implementation simplicity improves substantially.

### 3. Prefer R for classic manuscript statistical graphics

For grouped comparisons, distributions, effect plots, enrichment bubbles, conventional scatter/line plots, forest-like summaries, and many multi-panel figures, `ggplot2` usually minimizes bespoke formatting code.

This is a default, not a rule. Existing Python-native analyses do not need to round-trip through R for ordinary plots that Matplotlib/plotnine can render cleanly.

### 4. Prefer ComplexHeatmap for annotation-heavy heatmaps

Use it when the figure contains several annotation tracks, grouped rows/columns, multiple heatmap bodies, custom legends, or genomics-specific layout needs.

Simple exploratory heatmaps do not need this dependency.

### 5. Style packages are references, not masters

Packages such as SciencePlots, ggprism, ggpubr, and ggsci contain useful defaults and ideas. Figurer's own theme/profile files remain the final style authority so that figures from different upstream tools still look related.

## What we should learn from these projects

- **ggplot2 / plotnine:** separate data, mappings, geometries, scales, and themes.
- **patchwork / cowplot:** figure composition deserves dedicated abstractions.
- **ComplexHeatmap / Marsilea / PyComplexHeatmap:** complex figures are built by composing annotation tracks around a central quantitative object.
- **SciencePlots / ggprism:** reusable style presets dramatically reduce repeated formatting code.
- **scCustomize / dittoSeq:** domain-specific wrappers can make common single-cell figures much easier without creating a new plotting engine.

## Dependency philosophy

Keep the base dependency set small. A downstream project should install only the packages needed for the figure family it uses. Heavy or specialized packages are optional rather than global requirements.