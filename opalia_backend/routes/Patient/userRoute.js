const express = require("express");
const app = express.Router();
const User = require("../../models/Patient/user.model");
const USerService = require("../../middleware/service");
const upload = require("../../middleware/upload");
const path = require("path");
const bodyParser = require("body-parser");
const UserController = require("../../controller/user");
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "public")));
app.get("/", async (req, res) => {
  try {
    const allUsers = await User.find();
    res.status(200).json(allUsers);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
async function geUserId(req, res, next) {
  try {
    userr = await User.findById(req.params.id);
    if (userr == null) {
      return res.status(404).json({ message: "cant find user" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.userr = userr;
  next();
}
app.post("/registration", upload.single("image"), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "No file uploaded" });
  }

  const path = req.file.path.replace(/\\/g, "/");
  const imageUrl = `${req.protocol}://10.0.2.2:3001/${path}`;
  const user = new User({
    familyname: req.body.familyname,
    username: req.body.username,
    email: req.body.email,
    password: req.body.password,
    image: imageUrl,
  });
  try {
    const newuser = await user.save();
    res.status(200).json(newuser);
  } catch (err) {
    res.status(400).json({ message: "error" });
  }
});
app.patch("/update/:id", geUserId, async (req, res) => {
  if (req.body.username != null) {
    res.userr.username = req.body.username;
  }

  try {
    const updateUSer = await res.userr.save();
    res.json(updateUSer);
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
      throw new Error("Mot de passe incorrect");
    }
    let tokenData = {
      _id: user._id,
      email: user.email,
      username: user.username,
      familyname: user.familyname,
      image: user.image,
    };
    const token = await USerService.generateAccessToken(
      tokenData,
      "secretkey",
      "9999 years"
    );
    res.status(200).json({ status: true, token: token });
  } catch (err) {}
});
/////
app.post("/forgot-password", async (req, res) => {
  try {
    const { email } = req.body;
    const user = await USerService.checkuser(email);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const token = await USerService.generateResetToken();
    user.resetPasswordToken = token;
    user.resetPasswordExpires = Date.now() + 3600000; // 1 hour
    await user.save();

    await USerService.sendResetEmailUser(email, token);
    res.status(200).json({ message: "Password reset email sent" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});
app.get("/patients/:id", async (req, res) => {
  try {
    const patientId = req.params.id;
    const patient = await User.findById(patientId);

    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    res.json(patient);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
});
// Route to reset password
app.post("/reset/:token", async (req, res) => {
  try {
    const user = await User.findOne({
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
////
app.get("/reset", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "resetuser.html"));
});

////
app.delete("/delete/:id", UserController.delete);
module.exports = app;
