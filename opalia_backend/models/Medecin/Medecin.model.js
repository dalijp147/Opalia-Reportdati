const mongoose = require("mongoose");
const bycrypt = require("bcrypt");
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
  identifiantMedecin: {
    type: String,
    default: "256548",
  },
});

// encryupt the password
medecinSchema.pre("save", async function () {
  try {
    var user = this;
    const salt = await bycrypt.genSalt(10);
    const hashpass = await bycrypt.hash(user.password, salt);

    user.password = hashpass;
  } catch (err) {
    throw err;
  }
});

//compare password
medecinSchema.methods.comparePassword = async function (userPassword) {
  try {
    const isMatch = await bycrypt.compare(userPassword, this.password);
    return isMatch;
  } catch (err) {
    throw err;
  }
};
module.exports = mongoose.model("Medecin", medecinSchema);
