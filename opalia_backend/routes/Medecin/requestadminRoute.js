const express = require("express");
const {
  registerParticipant,
  approveRequest,
  rejectRequest,
  get,
} = require("../../controller/requestadmin");
const router = express.Router();

router.post("/register", registerParticipant);
router.put("/approve/:id", approveRequest);
router.put("/reject/:id", rejectRequest);
router.get("/get", get);
module.exports = router;
