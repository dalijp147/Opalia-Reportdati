const puppetire = require("puppeteer");
const URL = "https://www.opaliarecordati.com/fr/produits/medical";
const Categorie = require("../models/categories.model");

let browserInstance;

// Function to initialize the browser instance
const initializeBrowser = async () => {
  browserInstance = await puppetire.launch({
    headless: false,
    defaultViewport: null,
  });
};

const fetchDataCategorie = async () => {
  try {
    browserInstance = await puppetire.launch({
      headless: false,
      defaultViewport: null,
    });
    const page = await browserInstance.newPage();
    await page.goto(URL, { waitUntil: "networkidle2" });
    const categorisHandles = await page.$$("div.bloc_left left > div.panel");
    for (const categoriehnadle of categorisHandles) {
      const categorietitle = await page.evaluate(
        (el) => el.querySelector("ul > li > a").textContent,
        categoriehnadle
      );
      //   const newsDescription = await page.evaluate(
      //     (el) => el.querySelector("div.cat_description").textContent,
      //     newshandle
      //   );
      //   const newsImage = await page.evaluate(
      //     (el) => el.querySelector("a > div.image_cat > img").getAttribute("src"),
      //     newshandle
      //   );
      //   let articlesSaved = 0;
      //   let duplicateArticles = 0;
      const categorie = new Categorie({
        categorienom: categorietitle,
      });
      console.log("Title:", categorie);
      //   console.log("Description:", newsDescription);
      //   console.log("Image URL:", newsImage);
      console.log("-------------------------");
      try {
        await categorie.save();
      } catch (error) {
        if (error.code === 11000) {
          console.error("Error saving :", error);
        } else {
          console.error("Error saving article:", error);
        }
      }
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
(module.exports = fetchDataCategorie), initializeBrowser;
