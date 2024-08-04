const Feedback = require("../models/Medecin/feedbackmodel");

exports.create = async (req, res) => {
  try {
    const { participantId, eventId, etoile, comment } = req.body;

    // Check if feedback already exists
    const existingFeedback = await Feedback.findOne({ participantId, eventId });

    if (existingFeedback) {
      return res.status(400).json({
        success: false,
        message:
          "Feedback for this event from this participant already exists.",
      });
    }

    // Create new feedback
    const feedback = new Feedback({
      participantId,
      eventId,
      etoile,
      comment,
    });

    const data = await feedback.save();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).send({
      success: false,
      message:
        err.message || "Some error occurred while creating the feedback.",
    });
  }
};
exports.get = (req, res) => {
  Feedback.find()
    .populate("participantId")
    .populate("eventId")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Feedback found!";
      else message = "Feedback successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Feedback.",
      });
    });
};
exports.delete = (req, res) => {
  Feedback.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Feedback not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Feedback successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Feedback not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Feedback with id " + req.params.id,
      });
    });
};
exports.updateFeedback = async (req, res) => {
  const { id } = req.params;
  try {
    const updatedFeedback = await Feedback.findByIdAndUpdate(id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!updatedFeedback) {
      return res.status(404).json({ message: "Feedback not found" });
    }
    res.status(200).json(updatedFeedback);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};
exports.getfeedbypartiandevent = (req, res) => {
  const participantId = req.params.participantId;
  const eventId = req.params.eventId;
  Feedback.find({ participantId, eventId })
    .populate("participantId")
    .populate("eventId")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Feedback found!";
      else message = "Feedback successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Feedback.",
      });
    });
};
