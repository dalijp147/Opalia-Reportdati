const Cadeau = require("../models/Patient/CadeauModel");
exports.create = (req, res) => {
  var cad = new Cadeau({
    cadeau: req.body.cadeau,
  });
  cad
    .save()
    .then((data) => {
      res.status(200).json({ data });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while creating the cad.",
      });
    });
};
exports.update = (req, res) => {
  const cadeauId = req.params.cadeauId;

  // Check if the event ID is provided
  if (!cadeauId) {
    return res.status(400).json({ message: "cadeauId is required" });
  }

  // Check if a file is uploaded and update the image URL

  // Find the event by ID and update the fields
  Cadeau.findById(cadeauId)
    .then((event) => {
      if (!event) {
        return res.status(404).json({ message: "cadeau not found" });
      }

      event.cadeau = req.body.cadeau || event.cadeau;

      // Update the image URL if a new file is uploaded

      return event.save();
    })
    .then((updatedEvent) => {
      res.status(200).json({ data: updatedEvent });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while updating the cadeau.",
      });
    });
};
exports.get = (req, res) => {
  Cadeau.find()

    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No Cadeau found!";
      else message = "Cadeau successfully retrieved";

      res.status(200).json({ data });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving Cadeau.",
      });
    });
};

exports.delete = (req, res) => {
  Cadeau.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Cadeau not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Cadeau successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Cadeau not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete event with id " + req.params.id,
      });
    });
};
