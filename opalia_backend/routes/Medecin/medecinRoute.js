const express = require("express");
const app = express.Router();
const Medecin = require("../../models/Medecin/Medecin.model");
const USerService = require("../../middleware/service");
const upload = require("../../middleware/upload");

app.get("/", async (req, res) => {
  try {
    const allUsers = await Medecin.find();
    res.status(200).json(allUsers);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.post("/registration", upload.single("image"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }
    const path = req.file.path.replace(/\\/g, "/");
    const imageUrl = `${req.protocol}://10.0.2.2:3001/${path}`;
    const medecin = new Medecin({
      image: imageUrl,
      specialite: req.body.specialite,
      familyname: req.body.familyname,
      numeroTel: req.body.numeroTel,
      username: req.body.username,
      email: req.body.email,
      password: req.body.password,
      identifiantMedecin: req.body.identifiantMedecin,
    });

    const newmedecin = await medecin.save();
    res.status(200).json(newmedecin);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.patch("/update/:id", async (req, res) => {
  try {
    const updateMedecin = await res.Medecin.save();
    res.json(updateMedecin);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      throw new Error("Parameter are not correct");
    }
    const user = await USerService.checkuserMedecin(email);
    if (!user) {
      throw new Error("Medecin dont exist");
    }
    const isMatch = await user.comparePassword(password);
    if (isMatch === false) {
      throw new Error("Password Invalid");
    }
    let tokenData = {
      _id: user._id,
      numeroTel: user.numeroTel,
      email: user.email,
      username: user.username,
      familyname: user.familyname,
      identifiantMedecin: user.identifiantMedecin,
    };
    const token = await USerService.generateAccessToken(
      tokenData,
      "secretkey",
      "9999 years"
    );
    res.status(200).json({ status: true, token: token });
  } catch (err) {}
});

module.exports = app;
