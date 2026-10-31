// uso: node render.js <frameInicial> <frameFinal> <pastaSaida>   |   node render.js sheet t1,t2,... <pastaSaida>
const { chromium } = require('playwright');
(async () => {
  const [, , a, b, outDir] = process.argv;
  const browser = await chromium.launch({ args: ['--allow-file-access-from-files'] });
  const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
  page.on('console', m => console.log('console:', m.text()));
  page.on('pageerror', e => console.log('pageerror:', e.message));
  await page.goto('file://' + __dirname + '/index.html');
  await page.waitForFunction('window.READY === true', null, { timeout: 180000 });
  const times = a === 'sheet' ? b.split(',').map(Number) : null;
  const frames = times ? times.map(t => Math.round(t * 30)) : [...Array(+b - +a).keys()].map(i => i + +a);
  for (const f of frames) {
    await page.evaluate(t => window.render(t), f / 30);
    await page.screenshot({ path: `${outDir}/${String(f).padStart(5, '0')}.jpg`, type: 'jpeg', quality: 92 });
  }
  await browser.close();
})();
