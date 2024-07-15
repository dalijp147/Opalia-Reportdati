const Farma = require("../models/Medecin/pharmamodel");
exports.createFarma = async (req, res) => {
  try {
    const newFarma = new Farma(req.body);
    const savedFarma = await newFarma.save();
    res.status(201).json(savedFarma);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};
exports.get = (req, res) => {
  Farma.find()

    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No Farma found!";
      else message = "Farma successfully retrieved";

      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving Farma.",
      });
    });
};

// PUT: Update an existing Farma document
exports.updateFarma = async (req, res) => {
  const { id } = req.params;
  try {
    const updatedFarma = await Farma.findByIdAndUpdate(id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!updatedFarma) {
      return res.status(404).json({ message: "Farma not found" });
    }
    res.status(200).json(updatedFarma);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};
exports.delete = (req, res) => {
  Farma.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Farma not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Farma successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Farma not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Farma with id " + req.params.id,
      });
    });
};
