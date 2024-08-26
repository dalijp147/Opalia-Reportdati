const mongoose = require("mongoose");

const cadeaupatientSchema = new mongoose.Schema({
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

const Cadeaupateint = mongoose.model("cadeaupatient", cadeaupatientSchema);

module.exports = Cadeaupateint;
