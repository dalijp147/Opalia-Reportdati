const moogoose = require("mongoose");
const RequestSchema = moogoose.Schema({
  eventId: { type: moogoose.Schema.Types.ObjectId, ref: "Event" },
  MedecinId: { type: moogoose.Schema.Types.ObjectId, ref: "Medecin" },
  participantId: { type: moogoose.Schema.Types.ObjectId, ref: "Particant" },

  status: { type: String, default: "pending" },
});
module.exports = moogoose.model("RequestAdmin", RequestSchema);
