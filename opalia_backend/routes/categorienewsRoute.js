const express = require("express");
const router = express.Router();
const CategorieNEwsController = require("../controller/categorieNews");
router.get("/", CategorieNEwsController.get);
router.post("/", CategorieNEwsController.create);
router.delete("/delete/:id", CategorieNEwsController.delete);
module.exports = router;
