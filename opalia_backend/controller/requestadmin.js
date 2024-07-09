const RegistrationRequest = require("../models/Medecin/requestadmin.model");
const sendmail = require("../middleware/sendMail");
const registerParticipant = async (req, res) => {
  try {
    const { eventId, participantId } = req.body;

    // Check if a registration request already exists for this participant and event
    const existingRequest = await RegistrationRequest.findOne({
      participantId,
    });

    if (existingRequest) {
      return res
        .status(400)
        .send(
          "Une demande d'inscription pour ce participant à cet événement existe déjà."
        );
    }

    // Create and save the new registration request
    const registrationRequest = new RegistrationRequest({
      eventId,
      participantId,
    });
    await registrationRequest.save();

    res.status(200).send("Demande d'inscription enregistrée avec succès.");
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .send("Erreur lors de l'enregistrement de la demande d'inscription.");
  }
};
const get = (req, res) => {
  RegistrationRequest.find()
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No Quiz found!";
      else message = "Quiz successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving Quiz.",
      });
    });
};
const approveRequest = async (req, res) => {
  try {
    const { id } = req.params;
    const registrationRequest = await RegistrationRequest.findByIdAndUpdate(
      id,
      { status: "approved" },
      { new: true }
    );
    if (!registrationRequest) {
      return res.status(404).send("Demande d'inscription non trouvée.");
    }
    res.status(200).send("Demande d'inscription approuvée.");
  } catch (error) {
    res.status(500).send(error.toString());
  }
};

const rejectRequest = async (req, res) => {
  try {
    const { id } = req.params;
    const registrationRequest = await RegistrationRequest.findByIdAndUpdate(
      id,
      { status: "rejected" },
      { new: true }
    );
    if (!registrationRequest) {
      return res.status(404).send("Demande d'inscription non trouvée.");
    }
    res.status(200).send("Demande d'inscription rejetée.");
  } catch (error) {
    res.status(500).send(error.toString());
  }
};

module.exports = {
  registerParticipant,
  approveRequest,
  rejectRequest,
  get,
};
