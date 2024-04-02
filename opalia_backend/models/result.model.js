const moogoose = require("mongoose");

const resultSchema = moogoose.Schema({
  username: { type: String, default: "user" },
  result: {
    type: Array,
    default: [],
  },
  attempts: { type: Number, default: 0 },
  points: { type: Number, default: 0 },
  achived: { type: String, default: "" },
  createdAt: { type: Date, default: Date.now },
});
module.exports = moogoose.model("Result", resultSchema);
