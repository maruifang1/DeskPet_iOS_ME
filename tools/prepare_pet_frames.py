"""Turn raw generated pet frames into transparent widget assets.

Raw frames are expected at tools/raw/frame.<mood>.png on a solid green
background. This script keys out the green, trims, centers each character
on a 600x600 transparent canvas, writes it into the matching imageset, and
updates that imageset's Contents.json. It also builds a preview sheet.

Requires Pillow.
"""

import json
import math
from pathlib import Path

from PIL import Image, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = ROOT / "tools" / "raw"
ASSET_DIR = ROOT / "PetAssets" / "PetAssets.xcassets"
CANVAS = 600
FRAMES = [
    "morning",
    "noon",
    "afternoon",
    "evening",
    "night",
    "charging",
    "lowBattery",
    "reactHappy",
    "reactSurprised",
    "reactSleepy",
]


def key_out_green(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if g > r + 30 and g > b + 30 and g > 110:
                pixels[x, y] = (r, g, b, 0)

    alpha = rgba.getchannel("A")
    alpha = alpha.filter(ImageFilter.GaussianBlur(1.2))
    rgba.putalpha(alpha)
    return rgba


def trim_and_center(image: Image.Image) -> Image.Image:
    alpha = image.getchannel("A")
    bbox = alpha.getbbox()
    if bbox is None:
        return Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))

    pad = 14
    left, top, right, bottom = bbox
    left = max(0, left - pad)
    top = max(0, top - pad)
    right = min(image.width, right + pad)
    bottom = min(image.height, bottom + pad)
    cropped = image.crop((left, top, right, bottom))

    max_side = CANVAS - 48
    scale = min(max_side / cropped.width, max_side / cropped.height)
    new_size = (
        max(1, math.ceil(cropped.width * scale)),
        max(1, math.ceil(cropped.height * scale)),
    )
    cropped = cropped.resize(new_size, Image.LANCZOS)

    canvas = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
    offset = ((CANVAS - cropped.width) // 2, (CANVAS - cropped.height) // 2)
    canvas.alpha_composite(cropped, offset)
    return canvas


def update_imageset(mood: str, frame: Image.Image) -> None:
    imageset = ASSET_DIR / f"frame.{mood}.imageset"
    filename = f"frame.{mood}.png"
    frame.save(imageset / filename, "PNG")

    contents_path = imageset / "Contents.json"
    contents = json.loads(contents_path.read_text(encoding="utf-8"))
    entry = {
        "filename": filename,
        "idiom": "universal",
        "scale": "1x",
    }
    contents["images"] = [entry]
    contents_path.write_text(
        json.dumps(contents, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def build_preview(frames: dict[str, Image.Image]) -> Path:
    cols = 5
    rows = math.ceil(len(frames) / cols)
    cell = 220
    sheet = Image.new("RGBA", (cols * cell, rows * cell), (24, 24, 26, 255))
    for index, (mood, frame) in enumerate(frames.items()):
        thumb = frame.copy()
        thumb.thumbnail((cell - 24, cell - 24), Image.LANCZOS)
        x = (index % cols) * cell + (cell - thumb.width) // 2
        y = (index // cols) * cell + (cell - thumb.height) // 2
        sheet.alpha_composite(thumb, (x, y))
    preview = ROOT / "reference" / "frames-preview.png"
    sheet.convert("RGB").save(preview, "PNG")
    return preview


def main() -> None:
    frames: dict[str, Image.Image] = {}
    for mood in FRAMES:
        raw = RAW_DIR / f"frame.{mood}.png"
        if not raw.exists():
            continue
        frame = trim_and_center(key_out_green(Image.open(raw)))
        update_imageset(mood, frame)
        frames[mood] = frame
        print(f"PREPARED={mood}")

    if not frames:
        print("no raw frames found")
        return

    preview = build_preview(frames)
    print(f"PREVIEW={preview}")


if __name__ == "__main__":
    main()
