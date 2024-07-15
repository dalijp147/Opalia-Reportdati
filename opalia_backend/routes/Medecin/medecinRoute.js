const express = require("express");
const app = express.Router();
const Medecin = require("../../models/Medecin/Medecin.model");
const USerService = require("../../middleware/service");
const upload = require("../../middleware/upload");
const path = require("path");
const bodyParser = require("body-parser");

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "public")));

// Serve static files

app.get("/", async (req, res) => {
  try {
    const allUsers = await Medecin.find();
    res.status(200).json(allUsers);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.delete("/delete/:id", getNews, async (req, res) => {
  try {
    await res.news.deleteOne();
    res.status(200).json({ message: "Delete Medecin" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/detail/:id", async (req, res) => {
  try {
    const allUsers = await Medecin.findById(req.params.id);
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
      licenseNumber: req.body.licenseNumber,
      isVerified: false, // Initially set to false
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
      image: user.image,
      username: user.username,
      familyname: user.familyname,
      specialite: user.specialite,
      licenseNumber: user.licenseNumber,
      identifiantMedecin: user.identifiantMedecin,
    };
    const token = await USerService.generateAccessToken(
      tokenData,
      "secretkey",
      "9999 years"
    );
    res.status(200).json({ status: true, token: token });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.post("/forgot-password", async (req, res) => {
  try {
    const { email } = req.body;
    const user = await USerService.checkuserMedecin(email);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const token = await USerService.generateResetToken();
    user.resetPasswordToken = token;
    user.resetPasswordExpires = Date.now() + 3600000; // 1 hour
    await user.save();

    await USerService.sendResetEmail(email, token);
    res.status(200).json({ message: "Password reset email sent" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Route to reset password
app.post("/reset/:token", async (req, res) => {
  try {
    const user = await Medecin.findOne({
      resetPasswordToken: req.params.token,
      resetPasswordExpires: { $gt: Date.now() },
    });

    if (!user) {
      return res
        .status(400)
        .json({ message: "Password reset token is invalid or has expired" });
    }

    user.password = req.body.password;
    user.resetPasswordToken = undefined;
    user.resetPasswordExpires = undefined;
    await user.save();

    res.status(200).json({ message: "Password has been reset" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

app.get("/reset", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "reset.html"));
});
async function getNews(req, res, next) {
  try {
    news = await Medecin.findById(req.params.id);
    if (news == null) {
      return res.status(404).json({ message: "cant find News" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.news = news;
  next();
}

module.exports = app;
