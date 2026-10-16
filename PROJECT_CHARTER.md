# FIGURER Project Charter

> **Status: highest-level project specification.**
>
> This file is the source of truth for Figurer's architecture and design constraints. Implementation details may evolve; changes that conflict with this charter require an explicit charter update and rationale in `docs/DECISIONS.md`.

## 1. Mission

Figurer is a reusable, versioned scientific-figure system for computational biology and biomedical research.

Its purpose is not merely to "make plots look nicer". It should convert scientific intent + standardized data + an explicit visual specification into publication-grade, presentation-grade, reproducible figures across projects.

The repository should be callable by other projects without copy-pasting plotting code, and should preserve a coherent visual language while allowing multiple named styles.

## 2. Core design constraints

### 2.1 Reusability first

- No project-specific paths, sample IDs, cohort names, genes, labels, colors, or assumptions may be embedded in generic plotting code.
- Plotting functions consume explicit data and configuration inputs.
- Other repositories should depend on a tagged Figurer version rather than copying source files.
- Public APIs must remain stable within a major version.

### 2.2 Style is data, not scattered code

All visual styling must be defined in centralized style/profile configuration, not hard-coded independently inside plotting functions.

Style includes, at minimum:

- typography and font hierarchy
- categorical, sequential, and diverging palettes
- semantic color registries
- line widths, marker sizes, alpha, borders
- axes, ticks, grids, backgrounds
- legend rules
- panel labels
- spacing and margins
- annotation defaults

A plotting function may request semantic tokens such as `text.primary`, `line.axis`, `celltype.malignant`, or `palette.diverging`; it should not invent its own visual constants.

### 2.3 Separate scientific semantics from rendering

The system must separate five concerns:

1. **Scientific semantics** — what is being shown and what variables mean.
2. **Data contract** — the standardized columns/matrices/objects required by a recipe.
3. **Figure recipe** — mapping from scientific intent to geometries, annotations, and layout.
4. **Style/profile** — visual language and output target.
5. **Backend renderer** — R or Python implementation.

Changing a theme should not require rewriting analysis logic. Changing from R to Python should not require changing the scientific meaning of a figure.

### 2.4 Language-agnostic specification, multi-backend rendering

Figurer must not be designed around the assumption that one language is inherently superior for scientific graphics.

- Shared configuration and schemas should use language-neutral formats such as YAML/JSON/TOML where practical.
- R and Python backends may use their strongest native ecosystems.
- Backend-specific features are allowed, but the public semantic interface should remain as consistent as practical.
- Visual equivalence is required; pixel identity is not.

Likely backend ecosystems:

- **R:** ggplot2, ComplexHeatmap, patchwork/cowplot, ggraph and domain-specific extensions.
- **Python:** matplotlib, seaborn/scanpy-compatible layers, PyComplexHeatmap and domain-specific extensions.

### 2.5 Composition is a first-class feature

Publication quality is not achieved by styling individual plots alone. Figurer must support figure-level composition:

- multi-panel layouts
- aligned axes and panel widths
- shared legends
- panel labels (a, b, c...)
- figure-level titles/subtitles/captions
- consistent whitespace
- inset plots
- image + quantitative-panel composition
- vector-safe annotations

The unit of quality is the **whole figure**, not only the individual chart.

### 2.6 Multiple output profiles

The same scientific figure may need different typography and geometry for different destinations. Output target must therefore be an explicit parameter.

Initial profiles should include:

- `paper_single_column`
- `paper_double_column`
- `paper_full_width`
- `slides_16x9`
- `poster`

Profiles control dimensions, base font size, line widths, marker scaling, legend density, and export settings without altering scientific content.

### 2.7 Vector-first, reproducible export

- Prefer PDF/SVG for line art and plots.
- Support high-DPI PNG/TIFF where raster output is appropriate.
- Explicitly control physical dimensions.
- Embed or safely reference fonts where permitted.
- Record the Figurer version, backend, theme, profile, and export settings in machine-readable metadata where practical.
- Randomized elements must accept an explicit seed.

### 2.8 Scientific correctness outranks aesthetics

Figurer may improve visual hierarchy, but must not silently alter scientific meaning.

Examples:

- no truncating quantitative axes unless explicitly requested and clearly encoded
- no inappropriate interpolation or smoothing
- no hidden filtering
- no misleading area/volume encodings
- no default rainbow/jet palettes for quantitative data
- uncertainty/statistical annotations must be tied to explicit input data or analysis output

## 3. Repository architecture

The intended architecture is:

```text
figurer/
├─ PROJECT_CHARTER.md          # highest-level source of truth
├─ AGENTS.md                   # rules for AI/code agents
├─ README.md
├─ pyproject.toml              # Python package metadata
├─ python/figurer/             # Python backend
├─ R/                          # R backend/package code
├─ styles/                     # themes, palettes, semantic color registries
│  ├─ themes/
│  ├─ palettes/
│  └─ identities/
├─ profiles/                   # paper / slide / poster output profiles
├─ schemas/                    # language-neutral configuration/data schemas
├─ recipes/                    # plot and figure recipes
├─ components/                 # reusable legends, annotations, panel helpers
├─ skills/                     # AI-facing figure skills and instructions
├─ prompts/                    # reusable prompts for figure planning/review
├─ gallery/                    # reference figures + minimal reproducible examples
├─ tests/                      # functional + visual regression tests
├─ docs/
│  ├─ DECISIONS.md             # architectural decision log
│  ├─ STYLE_SYSTEM.md
│  ├─ API.md
│  └─ CONTRIBUTING.md
└─ .github/workflows/          # CI for Python/R + rendering checks
```

The exact directory layout may be refined, but the separation of concerns above is mandatory.

## 4. Figure API model

Every reusable figure recipe should conceptually expose the following parameter groups:

```text
data        # values to visualize
mapping     # semantic roles: x/y/color/fill/group/etc.
geometry    # plot-specific structure
annotation  # labels, statistical notes, highlights
layout      # panel arrangement and relative sizes
style       # named theme + semantic palette
profile     # paper/slide/poster target
export      # format, dimensions, dpi, output path
```

Project-specific scripts should mostly describe **what to show**, while Figurer decides **how to render it consistently**.

A conceptual call may look like:

```text
render(
  recipe="embedding.categorical",
  data=...,
  mapping=...,
  theme="journal_clean",
  profile="paper_double_column",
  backend="python"
)
```

Equivalent R/Python syntax may differ, but the semantic contract should remain recognizable.

## 5. Style system

### 5.1 Named themes

The repository should support multiple coherent named themes rather than a single enforced visual appearance. Example families:

- `journal_clean` — restrained general-purpose manuscript style
- `cell_like` — dense but highly structured biomedical figure style
- `nature_like` — minimal, high-contrast manuscript style
- `presentation_clean` — larger typography and simplified legends for slides

Names such as `cell_like` describe design characteristics and must not imply publisher endorsement or exact imitation.

### 5.2 Semantic identities

Frequently recurring biological entities should optionally use stable semantic identity colors, stored separately from themes. Examples:

- broad cell classes
- malignant vs non-malignant
- endothelial / mural / immune / neural lineages
- positive / negative / neutral statistical direction

Identity registries must be overridable per project and must not force arbitrary colors onto unrelated categorical variables.

### 5.3 Accessibility

Default palettes should be color-vision-aware, grayscale-tolerant where feasible, and interpretable when printed. Red/green-only distinctions should not be the sole encoding for important comparisons.

## 6. Recipe library priorities

The first stable recipe set should target the plots repeatedly needed in computational biology rather than attempting exhaustive coverage.

### Tier 1 — core

- categorical and continuous scatter
- UMAP/t-SNE/other embeddings
- line + uncertainty
- grouped bar / proportion
- box/violin/raincloud
- dot/bubble plot
- heatmap
- volcano / MA-style scatter
- multi-panel composition

### Tier 2 — single-cell / spatial

- marker dot plot
- composition plots
- pseudobulk summaries
- program/module heatmaps
- enrichment bubble plots
- spatial categorical maps
- spatial continuous maps
- histology/image overlays
- neighborhood/adjacency matrices

### Tier 3 — translational/clinical

- Kaplan-Meier
- forest plot
- ROC / calibration / decision curves
- longitudinal patient-level trajectories

## 7. Gallery-driven development

Every stable recipe should include a minimal reproducible example and a rendered reference figure in `gallery/`.

A recipe is not considered production-ready until:

- the example runs from clean input
- required data are documented
- style/profile switching works
- vector export works when appropriate
- labels remain readable at target physical dimensions
- legends are not clipped
- the figure passes the relevant visual-quality checklist

## 8. Figure linting and quality gates

Figurer should eventually provide automated or semi-automated figure review. Candidate checks include:

- text below minimum physical size
- clipped labels/legends
- inconsistent fonts
- low-contrast text or markers
- excessive legend categories
- missing axis units
- rasterized text where vector text is expected
- non-semantic hard-coded colors
- inconsistent panel spacing
- output size inconsistent with target profile

These checks should be advisory unless they affect reproducibility or scientific correctness.

## 9. Dependency and compatibility strategy

Cross-project compatibility requires explicit versioning.

- Use semantic versioning.
- Downstream projects should pin a Figurer release/tag or commit.
- Python dependencies should be declared in package metadata and tested in CI.
- R dependencies should be declared and reproducible (for example via DESCRIPTION/renv-compatible workflows).
- Avoid requiring a single massive environment containing every optional plotting package.
- Optional recipe families may declare optional extras.

Copy-pasting plotting utilities from Figurer into downstream repositories is an anti-pattern.

## 10. AI-agent integration

AI agents are expected to be major users and contributors.

Agents should be able to:

1. infer an appropriate recipe from a scientific request;
2. map project data to the recipe data contract;
3. choose a style/profile explicitly;
4. render the figure through a supported backend;
5. run figure linting;
6. compare output against gallery references;
7. return both the figure and the exact reproducible configuration/code.

AI prompts and skills must call stable Figurer APIs instead of generating arbitrary plotting code from scratch whenever a suitable recipe exists.

## 11. What Figurer is not

Figurer is not:

- a replacement for statistical analysis pipelines;
- a dumping ground for one-off scripts copied from publications;
- a single hard-coded theme;
- a collection of screenshots without reproducible source code;
- a reason to force all projects into R or all projects into Python;
- a mechanism for beautifying misleading or scientifically invalid plots.

## 12. Initial development roadmap

### v0.1 — foundation

- repository architecture
- schema for theme/profile configuration
- one default journal theme and one slide theme
- palette + semantic identity registry
- Python + R minimal theme loaders
- export helpers
- core scatter/embedding, heatmap, dot plot, line plot, and composition recipes
- gallery examples
- CI smoke tests

### v0.2 — computational biology core

- single-cell/spatial recipes
- ComplexHeatmap/PyComplexHeatmap adapters
- histology/spatial overlay primitives
- richer annotation and shared-legend composition

### v0.3 — clinical figures + quality control

- survival/forest/ROC/calibration recipes
- figure linter
- visual regression tests

### v0.4 — agent-facing figure system

- stable `skills/` interface
- prompt templates for figure planning, figure review, and manuscript-to-recipe extraction
- automated recipe selection from structured scientific intent

## 13. Change-control rule

When a new feature is proposed, ask in this order:

1. Is it scientifically reusable?
2. Is it a **recipe**, a **component**, a **style token**, a **profile**, or a **backend-specific adapter**?
3. Can project-specific content remain outside the core library?
4. Can R and Python share the same semantic specification?
5. Does the feature preserve existing public APIs?

If a change alters the answers encoded in this charter, update this file deliberately and record the rationale in `docs/DECISIONS.md`.

---

**Founding principle:** Figurer should make high-quality scientific visualization a reusable system rather than a sequence of one-off AI-generated plotting scripts.
