const Programme = require("../models/Medecin/programe.model");

exports.create = async (req, res) => {
  try {
    const { prog, event } = req.body;

    // Check if feedback already exists
    const existingProgramme = await Programme.findOne({ event });

    if (existingProgramme) {
      return res.status(400).json({
        success: false,
        message: "Programme for this event  already exists.",
      });
    }

    // Create new feedback
    const programme = new Programme({
      prog,
      event,
    });

    const data = await programme.save();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).send({
      success: false,
      message:
        err.message || "Some error occurred while creating the programme.",
    });
  }
};
exports.get = (req, res) => {
  Programme.find()
    .populate("event")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Programme found!";
      else message = "Programme successfully retrieved";
      cleanUpParticipants();
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Programme.",
      });
    });
};
exports.getweb = (req, res) => {
  Programme.find()
    .populate("event")
    .populate({
      path: "prog.speaker",
      populate: {
        path: "doctorId", // Assuming doctorId is referencing another collection
        select: "username", // Fetch only the username field
      },
    })
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0)
        message = "No Programme found!";
      else message = "Programme successfully retrieved";
      cleanUpParticipants();
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Programme.",
      });
    });
};
exports.delete = (req, res) => {
  Programme.findByIdAndDelete(req.params.id)
    .then((data) => {
      if (!data) {
        return res.status(404).send({
          success: false,
          message: "Programme not found with id " + req.params.id,
        });
      }
      res.send({
        success: true,
        message: "Programme successfully deleted!",
      });
    })
    .catch((err) => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).send({
          success: false,
          message: "Programme not found with id " + req.params.id,
        });
      }
      return res.status(500).send({
        success: false,
        message: "Could not delete Programme with id " + req.params.id,
      });
    });
};
exports.sortbydate = (req, res) => {
  const event = req.params.event;

  Programme.find({ event })
    .then((data) => {
      if (!data || data.length === 0) {
        return res.status(404).json({ message: "No Programme found!" });
      }

      // Sort each programme's 'prog' array by time only
      data.forEach((programme) => {
        programme.prog.sort((a, b) => {
          const getTimeValue = (timeObj) => {
            if (typeof timeObj === "string") {
              return new Date("1970-01-01T" + timeObj.split("T")[1] || timeObj);
            } else if (timeObj instanceof Date) {
              return new Date(
                "1970-01-01T" + timeObj.toISOString().split("T")[1]
              );
            } else {
              // If it's neither string nor Date, return the original value
              // This will cause such entries to be sorted to the end
              return timeObj;
            }
          };

          const timeA = getTimeValue(a.time);
          const timeB = getTimeValue(b.time);

          // If both are Date objects, compare them
          if (timeA instanceof Date && timeB instanceof Date) {
            return timeA - timeB;
          }
          // If either is not a Date, sort the non-Date to the end
          return timeA instanceof Date ? -1 : 1;
        });
      });
      cleanUpParticipants();
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while retrieving Programme.",
      });
    });
};
exports.getprogrammebyevent = (req, res) => {
  const event = req.params.event;

  Programme.find({ event })
    .populate({
      path: "prog.speaker",
      populate: {
        path: "doctorId", // Assuming doctorId is referencing another collection
        select: "username", // Fetch only the username field
      },
    })
    .populate("event")
    .then((data) => {
      var message = "";
      if (data === undefined || data.length == 0) message = "No event found!";
      else message = "event successfully retrieved";
      cleanUpParticipants();
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving event.",
      });
    });
};
exports.updateProgramme = (req, res) => {
  const programmeId = req.params.programmeId;

  // Check if the programme ID is provided
  if (!programmeId) {
    return res.status(400).json({ message: "programmeId is required" });
  }

  // Find the programme by ID and update the fields
  Programme.findById(programmeId)
    .then((programme) => {
      if (!programme) {
        return res.status(404).json({ message: "Programme not found" });
      }

      // Update programme fields
      programme.event = req.body.event || programme.event;

      // Update nested prog items
      if (req.body.prog && Array.isArray(req.body.prog)) {
        programme.prog = req.body.prog.map((progItem) => {
          return {
            time: progItem.time || Date.now(),
            title: progItem.title || "",
            speaker: progItem.speaker || [],
          };
        });
      }

      return programme.save();
    })
    .then((updatedProgramme) => {
      res.status(200).json({ data: updatedProgramme });
    })
    .catch((err) => {
      res.status(500).send({
        success: false,
        message:
          err.message || "Some error occurred while updating the programme.",
      });
    });
};
const cleanUpParticipants = () => {
  Programme.deleteMany({
    $or: [{ event: null }, { prog: null }],
  })
    .then(() => {
      console.log("Deleted Programme with null event");
    })
    .catch((err) => {
      console.error("Error occurred while deleting Programmes:", err);
    });
};
