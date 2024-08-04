const Answer = require("../models/Medecin/AnswerModel");
const Question = require("../models/Patient/Question.model");
const UserResponse = require("../models/Patient/ReponseAnswer");
const { getIo } = require("../middleware/Socket");
exports.postAnswer = async (req, res) => {
  try {
    const { answer, doctorId, questionId } = req.body;

    const newAnswer = new Answer({
      answer,
      doctorId,
      questionId,
    });

    await newAnswer.save();
    const io = getIo();
    io.emit("new_answer", newAnswer);
    res.status(201).json(newAnswer);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.getAnswers = async (req, res) => {
  try {
    const { questionId } = req.params;
    const answers = await Answer.find({ questionId }).populate("doctorId");
    res.json(answers);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.post = async (req, res) => {
  const { answerId, userId, response } = req.body;

  try {
    const newUserResponse = new UserResponse({ answerId, userId, response });
    await newUserResponse.save();

    // Mettre à jour le document de réponse pour inclure la nouvelle réponse d'utilisateur
    await Answer.findByIdAndUpdate(answerId, {
      $push: { userResponses: newUserResponse._id },
    });

    res.status(201).json({ message: "Réponse ajoutée avec succès" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
exports.delete = (req, res) => {
  Answer.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Answer not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Answer successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Answer not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Answer with id " + req.params.id,
      });
    });
};
