import fs from 'node:fs/promises';
import path from 'node:path';
import {
  Presentation,
  PresentationFile,
} from 'file:///C:/Users/ivanz/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs';

const root = 'C:/Users/ivanz/OneDrive/Documents/CineMind/week5';
const outDir = path.join(root, 'docs/presentations');
const previewDir = path.join(outDir, 'preview');
const finalPptx = path.join(outDir, 'CineMind_захист_проєкту.pptx');
const shots = path.join(root, 'docs/reports/week-5/screenshots');

const W = 1280;
const H = 720;
const page = { left: 58, top: 48, width: 1164, height: 624 };

const colors = {
  ink: '#02040A',
  panel: '#101218',
  panel2: '#171A23',
  line: '#2B3140',
  blue: '#0A84FF',
  mint: '#66D4CF',
  jade: '#30D158',
  amber: '#FFD60A',
  coral: '#FF453A',
  violet: '#BF5AF2',
  white: '#F7F8FF',
  muted: '#A9B0C2',
};

async function bytes(file) {
  const data = await fs.readFile(file);
  return data.buffer.slice(data.byteOffset, data.byteOffset + data.byteLength);
}

function addBg(slide) {
  slide.background.fill = colors.ink;
  slide.shapes.add({
    geometry: 'rect',
    position: { left: 0, top: 0, width: W, height: H },
    fill: {
      color: colors.ink,
      transparency: 0,
    },
    line: { style: 'solid', fill: 'none', width: 0 },
  });
  slide.shapes.add({
    geometry: 'rect',
    position: { left: 0, top: 0, width: W, height: H },
    fill: {
      color: '#07111E',
      transparency: 18,
    },
    line: { style: 'solid', fill: 'none', width: 0 },
  });
}

function text(slide, value, x, y, w, h, opts = {}) {
  const box = slide.shapes.add({
    geometry: 'textbox',
    position: { left: x, top: y, width: w, height: h },
    fill: 'none',
    line: { style: 'solid', fill: 'none', width: 0 },
  });
  box.text = value;
  box.text.style = {
    fontSize: opts.size ?? 24,
    bold: opts.bold ?? false,
    color: opts.color ?? colors.white,
    alignment: opts.align ?? 'left',
  };
  return box;
}

function title(slide, value, subtitle) {
  text(slide, 'CineMind', page.left, 34, 220, 28, {
    size: 18,
    bold: true,
    color: colors.mint,
  });
  text(slide, value, page.left, 74, 760, 92, {
    size: 40,
    bold: true,
  });
  if (subtitle) {
    text(slide, subtitle, page.left, 188, 820, 52, {
      size: 20,
      color: colors.muted,
    });
  }
}

function card(slide, x, y, w, h, opts = {}) {
  return slide.shapes.add({
    geometry: 'roundRect',
    position: { left: x, top: y, width: w, height: h },
    fill: opts.fill ?? colors.panel,
    line: { style: 'solid', fill: opts.line ?? colors.line, width: 1 },
    borderRadius: 'rounded-xl',
    shadow: 'shadow-sm',
  });
}

function pill(slide, value, x, y, w, color = colors.blue) {
  card(slide, x, y, w, 34, {
    fill: '#0B1220',
    line: color,
  });
  text(slide, value, x + 12, y + 7, w - 24, 18, {
    size: 14,
    bold: true,
    color,
    align: 'center',
  });
}

async function image(slide, file, x, y, w, h, fit = 'cover') {
  slide.images.add({
    blob: await bytes(file),
    contentType: 'image/png',
    alt: path.basename(file),
    fit,
    position: { left: x, top: y, width: w, height: h },
    geometry: 'roundRect',
    borderRadius: 'rounded-xl',
  });
}

function bullets(slide, items, x, y, w, gap = 54) {
  items.forEach((item, idx) => {
    const top = y + idx * gap;
    card(slide, x, top, 34, 34, { fill: '#0B1822', line: colors.mint });
    text(slide, String(idx + 1), x, top + 7, 34, 18, {
      size: 14,
      bold: true,
      color: colors.mint,
      align: 'center',
    });
    text(slide, item, x + 48, top + 2, w - 48, 44, {
      size: 18,
      color: colors.white,
    });
  });
}

function metric(slide, value, label, x, y, w, color) {
  card(slide, x, y, w, 104, { fill: colors.panel2, line: color });
  text(slide, value, x + 16, y + 16, w - 32, 34, {
    size: 30,
    bold: true,
    color,
  });
  text(slide, label, x + 16, y + 58, w - 32, 30, {
    size: 15,
    color: colors.muted,
  });
}

function arrow(slide, x, y) {
  text(slide, '→', x, y, 34, 34, {
    size: 28,
    bold: true,
    color: colors.mint,
    align: 'center',
  });
}

async function build() {
  await fs.mkdir(outDir, { recursive: true });
  await fs.mkdir(previewDir, { recursive: true });

  const deck = Presentation.create({ slideSize: { width: W, height: H } });

  {
    const s = deck.slides.add();
    addBg(s);
    text(s, 'CineMind', 72, 96, 600, 70, {
      size: 58,
      bold: true,
      color: colors.white,
    });
    text(
      s,
      'Мобільний застосунок для персональних рекомендацій фільмів',
      74,
      172,
      680,
      64,
      { size: 26, color: colors.muted },
    );
    pill(s, 'Flutter', 76, 266, 110, colors.blue);
    pill(s, 'FastAPI', 198, 266, 110, colors.mint);
    pill(s, 'PostgreSQL', 320, 266, 142, colors.jade);
    pill(s, 'AI-сервіс', 474, 266, 118, colors.violet);
    await image(
      s,
      path.join(shots, '02_cinematic_home.png'),
      760,
      72,
      408,
      548,
      'contain',
    );
    text(s, 'Захист проєкту · тиждень 5', 76, 606, 500, 28, {
      size: 18,
      color: colors.mint,
      bold: true,
    });
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'Ідея проєкту: персональні рекомендації фільмів',
      'У 5 тижні я доробив інтерфейс, списки, оцінки, коментарі, профіль і підключення backend-частини.',
    );
    metric(s, '7', 'фільмів у seed-каталозі', 74, 260, 240, colors.blue);
    metric(s, '9', 'таблиць PostgreSQL', 334, 260, 240, colors.jade);
    metric(s, '7', 'FastAPI endpoint-ів', 594, 260, 240, colors.mint);
    metric(s, 'AI', 'підбір за смаком', 854, 260, 240, colors.violet);
    bullets(
      s,
      [
        'Переробив головний екран у темному стилі з афішами, великим банером і нижньою навігацією.',
        'Додав рейтинги, коментарі, профіль із фото, списки “обране / пізніше / переглянуто”.',
        'Підготував backend на FastAPI та PostgreSQL-схему для збереження даних.',
      ],
      86,
      430,
      1020,
      58,
    );
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'Архітектура застосунку',
      'Дані проходять від Flutter-інтерфейсу до FastAPI, зберігаються в PostgreSQL і використовуються для рекомендацій.',
    );
    const nodes = [
      ['Flutter UI', 'екрани, анімації, профіль', colors.blue],
      ['FastAPI', 'REST endpoint-и', colors.mint],
      ['PostgreSQL', 'каталог і дії користувача', colors.jade],
      ['AI-сервіс', 'підбір фільмів', colors.violet],
    ];
    nodes.forEach((node, i) => {
      const x = 80 + i * 284;
      card(s, x, 282, 210, 150, { fill: colors.panel2, line: node[2] });
      text(s, node[0], x + 18, 310, 174, 32, {
        size: 24,
        bold: true,
        color: node[2],
        align: 'center',
      });
      text(s, node[1], x + 18, 356, 174, 48, {
        size: 16,
        color: colors.muted,
        align: 'center',
      });
      if (i < nodes.length - 1) arrow(s, x + 228, 336);
    });
    text(
      s,
      'Приклад: користувач ставить 5 зірок Interstellar → FastAPI приймає PUT /ratings → PostgreSQL оновлює user_ratings → рекомендації змінюються під цей смак.',
      122,
      510,
      1030,
      58,
      { size: 20, color: colors.white, align: 'center' },
    );
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'PostgreSQL зберігає каталог і поведінку користувача',
      'База даних розділена на сутності фільмів, жанрів, акторів і користувацьких дій.',
    );
    await image(s, path.join(shots, '13_postgresql_interface.png'), 72, 238, 540, 380, 'contain');
    bullets(
      s,
      [
        'Основні таблиці: users, movies, movie_genres, movie_actors.',
        'Дії користувача: favorites, watch_later, watched_movies, user_ratings.',
        'Додано movie_comments для збереження відгуків користувача до фільмів.',
        'Запуск через Docker Compose: PostgreSQL + змінна DATABASE_URL для FastAPI.',
      ],
      660,
      248,
      500,
      68,
    );
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'FastAPI став шаром між додатком і PostgreSQL',
      'API приймає дії користувача, перевіряє дані через Pydantic і повертає готові відповіді для інтерфейсу.',
    );
    await image(s, path.join(shots, '12_fastapi_swagger.png'), 72, 240, 548, 370, 'contain');
    const endpoints = [
      'GET /health',
      'GET /movies',
      'POST /users',
      'PUT /ratings',
      'POST /comments',
      'POST /recommendations',
      'POST /ai/recommend',
    ];
    endpoints.forEach((ep, i) => {
      const x = 660 + (i % 2) * 250;
      const y = 242 + Math.floor(i / 2) * 74;
      card(s, x, y, 224, 50, { fill: '#07131F', line: i % 2 ? colors.mint : colors.blue });
      text(s, ep, x + 12, y + 15, 200, 20, {
        size: 14,
        bold: true,
        color: colors.white,
      });
    });
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'Рекомендації залежать від дій користувача',
      'Підбір фільмів враховує запит, жанрові смаки, оцінки, переглянуті фільми і коментарі.',
    );
    await image(s, path.join(shots, '04_ai_agent_studio.png'), 70, 234, 520, 382, 'cover');
    await image(s, path.join(shots, '07_flutter_ai_code.png'), 626, 234, 500, 382, 'contain');
    text(
      s,
      'Логіка підбору: збіг жанрів + оцінка користувача + врахування переглянутих фільмів + коротке пояснення вибору.',
      118,
      632,
      1000,
      30,
      { size: 18, color: colors.mint, align: 'center', bold: true },
    );
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'Інтерфейс складається з кількох робочих екранів',
      'Є авторизація, вибір смаків, головна стрічка, деталі фільму, оцінки, коментарі та профіль.',
    );
    await image(s, path.join(shots, '01_auth.png'), 72, 220, 254, 170, 'cover');
    await image(s, path.join(shots, '02_cinematic_home.png'), 346, 220, 254, 170, 'cover');
    await image(s, path.join(shots, '06_movie_details.png'), 620, 220, 254, 170, 'cover');
    await image(s, path.join(shots, '05_profile_memory.png'), 894, 220, 254, 170, 'cover');
    bullets(
      s,
      [
        'Афіші, блок трейлера, анімації та match meter роблять каталог зрозумілішим.',
        'Оцінка зірочками зберігається у стані застосунку і впливає на підбір.',
        'Профіль можна редагувати: ім’я, фото за URL та опис свого смаку.',
      ],
      104,
      454,
      980,
      58,
    );
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'Код розділений за відповідальністю',
      'Flutter відповідає за UX, FastAPI за HTTP-логіку, PostgreSQL за структуроване збереження даних.',
    );
    await image(s, path.join(shots, '07_flutter_ai_code.png'), 60, 236, 360, 360, 'contain');
    await image(s, path.join(shots, '10_vscode_fastapi.png'), 460, 236, 360, 360, 'contain');
    await image(s, path.join(shots, '11_vscode_postgresql.png'), 860, 236, 360, 360, 'contain');
    text(s, 'Flutter logic', 96, 614, 290, 24, { size: 18, bold: true, color: colors.blue, align: 'center' });
    text(s, 'VS Code: FastAPI', 502, 614, 270, 24, { size: 18, bold: true, color: colors.mint, align: 'center' });
    text(s, 'VS Code: PostgreSQL', 900, 614, 280, 24, { size: 18, bold: true, color: colors.jade, align: 'center' });
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'Проєкт перевірено перед захистом',
      'Фокус перевірки: застосунок запускається, код аналізується без issues, базові тести проходять.',
    );
    metric(s, '0', 'Flutter analyze issues', 110, 270, 260, colors.jade);
    metric(s, '1/1', 'widget test passed', 410, 270, 260, colors.mint);
    metric(s, 'OK', 'backend py_compile', 710, 270, 260, colors.blue);
    bullets(
      s,
      [
        'flutter analyze: No issues found.',
        'flutter test: All tests passed.',
        'python -m py_compile backend/main.py: синтаксис FastAPI backend валідний.',
        'Додатково перевірено backend-файл через Python-компіляцію.',
      ],
      116,
      440,
      1010,
      50,
    );
  }

  {
    const s = deck.slides.add();
    addBg(s);
    title(
      s,
      'Що показати на захисті',
      'Демонстрацію можна провести по кроках: інтерфейс, оцінки, коментарі, backend і база даних.',
    );
    bullets(
      s,
      [
        'Показати авторизацію, вибір смаків, головну стрічку й деталі фільму.',
        'Поставити оцінку, додати коментар і показати, що ці дані впливають на рекомендації.',
        'Відкрити вкладку “Система” та пояснити Flutter → FastAPI → PostgreSQL → рекомендації.',
        'Показати backend/main.py і schema.sql як доказ підключення бази даних.',
      ],
      126,
      260,
      930,
      68,
    );
    text(
      s,
      'GitHub: github.com/Vanil-CEO/CineMind-movie-ai',
      126,
      608,
      720,
      30,
      { size: 20, color: colors.mint, bold: true },
    );
  }

  for (const [index, slide] of deck.slides.items.entries()) {
    const png = await deck.export({ slide, format: 'png', scale: 1 });
    await fs.writeFile(
      path.join(previewDir, `slide-${String(index + 1).padStart(2, '0')}.png`),
      new Uint8Array(await png.arrayBuffer()),
    );
    const layout = await slide.export({ format: 'layout' });
    await fs.writeFile(
      path.join(previewDir, `slide-${String(index + 1).padStart(2, '0')}.layout.json`),
      await layout.text(),
    );
  }

  const montage = await deck.export({ format: 'webp', montage: true, scale: 1 });
  await fs.writeFile(
    path.join(previewDir, 'montage.webp'),
    new Uint8Array(await montage.arrayBuffer()),
  );
  const pptx = await PresentationFile.exportPptx(deck);
  await pptx.save(finalPptx);
  console.log(finalPptx);
}

build().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
