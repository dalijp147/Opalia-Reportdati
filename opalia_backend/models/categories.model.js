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
  productList: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Medicament",
    },
  ],
});
module.exports = mongoose.model("categorie", categorieSchema);
