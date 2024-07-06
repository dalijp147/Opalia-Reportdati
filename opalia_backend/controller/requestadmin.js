const RegistrationRequest = require("../models/Medecin/requestadmin.model");
const sendmail = require("../middleware/sendMail");
const registerParticipant = async (req, res) => {
  try {
    const { eventId, participantId, MedecinId } = req.body;

    const registrationRequest = new RegistrationRequest({
      eventId,
      participantId,
      MedecinId,
    });
    await registrationRequest.save();

    const adminEmail = "dalybouderbela@gmail.com";
    const subject = "Nouvelle demande d'inscription";
    const text = `Un participant a demandé à s'inscrire à l'événement. ID de la demande : ${registrationRequest._id}`;

    await sendmail(adminEmail, subject, text);

    res
      .status(200)
      .send(
        "Demande d'inscription envoyée à l'administrateur pour approbation."
      );
  } catch (error) {
    res.status(500).send(error.toString());
  }
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
};
