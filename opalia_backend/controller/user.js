const User = require("../models/Patient/user.model");
exports.delete = (req, res) => {
  User.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "User not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "User successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "User not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete User with id " + req.params.id,
      });
    });
};
