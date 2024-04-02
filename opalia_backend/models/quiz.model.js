const moogoose = require("mongoose");

const quizSchema = moogoose.Schema({
  questions: { type: String, default: "" },
  answers: { type: Number, default: "" },
  options: { type: Array, default: [] },
  createdAt: { type: Date, default: Date.now },
});
module.exports = moogoose.model("Quiz", quizSchema);
