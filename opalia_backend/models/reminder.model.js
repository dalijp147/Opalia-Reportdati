const moogoose = require("mongoose");

const reminderSchema = moogoose.Schema({
  remindertitre: {
    type: String,
    require: true,
  },
  datedebutReminder: {
    type: Date,
    default: Date.now,
  },
  datefinReminder: {
    type: Date,
    default: Date.now,
  },
  nombrederappelparjour: {
    type: Number,
    require: true,
  },
  description: {
    type: String,
    default: "",
  },
  color: {
    type: Number,
  },
  notifid: { type: Number, unique: true },
  time: {
    type: String,
    default: "",
  },
  userId: { type: moogoose.Schema.Types.ObjectId, ref: "User", required: true },
});
module.exports = moogoose.model("Reminder", reminderSchema);
