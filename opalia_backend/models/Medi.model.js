const mongoose = require("mongoose");

const mediSchema = mongoose.Schema({
  mediname: {
    type: String,
    require: true,
    unique: true,
  },
  medidesc: {
    type: String,
    require: true,
  },
  mediImage: {
    type: String,
    require: true,
  },
  categorie: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "categorie",
  },
});
module.exports = mongoose.model("Medicament", mediSchema);
