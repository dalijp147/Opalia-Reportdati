const mongoose = require("mongoose");

const cadeauSchema = new mongoose.Schema({
  cadeau: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

const Cadeau = mongoose.model("cadeau", cadeauSchema);

module.exports = Cadeau;
