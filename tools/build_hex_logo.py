"""Design a proper recruitR hex from the package's own two assets.

recruitR ships no usable hex. `data-raw/money_hex.png` is a money photo in a
hex mask with no wordmark; `data-raw/logo-transparent.png` is poker chips with
no wordmark; `man/figures/logo.png` is a 240x210 non-hex raster. In the hex
wall the money hex reads as an unlabelled grey-green texture.

The two ideas are combined: money as the field, chips as the subject. The
money photo is high-contrast and full of faces and serial numbers, so as-is it
competes with everything laid over it. It is darkened and green-tinted into a
texture, and the chips get a drop shadow to lift them off it.

Geometry follows the SDV hex spec, built as two filled polygons rather than a
stroked path (a stroke sits half outside its path and its joins push further,
which is how softballR's hex ended up clipped): outer circumradius sized to
stay on canvas, inner inset by the inradius for an exact border width.
"""

import math
import pathlib

from PIL import Image, ImageDraw, ImageFilter, ImageFont

SRC = pathlib.Path("C:/Users/saiem/Documents/GitHub-Data/sdv-dev/recruitR-dev/recruitR")
OUT = pathlib.Path(__file__).parent
CHIVO = "C:/Users/saiem/AppData/Local/Microsoft/Windows/Fonts/Chivo-VariableFont_wght.ttf"
INTER = "C:/Windows/Fonts/Inter-SemiBold.ttf"

SS = 3  # supersample, then downsample
W, H = 1036, 1200
CX, CY = W / 2, H / 2
R_OUT = 594.0  # 518 +/- 514.4 -> stays on canvas
BORDER = 18.0  # 9px at the 518x600 master size
R_IN = R_OUT - BORDER / (math.sqrt(3) / 2)

FELT = (17, 66, 42)  # card-table green, the border
GOLD = (206, 168, 68)


def hexagon(cx, cy, r):
    return [
        (
            cx + r * math.cos(math.radians(90 + 60 * k)),
            cy - r * math.sin(math.radians(90 + 60 * k)),
        )
        for k in range(6)
    ]


def build(scale):
    w, h = int(W * scale), int(H * scale)
    cx, cy = CX * scale, CY * scale

    card = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(card)
    d.polygon(hexagon(cx, cy, R_OUT * scale), fill=FELT + (255,))

    # --- field: the money photo, dimmed and tinted into a texture -----------
    money = Image.open(SRC / "data-raw/money_hex.png").convert("RGBA")
    money = money.resize((w, h), Image.LANCZOS).convert("RGB")
    scrim = Image.new("RGB", (w, h), (10, 40, 24))
    money = Image.blend(money, scrim, 0.62)

    inner = Image.new("L", (w, h), 0)
    ImageDraw.Draw(inner).polygon(hexagon(cx, cy, R_IN * scale), fill=255)
    card.paste(money, (0, 0), inner)

    # --- subject: the chips, with a shadow so they lift off the field -------
    chips = Image.open(SRC / "data-raw/logo-transparent.png").convert("RGBA")
    cw = int(w * 0.60)
    chips = chips.resize((cw, int(chips.height * cw / chips.width)), Image.LANCZOS)
    cxp, cyp = int((w - chips.width) / 2), int(h * 0.425)

    shadow = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    shadow.paste(
        Image.new("RGBA", chips.size, (0, 0, 0, 150)),
        (cxp, cyp + int(h * 0.012)),
        chips,
    )
    card.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(int(9 * scale))))
    card.alpha_composite(chips, (cxp, cyp))

    # --- wordmark -----------------------------------------------------------
    d = ImageDraw.Draw(card)
    f = ImageFont.truetype(CHIVO, int(w * 0.150))
    f.set_variation_by_axes([900])
    text = "recruitR"
    tw = d.textlength(text, font=f)
    d.text(
        ((w - tw) / 2, h * 0.175),
        text,
        font=f,
        fill=(255, 255, 255),
        stroke_width=int(w * 0.011),
        stroke_fill=(6, 26, 15),
    )

    # a gold rule under the wordmark, echoing the chips' stacked edges
    rw = int(w * 0.20)
    ry = int(h * 0.345)
    d.rectangle([cx - rw, ry, cx + rw, ry + max(2, int(5 * scale))], fill=GOLD)

    # No URL: most of the SDV hexes carry none, and a hex is small enough in
    # use that a domain line only adds noise.

    return card.resize((W, H), Image.LANCZOS) if scale != 1 else card


if __name__ == "__main__":
    hexi = build(SS)
    hexi.save(OUT / "recruitR_hex.png")
    hexi.resize((518, 600), Image.LANCZOS).save(OUT / "recruitR_hex_518.png")
    print(f"wrote recruitR_hex.png {hexi.size} ratio={hexi.size[0] / hexi.size[1]:.3f}")
