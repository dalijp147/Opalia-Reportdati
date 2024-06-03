const express = require("express");
const Scoreapp = express.Router();
const Result = require("../models/result.model");
const sendmail = require("../middleware/sendMail");
const User = require("../models/user.model");

Scoreapp.get("/", async (req, res) => {
  try {
    const result = await Result.find();
    res.json(result);
  } catch (error) {
    res.json({ error });
  }
});

Scoreapp.post("/", async (req, res) => {
  const { userid, attempts, points, gagner } = req.body;
  try {
    const result = new Result({ userid, attempts, points, gagner });
    await result.save();
    // req.body.resultId = Result._id;
    //sendWinnerEmail(result._id);
    res.json({ msg: "sucess result" });
  } catch (error) {
    res.json({ error });
  }
});
const sendWinnerEmail = async (_id) => {
  try {
    //const user = await User.findById(userid);
    const result = await Result.findById(_id).populate("userid");
    if (!result) {
      return res.status(404).send({ message: "Result not found" });
    }
    if (result.gagner) {
      await sendmail(
        result.userid.email,
        "Félicitation! You have won!",
        "Dear Patient,\n\nCongratulations on your recent victory! We're excited to inform you that you have won.\n\nBest regards,\nOpalia Recordati"
      );
    } else {
      res.status(400).send({ message: "User did not win." });
    }
  } catch (error) {
    res.status(500).send({ message: "Internal server error", error });
  }
};
// Scoreapp.post("/check-and-send-email", async (req, res) => {
//   try {
//     const { _id } = req.body;
//     //const user = await User.findById(userid);
//     const result = await Result.findById(_id).populate("userid");
//     if (!result) {
//       return res.status(404).send({ message: "Result not found" });
//     }
//     if (result.gagner) {
//       await sendmail(
//         result.userid.email,
//         "Congratulations! You have won!",
//         "Dear Patient,\n\nCongratulations on your recent victory! We're excited to inform you that you have won.\n\nBest regards,\nOpalia Recordati"
//       );
//     } else {
//       res.status(400).send({ message: "User did not win." });
//     }
//   } catch (error) {
//     res.status(500).send({ message: "Internal server error", error });
//   }
// });
Scoreapp.get("/byUser/:userid", async (req, res) => {
  const userid = req.params.userid;

  try {
    const allResult = await Result.find({
      userid,
    });

    res.status(200).json(allResult);
  } catch (err) {
    res.status(400).send({ message: "Failed to create result", error });
  }
});

Scoreapp.get("/:userid", async (req, res) => {
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
Scoreapp.delete("/delete/:id", geREsult, async (req, res) => {
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
module.exports = Scoreapp;
