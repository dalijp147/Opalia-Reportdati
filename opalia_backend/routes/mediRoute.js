const express = require("express");
const app = express.Router();
const Medicament = require("../models/Medi.model");
const Categorie = require("../models/categories.model");
const upload = require("../middleware/upload");

app.get("/", async (req, res) => {
  try {
    const medicaments = await Medicament.find().populate("categorie");
    res.json(medicaments);
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
