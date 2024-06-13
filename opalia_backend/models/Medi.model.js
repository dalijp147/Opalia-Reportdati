const mongoose = require("mongoose");

const mediSchema = mongoose.Schema({
  mediname: {
    type: String,
    required: true,
    unique: true,
  },

  presentationmedi: {
    type: String,
  },
  classeparamedicalemedi: {
    type: String,
  },
  sousclassemedi: {
    type: String,
  },
  dci: {
    type: String,
  },
  forme: {
    type: String,
  },
  mediImage: {
    type: String,
    required: true,
  },
  categorie: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "categorie",
  },
  categoriePro: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "categorieMedecin",
  },
});
module.exports = mongoose.model("Medicament", mediSchema);
