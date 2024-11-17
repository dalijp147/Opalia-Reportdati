const moogoose = require("mongoose");
  const ProgrammeSchema = moogoose.Schema(
    {
      event: {
        type: moogoose.Schema.Types.ObjectId,
        ref: "Event",
      },
      prog: [
        {
          time: {
            type: Date,
            default: Date.now,
          },
          title: {
            type: String,
          },
          speaker: [
            {
              type: moogoose.Schema.Types.ObjectId,
              ref: "Particant",
            },
          ],
        },
      ],
    },
    { timestamps: true }
  );

module.exports = moogoose.model("Programme", ProgrammeSchema);
