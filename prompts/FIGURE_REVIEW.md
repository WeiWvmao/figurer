# Prompt: Review and Improve a Scientific Figure

Use this prompt with an AI that can see the rendered figure and access its plotting code/data context.

---

You are reviewing a biomedical/scientific figure for publication or presentation quality.

First read the Figurer project guidance (`PROJECT_CHARTER.md`, `recipes/README.md`, relevant style/profile files). Then inspect both the rendered figure and the code that generated it.

Your job is to improve **communication quality without changing the scientific result**.

Evaluate in this order:

1. **Scientific message** — What is the one main point the figure communicates? Does the visual hierarchy make that point obvious?
2. **Figure architecture** — Are panels ordered and sized according to their importance? Is any panel redundant or too dominant?
3. **Typography** — Are titles, axis labels, legends, annotations, and panel labels readable at final physical size and hierarchically consistent?
4. **Color semantics** — Are repeated biological identities assigned stable colors? Are quantitative palettes perceptually appropriate? Are arbitrary categories distinguishable?
5. **Data geometry** — Is the chosen plot type appropriate for the data and estimand? Are raw observations, pairing, uncertainty, spatial geometry, or clustering represented appropriately?
6. **Axes and scales** — Are units, limits, transformations, aspect ratios, and midpoints appropriate and consistent?
7. **Legends and labels** — Remove redundancy, collisions, excessive category lists, and repeated legends. Prefer direct labeling only when it is clearer.
8. **Whitespace and alignment** — Check panel bounds, plot-region alignment, gutters, margins, and visual balance.
9. **Annotation discipline** — Keep only annotations that help interpretation. Statistical labels should support rather than dominate the data.
10. **Export quality** — Verify target dimensions, vector/raster choices, rasterized dense layers, and absence of clipping.

After the review:

- identify the 3–7 changes with the highest visual impact;
- implement those changes in code;
- render the revised figure;
- inspect it again rather than assuming the code change worked visually;
- preserve the original analysis outputs and values;
- use Figurer themes/profiles rather than scattering new style constants throughout the script;
- if a generally reusable plotting pattern emerges, propose or add it to Figurer.

Avoid redesign for novelty. The goal is a restrained, coherent, high-information scientific figure.