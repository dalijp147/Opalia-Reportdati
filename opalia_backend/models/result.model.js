const moogoose = require("mongoose");

const resultSchema = moogoose.Schema({
  userid: { type: moogoose.Schema.Types.ObjectId, ref: "User" },

  attempts: { type: Number, default: 0 },
  points: { type: Number, default: 0 },

  createdAt: { type: Date, default: Date.now },
});
module.exports = moogoose.model("Result", resultSchema);
