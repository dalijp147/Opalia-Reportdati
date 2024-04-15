const espress = require("express");

const app = espress.Router();
const Quiz = require("../models/quiz.model");

app.get("/", async (req, res) => {
  try {
    const quiz = await Quiz.find();
    res.json(quiz);
  } catch (err) {
    res.json(err);
  }
});
app.post("/", async (req, res) => {
  const quiz = new Quiz({
    questions: req.body.questions,
    answers: req.body.answers,
    options: req.body.options,
  });
  try {
    const newquiz = await quiz.save();

    res.json({ newquiz });
  } catch (error) {
    res.json({ error });
  }
});

app.delete("/delete/:id", getQuiz, async (req, res) => {
  try {
    await res.quiz.deleteOne();
    res.status(200).json({ message: "Delete Quiz" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

//middleware
async function getQuiz(req, res, next) {
  try {
    quiz = await Quiz.findById(req.params.id);
    if (quiz == null) {
      return res.status(404).json({ message: "cant find quiz" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.quiz = quiz;
  next();
}
module.exports = app;
