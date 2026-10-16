"""Convert PNG assets to WebP (same name, new extension) and delete the PNGs.

Usage: python scripts/optimize_assets.py [--keep]
Needs Pillow. Lossy q82 for maps/photos, lossless for icons/sprites/logo.
"""
import sys
from concurrent.futures import ProcessPoolExecutor
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent / "assets" / "imgs"
LOSSY = ["maps", "monsters"]
LOSSLESS = ["item_icons", "monster_icons", "sprites", "logo"]


def convert(job):
    src, lossless, keep = job
    dst = src.with_suffix(".webp")
    with Image.open(src) as im:
        im.load()
        if lossless:
            im.save(dst, "WEBP", lossless=True, quality=100, method=6)
        else:
            im.save(dst, "WEBP", quality=82, method=6)
    if not keep:
        src.unlink()
    return src


if __name__ == "__main__":
    keep = "--keep" in sys.argv
    jobs = [(p, ll, keep)
            for dirs, ll in ((LOSSY, False), (LOSSLESS, True))
            for d in dirs for p in sorted((ROOT / d).rglob("*.png"))]
    with ProcessPoolExecutor() as ex:
        done = sum(1 for _ in ex.map(convert, jobs, chunksize=16))
    print(f"converted {done} files")
