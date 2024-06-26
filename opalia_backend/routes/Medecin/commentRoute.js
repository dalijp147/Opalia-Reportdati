const express = require("express");
const router = express.Router();
const Comment_Controller = require("../../controller/comment");

router.get("/", Comment_Controller.get);
router.get("/getbypost/:post", Comment_Controller.getcommentbypost);
router.post("/create", Comment_Controller.create);
router.delete("/delete/:id", Comment_Controller.delete);

module.exports = router;
