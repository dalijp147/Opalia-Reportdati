const express = require("express");
const app = express.Router();
const Categorie = require("../models/categories.model");
const multer = require("multer");

// Set up storage for uploaded files
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/categories/");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

// Create the multer instance
const upload = multer({ storage: storage });
app.get("/", async (req, res) => {
  try {
    const categories = await Categorie.find();
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
  const url = req.protocol + "://" + req.get("host");

  const path = req.file != undefined ? req.file.path.replace(/\\/g, "/") : "";
  const categories = new Categorie({
    categorienom: req.body.categorienom,
    categorieImage: path != "" ? url + "/" + path : "",
  });
  try {
    const newCategories = await categories.save();
    res.status(201).json(newCategories);
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
