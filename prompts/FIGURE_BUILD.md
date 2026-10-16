# Prompt: Build a Figure Using Figurer

Copy/adapt this prompt inside a downstream research repository when asking an AI agent to make a figure.

---

Create or revise the requested scientific figure using the Figurer repository available at `$FIGURER_HOME` (or the local cloned `figurer/` directory).

Before plotting:

1. read `figurer/PROJECT_CHARTER.md`;
2. read `figurer/skills/FIGURE_AGENT.md`;
3. read `figurer/recipes/README.md` and `figurer/docs/REFERENCE_STACK.md`;
4. inspect the actual analysis outputs/data used by this project.

Then:

- infer the scientific message and target output (paper vs slides);
- choose the smallest natural data contract rather than converting the whole project into a new format;
- choose R or Python according to the strongest backend and the project's native workflow;
- reuse mature plotting packages and Figurer style/profile helpers;
- keep project-specific data adapters in this repository, not in Figurer core;
- use stable Figurer biological identity colors when the categories match;
- compose the full figure deliberately rather than styling each panel in isolation;
- export a vector PDF when appropriate and a raster preview if useful;
- inspect the rendered output visually;
- perform one focused refinement pass using `figurer/prompts/FIGURE_REVIEW.md`;
- return/save the exact plotting code and final figure.

Do not repeatedly ask for approval on ordinary aesthetic choices. Make reasonable reversible decisions and proceed. Ask only when a choice changes scientific meaning or when required data are genuinely ambiguous/missing.

If the final plotting pattern is broadly reusable, propose a compact addition back to Figurer; otherwise leave project-specific plotting logic local.