const express = require("express");
const router = express.Router();
const answerController = require("../../controller/answer");
router.post("/post-answer", answerController.postAnswer);
router.post("/post", answerController.post);
router.get("/get-answers/:questionId", answerController.getAnswers);
router.delete("/delete/:id", answerController.delete);
module.exports = router;
