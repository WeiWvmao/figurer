# Figurer

Reusable, versioned, publication-grade scientific visualization infrastructure for computational biology and biomedical research.

## Start here

**Read [`PROJECT_CHARTER.md`](./PROJECT_CHARTER.md) before implementing anything.** It is the highest-level source of truth for Figurer's architecture and design constraints.

Core idea:

> Scientific intent, data contracts, figure recipes, visual style, output profile, and rendering backend should be separable.

Figurer is being designed so that downstream projects can call stable plotting recipes instead of repeatedly asking an AI to generate ad-hoc plotting code.

## Design goals

- reusable across projects
- coherent but configurable visual styles
- style parameters centralized rather than hard-coded in plot functions
- R and Python backends under a shared semantic specification
- publication, slide, and poster output profiles
- whole-figure composition as a first-class capability
- vector-first reproducible export
- gallery-driven examples and visual quality gates
- AI-facing skills that call stable plotting APIs

## Planned structure

```text
styles/      centralized themes, palettes, semantic identities
profiles/    manuscript / slide / poster output profiles
schemas/     language-neutral data/configuration contracts
recipes/     reusable plot and figure recipes
components/  legends, annotations, panel/layout primitives
python/      Python backend
R/           R backend
skills/      AI-facing visualization skills
prompts/     reusable figure planning/review prompts
gallery/     rendered references + reproducible examples
tests/       functional and visual regression tests
docs/        design decisions and API documentation
```

## Current status

Bootstrap phase. The architectural contract has been established before implementation to prevent later drift toward project-specific plotting scripts or scattered style definitions.

See:

- [`PROJECT_CHARTER.md`](./PROJECT_CHARTER.md) — source of truth
- [`AGENTS.md`](./AGENTS.md) — rules for AI/code agents
- [`docs/DECISIONS.md`](./docs/DECISIONS.md) — architectural decision log
