const moogoose = require("mongoose");

const newsSchema = moogoose.Schema({
  newsTitle: {
    type: String,
    require: true,
    unique: true,
  },
  newsAuthor: {
    type: String,
  },
  newsDetail: {
    type: String,
    require: true,
  },
  newsImage: {
    type: String,
  },
  newsPublication: {
    type: Date,
    default: Date.now,
  },
});
module.exports = moogoose.model("News", newsSchema);
