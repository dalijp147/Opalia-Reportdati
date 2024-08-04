const Discussion = require("../models/Medecin/Discusion.model");
const LikeModel = require("../models/Medecin/Like.model");
const { getIo } = require("../middleware/Socket");
exports.create = (req, res) => {
  var discussion = new Discussion({
    subject: req.body.subject,
    author: req.body.author,
    eventId: req.body.eventId,
    likes: req.body.likes,
  });
  discussion
    .save()
    .then((data) => {
      const io = getIo();
      io.emit("new_discussion", data);
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while creating the discussion .",
      });
    });
};
exports.get = (req, res) => {
  Discussion.find()
    .populate("author")
    .populate("eventId")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Discussion found!";
      else message = "Discussion successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Discussion.",
      });
    });
};
exports.delete = (req, res) => {
  Discussion.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Discussion not found with id " + req.params.id,
        });
      }
      io.emit("delete_dicucomment", { id: req.params.id });
      res.send({
        success: true,
        message: "Discussion successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Discussion not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Discussion with id " + req.params.id,
      });
    });
};
exports.getdiscussionbyeventId = (req, res) => {
  const eventId = req.params.eventId;
  Discussion.find({ eventId })
    .populate("eventId")
    .populate("author")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Discussion found!";
      else message = "Discussion successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Discussion.",
      });
    });
};
exports.likedislike = async (req, res) => {
  const { postId, userId } = req.body;
  const existingLike = await LikeModel.findOne({ postId, userId });
  try {
    if (!existingLike) {
      await LikeModel.create(req.body);
      await Discussion.findByIdAndUpdate(
        postId,
        { $inc: { likes: 1 } },
        { new: true }
      );
      return res.status(200).json({ message: "Like added sucessfully..!!" });
    } else {
      await LikeModel.findByIdAndDelete(existingLike._id);
      await Discussion.findByIdAndUpdate(postId, { $inc: { likes: -1 } });
      return res.status(200).json({ message: "Like removed sucessfully..!!" });
    }
  } catch (error) {
    res.status(403).json({ status: false, error: error });
  }
};
