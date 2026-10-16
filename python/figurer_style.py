"""Lightweight Figurer helpers for Python.

Typical downstream usage:

    import sys
    sys.path.insert(0, "/path/to/figurer/python")
    from figurer_style import apply_figurer_style, save_figurer, palette

    apply_figurer_style()
    ...  # matplotlib / scanpy plotting
    save_figurer(fig, "figure.pdf")

Dependencies: matplotlib, PyYAML.
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any


def find_figurer_root(start: str | Path | None = None) -> Path:
    env_root = os.environ.get("FIGURER_HOME")
    if env_root:
        root = Path(env_root).expanduser().resolve()
        if (root / "PROJECT_CHARTER.md").exists():
            return root

    current = Path(start or Path.cwd()).expanduser().resolve()
    for candidate in (current, *current.parents):
        if (candidate / "PROJECT_CHARTER.md").exists():
            return candidate

    raise FileNotFoundError(
        "Could not locate Figurer root. Set FIGURER_HOME or run from inside the cloned figurer repository."
    )


def _load_yaml(relative_path: str, root: str | Path | None = None) -> dict[str, Any]:
    try:
        import yaml
    except ImportError as exc:
        raise ImportError("Figurer requires PyYAML: pip install pyyaml") from exc

    base = Path(root).resolve() if root else find_figurer_root()
    path = base / relative_path
    if not path.exists():
        raise FileNotFoundError(f"Missing Figurer config: {path}")
    with path.open("r", encoding="utf-8") as handle:
        return yaml.safe_load(handle)


def profile(name: str = "paper_double_column", root: str | Path | None = None) -> dict[str, Any]:
    cfg = _load_yaml("profiles/output_profiles.yml", root)
    try:
        return cfg["profiles"][name]
    except KeyError as exc:
        raise KeyError(f"Unknown Figurer output profile: {name}") from exc


def theme_tokens(name: str = "journal_clean", root: str | Path | None = None) -> dict[str, Any]:
    cfg = _load_yaml("styles/themes.yml", root)
    try:
        return cfg["themes"][name]
    except KeyError as exc:
        raise KeyError(f"Unknown Figurer theme: {name}") from exc


def palette(name: str = "qualitative_8", root: str | Path | None = None):
    cfg = _load_yaml("styles/palettes.yml", root)
    try:
        return cfg["palettes"][name]["colors"]
    except KeyError as exc:
        raise KeyError(f"Unknown Figurer palette: {name}") from exc


def identities(group: str = "cell_classes", root: str | Path | None = None) -> dict[str, str]:
    cfg = _load_yaml("styles/identities.yml", root)
    try:
        return dict(cfg[group])
    except KeyError as exc:
        raise KeyError(f"Unknown Figurer identity group: {group}") from exc


def apply_figurer_style(
    theme: str = "journal_clean",
    output_profile: str = "paper_double_column",
    root: str | Path | None = None,
) -> None:
    """Apply shared Figurer styling to Matplotlib/Scanpy plots."""
    try:
        import matplotlib as mpl
    except ImportError as exc:
        raise ImportError("Figurer requires matplotlib for Python rendering.") from exc

    t = theme_tokens(theme, root)
    p = profile(output_profile, root)
    line_scale = float(p.get("line_scale", 1.0))

    family = t.get("font_family", "sans")
    mpl_family = "sans-serif" if family in {"sans", "sans-serif"} else family

    mpl.rcParams.update(
        {
            "font.family": mpl_family,
            "font.size": float(p["base_size_pt"]),
            "text.color": t["text_color"],
            "axes.labelcolor": t["text_color"],
            "axes.titlesize": float(p["title_size_pt"]),
            "axes.labelsize": float(p["axis_title_size_pt"]),
            "axes.edgecolor": t["axis_color"],
            "axes.linewidth": float(t["axis_line_width_pt"]) * line_scale,
            "axes.facecolor": t["panel_background"],
            "axes.spines.top": not bool(t.get("despine_top", True)),
            "axes.spines.right": not bool(t.get("despine_right", True)),
            "xtick.color": t["text_color"],
            "ytick.color": t["text_color"],
            "xtick.labelsize": float(p["tick_size_pt"]),
            "ytick.labelsize": float(p["tick_size_pt"]),
            "xtick.major.width": float(t["tick_line_width_pt"]) * line_scale,
            "ytick.major.width": float(t["tick_line_width_pt"]) * line_scale,
            "xtick.major.size": float(t["tick_length_pt"]),
            "ytick.major.size": float(t["tick_length_pt"]),
            "legend.fontsize": float(p["legend_size_pt"]),
            "legend.title_fontsize": float(p["legend_size_pt"]),
            "legend.frameon": bool(t.get("legend_frame", False)),
            "figure.facecolor": t["background"],
            "savefig.facecolor": t["background"],
            "savefig.bbox": "tight",
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
            "svg.fonttype": "none",
        }
    )

    colors = palette("qualitative_8", root)
    if isinstance(colors, list):
        from cycler import cycler

        mpl.rcParams["axes.prop_cycle"] = cycler(color=colors)


def figure_size_inches(
    output_profile: str = "paper_double_column",
    root: str | Path | None = None,
) -> tuple[float, float]:
    p = profile(output_profile, root)
    return float(p["width_mm"]) / 25.4, float(p["height_mm"]) / 25.4


def save_figurer(
    fig,
    filename: str | Path,
    output_profile: str = "paper_double_column",
    root: str | Path | None = None,
    width_mm: float | None = None,
    height_mm: float | None = None,
    dpi: int | None = None,
    **kwargs,
) -> Path:
    """Save a Matplotlib figure using a named physical output profile."""
    p = profile(output_profile, root)
    width_mm = float(width_mm if width_mm is not None else p["width_mm"])
    height_mm = float(height_mm if height_mm is not None else p["height_mm"])
    dpi = int(dpi if dpi is not None else p["dpi"])

    fig.set_size_inches(width_mm / 25.4, height_mm / 25.4, forward=True)

    path = Path(filename)
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=dpi, bbox_inches="tight", **kwargs)
    return path.resolve()
