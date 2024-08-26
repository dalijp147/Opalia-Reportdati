const express = require("express");
const router = express.Router();
const cadeauController = require("../../controller/cadeaupro");
router.post("/", cadeauController.create);
router.put("/update/:id", cadeauController.update);
router.get("/", cadeauController.get);
router.delete("/delete/:id", cadeauController.delete);
module.exports = router;
