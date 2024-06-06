const mongoose = require("mongoose");

const mediSchema = mongoose.Schema({
  mediname: {
    type: String,
    required: true,
    unique: true,
  },

  présentationmedi: {
    type: String,
  },
  classeparamédicalemedi: {
    type: String,
  },
  sousclassemedi: {
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
});
module.exports = mongoose.model("Medicament", mediSchema);
