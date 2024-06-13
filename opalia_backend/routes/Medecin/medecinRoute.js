const express = require("express");
const app = express.Router();
const Medecin = require("../../models/Medecin/Medecin.model");
const USerService = require("../../middleware/service");
app.get("/", async (req, res) => {
  try {
    const allUsers = await Medecin.find();
    res.status(200).json(allUsers);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.post("/registration", async (req, res) => {
  const medecin = new Medecin({
    familyname: req.body.familyname,
    username: req.body.username,
    email: req.body.email,
    password: req.body.password,
    identifiantMedecin: req.body.identifiantMedecin,
  });
  try {
    const newmedecin = await medecin.save();
    res.status(200).json(newmedecin);
  } catch (err) {
    res.status(400).json({ message: "error" });
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
    const user = await USerService.checkuser(email);
    if (!user) {
      throw new Error("User dont exist");
    }
    const isMatch = await user.comparePassword(password);
    if (isMatch === false) {
      throw new Error("Password Invalid");
    }
    let tokenData = {
      _id: user._id,
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
