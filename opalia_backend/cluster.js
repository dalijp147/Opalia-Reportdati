const { Cluster } = require("puppeteer-cluster");
const urls = [
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/62-dermatologie",
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/64-metabolisme-et-nutrition",
];

(async () => {
  const cluster = await Cluster.launch({
    concurrency: Cluster.CONCURRENCY_PAGE,
    maxConcurrency: 100,
    puppeteerOptions: {
      headless: false,
      defaultViewport: null,
    },
  });

  await cluster.task(async ({ page, data: url }) => {
    await page.goto(url);
  });
  for (const url of urls) {
    await cluster.queue(url);
  }

  // many more pages

  //await cluster.idle();
  //await cluster.close();
})();
