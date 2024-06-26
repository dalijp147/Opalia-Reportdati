const mongoose = require("mongoose");
const likeSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Particant",
    },
    postId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Discussion",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Likes", likeSchema);
