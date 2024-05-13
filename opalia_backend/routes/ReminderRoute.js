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
  try {
    const reminder = new Reminder({
      userId: req.body.userId,
      remindertitre: req.body.remindertitre,
      datedebutReminder: req.body.datedebutReminder,
      datefinReminder: req.body.datefinReminder,
      nombrederappelparjour: req.body.nombrederappelparjour,
      color: req.body.color,
      time: req.body.time,
      description: req.body.description,
    });

    const newReminder = await reminder.save();
    res.status(200).json({ date: newReminder });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/:userId", async (req, res) => {
  const userId = req.params.userId;

  try {
    const allReminder = await Reminder.find({
      userId,
    });

    res.status(200).json(allReminder);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/getbyuserid", async (req, res) => {
  try {
    const { userId } = req.body;
    const remind = await Reminder.find({ userId });
    res.status(200).json({ status: true, success: remind });
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
  if (req.body.remindertitre != null) {
    res.reminder.remindertitre = req.body.remindertitre;
  }

  try {
    const updateReminder = await res.reminder.save();
    res.json(updateReminder);
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
