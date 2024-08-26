const Quiz = require("../models/quiz.model");

const Result = require("../models/Patient/participantquiz.model");
exports.create = (req, res) => {
  var quiz = new Quiz({
    questions: req.body.questions,
    answers: req.body.answers,
    options: req.body.options,
  });
  quiz
    .save()
    .then((data) => {
      res.status(200).json({ data });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while creating the quiz.",
      });
    });
};

exports.get = (req, res) => {
  Quiz.find()
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
exports.delete = (req, res) => {
  Quiz.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Quiz not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Quiz successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Quiz not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Quiz with id " + req.params.id,
      });
    });
};
exports.getRandom = async (req, res) => {
  try {
    const randomQuestions = await Quiz.aggregate([{ $sample: { size: 5 } }]);

    const formattedQuestions = randomQuestions.map((q) => ({
      questions: q.questions,
      options: q.options,
      answers: q.answers,
    }));

    res.status(200).json(formattedQuestions);
  } catch (error) {
    console.error("Error fetching random questions:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
exports.getwinner = (req, res) => {
  const gagner = req.params.gagner;
  Result.find({ gagner })
    .populate("userid")
    .populate("doctorId")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No winner found!";
      else message = "winner successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving winnner.",
      });
    });
};
