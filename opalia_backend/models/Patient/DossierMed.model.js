const moogoose = require("mongoose");
const DosierMediSchema = moogoose.Schema({
  userId: { type: moogoose.Schema.Types.ObjectId, ref: "User", required: true },
  poids: {
    type: Number,
    require: true,
  },
  age: {
    type: Number,
    require: true,
  },
  maladie: { type: Array, default: [] },
});
module.exports = moogoose.model("DossierMedi", DosierMediSchema);
