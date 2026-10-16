# Architectural Decision Log

`PROJECT_CHARTER.md` is the highest-level source of truth. This file records durable implementation decisions.

## ADR-0001 — Separate style from plotting logic
**Status:** Accepted · 2026-10-16

Themes, palettes, semantic identities, and output profiles are centralized. Plot recipes should not independently invent fonts, colors, line widths, or export dimensions.

## ADR-0002 — Support both R and Python
**Status:** Accepted · 2026-10-16

Neither language is the exclusive backend. Backend choice follows the strongest ecosystem and the project's native data environment.

## ADR-0003 — Treat whole-figure composition as first-class
**Status:** Accepted · 2026-10-16

Panel layout, alignment, shared legends, whitespace, lettering, image integration, and annotation are part of figure quality rather than afterthoughts.

## ADR-0004 — Separate themes from output profiles
**Status:** Accepted · 2026-10-16

Themes define visual language; profiles define physical destination such as single-column paper or 16:9 slides.

## ADR-0005 — Reuse existing visualization ecosystems before writing custom renderers
**Status:** Accepted · 2026-10-16

Figurer will build on mature packages such as ggplot2, patchwork/cowplot, ComplexHeatmap, scCustomize/dittoSeq, matplotlib/scanpy, SciencePlots, Marsilea, PyComplexHeatmap, and plotnine rather than recreating their capabilities.

**Reason:** the project's objective is better figures, not ownership of a plotting engine.

## ADR-0006 — Do not force a universal data object
**Status:** Accepted · 2026-10-16

Each recipe uses the simplest natural data contract: tidy tables, matrices + annotations, coordinate tables, model-summary tables, or native objects when an upstream package already handles them well.

**Reason:** biological plotting inputs are intrinsically heterogeneous. Universal normalization would add conversion burden without improving the final figure.

## ADR-0007 — Keep the early repository thin
**Status:** Accepted · 2026-10-16

During early development, downstream projects may clone/source Figurer directly. A formal installable package, stable CLI, or universal API is deferred until repeated real-project use reveals a stable interface.

**Reason:** Figurer should help ongoing projects immediately rather than becoming a separate infrastructure project requiring continuous supervision.

## ADR-0008 — Allow recipe-level preferred backends
**Status:** Accepted · 2026-10-16

Examples: ComplexHeatmap may be preferred for annotation-heavy genomic heatmaps; Python/matplotlib may be preferred for dense spatial overlays already produced in Python pipelines.

## ADR-0009 — AI agents should reuse Figurer and upstream recipes before generating ad-hoc code
**Status:** Accepted · 2026-10-16

Agents first inspect existing style, profile, recipe, and reference-stack guidance. New one-off code is allowed for genuinely new figures, but recurring solutions should be promoted back into Figurer.

## ADR-0010 — Gallery and automated linting are evolutionary, not blocking requirements
**Status:** Accepted · 2026-10-16

Reference figures and visual checks remain desirable, but early useful recipes do not need a heavyweight release process. Proven recurring recipes receive stronger tests later.