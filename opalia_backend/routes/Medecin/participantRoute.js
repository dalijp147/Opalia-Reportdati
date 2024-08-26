const express = require("express");
const router = express.Router();
const Particpant_controller = require("../../controller/participan");

router.get("/", Particpant_controller.get);
router.get("/participant/:id", Particpant_controller.getParticipantById);
router.get("/byid/:doctorId", Particpant_controller.getParticipantIfExist);
router.get("/speaker/:speaker/:eventId", Particpant_controller.getspeaker);
router.get(
  "/participon/:participon/:eventId",
  Particpant_controller.getparicipant
);
router.post("/create", Particpant_controller.create);
router.delete("/delete/:id", Particpant_controller.delete);
router.delete(
  "/deletebydoctorid/:doctorId",
  Particpant_controller.deletebydoctor
);
router.put(
  "/update/:participantId",

  Particpant_controller.update
);
router.get(
  "/byiddoc/:doctorId/:eventId",
  Particpant_controller.getParticipantPartipeaevenement
);
router.get(
  "/participon/:eventId",
  Particpant_controller.getparicipantandspeakertoevent
);
router.patch("/approve/:id", Particpant_controller.approveParticipant);
router.patch("/disapprove/:id", Particpant_controller.disapproveParticipant);
router.get(
  "/:doctorId/speaker",
  Particpant_controller.getEventsWhereParticipantIsSpeaker
);

module.exports = router;
