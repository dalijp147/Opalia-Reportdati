const Event = require("../models/Medecin/Event.model");
const { getIo } = require("../middleware/Socket");
exports.create = (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "No file uploaded" });
  }

  const path = req.file.path.replace(/\\/g, "/");
  const imageUrl = `${req.protocol}://10.0.2.2:3001/${path}`;
  var event = new Event({
    eventname: req.body.eventname,

    eventdescription: req.body.eventdescription,
    eventimage: imageUrl,
    eventLocalisation: req.body.eventLocalisation,
    dateEvent: req.body.dateEvent,
    nombreparticipant: req.body.nombreparticipant,
  });
  event
    .save()
    .then((data) => {
      const io = getIo();
      io.emit("newEvent", data);
      res.status(200).json({ data });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while creating the event.",
      });
    });
};
exports.update = (req, res) => {
  const eventId = req.params.eventId;

  // Check if the event ID is provided
  if (!eventId) {
    return res.status(400).json({ message: "Event ID is required" });
  }

  // Check if a file is uploaded and update the image URL
  let imageUrl = null;
  if (req.file) {
    const path = req.file.path.replace(/\\/g, "/");
    imageUrl = `${req.protocol}://10.0.2.2:3001/${path}`;
  }

  // Find the event by ID and update the fields
  Event.findById(eventId)
    .then((event) => {
      if (!event) {
        return res.status(404).json({ message: "Event not found" });
      }

      event.eventname = req.body.eventname || event.eventname;
      event.eventdescription =
        req.body.eventdescription || event.eventdescription;
      event.eventLocalisation =
        req.body.eventLocalisation || event.eventLocalisation;
      event.dateEvent = req.body.dateEvent || event.dateEvent;
      event.nombreparticipant =
        req.body.nombreparticipant || event.nombreparticipant;

      // Update the image URL if a new file is uploaded
      if (imageUrl) {
        event.eventimage = imageUrl;
      }

      return event.save();
    })
    .then((updatedEvent) => {
      res.status(200).json({ data: updatedEvent });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while updating the event.",
      });
    });
};
exports.get = (req, res) => {
  Event.find()

    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No Event found!";
      else message = "Event successfully retrieved";

      res.status(200).json({ data });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving Event.",
      });
    });
};

exports.delete = (req, res) => {
  Event.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Event not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Event successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Event not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete event with id " + req.params.id,
      });
    });
};
exports.deletePastEvents = async (req, res) => {
  try {
    const now = new Date();
    const result = await Event.deleteMany({ dateEvent: { $lt: now } });
    res.status(200).json({ message: "Deleted past events", result });
  } catch (error) {
    res.status(500).json({ message: "Error deleting past events", error });
  }
};
exports.getbyid = (req, res) => {
  const id = req.params.id;

  Event.findById(id)
    .then((data) => {
      if (!data) {
        const message = "Event not found.";
        console.log(message);
        return res.status(404).json({ success: false, message });
      }

      const message = "Event successfully retrieved";
      console.log(message, data);
      return res.status(200).json({ success: true, message, data });
    })
    .catch((err) => {
      console.error("Error occurred while retrieving event:", err);
      return res.status(500).json({
        success: false,
        message:
          err.message || "Some error occurred while retrieving the event.",
      });
    });
};
