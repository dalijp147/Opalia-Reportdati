const express = require("express");
const router = express.Router();
const Programme_controller = require("../../controller/programme");
router.get("/", Programme_controller.get);
router.get("/sort/:event", Programme_controller.sortbydate);
router.post("/create", Programme_controller.create);
router.delete("/delete/:id", Programme_controller.delete);
module.exports = router;
