const AnswerToQuestion = require("../models/AnswerToQuestionmodel");
const { broadcastNewComment } = require("../middleware/broadcast");
const { getIo } = require("../middleware/Socket");
exports.get = (req, res) => {
  AnswerToQuestion.find()
    .populate("doc")
    .populate("question")
    .populate("user")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No Comment found!";
      else message = "AnswerToQuestion successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message ||
          "Some error occurred while retrieving AnswerToQuestion.",
      });
    });
};
exports.getcommentbypost = (req, res) => {
  const question = req.params.question;
  AnswerToQuestion.find({ question })
    .populate("doc")
    .populate("user")
    .then((data) => {
      if (data.length === 0) {
        return res.status(404).json({ message: "No comments found!" });
      }
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message ||
          "Some error occurred while retrieving DiscuCommentssion.",
      });
    });
};
exports.createDocReponse = (req, res, next) => {
  const comment = new AnswerToQuestion({
    doc: req.body.doc,
    question: req.body.question,
    comment: req.body.comment,
  });

  comment
    .save()
    .then((data) => {
      const io = getIo();
      io.emit("new_comment", data); // Ensure the event name matches what the client expects
      res.status(201).json({
        success: true,
        message: "Comment successfully created",
        data,
      });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while creating the comment.",
      });
    });
};
exports.createUserReponse = (req, res, next) => {
  const comment = new AnswerToQuestion({
    user: req.body.user,
    question: req.body.question,
    comment: req.body.comment,
  });

  comment
    .save()
    .then((data) => {
      const io = getIo();
      io.emit("new_comment", data);
      res.status(201).json({
        success: true,
        message: "Comment successfully created",
        data,
      });
      res.status(200).json(data);
    })
    .catch((err) => {
      console.error("Error fetching comments:", err);
      res.status(500).json({ message: "Internal server error" });
    });
};
exports.delete = (req, res) => {
  AnswerToQuestion.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Comment not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Comment successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Comment not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Comment with id " + req.params.id,
      });
    });
};
