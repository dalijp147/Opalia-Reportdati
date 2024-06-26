const express = require("express");
const router = express.Router();
const Discussion_controller = require("../../controller/discussion");
const Discusion = require("../../models/Medecin/Discusion.model");
router.get("/", Discussion_controller.get);
router.post("/create", Discussion_controller.create);
router.delete("/delete/:id", Discussion_controller.delete);
router.get("/byeventID/:eventId", Discussion_controller.getdiscussionbyeventId);
router.put("/like", async (req, res) => {
  const { postId, userId } = req.body; // Make sure to pass postId and userId in the request body

  // Validate the inputs
  if (!postId || !userId) {
    return res.status(400).json({ error: "postId and userId are required" });
  }

  try {
    const result = await Discusion.findByIdAndUpdate(
      postId,
      {
        $addToSet: { likedBy: userId }, // Use $addToSet to avoid duplicate likes
      },
      { new: true }
    ).populate("author", "name"); // Optionally populate the author field (assuming 'name' is a field in the Medecin model)

    if (!result) {
      return res.status(404).json({ error: "Discussion post not found" });
    }

    res.json(result);
  } catch (err) {
    res.status(422).json({ error: err.message });
  }
});
router.put("/unlike", async (req, res) => {
  const { postId, userId } = req.body; // Make sure to pass postId and userId in the request body

  // Validate the inputs
  if (!postId || !userId) {
    return res.status(400).json({ error: "postId and userId are required" });
  }

  try {
    const result = await Discusion.findByIdAndUpdate(
      postId,
      {
        $pull: { likedBy: userId }, // Use $pull to remove the user from the likedBy array
      },
      { new: true }
    ).populate("author", "name"); // Optionally populate the author field (assuming 'name' is a field in the Medecin model)

    if (!result) {
      return res.status(404).json({ error: "Discussion post not found" });
    }

    res.json(result);
  } catch (err) {
    res.status(422).json({ error: err.message });
  }
});
module.exports = router;
