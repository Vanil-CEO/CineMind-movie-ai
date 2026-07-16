from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "posters"
OUT.mkdir(parents=True, exist_ok=True)


def font(size, bold=False):
    fonts = Path(r"C:\Windows\Fonts")
    for name in (
        "segoeuib.ttf" if bold else "segoeui.ttf",
        "arialbd.ttf" if bold else "arial.ttf",
        "calibrib.ttf" if bold else "calibri.ttf",
    ):
        path = fonts / name
        if path.exists():
            return ImageFont.truetype(str(path), size)
    return ImageFont.load_default()


def rgb(value):
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


POSTERS = [
    ("endgame", "AVENGERS:\nENDGAME", "Whatever it takes.", "12+", ["#2B163F", "#942315", "#FF7A00"]),
    ("spiderman", "SPIDER-MAN:\nNO WAY\nHOME", "The multiverse\nopens.", "12+", ["#3B0710", "#E11D48", "#0A84FF"]),
    ("dune", "DUNE", "Fear is the mind-\nkiller.", "12+", ["#20130D", "#A16207", "#FFD60A"]),
    ("interstellar", "INTERSTELL\nAR", "Beyond time.\nBeyond Earth.", "12+", ["#041A2E", "#0A84FF", "#66D4CF"]),
    ("inception", "INCEPTION", "Your mind is the\nscene.", "16+", ["#0B1020", "#5E5CE6", "#BF5AF2"]),
    ("martian", "THE\nMARTIAN", "Bring him home.", "12+", ["#361207", "#C2410C", "#FF9F0A"]),
    ("john_wick", "JOHN WICK", "No rules. No mercy.", "18+", ["#050509", "#2C2C2E", "#8E8E93"]),
]


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def make(slug, title, subtitle, maturity, colors):
    width, height = 720, 1040
    c0, c1, c2 = map(rgb, colors)
    img = Image.new("RGB", (width, height), c0)
    draw = ImageDraw.Draw(img)

    for y in range(height):
        t = y / (height - 1)
        base = lerp(c0, c1, min(t / 0.62, 1)) if t < 0.62 else lerp(c1, c2, (t - 0.62) / 0.38)
        vignette = 1 - abs((y / height) - 0.42) * 0.22
        draw.line((0, y, width, y), fill=tuple(int(v * vignette) for v in base))

    overlay = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    o = ImageDraw.Draw(overlay)
    o.rounded_rectangle((0, 0, width - 1, height - 1), radius=48, outline=(255, 255, 255, 34), width=2)
    o.ellipse((-180, -120, 520, 560), fill=(255, 255, 255, 30))
    o.ellipse((260, 580, 980, 1240), fill=(*c2, 62))
    o.rectangle((0, 0, width, 290), fill=(255, 255, 255, 10))
    overlay = overlay.filter(ImageFilter.GaussianBlur(16))
    img = Image.alpha_composite(img.convert("RGBA"), overlay)
    draw = ImageDraw.Draw(img)

    # iOS-style soft top shine
    shine = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    s = ImageDraw.Draw(shine)
    s.rounded_rectangle((26, 22, width - 26, 350), radius=44, fill=(255, 255, 255, 18))
    shine = shine.filter(ImageFilter.GaussianBlur(22))
    img = Image.alpha_composite(img, shine)
    draw = ImageDraw.Draw(img)

    draw.rounded_rectangle((34, 34, 150, 86), radius=26, fill=(0, 0, 0, 150))
    draw.text((92, 60), maturity, anchor="mm", font=font(24, True), fill=(255, 255, 255, 232))

    for row in range(7):
        for col in range(7):
            radius = 5 + row * 1.1
            x = width - 216 + col * 31
            y = 52 + row * 35
            alpha = 58 - row * 3
            draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=(255, 255, 255, alpha))

    y = 615
    for line in title.split("\n"):
        draw.text((72, y), line, font=font(62, True), fill=(255, 255, 255, 246))
        y += 66
    y += 18
    for line in subtitle.split("\n"):
        draw.text((74, y), line, font=font(29, True), fill=(255, 255, 255, 218))
        y += 37

    draw.text((74, height - 76), "CINEMIND", font=font(19, True), fill=(255, 255, 255, 130))
    img.convert("RGB").save(OUT / f"{slug}.png", quality=96)


for item in POSTERS:
    make(*item)
