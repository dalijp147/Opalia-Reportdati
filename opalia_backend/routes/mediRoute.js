const express = require("express");
const app = express.Router();
const Medicament = require("../models/Medi.model");
const Categorie = require("../models/categories.model");
const multer = require("multer");

// Set up storage for uploaded files
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/Medicament/");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

// Create the multer instance
const upload = multer({ storage: storage });
app.get("/", async (req, res) => {
  try {
    const medicaments = await Medicament.find().populate("categorie");
    res.status(200).json({ data: medicaments });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/bycategory", async (req, res) => {
  try {
    const getallMedicament = await Medicament.find(req.query).populate(
      "categorie"
    );
    res.json(getallMedicament);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/:id", getProduct, (req, res) => {
  res.send(res.medicament);
});
app.post("/", upload.single("mediImage"), async (req, res) => {
  const medicaments = new Medicament({
    mediname: req.body.mediname,
    medidesc: req.body.medidesc,
    mediImage: req.file.filename,
    categorie: req.body.categorie,
  });
  try {
    const newMedicaments = await medicaments.save();
    res.status(201).json(newMedicaments);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
//update
app.patch("/update/:id", getProduct, async (req, res) => {
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
