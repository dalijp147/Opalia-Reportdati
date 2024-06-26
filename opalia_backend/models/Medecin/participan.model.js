const moogoose = require("mongoose");
const participantScheema = moogoose.Schema({
  doctorId: {
    type: moogoose.Schema.Types.ObjectId,
    ref: "Medecin",
  },
  eventId: {
    type: moogoose.Schema.Types.ObjectId,
    ref: "Event",
  },
  speaker: {
    type: Boolean,
    default: false,
  },
  participon: {
    type: Boolean,
    default: false,
  },
  description: {
    type: String,
    default: "unknown",
  },
});
module.exports = moogoose.model("Particant", participantScheema);
