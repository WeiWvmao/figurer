"""First lightweight Figurer recipes for Python.

These functions accept ordinary pandas-like tables and column names. They are
small convenience recipes, not a new plotting framework.
"""

from __future__ import annotations

from collections.abc import Mapping
from typing import Any

from figurer_style import identities, palette


def _plt():
    try:
        import matplotlib.pyplot as plt
    except ImportError as exc:
        raise ImportError("Figurer Python recipes require matplotlib.") from exc
    return plt


def _categorical_colors(categories, identity_colors=False, root=None):
    cats = list(categories)
    if identity_colors:
        ids = identities("cell_classes", root)
        fallback = "#B7B7B7"
        return {cat: ids.get(str(cat), fallback) for cat in cats}

    colors = list(palette("qualitative_12", root))
    return {cat: colors[i % len(colors)] for i, cat in enumerate(cats)}


def embedding_categorical(
    data,
    x: str,
    y: str,
    group: str,
    *,
    ax=None,
    point_size: float = 4,
    alpha: float = 0.85,
    identity_colors: bool = False,
    color_map: Mapping[Any, str] | None = None,
    equal_aspect: bool = True,
    show_axes: bool = False,
    rasterized: bool | None = None,
    root=None,
):
    """Categorical UMAP/t-SNE/coordinate scatter with stable category colors."""
    plt = _plt()
    if ax is None:
        _, ax = plt.subplots()

    categories = list(dict.fromkeys(data[group].tolist()))
    colors = dict(color_map) if color_map is not None else _categorical_colors(
        categories, identity_colors=identity_colors, root=root
    )

    if rasterized is None:
        rasterized = len(data) >= 50_000

    for cat in categories:
        mask = data[group] == cat
        ax.scatter(
            data.loc[mask, x],
            data.loc[mask, y],
            s=point_size,
            alpha=alpha,
            c=colors.get(cat, "#B7B7B7"),
            linewidths=0,
            label=str(cat),
            rasterized=rasterized,
        )

    if equal_aspect:
        ax.set_aspect("equal", adjustable="datalim")
    if not show_axes:
        ax.set_axis_off()

    return ax


def embedding_continuous(
    data,
    x: str,
    y: str,
    value: str,
    *,
    ax=None,
    point_size: float = 4,
    alpha: float = 0.9,
    color_palette: str = "sequential_viridis_like",
    equal_aspect: bool = True,
    show_axes: bool = False,
    rasterized: bool | None = None,
    add_colorbar: bool = True,
    root=None,
):
    """Continuous embedding/spatial scatter using a Figurer sequential palette."""
    plt = _plt()
    from matplotlib.colors import LinearSegmentedColormap

    if ax is None:
        _, ax = plt.subplots()
    if rasterized is None:
        rasterized = len(data) >= 50_000

    cmap = LinearSegmentedColormap.from_list(
        f"figurer_{color_palette}", list(palette(color_palette, root))
    )

    sc = ax.scatter(
        data[x],
        data[y],
        c=data[value],
        s=point_size,
        alpha=alpha,
        cmap=cmap,
        linewidths=0,
        rasterized=rasterized,
    )

    if equal_aspect:
        ax.set_aspect("equal", adjustable="datalim")
    if not show_axes:
        ax.set_axis_off()
    if add_colorbar:
        ax.figure.colorbar(sc, ax=ax, fraction=0.045, pad=0.02)

    return ax


def spatial_categorical(
    data,
    x: str,
    y: str,
    group: str,
    *,
    image=None,
    image_extent=None,
    image_alpha: float = 1.0,
    invert_y: bool = True,
    ax=None,
    point_size: float = 5,
    point_alpha: float = 0.8,
    identity_colors: bool = True,
    color_map: Mapping[Any, str] | None = None,
    rasterized: bool | None = None,
    root=None,
):
    """Categorical spatial map with optional histology/image background."""
    plt = _plt()
    if ax is None:
        _, ax = plt.subplots()

    if image is not None:
        ax.imshow(image, extent=image_extent, alpha=image_alpha)

    embedding_categorical(
        data,
        x,
        y,
        group,
        ax=ax,
        point_size=point_size,
        alpha=point_alpha,
        identity_colors=identity_colors,
        color_map=color_map,
        equal_aspect=True,
        show_axes=False,
        rasterized=rasterized,
        root=root,
    )

    if invert_y:
        ax.invert_yaxis()

    return ax


def adjacency_heatmap(
    matrix,
    *,
    labels=None,
    ax=None,
    color_palette: str = "diverging_blue_red",
    center: float = 0.0,
    annotate: bool = True,
    fmt: str = ".1f",
    root=None,
):
    """Small adjacency/effect matrix heatmap; for complex annotations prefer ComplexHeatmap/Marsilea."""
    plt = _plt()
    import numpy as np
    from matplotlib.colors import LinearSegmentedColormap, TwoSlopeNorm

    arr = np.asarray(matrix)
    if ax is None:
        _, ax = plt.subplots()

    cmap = LinearSegmentedColormap.from_list(
        f"figurer_{color_palette}", list(palette(color_palette, root))
    )
    finite = arr[np.isfinite(arr)]
    vmax = float(np.max(np.abs(finite - center))) if finite.size else 1.0
    norm = TwoSlopeNorm(vmin=center - vmax, vcenter=center, vmax=center + vmax)

    im = ax.imshow(arr, cmap=cmap, norm=norm, aspect="equal")

    if labels is not None:
        ax.set_xticks(range(len(labels)), labels=labels, rotation=45, ha="right")
        ax.set_yticks(range(len(labels)), labels=labels)

    if annotate:
        threshold = center + vmax * 0.5
        for i in range(arr.shape[0]):
            for j in range(arr.shape[1]):
                value = arr[i, j]
                if np.isfinite(value):
                    text_color = "white" if abs(value - center) > abs(threshold - center) else "black"
                    ax.text(j, i, format(value, fmt), ha="center", va="center", color=text_color)

    ax.figure.colorbar(im, ax=ax, fraction=0.045, pad=0.02)
    return ax
