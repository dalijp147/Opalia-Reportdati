const express = require("express");
const app = express.Router();
const Medecin = require("../../models/Medecin/Medecin.model");
const USerService = require("../../middleware/service");
const upload = require("../../middleware/upload");
const path = require("path");
const bodyParser = require("body-parser");
const socketIo = require("socket.io");
const { getIo } = require("../../middleware/Socket");

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
app.get("/patients/:id", async (req, res) => {
  try {
    const patientId = req.params.id;
    const patient = await Medecin.findById(patientId);

    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    res.json(patient);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
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
      description: req.body.description,
      username: req.body.username,
      email: req.body.email,
      password: req.body.password,
      licenseNumber: req.body.licenseNumber,
      isVerified: false,
      isApproved: false, // Initially set to false
    });

    const newmedecin = await medecin.save();
    const io = getIo();
    io.emit("new doctor", newmedecin);
    res.status(200).json(newmedecin);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.put("/update/:id", upload.single("image"), async (req, res) => {
  const id = req.params.id;

  // Check if the ID is provided
  if (!id) {
    return res.status(400).json({ message: "Medecin ID is required" });
  }

  // Check if a file is uploaded and update the image URL
  let imageUrl = null;
  if (req.file) {
    const path = req.file.path.replace(/\\/g, "/");
    imageUrl = `${req.protocol}://10.0.2.2:3001/${path}`;
  }

  try {
    // Find the Medecin by ID
    const medecin = await Medecin.findById(id);

    if (!medecin) {
      return res.status(404).json({ message: "Medecin not found" });
    }

    // Update fields
    medecin.username = req.body.username || medecin.username;
    medecin.familyname = req.body.familyname || medecin.familyname;
    medecin.numeroTel = req.body.numeroTel || medecin.numeroTel;
    medecin.description = req.body.description || medecin.description;
    medecin.email = req.body.email || medecin.email;
    medecin.specialite = req.body.specialite || medecin.specialite;
    medecin.password = req.body.password || medecin.password;
    medecin.licenseNumber = req.body.licenseNumber || medecin.licenseNumber;
    medecin.isApproved = req.body.isApproved || medecin.isApproved;
    medecin.isVerified = req.body.isVerified || medecin.isVerified;

    // Update the image URL if a new file is uploaded
    if (imageUrl) {
      medecin.image = imageUrl;
    }

    // Save the updated document
    const updatedMedecin = await medecin.save();

    // Send the updated document as the response
    res.status(200).json(updatedMedecin);
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message || "Some error occurred while updating the Medecin.",
    });
  }
});
app.patch("/approve/:id", async (req, res) => {
  try {
    const medecin = await Medecin.findById(req.params.id);
    if (!medecin) {
      return res.status(404).json({ message: "Medecin not found" });
    }
    medecin.isApproved = true;
    await medecin.save();
    res.status(200).json({ message: "Médecin approuvé" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
// New disapprove route
app.patch("/disapprove/:id", async (req, res) => {
  try {
    const medecin = await Medecin.findById(req.params.id);
    if (!medecin) {
      return res.status(404).json({ message: "Médecin pas trouvé" });
    }
    medecin.isApproved = false;
    await medecin.save();
    res.status(200).json({ message: "Médecin pas encore approuvé" });
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
    if (!user.isApproved) {
      throw new Error("Medecin is not approved");
    }
    const isMatch = await user.comparePassword(password);
    if (isMatch === false) {
      throw new Error("Mot de passe incorrect");
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
      description: user.description,
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
