const fs = require('node:fs/promises');
const path = require('node:path');
const { createRequire } = require('node:module');

const dependencyRequire = createRequire(
  'C:/Users/ivanz/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/.pnpm/playwright@1.61.1/node_modules/playwright/index.js',
);
const { chromium } = dependencyRequire('playwright');

const root = 'C:/Users/ivanz/OneDrive/Documents/CineMind/week5';
const outDir = path.join(root, 'docs/presentation-assets');

async function screenshot(page, name) {
  await page.screenshot({
    path: path.join(outDir, name),
    fullPage: false,
  });
}

async function clickFirst(page, names) {
  for (const name of names) {
    const target = page.getByRole('button', { name });
    if ((await target.count()) > 0) {
      await target.first().click();
      return;
    }
  }
  throw new Error(`Button not found: ${names.join(', ')}`);
}

async function main() {
  await fs.mkdir(outDir, { recursive: true });
  const browser = await chromium.launch({
    executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
    headless: true,
  });
  const page = await browser.newPage({
    viewport: { width: 1440, height: 920 },
    deviceScaleFactor: 1,
  });

  await page.goto('http://127.0.0.1:5261', {
    waitUntil: 'networkidle',
    timeout: 60000,
  });
  await page.waitForTimeout(2600);
  await screenshot(page, '01_auth.png');

  await clickFirst(page, [/Створити профіль/, /Увійти/]);
  await page.waitForTimeout(900);
  await screenshot(page, '02_preferences.png');

  await clickFirst(page, [/Побудувати стрічку/]);
  await page.waitForTimeout(1800);
  await screenshot(page, '03_home.png');

  await clickFirst(page, [/Система/]);
  await page.waitForTimeout(1100);
  await screenshot(page, '04_system.png');

  await clickFirst(page, [/^AI$/]);
  await page.waitForTimeout(900);
  await screenshot(page, '05_ai_studio.png');

  await clickFirst(page, [/Згенерувати рішення/]);
  await page.waitForTimeout(1400);
  await screenshot(page, '06_ai_answer.png');

  await clickFirst(page, [/Головна/]);
  await page.waitForTimeout(900);
  const movieTitle = page.getByText('Interstellar').first();
  if ((await movieTitle.count()) > 0) {
    await movieTitle.click();
  } else {
    await page.getByText('Avengers: Endgame').first().click();
  }
  await page.waitForTimeout(1100);
  await screenshot(page, '07_movie_details.png');

  await browser.close();
  console.log(outDir);
}

main().catch(async (error) => {
  console.error(error);
  process.exitCode = 1;
});
