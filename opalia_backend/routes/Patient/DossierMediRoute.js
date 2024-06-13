const express = require("express");
const DosMedIapp = express.Router();
const DossierMed = require("../../models/Patient/DossierMed.model");
DosMedIapp.get("/", async (req, res) => {
  try {
    const dossiermed = await DossierMed.find().populate("userId");
    res.status(200).json({ data: dossiermed });
  } catch (error) {
    res.status(404).json({ message: error });
  }
});
DosMedIapp.get("/:userId", async (req, res) => {
  const userId = req.params.userId;
  try {
    const dossier = await DossierMed.findOne({ userId });
    if (!dossier) {
      return res
        .status(404)
        .json({ message: "Medical dossier not found for this user." });
    }
    res.status(200).json(dossier);
  } catch (err) {
    res.status(500).json({ message: "Internal server error." });
  }
});
DosMedIapp.get("/byUser/:userId", async (req, res) => {
  const userId = req.params.userId;

  try {
    const allDossierMed = await DossierMed.find({
      userId,
    });

    res.status(200).json(allDossierMed);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
DosMedIapp.post("/newDoss", async (req, res) => {
  try {
    const { userId, poids, age, maladie } = req.body;
    const newDoss = new DossierMed({ userId, poids, age, maladie });
    const dos = await newDoss.save();
    res.status(200).json({ dos });
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
});
DosMedIapp.delete("/delete/:id", getDos, async (req, res) => {
  try {
    await res.dos.deleteOne();
    res.status(200).json({ message: "Delete dossier" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
async function getDos(req, res, next) {
  try {
    dos = await DossierMed.findById(req.params.id);
    if (dos == null) {
      return res.status(404).json({ message: "cant find dossier" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.dos = dos;
  next();
}
module.exports = DosMedIapp;
