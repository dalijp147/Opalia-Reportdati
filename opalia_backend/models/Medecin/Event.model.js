const moogoose = require("mongoose");

const EventSchema = moogoose.Schema({
  doctorId: {
    type: moogoose.Schema.Types.ObjectId,
    ref: "Medecin",
  },
  eventname: {
    type: String,
    required: true,
    unique: true,
  },
  dateEvent: {
    type: Date,

    default: Date.now(),
  },
  eventLocalisation: [
    {
      longitude: { type: String },
      latitude: { type: String },
    },
  ],

  eventdescription: {
    type: String,
    required: true,
  },
  eventimage: {
    type: String,
    required: true,
  },
  participant: [
    {
      doctorId: {
        type: moogoose.Schema.Types.ObjectId,
        ref: "Medecin",
      },
    },
  ],
});
module.exports = moogoose.model("Event", EventSchema);
