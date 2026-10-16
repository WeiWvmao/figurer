# Prompt: Learn a Visual Style from a Reference Scientific Figure

Use this when a paper figure, labmate figure, or previous project figure has a visual style worth learning from.

---

Inspect the supplied reference figure as a **design system**, not as scientific content to copy.

Extract and describe:

1. **Typography** — font family class, approximate hierarchy, weight, capitalization, title/label relationship.
2. **Color system** — categorical palette character, sequential/diverging palettes, saturation, neutral/background colors, semantic reuse.
3. **Axes** — spine visibility, line weight, tick direction/length, grid use, numeric formatting.
4. **Marks** — point sizes, line widths, alpha, borders, error bars, summary marks.
5. **Legends** — placement, order, title treatment, symbol sizing, direct labeling vs legend use.
6. **Panel composition** — panel ratios, gutters, alignment, shared axes/legends, panel letters, inset behavior.
7. **Whitespace** — outer margins, internal padding, density of information.
8. **Annotations** — arrows, brackets, text callouts, significance labels, scale bars.
9. **Heatmap-specific design** if present — dendrograms, annotation tracks, gaps, row/column labels, colorbar treatment.
10. **Spatial/image-specific design** if present — image contrast, overlay opacity, scale bars, outlines, masking.

Then separate observations into:

- reusable **theme tokens**;
- reusable **output/profile decisions**;
- figure-specific **recipe/layout decisions**;
- biological **identity colors**, if genuinely stable;
- elements that should **not** be generalized.

Compare the extracted system with Figurer's existing `styles/` and `profiles/` files. Reuse existing tokens where they already capture the design. Propose a new named theme only if the reference represents a coherent style that cannot be expressed by small overrides.

Do not imitate logos, proprietary graphic assets, or scientific results. The goal is to learn typography, hierarchy, palette logic, composition, and visual discipline.

If code is available for the reference figure, inspect it, but judge success from the rendered output rather than assuming the code's defaults are desirable.