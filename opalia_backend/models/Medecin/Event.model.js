const moogoose = require("mongoose");

const EventSchema = moogoose.Schema({
  eventname: {
    type: String,
    required: true,
    unique: true,
  },
  dateEvent: {
    type: Date,

    default: Date.now,
  },
  datefinEvent: {
    type: Date,
    default: Date.now,
  },
  eventLocalisation: {
    type: String,
    default: "jendouba",
  },

  eventdescription: {
    type: String,
    required: true,
  },
  eventimage: {
    type: String,
    required: true,
  },
  nombreparticipant: {
    type: Number,
  },
});
module.exports = moogoose.model("Event", EventSchema);
