const mongoose = require("mongoose");

const categorieSchema = mongoose.Schema({
  categorienom: {
    type: String,
    required: true,
    unique: true,
  },
  categorieImage: {
    type: String,
  },
});
module.exports = mongoose.model("categorie", categorieSchema);
