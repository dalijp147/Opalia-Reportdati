const express = require("express");
const router = express.Router();
const feedbackController = require("../../controller/feedback");
router.get("/", feedbackController.get);
router.post("/", feedbackController.create);
router.delete("/delete/:id", feedbackController.delete);
router.put("/feed/:id", feedbackController.updateFeedback);
module.exports = router;
