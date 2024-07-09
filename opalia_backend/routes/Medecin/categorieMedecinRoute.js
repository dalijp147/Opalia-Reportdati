const express = require("express");
const categoryMedecinapp = express.Router();
const puppetire = require("puppeteer");
const Categorie = require("../../models/Medecin/categorisPro.model");

const URL = "https://www.opaliarecordati.com/fr/produits/medical";
const fetchDataCategoriePro = async () => {
  try {
    const browser = await puppetire.launch({
      headless: false,
      defaultViewport: null,
    });
    const page = await browser.newPage();
    await page.goto(URL, { waitUntil: "networkidle2" });

    const categorisHandles = await page.$$(".panel > li");
    for (const categoriehnadle of categorisHandles) {
      const categorietitle = await page.evaluate(
        (el) =>
          el.querySelector("div.bloc_left.left > ul > li > a").textContent,
        categoriehnadle
      );

      let articlesSaved = 0;
      let duplicateArticles = 0;

      const categorie = new Categorie({
        categorienompro: categorietitle,
      });

      console.log("scrape categorie succes");

      try {
        await categorie.save();
        articlesSaved++;
      } catch (error) {
        if (error.code === 11000) {
          duplicateArticles++;
        } else {
          console.error("Error saving article:", error);
        }
      }
    }

    await browser.close();
    // res.status(200).json({
    //   message: "Scraping completed",
    // });
  } catch (e) {
    console.log(e);
    // res.status(500).json({ error: "An error occurred during scraping" });
  }
};
categoryMedecinapp.get("/", async (req, res) => {
  try {
    const categories = await Categorie.find();

    //fetchDataCategoriePro();
    res.status(200).json({ data: categories });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = categoryMedecinapp;
