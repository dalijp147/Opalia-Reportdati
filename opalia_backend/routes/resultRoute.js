const express = require("express");
const app = express.Router();
const Result = require("../models/result.model");
app.get("/", async (req, res) => {
  try {
    const result = await Result.find();
    res.json(result);
  } catch (error) {
    res.json({ error });
  }
});
app.post("/", async (req, res) => {
  try {
    const { userid, attempts, points } = req.body;
    if (!points && !userid) throw new Error("data  not provided");
    Result.create({ userid, attempts, points });
    res.json({ msg: "sucess result" });
  } catch (error) {
    res.json({ error });
  }
});
app.get("/byUser/:userid", async (req, res) => {
  const userid = req.params.userid;

  try {
    const allResult = await Result.find({
      userid,
    });

    res.status(200).json(allResult);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

app.get("/:userid", async (req, res) => {
  const userid = req.params.userid;
  try {
    const result = await Result.findOne({ userid });
    if (!result) {
      return res
        .status(404)
        .json({ message: "result not found for this user." });
    }
    res.status(200).json(result);
  } catch (err) {
    res.status(500).json({ message: "Internal server error." });
  }
});
app.delete("/delete/:id", geREsult, async (req, res) => {
  try {
    await res.result.deleteOne();
    res.status(200).json({ message: "Delete Result" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
async function geREsult(req, res, next) {
  try {
    result = await Result.findById(req.params.id);
    if (result == null) {
      return res.status(404).json({ message: "cant find Result" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.result = result;
  next();
}
module.exports = app;
