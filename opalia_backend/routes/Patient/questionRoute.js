const express = require("express");
const router = express.Router();
const questionController = require("../../controller/question");
router.post("/post-question", questionController.postQuestion);
router.get("/get-questions", questionController.getQuestions);
router.delete("/delete/:id", questionController.delete);
module.exports = router;
