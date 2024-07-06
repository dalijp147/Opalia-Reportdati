const mongoose = require("mongoose");
const bycrypt = require("bcrypt");
const userSchema = mongoose.Schema({
  username: {
    type: String,
    required: true,
  },
  familyname: {
    type: String,
    required: true,
  },
  image: {
    type: String,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
});

// encryupt the password
userSchema.pre("save", async function () {
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
userSchema.methods.comparePassword = async function (userPassword) {
  try {
    const isMatch = await bycrypt.compare(userPassword, this.password);
    return isMatch;
  } catch (err) {
    throw err;
  }
};
module.exports = mongoose.model("User", userSchema);
