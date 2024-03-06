const express = require("express");
const app = express();
const mongoose = require("mongoose");
const categorieRoute = require("../routes/categorieRoute.js");
const mediRoute = require("../routes/mediRoute.js");
// const errors = require("./middleware/error.js");
const dotenv = require("dotenv");
dotenv.config();

//middleware
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

//routes
app.use("/catgorie", categorieRoute);
app.use("/medicament", mediRoute);

//mongoose connection
mongoose.connect(process.env.MONGO_URL, {}).then(
  () => {
    console.log("Database connceted");
  },
  (error) => {
    console.log("Database can't be connected :" + error);
  }
);

app.listen(process.env.PORT, () =>
  console.log(`Running Express Server on Port  ${process.env.PORT} `)
);
