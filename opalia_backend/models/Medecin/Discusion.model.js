const mongoose = require("mongoose");
const DiscussionSchema = mongoose.Schema(
  {
    subject: {
      type: String,
      required: true,
    },
    author: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Medecin", // Replace with your actual model name for authors
      required: true,
    },
    eventId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Event", // Replace with your actual model name for events
      required: true,
    },

    likedBy: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Particant", // Replace with your actual model name for users
      },
    ],
  },
  { timestamps: true }
);

module.exports = mongoose.model("Discussion", DiscussionSchema);
