const mongoose = require("mongoose");

const categorieProSchema = mongoose.Schema({
  categorienompro: {
    type: String,
    required: true,
    unique: true,
  },
  categorieImagepro: {
    type: String,
  },
});
module.exports = mongoose.model("categorieMedecin", categorieProSchema);
