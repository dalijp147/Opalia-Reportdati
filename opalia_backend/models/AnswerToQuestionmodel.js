const moogoose = require("mongoose");

const AnswerToQuestionSChema = moogoose.Schema(
  {
    doc: {
      type: moogoose.Schema.Types.ObjectId,
      ref: "Medecin", // Replace with your actual model name for authors
    },
    user: {
      type: moogoose.Schema.Types.ObjectId,
      ref: "User", // Replace with your actual model name for authors
    },
    comment: {
      type: String,
      required: true,
    },
    question: {
      type: moogoose.Schema.Types.ObjectId,
      ref: "Answer",
      required: true,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);
module.exports = moogoose.model("AnswerToQuestion", AnswerToQuestionSChema);
