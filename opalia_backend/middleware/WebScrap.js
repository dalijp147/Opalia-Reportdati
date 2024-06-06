const puppetire = require("puppeteer");
const URL =
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/62-dermatologie";

const fetchData = async () => {
  try {
    browserInstance = await puppetire.launch({
      headless: false,
      defaultViewport: null,
    });
    const page = await browserInstance.newPage();
    await page.goto(URL, { waitUntil: "networkidle2" });
    const categorisHandles = await page.$$("div.inter_categorie > div.bloc3");
    for (const categoriehnadle of categorisHandles) {
      const categorietitle = await page.evaluate(
        (el) => el.querySelector("div > a > div.cat_titre").textContent,
        categoriehnadle
      );
      //   const newsDescription = await page.evaluate(
      //     (el) => el.querySelector("div.cat_description").textContent,
      //     newshandle
      //   );
      const Image = await page.evaluate(
        (el) => el.querySelector("a > div.image_cat > img").getAttribute("src"),
        categoriehnadle
      );
      let articlesSaved = 0;
      let duplicateArticles = 0;
      // const categorie = new Categorie({
      //   categorienom: categorietitle,
      // });
      console.log("Title:", categorietitle);
      //   console.log("Description:", newsDescription);
      console.log("Image URL:", Image);
      console.log("-------------------------");
      // try {
      //   await categorie.save();
      //   articlesSaved++;
      // } catch (error) {
      //   if (error.code === 11000) {
      //     duplicateArticles++;
      //   } else {
      //     console.error("Error saving article:", error);
      //   }
      // }
    }
    await browserInstance.close();
    // res.status(200).json({
    //   message: "Scraping completed",
    // });
  } catch (e) {
    console.log(e);
    //res.status(500).json({ error: "An error occurred during scraping" });
  }
};
module.exports = fetchData;
