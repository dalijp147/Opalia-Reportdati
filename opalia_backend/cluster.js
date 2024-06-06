const { Cluster } = require("puppeteer-cluster");
const urls = [
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/62-dermatologie",
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/64-metabolisme-et-nutrition",
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/65-pneumologie",
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/139-anti-viraux",
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/140-neurologie-psychiatrie",
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/141-infectiologie",
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
