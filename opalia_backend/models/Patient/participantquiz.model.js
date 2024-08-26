const moogoose = require("mongoose");

const resultSchema = moogoose.Schema({
  userid: { type: moogoose.Schema.Types.ObjectId, ref: "User" },
  doctorId: { type: moogoose.Schema.Types.ObjectId, ref: "Medecin" },
  attempts: { type: Number, default: 0 },
  points: { type: Number, default: 0 },
  cadeau: { type: String, default: "pas de cadeau" },
  gagner: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now },
});

module.exports = moogoose.model("Result", resultSchema);
