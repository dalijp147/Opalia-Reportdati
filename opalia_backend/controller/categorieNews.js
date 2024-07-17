const CategorieNews = require("../models/CategorieNews.model");
exports.create = (req, res) => {
  var categorieNews = new CategorieNews({
    categorienewsnom: req.body.categorienewsnom,
  });
  categorieNews
    .save()
    .then((data) => {
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message ||
          "Some error occurred while creating the categorieNews.",
      });
    });
};
exports.get = (req, res) => {
  CategorieNews.find()
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No categorieNews found!";
      else message = "categorieNews successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving categorieNews.",
      });
    });
};
exports.delete = (req, res) => {
  CategorieNews.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "categorieNews not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "categorieNews successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "categorieNews not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete categorieNews with id " + req.params.id,
      });
    });
};
