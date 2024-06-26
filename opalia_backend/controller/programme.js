const Programme = require("../models/Medecin/programe.model");
exports.create = (req, res) => {
  var programme = new Programme({
    prog: req.body.prog,

    event: req.body.event,
  });
  programme
    .save()
    .then((data) => {
      res.status(200).json({ data });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while creating the programme.",
      });
    });
};
exports.get = (req, res) => {
  Programme.find()
    .populate("event")
    .populate("prog.speaker")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Programme found!";
      else message = "Programme successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Programme.",
      });
    });
};
exports.delete = (req, res) => {
  Programme.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Programme not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Programme successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Programme not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Programme with id " + req.params.id,
      });
    });
};
exports.sortbydate = (req, res) => {
  const event = req.params.event;
  Programme.find({ event })
    .populate("prog")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Programme found!";
      else message = "Programme successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Programme.",
      });
    });
};
