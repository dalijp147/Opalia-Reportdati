const express = require("express");
const app = express();
const mongoose = require("mongoose");
const categorieRoute = require("../routes/categorieRoute.js");
const mediRoute = require("../routes/mediRoute.js");
const newsRoute = require("../routes/newsRoute.js");
const ReminderRoute = require("../routes/ReminderRoute.js");
const QuizRoute = require("../routes/quizRoute.js");
const ResultRoute = require("../routes/resultRoute.js");
const UserRoute = require("../routes/userRoute.js");
const DossierRoute = require("../routes/DossierMediRoute.js");
const dotenv = require("dotenv");
const body_parser = require("body-parser");
dotenv.config();

//middleware
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(body_parser.json());

app.use("/uploads", express.static("uploads"));
//routes
app.use("/dossier", DossierRoute);
app.use("/catgorie", categorieRoute);
app.use("/medicament", mediRoute);
app.use("/news", newsRoute);
app.use("/reminder", ReminderRoute);
app.use("/quiz", QuizRoute);
app.use("/result", ResultRoute);
app.use("/user", UserRoute);
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
