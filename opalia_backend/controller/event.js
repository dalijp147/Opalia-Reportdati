const Event = require("../models/Medecin/Event.model");

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
  });
  event
    .save()
    .then((data) => {
      res.status(200).json({ data });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while creating the event.",
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
