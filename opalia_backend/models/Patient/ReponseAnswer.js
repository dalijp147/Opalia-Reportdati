const mongoose = require("mongoose");

const userResponseSchema = new mongoose.Schema({
  answerId: { type: mongoose.Schema.Types.ObjectId, ref: "Answer" },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  response: String,
});

module.exports = mongoose.model("UserResponse", userResponseSchema);
