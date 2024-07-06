const express = require("express");
const Scoreapp = express.Router();
const Result = require("../models/Patient/result.model");
const sendmail = require("../middleware/sendMail");
const User = require("../models/Patient/user.model");

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
    req.body.resultId = Result._id;
    //sendWinnerEmail(result._id);
    res.json({ msg: "sucess result" });
  } catch (error) {
    res.json({ error });
  }
});
Scoreapp.post("/doctor", async (req, res) => {
  const { doctorId, attempts, points, gagner } = req.body;
  try {
    const result = new Result({ doctorId, attempts, points, gagner });
    await result.save();
    req.body.resultId = Result._id;
    // sendWinnerEmail(result._id);
    res.json({ msg: "sucess result" });
  } catch (error) {
    res.json({ error });
  }
});
const sendWinnerEmail = async (_id, res, req) => {
  try {
    if (!res) {
      console.error("Response object (res) is undefined");
      throw new Error("Response object is required");
    }

    console.log("Fetching result with ID:", _id);
    const result = await Result.findById(_id).populate("userid");

    if (!result) {
      console.log("Result not found");
      return res.status(404).send({ message: "Result not found" });
    }

    console.log("Result found:", result);

    if (result.gagner) {
      console.log("User has won, sending email to:", result.userid.email);
      await sendmail(
        result.userid.email,
        "Félicitation! You have won!",
        "Dear Patient,\n\nCongratulations on your recent victory! We're excited to inform you that you have won.\n\nBest regards,\nOpalia Recordati"
      );
      console.log("Email sent successfully");
      return res.status(200).send({ message: "Email sent successfully" });
    } else {
      console.log("User did not win");
      return res.status(400).send({ message: "User did not win." });
    }
  } catch (error) {
    console.error("Error occurred:", error);
    if (res) {
      return res
        .status(500)
        .send({ message: "Internal server error", error: error.message });
    } else {
      console.error("Cannot send response, res is undefined");
      throw error;
    }
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
// Scoreapp.get("/:userid", async (req, res) => {
//   const userid = req.params.userid;
//   try {
//     const result = await Result.findOne({ userid });
//     if (!result) {
//       return res
//         .status(404)
//         .json({ message: "result not found for this user." });
//     }
//     res.status(200).json(result);
//     // Function to be executed every Monday
//     function scheduledMethod() {
//       console.log("This method is executed every Monday at 3:30 PM");
//       // Add your code here to perform the desired action
//     }

//     // Function to calculate the delay until the next Monday at 3:30 PM
//     function getNextMondayAtTime(hour, minute) {
//       const now = new Date();
//       const nextMonday = new Date(
//         now.getFullYear(),
//         now.getMonth(),
//         now.getDate() + ((1 + 7 - now.getDay()) % 7), // Get the next Monday
//         hour,
//         minute
//       );

//       if (nextMonday <= now) {
//         nextMonday.setDate(nextMonday.getDate() + 7); // Ensure the time is in the future
//       }

//       return nextMonday.getTime() - now.getTime();
//     }

//     // Schedule the first execution
//     const initialDelay = getNextMondayAtTime(15, 30); // 3:30 PM

//     setTimeout(function run() {
//       scheduledMethod();
//       setInterval(scheduledMethod, 7 * 24 * 60 * 60 * 1000); // Schedule subsequent executions every week
//     }, initialDelay);
//   } catch (err) {
//     res.status(500).json({ message: "Internal server error." });
//   }
// });
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
