const mongoose = require("mongoose");

const categorieSchema = mongoose.Schema({
  categorienom: {
    type: String,
    require: true,
    unique: true,
  },
  categorieImage: {
    type: String,
    require: true,
  },
});
module.exports = mongoose.model("categorie", categorieSchema);