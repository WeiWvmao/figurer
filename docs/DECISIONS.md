# Architectural Decision Log

This document records durable design decisions for Figurer. `PROJECT_CHARTER.md` remains the highest-level source of truth.

## ADR-0001 — Separate style from plotting logic

**Status:** Accepted  
**Date:** 2026-10-16

### Decision

Visual styling will live in centralized theme, palette, semantic-identity, and output-profile configuration rather than being scattered across plotting functions.

### Why

The repository must support multiple coherent styles without duplicating plotting code. A downstream project should be able to change its visual language or output target without rewriting analysis-specific plotting logic.

---

## ADR-0002 — Support both R and Python under a shared semantic specification

**Status:** Accepted  
**Date:** 2026-10-16

### Decision

Figurer will not choose R or Python as the exclusive rendering language. Shared data/configuration contracts will be language-neutral where practical, with separate backend adapters using the strongest ecosystem available in each language.

### Why

Scientific figure quality depends more on design systems, composition, typography, annotation, and export discipline than on the programming language itself. R has particularly mature scientific visualization tooling in several areas, while Python integrates naturally with many existing analysis pipelines. Forcing a single language would reduce reuse.

---

## ADR-0003 — Treat whole-figure composition as a first-class abstraction

**Status:** Accepted  
**Date:** 2026-10-16

### Decision

Figurer will support multi-panel figure composition, shared legends, aligned panels, panel lettering, image overlays, insets, and global spacing rules as core capabilities rather than leaving composition entirely to downstream PowerPoint/Illustrator editing.

### Why

Many visibly "publication-grade" figures are distinguished less by the primitive plot type than by panel hierarchy, spacing, consistent typography, annotation, and composition.

---

## ADR-0004 — Distinguish themes from output profiles

**Status:** Accepted  
**Date:** 2026-10-16

### Decision

A **theme** controls visual language; a **profile** controls physical output context. Manuscript single-column, manuscript full-width, slide, and poster outputs will therefore be separate from style/theme selection.

### Why

The same scientific content needs different font sizes, line weights, legend density, and dimensions depending on destination. Mixing these concerns into one theme produces fragile figures.

---

## ADR-0005 — Make the repository callable, not copyable

**Status:** Accepted  
**Date:** 2026-10-16

### Decision

Downstream projects should install or otherwise reference a pinned Figurer release/commit and call stable APIs. Copy-pasting utility scripts into project repositories is discouraged.

### Why

Copied code immediately diverges. Versioned dependencies allow bug fixes, style improvements, compatibility testing, and reproducible historical figures.

---

## ADR-0006 — AI agents should prefer Figurer recipes over ad-hoc plotting code

**Status:** Accepted  
**Date:** 2026-10-16

### Decision

Agent-facing skills and prompts will first search/select an existing reusable recipe and map project data into its contract. Generating arbitrary plotting code from scratch is a fallback, not the default workflow.

### Why

The main failure mode Figurer is intended to eliminate is repeated one-off AI-generated plotting code with inconsistent aesthetics and conventions.

---

## ADR-0007 — Gallery-driven development and visual quality gates

**Status:** Accepted  
**Date:** 2026-10-16

### Decision

Stable recipes require reproducible examples and rendered reference figures. Functional tests alone are insufficient; visual regressions and physical-output checks will be introduced as the project matures.

### Why

A plotting API can be technically functional while producing poor typography, clipped labels, inconsistent spacing, or unusable manuscript output.

---

## ADR-0008 — Allow recipe-level preferred backends

**Status:** Accepted  
**Date:** 2026-10-16

### Decision

R and Python remain peer backends, but an individual recipe may declare a **preferred backend** when one ecosystem is materially stronger for that figure class. A fallback backend may still be provided when useful.

Examples may include R/ComplexHeatmap for heavily annotated heatmaps and Python/matplotlib-based rendering for dense spatial overlays tightly coupled to Python analysis objects.

### Why

Artificially forcing every recipe to have perfectly symmetric implementations would create unnecessary maintenance and could lower figure quality. The shared semantic specification is the compatibility contract; backend choice should follow the strongest reliable renderer for the task.
