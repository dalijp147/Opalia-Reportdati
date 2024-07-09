const express = require("express");
const router = express.Router();
const farmaController = require("../../controller/farma");

router.post("/farma", farmaController.createFarma);
router.put("/farma/:id", farmaController.updateFarma);

module.exports = router;
