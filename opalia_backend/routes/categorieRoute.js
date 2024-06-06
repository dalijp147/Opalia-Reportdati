const express = require("express");
const app = express.Router();
const Categorie = require("../models/categories.model");
const upload = require("../middleware/upload");
const puppetire = require("puppeteer");
const URL = "https://www.opaliarecordati.com/fr/produits/paramedical";

const fetchDataCategorie = async () => {
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
      //   const newsDescription = await page.evaluate(
      //     (el) => el.querySelector("div.cat_description").textContent,
      //     newshandle
      //   );
      //   const newsImage = await page.evaluate(
      //     (el) => el.querySelector("a > div.image_cat > img").getAttribute("src"),
      //     newshandle
      //   );
      let articlesSaved = 0;
      let duplicateArticles = 0;
      const categorie = new Categorie({
        categorienom: categorietitle,
      });
      console.log("Title:", categorietitle);
      //   console.log("Description:", newsDescription);
      //   console.log("Image URL:", newsImage);
      console.log("-------------------------");
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
    //res.status(500).json({ error: "An error occurred during scraping" });
  }
};

app.get("/", async (req, res) => {
  try {
    const categories = await Categorie.find();

    fetchDataCategorie();
    res.status(200).json({ data: categories });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/:productname", async (req, res) => {
  try {
    const categories = await Categorie.find({
      categorienom: req.params.productname,
    }).populate("productList");
    res.status(200).json({ data: categories });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
//get by id
app.get("/:id", getCategorie, (req, res) => {
  res.send(res.categorie);
});
//post
app.post("/", upload.single("categorieImage"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const path = req.file.path.replace(/\\/g, "/");
    const imageUrl = `${req.protocol}://10.0.2.2:3001/${path}`;
    const categories = new Categorie({
      categorienom: req.body.categorienom,
      categorieImage: imageUrl,
    });
    const newCategories = await categories.save();
    res.status(201).json({ data: newCategories });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

//update
app.patch("/update/:id", getCategorie, async (req, res) => {
  if (req.body.categorienom != null) {
    res.categorie.categorienom = req.body.categorienom;
  }
  if (req.body.categorieImage != null) {
    res.categorie.categorieImage = req.body.categorieImage;
  }
  try {
    const updateCategorie = await res.categorie.save();
    res.json(updateCategorie);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
//delete
app.delete("/delete/:id", getCategorie, async (req, res) => {
  try {
    await res.categorie.deleteOne();
    res.json({ message: "Delete Categorie" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
});
//middleware
async function getCategorie(req, res, next) {
  try {
    categorie = await Categorie.findById(req.params.id);
    if (categorie == null) {
      return res.status(404).json({ message: "cant find categorie" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.categorie = categorie;
  next();
}
module.exports = app;
