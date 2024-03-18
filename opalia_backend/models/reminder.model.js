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
});
module.exports = moogoose.model("Reminder", reminderSchema);
