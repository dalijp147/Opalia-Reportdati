const express = require("express");
const Scoreapp = express.Router();
const Result = require("../models/Patient/result.model");
const sendmail = require("../middleware/sendMail");
const User = require("../models/Patient/user.model");
const Quiz_Controller = require("../controller/quiz");
Scoreapp.get("/", async (req, res) => {
  try {
    const result = await Result.find();
    res.json(result);
  } catch (error) {
    res.json({ error });
  }
});

Scoreapp.post("/", async (req, res) => {
  const { userid, attempts, points, gagner, cadeau } = req.body;
  try {
    const result = new Result({ userid, attempts, points, gagner, cadeau });
    await result.save();
    req.body.resultId = result._id;

    const emailSendResult = await sendWinnerEmail(result._id);

    if (emailSendResult.error) {
      return res
        .status(emailSendResult.status)
        .json({ message: emailSendResult.message });
    }

    res.json({ msg: "success result" });
  } catch (error) {
    res.json({ error });
  }
});
Scoreapp.post("/doctor", async (req, res) => {
  const { doctorId, attempts, points, gagner, cadeau } = req.body;
  try {
    const result = new Result({ doctorId, attempts, points, gagner, cadeau });
    await result.save();
    req.body.resultId = result._id;

    const emailSendResult = await sendWinnerEmailPro(result._id);

    if (emailSendResult.error) {
      return res
        .status(emailSendResult.status)
        .json({ message: emailSendResult.message });
    }

    res.json({ msg: "success result" });
  } catch (error) {
    res.json({ error });
  }
});
const sendWinnerEmail = async (_id) => {
  try {
    console.log("Fetching result with ID:", _id);
    const result = await Result.findById(_id).populate("userid");

    if (!result) {
      console.log("Result not found");
      return { error: true, status: 404, message: "Result not found" };
    }

    console.log("Result found:", result);

    if (result.gagner) {
      console.log("User has won, sending email to:", result.userid.email);
      await sendmail(
        result.userid.email,
        "Félicitations! tu as gagné",
        "Cher patient,\n\nFélicitations pour votre récente victoire ! Nous sommes ravis de vous informer que vous avez gagné.\n\nMeilleures salutations,\nOpalia Recordati"
      );
      console.log("Email sent successfully");
      return { error: false, status: 200, message: "Email sent successfully" };
    } else {
      console.log("User did not win");
      return { error: true, status: 400, message: "User did not win." };
    }
  } catch (error) {
    console.error("Error occurred:", error);
    return {
      error: true,
      status: 500,
      message: "Internal server error",
      details: error.message,
    };
  }
};
const sendWinnerEmailPro = async (_id) => {
  try {
    console.log("Fetching result with ID:", _id);
    const result = await Result.findById(_id).populate("doctorId");

    if (!result) {
      console.log("Result not found");
      return { error: true, status: 404, message: "Result not found" };
    }

    console.log("Result found:", result);

    if (result.gagner) {
      console.log("User has won, sending email to:", result.doctorId.email);
      await sendmail(
        result.doctorId.email,
        "Félicitations! tu as gagné",
        "Cher Docteur,\n\nFélicitations pour votre récente victoire ! Nous sommes ravis de vous informer que vous avez gagné.\n\nMeilleures salutations,\nOpalia Recordati"
      );
      console.log("Email sent successfully");
      return { error: false, status: 200, message: "Email sent successfully" };
    } else {
      console.log("User did not win");
      return { error: true, status: 400, message: "User did not win." };
    }
  } catch (error) {
    console.error("Error occurred:", error);
    return {
      error: true,
      status: 500,
      message: "Internal server error",
      details: error.message,
    };
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
Scoreapp.get("/doc/:doctorId", async (req, res) => {
  const doctorId = req.params.doctorId;
  try {
    const result = await Result.findOne({ doctorId });
    if (!result) {
      return res
        .status(404)
        .json({ message: "result not found for this doctor." });
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
Scoreapp.get("/winner/:gagner", Quiz_Controller.getwinner);
module.exports = Scoreapp;
