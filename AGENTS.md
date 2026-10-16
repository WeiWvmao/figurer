# Instructions for AI and Code Agents

Figurer is intended to be developed and used heavily by AI agents. These rules are mandatory for automated contributions.

## 1. Read the charter first

Before adding or changing plotting code, read `PROJECT_CHARTER.md`.

If a requested implementation conflicts with the charter, do not silently implement the conflict. Either:

- adapt the implementation to the charter, or
- explicitly update the charter and record the architectural rationale in `docs/DECISIONS.md`.

## 2. Never generate one-off styling when a reusable token belongs in the style system

Do not hard-code fonts, colors, line widths, marker sizes, margins, legend formatting, or export dimensions inside individual recipes unless the value is intrinsically part of that geometry.

Prefer named style tokens, semantic identities, and output profiles.

Bad:

```python
ax.spines['left'].set_linewidth(1.3)
ax.tick_params(labelsize=8)
color = '#2B6F9F'
```

inside every plotting function.

Preferred:

```text
style.axis.line_width
style.typography.tick
identity.endothelial
```

with backend adapters resolving those tokens.

## 3. Keep project-specific content outside the core

Do not embed sample names, cohort names, patient IDs, gene lists, file paths, project-specific labels, or project-specific colors in generic library code.

If an example requires such content, place it in a gallery/example data file and keep the recipe generic.

## 4. Classify every addition

Before creating code, decide whether the requested feature is primarily a:

- recipe
- reusable component
- style token/theme
- semantic identity registry entry
- output profile
- schema/data contract
- backend adapter
- AI skill/prompt

Do not solve all requests by adding another plotting script.

## 5. Preserve semantic/backend separation

Scientific meaning and data contracts should be defined independently of the renderer whenever practical.

Backend-specific code belongs in backend-specific modules. Shared YAML/JSON/TOML configuration should not contain executable language-specific code.

## 6. Prefer stable public APIs

Downstream projects should call documented public interfaces. Avoid requiring imports from internal/private modules.

When a public API must change, use semantic versioning and document the change.

## 7. Every stable recipe needs a gallery example

For a recipe to be considered stable, add or update:

- a minimal reproducible example
- representative input data or generated fixture
- a rendered reference output
- documentation of required fields
- tests for basic rendering/export

## 8. Whole-figure quality matters

When reviewing output, inspect:

- typography hierarchy
- alignment
- whitespace
- panel balance
- legend placement
- annotation collisions
- target physical dimensions
- color contrast
- semantic consistency across panels

A technically correct set of panels is not automatically a publication-quality figure.

## 9. Export deliberately

Always make output target explicit. Do not assume that a figure intended for a manuscript should use the same dimensions and font scale as a slide.

Prefer vector output for line art. Rasterize only elements that benefit from it, such as extremely dense point clouds or histology images.

## 10. Scientific integrity

Do not beautify a figure by silently modifying the underlying data, statistical result, filtering threshold, axis meaning, or uncertainty representation.

Rendering functions should be deterministic given the same data, configuration, version, backend, and seed.

## 11. Reuse before invention

When another project asks for a figure:

1. search Figurer for an existing recipe;
2. reuse or extend it if the scientific grammar matches;
3. create a new reusable recipe only when the grammar is genuinely new;
4. avoid project-local ad-hoc plotting code whenever a Figurer abstraction can reasonably cover the use case.

## 12. Keep an architectural decision trail

Record meaningful architecture changes in `docs/DECISIONS.md`, including rejected alternatives when they are likely to recur.
