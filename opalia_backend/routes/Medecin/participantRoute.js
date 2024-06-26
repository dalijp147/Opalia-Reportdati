const express = require("express");
const router = express.Router();
const Particpant_controller = require("../../controller/participan");

router.get("/", Particpant_controller.get);
router.get("/byid/:doctorId", Particpant_controller.getParticipantIfExist);
router.get("/speaker/:speaker/:eventId", Particpant_controller.getspeaker);
router.get(
  "/participon/:participon/:eventId",
  Particpant_controller.getparicipant
);
router.post("/create", Particpant_controller.create);
router.delete("/delete/:id", Particpant_controller.delete);

module.exports = router;
