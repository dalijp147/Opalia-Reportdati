const express = require("express");
const app = express.Router();
const Medicament = require("../models/Medi.model");
const upload = require("../middleware/upload");
const puppetire = require("puppeteer");

const URL =
  "https://www.opaliarecordati.com/fr/produits/medical/specialite/188-anti-coagulant";
const fetchDataMedical = async () => {
  try {
    const browser = await puppetire.launch({
      headless: false,
      defaultViewport: null,
    });
    const page = await browser.newPage();
    await page.goto(URL, { waitUntil: "networkidle2" });
    const MedicalHandles = await page.$$("div.inter_categorie > div.bloc3");
    for (const mediehnadle of MedicalHandles) {
      const medietitle = await page.evaluate(
        (el) => el.querySelector("div > a > div.cat_titre").textContent,
        mediehnadle
      );
      // const medieDescription = await page.evaluate(
      //   (el) => el.querySelector("div.cat_description").textContent,
      //   newshandle
      // );
      const medieImage = await page.evaluate(
        (el) => el.querySelector("a > div.image_cat > img").getAttribute("src"),
        mediehnadle
      );
      let articlesSaved = 0;
      let duplicateArticles = 0;
      const medi = new Medicament({
        mediname: medietitle,
        mediImage: medieImage,
        forme: "unkonwn",
        dci: "unkonwn",
        presentationmedi: "unkonwn",
        classeparamedicalemedi: "unkonwn",
        sousclassemedi: "unkonwn",
        categoriePro: "66698540edfa936fab0444e6",
      });
      // console.log("Title:", medietitle);
      // console.log("Description:", newsDescription);
      // console.log("Image URL:", medieImage);
      console.log("scrape medicament succes");
      try {
        await medi.save();
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
    const medicaments = await Medicament.find().populate("categorie");

    res.json({ data: medicaments });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/:categorie", async (req, res) => {
  const categorie = req.params.categorie;

  try {
    const getallMedicament = await Medicament.find({
      categorie,
    }).populate("categorie");
    //fetchDataMedical();
    res.status(200).json({ data: getallMedicament });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/cat/:categoriePro", async (req, res) => {
  const categoriePro = req.params.categoriePro;

  try {
    const getallMedicament = await Medicament.find({
      categoriePro,
    }).populate("categoriePro");
    //fetchDataMedical();
    res.status(200).json({ data: getallMedicament });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/:id", getProduct, (req, res) => {
  res.send(res.medicament);
});
app.post("/", upload.single("mediImage"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const path = req.file.path.replace(/\\/g, "/");
    const imageUrl = `${req.protocol}://10.0.2.2:3001/${path}`;
    const medicaments = new Medicament({
      mediname: req.body.mediname,
      medidesc: req.body.medidesc,
      mediImage: imageUrl,
      categorie: req.body.categorie,
    });
    const newMedicaments = await medicaments.save();
    res.status(201).json(newMedicaments);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
//update
app.put("/update/:id", getProduct, async (req, res) => {
  if (req.body.mediname != null) {
    res.medicament.mediname = req.body.mediname;
  }
  if (req.body.medidesc != null) {
    res.medicament.medidesc = req.body.medidesc;
  }
  try {
    const updateMedi = await res.medicament.save();
    res.json(updateMedi);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
//delete
app.delete("/delete/:id", getProduct, async (req, res) => {
  try {
    await res.medicament.deleteOne();
    res.json({ message: "Delete medicament" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
});
//middelware
async function getProduct(req, res, next) {
  try {
    medicament = await Medicament.findById(req.params.id);
    if (medicament == null) {
      return res.status(404).json({ message: "cant find medicament" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.medicament = medicament;
  next();
}

module.exports = app;
