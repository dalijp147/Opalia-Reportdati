const mongoose = require("mongoose");

const categorieSchema = mongoose.Schema(
  {
    categorienom: {
      type: String,
      require: true,
      unique: true,
    },
    categorieImage: {
      type: String,
      require: true,
    },
  },
  {
    toJSON: {
      trasform: function (doc, ret) {
        ret.categorieid = ret._id.toString();
        delete ret._id;
        delete ret._v;
      },
    },
  }
);
module.exports = mongoose.model("categorie", categorieSchema);
