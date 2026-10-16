# Figurer Skill: Produce High-Quality Scientific Figures

Use this instruction when an AI/code agent is asked to create, revise, or review a scientific figure in another repository.

## Objective

Produce a figure that is scientifically faithful, visually coherent, reproducible, and appropriate for its destination. Prefer Figurer conventions and mature upstream plotting packages over ad-hoc styling.

## Required workflow

### 1. Establish the figure's scientific job

Before coding, infer:

- the main claim/question the figure must communicate;
- whether the figure is exploratory, manuscript-facing, or presentation-facing;
- the intended comparison unit (cell, spot, patient, sample, program, group, etc.);
- which variables are quantitative, ordinal, categorical, spatial, or semantic identities;
- which uncertainty/statistical quantities already exist in the analysis output.

Do not change upstream statistics merely to make the figure easier to draw.

### 2. Inspect Figurer before inventing style

Read:

- `PROJECT_CHARTER.md`
- `docs/REFERENCE_STACK.md`
- `styles/themes.yml`
- `styles/palettes.yml`
- `styles/identities.yml`
- `profiles/output_profiles.yml`
- `recipes/README.md`

If working from a cloned copy inside another project, locate it via `FIGURER_HOME` or the project path.

### 3. Choose the smallest natural data contract

Do not force the source data into a universal object.

Examples:

- UMAP/spatial: x, y, category/value + optional annotation/image;
- grouped comparison: group, value, optional subject/pair;
- heatmap: numeric matrix + annotation tables;
- forest: estimate, lower, upper, label;
- enrichment bubble: term, group, effect, significance.

Create a local adapter only for the columns needed by the figure.

### 4. Route to the strongest backend

Use these defaults unless the project context gives a better reason:

- general manuscript statistical plots -> R/ggplot2;
- multi-panel ggplot composition -> patchwork/cowplot;
- annotation-heavy heatmaps -> R/ComplexHeatmap;
- R single-cell objects -> ggplot2/scCustomize/dittoSeq as useful;
- AnnData/Scanpy-native embeddings and spatial plots -> Python/scanpy/matplotlib;
- Python complex heatmaps -> Marsilea or PyComplexHeatmap;
- Python grammar-of-graphics -> plotnine when it materially reduces bespoke Matplotlib code.

Do not convert languages solely for aesthetic reasons if the native backend can render the figure well.

### 5. Apply Figurer style/profile

R:

```r
source(file.path(Sys.getenv("FIGURER_HOME"), "R", "figurer.R"))
p <- p + theme_figurer(theme = "journal_clean", profile = "paper_double_column")
save_figurer(p, "figure.pdf", profile = "paper_double_column")
```

Python:

```python
from figurer_style import apply_figurer_style, save_figurer
apply_figurer_style("journal_clean", "paper_double_column")
# render with matplotlib/scanpy
save_figurer(fig, "figure.pdf", "paper_double_column")
```

Use `presentation_clean` + `slides_16x9` for slide figures unless a project explicitly specifies otherwise.

### 6. Design for hierarchy, not decoration

A strong figure usually has:

- one clear anchor panel or focal comparison;
- restrained axes and guides;
- few redundant labels;
- semantic color used consistently;
- visible raw data where relevant;
- annotations only where they carry information;
- deliberate whitespace;
- aligned panels and shared legends where appropriate.

Avoid decorative gradients, excessive borders, 3D effects, shadows, arbitrary transparency, and unnecessary chart junk.

### 7. Use figure-specific rules

#### UMAP / embeddings

- coordinates normally do not need numeric axes;
- use equal aspect where appropriate;
- use rasterization for very dense cells;
- keep rare populations visible by draw order or controlled point size;
- use direct labels only if collisions can be controlled;
- do not assign colors in arbitrary alphabetical order when categories have stable biological identities.

#### Spatial

- preserve physical geometry;
- keep histology readable under overlays;
- use scale bars when distances matter;
- avoid opaque points that destroy tissue context;
- keep categorical identity colors stable across sections/patients.

#### Group comparisons

- prefer raw observations + summary over bars alone;
- show pairing when paired;
- keep uncertainty aligned with the reported estimand;
- statistical annotations should not dominate the data.

#### Heatmaps

- decide ordering/clustering from the scientific question;
- reserve annotations for biologically meaningful metadata;
- center diverging scales at a meaningful value;
- use ComplexHeatmap when annotations/layout become nontrivial.

#### Bubble/dot plots

- size must encode area appropriately;
- order axes biologically;
- keep legends compact;
- do not encode too many variables simultaneously.

#### Multi-panel figures

- determine the narrative order before arranging panels;
- use consistent color mappings across panels;
- collect duplicate legends;
- align axes when comparisons require it;
- keep panel labels consistent and unobtrusive.

### 8. Export deliberately

For manuscript figures:

- save a vector PDF/SVG when possible;
- additionally save PNG/TIFF only if required;
- use profile-defined physical dimensions;
- rasterize only dense data layers if needed, not labels/axes.

For slides:

- render at slide-scale dimensions rather than enlarging a manuscript figure afterward;
- simplify legends and annotations if necessary for viewing distance.

### 9. Review the rendered output

Do not judge quality from code alone. Inspect the final rendered figure and ask:

- Can the main message be understood in several seconds?
- Is any text too small at final physical size?
- Are categories distinguishable without relying only on red vs green?
- Are labels clipped or overlapping?
- Are panel widths and whitespace intentional?
- Are repeated legends/axes unnecessary?
- Does the figure look like one visual system rather than several unrelated plotting defaults?
- Is the statistical/biological meaning unchanged?

Fix visible defects before considering the task complete.

### 10. Feed useful patterns back into Figurer

If a project creates a generally useful plotting solution, add a compact reusable recipe/example to Figurer instead of leaving the knowledge only in the project repository.

Do not promote highly project-specific sample labels, gene lists, paths, or one-off logic.