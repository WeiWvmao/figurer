# Run from the figurer repository root.
from pathlib import Path
import os
import sys

ROOT = Path.cwd().resolve()
os.environ["FIGURER_HOME"] = str(ROOT)
sys.path.insert(0, str(ROOT / "python"))

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from figurer_style import apply_figurer_style, save_figurer
from recipes_core import embedding_categorical

apply_figurer_style("journal_clean", "paper_double_column")

rng = np.random.default_rng(1)
data = pd.DataFrame(
    {
        "x": np.r_[rng.normal(-1, 0.6, 250), rng.normal(1, 0.7, 250)],
        "y": np.r_[rng.normal(0, 0.8, 250), rng.normal(0.5, 0.8, 250)],
        "cell_type": ["Myeloid"] * 250 + ["EC"] * 250,
    }
)

fig, ax = plt.subplots()
embedding_categorical(
    data,
    "x",
    "y",
    "cell_type",
    ax=ax,
    identity_colors=True,
    point_size=8,
)
ax.legend(title="Cell type", markerscale=1.5, loc="best")

save_figurer(fig, ROOT / "gallery" / "quickstart_python.pdf")
