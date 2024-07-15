const moogoose = require("mongoose");
const FeedbackSchema = moogoose.Schema({
  participantId: { type: moogoose.Schema.Types.ObjectId, ref: "Medecin" },
  eventId: { type: moogoose.Schema.Types.ObjectId, ref: "Event" },
  etoile: {
    type: Number,
    default: 0,
  },
  comment: {
    type: String,
    default: " no comment",
  },
});

module.exports = moogoose.model("Feedback", FeedbackSchema);
