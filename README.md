# Figurer

A lightweight scientific-figure toolbox for computational biology and biomedical research.

The goal is simple: **make good figures reproducible across projects without rebuilding style and plotting conventions every time.**

Figurer deliberately reuses mature visualization ecosystems instead of trying to replace them.

## Start here

1. Read [`PROJECT_CHARTER.md`](./PROJECT_CHARTER.md) — highest-level project plan.
2. Read [`docs/REFERENCE_STACK.md`](./docs/REFERENCE_STACK.md) — which upstream plotting tools to use for which jobs.
3. For AI/code agents, read [`skills/FIGURE_AGENT.md`](./skills/FIGURE_AGENT.md).
4. Use the shared styles/profiles and source the lightweight helper for your language.

## Current structure

```text
styles/                    shared themes, palettes, biological identity colors
profiles/                  manuscript / slide physical output settings
R/figurer.R                lightweight ggplot2/patchwork style + export helpers
python/figurer_style.py    lightweight matplotlib/scanpy style + export helpers
recipes/README.md          figure grammars and minimal data contracts
skills/FIGURE_AGENT.md     instructions for AI figure production
prompts/FIGURE_REVIEW.md   reusable rendered-figure review prompt
docs/REFERENCE_STACK.md    curated open-source visualization stack
```

## Quick start: R

Clone Figurer somewhere stable, then set its path once in your session/environment:

```r
Sys.setenv(FIGURER_HOME = "E:/path/to/figurer")
source(file.path(Sys.getenv("FIGURER_HOME"), "R", "figurer.R"))

library(ggplot2)

p <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 2) +
  scale_color_figurer() +
  theme_figurer(
    theme = "journal_clean",
    profile = "paper_double_column"
  )

save_figurer(p, "results/example.pdf")
```

For slide output, switch to:

```r
p + theme_figurer("presentation_clean", "slides_16x9")
```

## Quick start: Python

```python
import os, sys
os.environ["FIGURER_HOME"] = r"E:\path\to\figurer"
sys.path.insert(0, os.path.join(os.environ["FIGURER_HOME"], "python"))

from figurer_style import apply_figurer_style, save_figurer
import matplotlib.pyplot as plt

apply_figurer_style("journal_clean", "paper_double_column")

fig, ax = plt.subplots()
ax.scatter([1, 2, 3], [2, 4, 3])
ax.set(xlabel="X", ylabel="Y")

save_figurer(fig, "results/example.pdf")
```

## What Figurer does now

- centralizes visual style rather than scattering plot constants through analysis scripts;
- centralizes stable biological identity colors;
- separates manuscript vs slide dimensions and typography;
- gives R and Python projects a common visual baseline;
- gives AI agents explicit backend-routing and figure-review rules;
- documents when to use ggplot2, ComplexHeatmap, patchwork/cowplot, scanpy/matplotlib, Marsilea, PyComplexHeatmap, etc.;
- defines lightweight recipe contracts without forcing a universal data structure.

## What it intentionally does **not** require yet

- installing Figurer as a formal R/Python package;
- converting every project to one data schema;
- implementing every plot in both R and Python;
- a universal rendering API;
- heavyweight CI or release gates for every new plotting idea.

Those can be added later if repeated use makes them worthwhile.

## Development rule

When a project needs a new figure:

> reuse upstream package → apply Figurer style/profile → write the minimum local adapter → promote to Figurer only if the pattern is genuinely reusable.

See [`docs/DECISIONS.md`](./docs/DECISIONS.md) for the architecture decisions behind this approach.