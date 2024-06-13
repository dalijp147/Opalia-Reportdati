const express = require("express");
const router = express.Router();

const Quiz_Controller = require("../controller/quiz");

router.get("/", Quiz_Controller.get);
router.post("/", Quiz_Controller.create);
router.delete("/delete/:id", Quiz_Controller.delete);
module.exports = router;
