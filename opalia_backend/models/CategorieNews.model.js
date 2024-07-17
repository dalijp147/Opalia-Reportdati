const mongoose = require("mongoose");

const categorieNewsSchema = mongoose.Schema({
  categorienewsnom: {
    type: String,
    required: true,
    unique: true,
  },
});
module.exports = mongoose.model("categorieNews", categorieNewsSchema);
