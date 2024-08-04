const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const medecinSchema = mongoose.Schema({
  username: {
    type: String,
    required: true,
  },
  familyname: {
    type: String,
    required: true,
  },
  numeroTel: {
    type: Number,
    //required: true,
  },
  description: {
    type: String,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  image: {
    type: String,
  },
  specialite: {
    type: String,
  },
  password: {
    type: String,
    required: true,
  },
  licenseNumber: {
    type: String,
    default: "000000",
    unique: true,
  },
  isApproved: {
    type: Boolean,
    default: false,
  },
  isVerified: { type: Boolean, default: false },
  resetPasswordToken: String,
  resetPasswordExpires: Date,
});

// encryupt the password
medecinSchema.pre("save", async function (next) {
  try {
    if (!this.isModified("password")) {
      return next();
    }

    const salt = await bcrypt.genSalt(10);
    const hashpass = await bcrypt.hash(this.password, salt);
    this.password = hashpass;
    next();
  } catch (err) {
    next(err);
  }
});

//compare password
medecinSchema.methods.comparePassword = async function (userPassword) {
  try {
    const isMatch = await bcrypt.compare(userPassword, this.password);
    return isMatch;
  } catch (err) {
    throw err;
  }
};

module.exports = mongoose.model("Medecin", medecinSchema);
