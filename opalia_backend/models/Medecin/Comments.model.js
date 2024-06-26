const moogoose = require("mongoose");

const CommentSChema = moogoose.Schema(
  {
    doc: {
      type: moogoose.Schema.Types.ObjectId,
      ref: "Medecin", // Replace with your actual model name for authors
      required: true,
    },
    comment: {
      type: String,
      required: true,
    },
    post: {
      type: moogoose.Schema.Types.ObjectId,
      ref: "Discussion",
      required: true,
    },
  },
  { timestamps: true }
);
module.exports = moogoose.model("Comment", CommentSChema);
