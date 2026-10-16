# Instructions for AI and Code Agents

Figurer is intended to be used heavily by AI agents. Keep it practical, lightweight, and reusable.

## 1. Read the charter first

Before adding or changing plotting code, read `PROJECT_CHARTER.md` and `docs/REFERENCE_STACK.md`.

If an implementation conflicts with the charter, update the design deliberately rather than silently drifting.

## 2. Reuse before invention

Before writing a new renderer, ask whether a mature upstream package already solves the problem.

Default building blocks include:

- R: ggplot2, patchwork/cowplot, ComplexHeatmap, ggdist, ggbeeswarm, scCustomize, dittoSeq
- Python: matplotlib, scanpy, plotnine, SciencePlots, Marsilea, PyComplexHeatmap

Figurer should standardize and compose these tools, not recreate them.

## 3. Keep the core thin

Do not create a new abstraction layer merely because one is possible.

A project-local adapter is acceptable when the input data are specific to that project. Promote it into Figurer only when the plotting grammar is reusable or recurring.

Do not block useful work on packaging, CLI design, cross-language parity, or a universal schema.

## 4. Style belongs in centralized configuration

Do not scatter fonts, colors, line widths, marker sizes, margins, legend formatting, or export dimensions throughout project plotting scripts.

Use:

- `styles/themes.yml`
- `styles/palettes.yml`
- `styles/identities.yml`
- `profiles/output_profiles.yml`

Recipe-specific overrides are allowed when required by the geometry or scientific meaning.

## 5. Do not force one data structure

Use the simplest natural contract for the figure:

- tidy tables for ordinary plots;
- matrices + annotations for heatmaps;
- coordinate tables for spatial/embedding plots;
- model-summary tables for clinical figures;
- native Seurat/AnnData/etc. objects when mature upstream plotting APIs make this easier.

## 6. Choose the strongest backend

Use R or Python according to figure quality and integration cost.

Typical choices:

- statistical manuscript plots -> R/ggplot2
- multi-panel ggplot figures -> patchwork/cowplot
- heavily annotated heatmaps -> ComplexHeatmap
- AnnData/Scanpy-native embeddings/spatial -> Python
- Python complex heatmaps -> Marsilea/PyComplexHeatmap

Do not force symmetrical R/Python implementations.

## 7. Whole-figure quality matters

Inspect:

- visual hierarchy;
- panel size and order;
- typography;
- whitespace;
- alignment;
- legends;
- annotation collisions;
- stable color semantics;
- physical output dimensions.

A technically correct plot is not automatically a good figure.

## 8. Preserve scientific meaning

Never beautify a figure by silently changing filtering, statistics, axis meaning, uncertainty, clustering, or underlying values.

Any transformation used only for visualization should be explicit.

## 9. Export deliberately

Use the named output profiles. Prefer PDF/SVG for vector-friendly figures. Rasterize dense points or histology layers when useful while preserving text and axes as vectors when possible.

## 10. Review the rendered output

Do not stop after code executes. Inspect the rendered figure. Fix clipped text, overlaps, weak hierarchy, unreadable legends, or poor panel balance.

Use `prompts/FIGURE_REVIEW.md` when a systematic second pass is useful.

## 11. Feed successful patterns back

When a downstream project produces a genuinely reusable figure pattern, add the compact recipe/helper/guidance to Figurer. Do not copy project paths, patient IDs, sample names, or highly specific biological assumptions into the core.

## 12. Avoid needless process

This project supports ongoing research; it should not demand repeated human approval for routine improvements. Make reasonable reversible choices, document durable decisions, and keep moving.