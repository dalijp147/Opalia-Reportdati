const express = require("express");
const router = express.Router();
const AnswerToQuestion_Controller = require("../controller/answerToQuestion");

router.get("/", AnswerToQuestion_Controller.get);
router.get(
  "/getbypost/:question",
  AnswerToQuestion_Controller.getcommentbypost
);
router.post("/createDocReponse", AnswerToQuestion_Controller.createDocReponse);
router.post(
  "/createUserReponse",
  AnswerToQuestion_Controller.createUserReponse
);
router.delete("/delete/:id", AnswerToQuestion_Controller.delete);

module.exports = router;
