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
    const { userid, result, attempts, points } = req.body;
    if (!result && !userid) throw new Error("data  not provided");
    Result.create({ userid, result, attempts, points });
    res.json({ msg: "sucess" });
  } catch (error) {
    res.json({ error });
  }
});
module.exports = app;
