const Partipant = require("../models/Medecin/participan.model");
const { getIo } = require("../middleware/Socket");
exports.create = (req, res) => {
  var particpant = new Partipant({
    doctorId: req.body.doctorId,
    eventId: req.body.eventId,
    speaker: req.body.speaker,
    participon: req.body.participon,
    description: req.body.description,
  });
  particpant
    .save()
    .then((data) => {
      const io = getIo();
      io.emit("newParticipant", data);
      res.status(200).json({ data });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while creating the particpant.",
      });
    });
};

exports.get = (req, res) => {
  Partipant.find()
    .populate("doctorId")
    .populate("eventId")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Partipant found!";
      else message = "Partipant successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Partipant.",
      });
    });
};
exports.getParticipantIfExist = (req, res) => {
  const doctorId = req.params.doctorId;
  Partipant.findOne({ doctorId })
    .populate("doctorId")
    .populate("eventId")
    .then((data) => {
      let message = "";
      if (!data) {
        message = "Participant not found for this user.";
        return res.status(404).json({ message });
      } else {
        message = "Participant successfully retrieved";
        return res.status(200).json(data);
      }
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Participant.",
      });
    });
};
exports.getParticipantPartipeaevenement = (req, res) => {
  const doctorId = req.params.doctorId;
  const eventId = req.params.eventId;
  Partipant.findOne({ doctorId, eventId })
    .then((data) => {
      let message = "";
      if (!data) {
        message = "Participant not found for this user.";
        console.log(message);
        return res.status(404).json({ message });
      } else {
        message = "Participant successfully retrieved";
        console.log(message, data);
        return res.status(200).json(data);
      }
    })
    .catch((err) => {
      console.error("Error occurred while retrieving participant:", err);
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Participant.",
      });
    });
};
exports.getspeaker = (req, res) => {
  const speaker = req.params.speaker;
  const eventId = req.params.eventId;
  Partipant.find({ speaker, eventId })
    .populate("doctorId")
    .populate("eventId")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No Speaker found!";
      else message = "Speaker successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving Speaker.",
      });
    });
};
exports.getparicipant = (req, res) => {
  const participon = req.params.participon;
  const eventId = req.params.eventId;

  Partipant.find({ participon, eventId })
    .populate("doctorId")
    .populate("eventId")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Partipant found!";
      else message = "Partipant successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Partipant.",
      });
    });
};
exports.getparicipantandspeakertoevent = (req, res) => {
  const eventId = req.params.eventId;

  Partipant.find({ eventId })
    .populate("doctorId")
    .populate("eventId")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Partipant found!";
      else message = "Partipant successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Partipant.",
      });
    });
};
exports.getParticipantById = async (req, res) => {
  const id = req.params.id;
  try {
    const data = await Partipant.findById(id)
      .populate("doctorId")
      .populate("eventId"); // Use findById to find by ID

    if (!data) {
      return res.status(404).json({
        success: false,
        message: "Participant not found",
      });
    }

    res.status(200).json(data);
  } catch (err) {
    res.status(500).send({
      success: false,
      message:
        err.message || "Some error occurred while retrieving Participant.",
    });
  }
};
exports.delete = (req, res) => {
  Partipant.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Participant not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Participant successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Participant not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Participant with id " + req.params.id,
      });
    });
};
exports.deletebydoctor = (req, res) => {
  const doctorId = req.params.doctorId;
  Partipant.findOneAndDelete({ doctorId })
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Participant not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Participant successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Participant not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Participant with id " + req.params.id,
      });
    });
};
exports.update = (req, res) => {
  const participantId = req.params.participantId;

  if (!participantId) {
    return res.status(400).json({ message: "participantId is required" });
  }
  Partipant.findById(participantId)
    .then((event) => {
      if (!event) {
        return res.status(404).json({ message: "Event not found" });
      }

      event.doctorId = req.body.doctorId || event.doctorId;
      event.eventId = req.body.eventId || event.eventId;
      event.speaker = req.body.speaker || event.speaker;
      event.participon = req.body.participon || event.participon;
      event.description = req.body.description || event.description;

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
