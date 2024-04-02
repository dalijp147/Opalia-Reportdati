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
    const { username, result, attempts, achived, points } = req.body;
    if (!result && !username) throw new Error("data  not provided");
    Result.create({ username, result, attempts, achived, points });
    res.json({ msg: "sucess" });
  } catch (error) {
    res.json({ error });
  }
});
module.exports = app;
