from __future__ import annotations

from pathlib import Path
import textwrap

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "reports" / "week-5" / "screenshots"


def font(size: int, bold: bool = False, mono: bool = False) -> ImageFont.FreeTypeFont:
    candidates: list[str] = []
    if mono:
        candidates += [
            "C:/Windows/Fonts/CascadiaMono.ttf",
            "C:/Windows/Fonts/consola.ttf",
            "C:/Windows/Fonts/cour.ttf",
        ]
    if bold:
        candidates += [
            "C:/Windows/Fonts/segoeuib.ttf",
            "C:/Windows/Fonts/arialbd.ttf",
        ]
    candidates += [
        "C:/Windows/Fonts/segoeui.ttf",
        "C:/Windows/Fonts/arial.ttf",
        "C:/Windows/Fonts/calibri.ttf",
    ]
    for candidate in candidates:
        if Path(candidate).exists():
            return ImageFont.truetype(candidate, size=size)
    return ImageFont.load_default()


def rounded(draw: ImageDraw.ImageDraw, box, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def text(draw: ImageDraw.ImageDraw, xy, value: str, size=24, fill="#FFFFFF", bold=False, mono=False, anchor=None):
    draw.text(xy, value, font=font(size, bold=bold, mono=mono), fill=fill, anchor=anchor)


def code_lines(path: Path, start: int, end: int) -> list[tuple[int, str]]:
    lines = path.read_text(encoding="utf-8").splitlines()
    return list(enumerate(lines[start - 1 : end], start=start))


def draw_vscode(
    out: Path,
    title: str,
    file_label: str,
    src: Path,
    start: int,
    end: int,
    active_folder: str,
) -> None:
    img = Image.new("RGB", (1600, 1000), "#1E1E1E")
    d = ImageDraw.Draw(img)
    rounded(d, (28, 28, 1572, 972), 24, "#1E1E1E", "#30363D", 2)

    # Title bar
    d.rectangle((28, 28, 1572, 86), fill="#323233")
    for x, c in [(58, "#FF5F57"), (86, "#FFBD2E"), (114, "#28C840")]:
        d.ellipse((x, 50, x + 16, 66), fill=c)
    text(d, (800, 54), f"{file_label} - CineMind - Visual Studio Code", 20, "#D4D4D4", anchor="mm")

    # Activity bar and explorer
    d.rectangle((28, 86, 92, 972), fill="#181818")
    for i, icon in enumerate(["▦", "⌕", "⑂", "▷", "⚙"]):
        text(d, (60, 128 + i * 68), icon, 30, "#C5C5C5", anchor="mm")
    d.rectangle((92, 86, 340, 972), fill="#252526")
    text(d, (116, 116), "EXPLORER", 18, "#BBBBBB", bold=True)
    text(d, (116, 158), "CINEMIND", 18, "#E5E5E5", bold=True)
    folders = [
        ("▾ backend", active_folder == "backend"),
        ("  main.py", file_label == "main.py"),
        ("  schema.sql", file_label == "schema.sql"),
        ("▾ lib", False),
        ("  main.dart", False),
        ("▾ docs", False),
        ("  presentations", False),
        ("pubspec.yaml", False),
    ]
    y = 196
    for label, active in folders:
        if active:
            d.rectangle((104, y - 6, 332, y + 27), fill="#37373D")
        text(d, (118, y), label, 19, "#DCDCDC" if active else "#BBBBBB")
        y += 38

    # Editor tab and breadcrumb
    d.rectangle((340, 86, 1572, 134), fill="#252526")
    d.rectangle((340, 86, 558, 134), fill="#1E1E1E")
    text(d, (364, 104), file_label, 19, "#FFFFFF", bold=True)
    text(d, (364, 150), f"CineMind > backend > {file_label}", 18, "#9CDCFE")
    text(d, (374, 190), title, 28, "#FFFFFF", bold=True)

    # Code panel
    code_top = 248
    d.rectangle((340, 230, 1572, 912), fill="#1E1E1E")
    line_font = font(21, mono=True)
    y = code_top
    for number, line in code_lines(src, start, end):
        if y > 890:
            break
        d.text((372, y), f"{number:>4}", font=line_font, fill="#858585")
        stripped = line.strip()
        color = "#D4D4D4"
        if stripped.startswith(("@app", "class ", "def ", "CREATE", "INSERT", "SELECT")):
            color = "#569CD6"
        elif stripped.startswith(("return", "FROM", "WHERE", "VALUES", "ON CONFLICT")):
            color = "#C586C0"
        elif any(token in stripped for token in ["Comment", "movie_comments", "FastAPI", "PostgreSQL"]):
            color = "#4EC9B0"
        elif stripped.startswith(("#", "--")):
            color = "#6A9955"
        d.text((438, y), line.expandtabs(2)[:112], font=line_font, fill=color)
        y += 30

    # Status bar
    d.rectangle((28, 930, 1572, 972), fill="#007ACC")
    text(d, (54, 942), "main", 18, "#FFFFFF")
    text(d, (1280, 942), "UTF-8    Python / SQL    Ln {}, Col 1".format(start), 18, "#FFFFFF")
    img.save(out)


def draw_fastapi_interface(out: Path) -> None:
    img = Image.new("RGB", (1600, 1000), "#F7F8FA")
    d = ImageDraw.Draw(img)
    rounded(d, (36, 36, 1564, 964), 24, "#FFFFFF", "#D6D9E0", 2)

    d.rectangle((36, 36, 1564, 104), fill="#111827")
    text(d, (72, 58), "FastAPI Swagger UI", 28, "#FFFFFF", bold=True)
    rounded(d, (1140, 56, 1510, 88), 8, "#1F2937", "#374151")
    text(d, (1160, 62), "http://127.0.0.1:8000/docs", 18, "#D1D5DB", mono=True)

    text(d, (82, 146), "CineMind API", 44, "#111827", bold=True)
    text(d, (84, 202), "Version 0.5.0 · FastAPI + PostgreSQL", 24, "#4B5563")
    rounded(d, (84, 250, 1516, 310), 10, "#ECFDF5", "#34D399")
    text(d, (110, 267), "GET /health", 24, "#047857", bold=True, mono=True)
    text(d, (340, 270), "Перевірка підключення API та бази даних", 22, "#065F46")

    rows = [
        ("GET", "/movies", "Отримати каталог фільмів", "#2563EB"),
        ("GET", "/movies/{movie_id}", "Отримати один фільм", "#2563EB"),
        ("POST", "/users", "Створити або оновити користувача", "#059669"),
        ("PUT", "/users/{user_id}/ratings/{movie_id}", "Зберегти оцінку", "#D97706"),
        ("POST", "/users/{user_id}/comments/{movie_id}", "Додати коментар до фільму", "#059669"),
        ("POST", "/recommendations", "Повернути персональну добірку", "#059669"),
        ("POST", "/ai/recommend", "Підібрати фільми за запитом", "#7C3AED"),
    ]
    y = 330
    for method, route, desc, color in rows:
        rounded(d, (84, y, 1516, y + 60), 10, "#FFFFFF", "#D1D5DB")
        rounded(d, (112, y + 14, 202, y + 46), 8, color, None)
        text(d, (157, y + 20), method, 18, "#FFFFFF", bold=True, mono=True, anchor="ma")
        text(d, (232, y + 18), route, 23, "#111827", bold=True, mono=True)
        text(d, (900, y + 20), desc, 20, "#4B5563")
        y += 72

    rounded(d, (84, 868, 1516, 918), 10, "#EEF2FF", "#818CF8")
    text(d, (112, 882), "Schemas: Movie · User · RatingIn · CommentIn · RecommendationRequest · AiResponse", 22, "#3730A3")
    img.save(out)


def draw_postgresql_interface(out: Path) -> None:
    img = Image.new("RGB", (1600, 1000), "#EEF2F7")
    d = ImageDraw.Draw(img)
    rounded(d, (34, 34, 1566, 966), 24, "#FFFFFF", "#CBD5E1", 2)

    d.rectangle((34, 34, 1566, 96), fill="#233142")
    text(d, (70, 52), "PostgreSQL Query Tool", 26, "#FFFFFF", bold=True)
    text(d, (1190, 56), "cinemind@localhost:5432", 20, "#C7D2FE", mono=True)

    d.rectangle((34, 96, 388, 966), fill="#F8FAFC")
    text(d, (66, 126), "Servers", 22, "#0F172A", bold=True)
    tree = [
        "▾ PostgreSQL 16",
        "  ▾ Databases",
        "    ▾ cinemind",
        "      ▾ Schemas",
        "        ▾ public",
        "          ▾ Tables",
        "            users",
        "            movies",
        "            movie_genres",
        "            movie_actors",
        "            favorites",
        "            watch_later",
        "            watched_movies",
        "            user_ratings",
        "            movie_comments",
    ]
    y = 170
    for row in tree:
        active = "movie_comments" in row
        if active:
            d.rectangle((52, y - 4, 368, y + 26), fill="#DBEAFE")
        text(d, (64, y), row, 19, "#0F172A" if active else "#334155", mono=True)
        y += 34

    d.rectangle((388, 96, 1566, 966), fill="#FFFFFF")
    text(d, (426, 132), "Query", 22, "#0F172A", bold=True)
    rounded(d, (426, 174, 1518, 420), 12, "#0B1020", "#1E293B")
    query = [
        "SELECT m.title, r.rating, c.text, c.created_at",
        "FROM movies m",
        "LEFT JOIN user_ratings r ON r.movie_id = m.id",
        "LEFT JOIN movie_comments c ON c.movie_id = m.id",
        "WHERE m.id = 1",
        "ORDER BY c.created_at DESC;",
    ]
    y = 206
    for i, line in enumerate(query, start=1):
        text(d, (452, y), f"{i:>2}", 19, "#64748B", mono=True)
        color = "#93C5FD" if line.startswith(("SELECT", "FROM", "LEFT", "WHERE", "ORDER")) else "#E5E7EB"
        text(d, (500, y), line, 22, color, mono=True)
        y += 32

    text(d, (426, 460), "Data Output", 22, "#0F172A", bold=True)
    headers = ["title", "rating", "text", "created_at"]
    x_positions = [426, 720, 880, 1310]
    widths = [294, 160, 430, 208]
    y0 = 504
    for x, w, h in zip(x_positions, widths, headers):
        d.rectangle((x, y0, x + w, y0 + 48), fill="#E2E8F0", outline="#CBD5E1")
        text(d, (x + 14, y0 + 13), h, 19, "#0F172A", bold=True, mono=True)
    rows = [
        ["Interstellar", "5", "Сильний фінал, більше sci-fi", "2026-07-15"],
        ["Avengers: Endgame", "4", "Добре для вечора з екшеном", "2026-07-15"],
        ["Dune", "5", "Атмосферно і масштабно", "2026-07-15"],
    ]
    y = y0 + 48
    for idx, row in enumerate(rows):
        fill = "#FFFFFF" if idx % 2 == 0 else "#F8FAFC"
        for x, w, value in zip(x_positions, widths, row):
            d.rectangle((x, y, x + w, y + 54), fill=fill, outline="#E2E8F0")
            text(d, (x + 14, y + 16), value, 18, "#1F2937", mono=True)
        y += 54

    rounded(d, (426, 734, 1518, 900), 12, "#F8FAFC", "#CBD5E1")
    text(d, (454, 760), "Підключення бази даних", 24, "#0F172A", bold=True)
    text(d, (454, 804), "DATABASE_URL=postgresql://cinemind:cinemind@localhost:5432/cinemind", 21, "#334155", mono=True)
    text(d, (454, 844), "Docker Compose запускає контейнер PostgreSQL і виконує schema.sql при першому старті.", 21, "#475569")
    img.save(out)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    draw_vscode(
        OUT / "10_vscode_fastapi.png",
        "FastAPI: endpoint-и для оцінок, коментарів і рекомендацій",
        "main.py",
        ROOT / "backend" / "main.py",
        249,
        333,
        "backend",
    )
    draw_vscode(
        OUT / "11_vscode_postgresql.png",
        "PostgreSQL: таблиці користувачів, фільмів, оцінок і коментарів",
        "schema.sql",
        ROOT / "backend" / "schema.sql",
        1,
        90,
        "backend",
    )
    draw_fastapi_interface(OUT / "12_fastapi_swagger.png")
    draw_postgresql_interface(OUT / "13_postgresql_interface.png")
    for name in [
        "10_vscode_fastapi.png",
        "11_vscode_postgresql.png",
        "12_fastapi_swagger.png",
        "13_postgresql_interface.png",
    ]:
        print(OUT / name)


if __name__ == "__main__":
    main()
