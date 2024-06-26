const Comment = require("../models/Medecin/Comments.model");

exports.get = (req, res) => {
  Comment.find()
    .populate("doc")
    .populate("post")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No Comment found!";
      else message = "Comment successfully retrieved";

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
exports.getcommentbypost = (req, res) => {
  const post = req.params.post;
  Comment.find({ post })
    .populate("doc")
    .populate("post")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No Comment found!";
      else message = "Comment successfully retrieved";

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
exports.create = (req, res) => {
  var comment = new Comment({
    doc: req.body.doc,
    post: req.body.post,
    comment: req.body.comment,
  });
  comment
    .save()
    .then((data) => {
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while creating the comment .",
      });
    });
};
exports.delete = (req, res) => {
  Comment.findByIdAndDelete(req.params.id)
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
