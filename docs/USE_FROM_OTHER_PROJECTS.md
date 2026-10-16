# Using Figurer from Other Projects

Figurer does not require a formal package/API yet. The simplest reliable approach is to keep one clone and point projects/agents at it.

## Option A — one shared local clone (recommended for now)

Clone once, for example:

```text
E:/AI-Workspace/figurer
```

Set:

```text
FIGURER_HOME=E:/AI-Workspace/figurer
```

Then downstream code can source/import the helpers without copying files.

### R

```r
source(file.path(Sys.getenv("FIGURER_HOME"), "R", "figurer.R"))
source(file.path(Sys.getenv("FIGURER_HOME"), "R", "recipes_core.R"))
```

### Python

```python
import os, sys
sys.path.insert(0, os.path.join(os.environ["FIGURER_HOME"], "python"))

from figurer_style import apply_figurer_style, save_figurer
from recipes_core import embedding_categorical
```

This is the lowest-maintenance model while Figurer changes quickly.

## Option B — git submodule inside each research project

Use this when a project must pin the exact Figurer version used for a manuscript/reproducibility snapshot.

Conceptually:

```text
my-project/
├─ tools/
│  └─ figurer/   # git submodule, pinned commit
├─ analysis/
└─ results/
```

The downstream project can then set `FIGURER_HOME` to `tools/figurer`.

Advantages:

- exact commit is recorded;
- no copied/diverging plotting utilities;
- project remains reproducible after Figurer changes.

Cost: submodules add some Git workflow complexity, so they are not required for routine exploratory projects.

## Option C — project agent pulls Figurer when needed

An AI/code agent may clone or update Figurer into a project-local tools/cache directory, read `skills/FIGURE_AGENT.md`, then produce the figure.

This is acceptable for active analysis, but manuscript/final figure generation should record the Figurer commit used.

## What belongs where

### Keep in Figurer

- themes and palettes;
- output profiles;
- reusable biological identity colors;
- generic plotting recipes;
- backend selection guidance;
- prompts/skills;
- generally reusable composition/export code.

### Keep in the research project

- paths;
- patient/sample IDs;
- cohort-specific ordering;
- gene/program lists specific to one analysis;
- data loading and analysis logic;
- one-off annotation positions;
- project-specific adapters.

## Recommended current policy

During active research: **shared clone + `FIGURER_HOME`**.

When freezing a paper/result: record the Figurer Git commit, or pin it as a submodule.

A formal pip/R package interface should be introduced only after the repeated calling patterns stabilize.