const express = require("express");
const router = express.Router();
const upload = require("../../middleware/upload");
const Event_controller = require("../../controller/event");

router.get("/", Event_controller.get);
router.post("/create", upload.single("eventimage"), Event_controller.create);
router.delete("/delete/:id", Event_controller.delete);
router.delete("/deletePastevent", Event_controller.deletePastEvents);
router.put(
  "/events/:eventId",
  upload.single("eventimage"),
  Event_controller.update
);
router.get("/:id", Event_controller.getbyid);
module.exports = router;
