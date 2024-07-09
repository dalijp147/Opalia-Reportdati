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
