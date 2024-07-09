const moogoose = require("mongoose");
const FeedbackSchema = moogoose.Schema({
  participantId: { type: moogoose.Schema.Types.ObjectId, ref: "Particant" },
  eventId: { type: moogoose.Schema.Types.ObjectId, ref: "Event" },
  etoile: {
    type: Number,
  },
  comment: {
    type: String,
  },
});

module.exports = mongoose.model("Feedback", FeedbackSchema);
