const Question = require("../models/Patient/Question.model");
const { getIo } = require("../middleware/Socket");

exports.postQuestion = async (req, res) => {
  try {
    const { question, patientId } = req.body;

    const newQuestion = new Question({
      question,
      patientId,
    });

    await newQuestion.save();
    const io = getIo();
    io.emit("new_question", newQuestion);
    res.status(201).json(newQuestion);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.getQuestions = async (req, res) => {
  try {
    const questions = await Question.find().populate("patientId");
    res.json(questions);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};
exports.delete = (req, res) => {
  Question.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Question not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Question successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Question not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Question with id " + req.params.id,
      });
    });
};
