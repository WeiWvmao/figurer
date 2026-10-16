# FIGURER Project Charter

> **Status: highest-level project specification.**
>
> This file is the source of truth for Figurer. The implementation may evolve quickly; durable changes to these principles should be reflected here and in `docs/DECISIONS.md`.

## 1. Mission

Figurer exists for one practical reason: **make consistently excellent scientific figures with minimal project-specific plotting work**.

It is a reusable visualization toolbox for computational biology, spatial omics, single-cell analysis, and biomedical/clinical research. Other repositories should be able to clone/source Figurer and obtain a coherent visual language, reliable export settings, strong plotting recipes, and AI instructions without rebuilding plotting conventions from scratch.

Figurer is not intended to become a large visualization framework unless repeated real-world use proves that such infrastructure is necessary.

## 2. Founding principles

### 2.1 Integrate before inventing

Do not reimplement capabilities that mature open-source packages already solve well.

Figurer should primarily **curate, configure, compose, and standardize** strong upstream tools. Examples include:

- R: `ggplot2`, `patchwork`, `cowplot`, `ComplexHeatmap`, `ggrepel`, `ggdist`, `ggbeeswarm`, `ggsci`, `scCustomize`, `dittoSeq`
- Python: `matplotlib`, `scanpy`, `plotnine`, `SciencePlots`, `Marsilea`, `PyComplexHeatmap`

Custom code is justified when it provides one of the following:

1. a reusable scientific plotting recipe not already available;
2. a centralized style/profile layer;
3. reliable composition/export behavior;
4. an adapter between project data and a strong upstream plotting tool;
5. a figure-quality or AI workflow that existing packages do not provide.

### 2.2 Thin core, useful immediately

The repository should stay light enough to improve while other research projects continue.

- Prefer small utilities and recipes over building a new plotting engine.
- Prefer sourcing/cloning the repository over requiring packaging infrastructure during early development.
- Do not block useful plotting work on a universal cross-project API.
- Do not require R/Python feature parity.
- Introduce formal interfaces only after repeated use shows a stable pattern.

### 2.3 Style is centralized data

Fonts, line widths, marker defaults, palettes, panel labels, legend conventions, spacing, and export dimensions must live in centralized style/profile files rather than being independently invented inside each plot.

A recipe may override style only when the geometry scientifically requires it.

### 2.4 Theme and output profile are separate

A **theme** is the visual language. A **profile** is the physical destination.

Initial themes:

- `journal_clean`
- `presentation_clean`

Initial profiles:

- `paper_single_column`
- `paper_double_column`
- `paper_full_width`
- `slides_16x9`

The same plot should be switchable from paper to presentation output without changing its scientific content.

### 2.5 No universal input object

Scientific plotting data are heterogeneous. Figurer will not force every project into one master data structure.

Recipes should accept the **simplest natural contract for that figure**:

- tidy/long data frames for ordinary statistical plots;
- matrices plus annotations for heatmaps;
- coordinate tables for spatial/embedding plots;
- survival/model-summary tables for clinical plots;
- native objects when a mature package already has a useful object-aware plotting API.

Project-specific adapters should transform local objects into these small recipe-level contracts.

### 2.6 Use the strongest backend for the figure

R and Python are both supported, but they are not required to mirror each other.

Default preference:

- ordinary statistical / grouped / annotated plots: R + `ggplot2`
- whole-figure composition in R: `patchwork` / `cowplot`
- heavily annotated genomic heatmaps: R + `ComplexHeatmap`
- single-cell figures in R: native `ggplot2` plus `scCustomize`/`dittoSeq` where useful
- Python-native single-cell/spatial workflows: `scanpy`/`matplotlib`
- Python scientific styling: native Matplotlib configuration, optionally informed by `SciencePlots`
- Python complex composable heatmaps: `Marsilea` or `PyComplexHeatmap`
- Python grammar-of-graphics workflows: `plotnine` when it reduces custom Matplotlib code

Backend choice follows output quality and integration cost, not ideology.

### 2.7 Composition matters as much as individual panels

High-quality figures require attention to:

- panel hierarchy and lettering;
- aligned plot regions;
- shared legends;
- whitespace and relative panel sizes;
- image + quantitative-plot integration;
- consistent typography;
- annotations and callouts;
- target physical dimensions.

A set of individually acceptable plots can still make a poor figure.

### 2.8 Scientific correctness outranks aesthetics

Styling must not silently alter the result. No hidden filtering, inappropriate smoothing, misleading axis treatment, fabricated uncertainty, or aesthetics-driven manipulation of scientific values.

### 2.9 Vector-first export

Prefer PDF/SVG for line art and mixed figures. Use high-resolution raster output for dense point clouds, histology, or other raster-native panels. Dimensions must be explicit and profile-driven.

### 2.10 AI should reuse, not improvise endlessly

AI agents working in downstream projects should first inspect Figurer and use an existing theme, profile, recipe, or upstream-package pattern. Ad-hoc plotting code is acceptable when the figure is genuinely new, but useful patterns should then be promoted back into Figurer.

## 3. Repository model

```text
figurer/
├─ PROJECT_CHARTER.md
├─ AGENTS.md
├─ README.md
├─ docs/
│  ├─ DECISIONS.md
│  └─ REFERENCE_STACK.md
├─ styles/
│  ├─ themes.yml
│  ├─ palettes.yml
│  └─ identities.yml
├─ profiles/
│  └─ output_profiles.yml
├─ R/
│  └─ figurer.R
├─ python/
│  └─ figurer_style.py
├─ recipes/
│  └─ README.md
├─ skills/
│  └─ FIGURE_AGENT.md
├─ prompts/
│  └─ FIGURE_REVIEW.md
└─ gallery/
```

This is intentionally a **toolbox layout**, not a requirement to build a full package immediately.

## 4. Initial recipe priorities

Build only what recurs in current biomedical work.

### Core

- categorical/continuous scatter and embedding
- grouped distribution plots (box/violin/raincloud + raw points)
- line + uncertainty
- proportion/composition plots
- dot/bubble plots
- volcano/MA-style scatter
- heatmaps
- multi-panel composition

### Single-cell / spatial

- UMAP/t-SNE styling
- marker dot plots
- program/module heatmaps
- enrichment bubble plots
- spatial categorical maps
- spatial continuous maps
- histology overlays
- neighborhood/adjacency matrices

### Clinical

- forest plots
- Kaplan-Meier
- ROC/calibration curves
- longitudinal patient trajectories

## 5. Development rule

When a new plotting need appears:

1. identify the scientific message;
2. check whether a strong upstream package already provides the geometry;
3. reuse it with Figurer style/profile settings;
4. write the minimum adapter required for the project data;
5. promote the solution to a reusable recipe only after it proves useful more than once or clearly represents a common figure grammar.

Do not create abstraction for abstraction's sake.

## 6. Near-term plan

### v0.1 — immediately useful

- curated upstream visualization stack
- centralized themes, palettes, biological identities, and output profiles
- small R and Python style/export helpers
- AI figure-production skill and figure-review prompt
- recipe guidance for heterogeneous data inputs

### v0.2 — learned from real projects

- promote successful plotting patterns from the GBM/spatial and brain-metastasis projects
- add a small recipe library for the most frequently recurring plots
- add gallery examples for proven recipes

### Later, only if justified

- formal installable package/API
- automatic backend selection
- visual regression testing
- figure linting
- structured cross-language recipe specification

These are explicitly **not prerequisites** for using Figurer now.

---

**Founding principle:** reuse the strongest existing visualization ecosystems, centralize visual decisions, and make good scientific figures easier to reproduce than bad ad-hoc ones.