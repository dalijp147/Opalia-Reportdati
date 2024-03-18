const express = require("express");
const app = express.Router();
const Reminder = require("../models/reminder.model");

app.get("/", async (req, res) => {
  try {
    const allReminder = await Reminder.find();
    res.status(200).json(allReminder);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.post("/newReminder", async (req, res) => {
  const reminder = new Reminder({
    remindertitre: req.body.remindertitre,
    datedebutReminder: req.body.datedebutReminder,
    datefinReminder: req.body.datefinReminder,
    nombrederappelparjour: req.body.nombrederappelparjour,
  });
  try {
    const newReminder = await reminder.save();
    res.status(200).json({ date: newReminder });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.delete("/delete/:id", getReminder, async (req, res) => {
  try {
    await res.reminder.deleteOne();
    res.status(200).json({ message: "Delete reminder" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.patch("/update/:id", getReminder, async (req, res) => {
  try {
    const newreminder = await Reminder.updateOne();
    res.status(200).json({ newreminder });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
//middleware
async function getReminder(req, res, next) {
  try {
    reminder = await Reminder.findById(req.params.id);
    if (reminder == null) {
      return res.status(404).json({ message: "cant find reminder" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.reminder = reminder;
  next();
}

module.exports = app;
