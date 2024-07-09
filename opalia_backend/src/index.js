const express = require("express");
const app = express();
const mongoose = require("mongoose");
const categorieRoute = require("../routes/Patient/categorieRoute.js");
const mediRoute = require("../routes/mediRoute.js");
const newsRoute = require("../routes/newsRoute.js");
const ReminderRoute = require("../routes/Patient/ReminderRoute.js");
const QuizRoute = require("../routes/quizRoute.js");
const ResultRoute = require("../routes/resultRoute.js");
const UserRoute = require("../routes/Patient/userRoute.js");
const DossierRoute = require("../routes/Patient/DossierMediRoute.js");
const DoctorRoute = require("../routes/Medecin/medecinRoute.js");
const EventRoute = require("../routes/Medecin/eventRoute.js");
const ParticapntRoute = require("../routes/Medecin/participantRoute.js");
const CategoriePtoRoute = require("../routes/Medecin/categorieMedecinRoute.js");
const ProgrammeRoute = require("../routes/Medecin/programmeRoute.js");
const DiscussionRoute = require("../routes/Medecin/discussionRoute.js");
const CommentRoute = require("../routes/Medecin/commentRoute.js");
const RequestAdminRoute = require("../routes/Medecin/requestadminRoute.js");
const FarmaRoute = require("../routes/Medecin/farmaRoute.js");
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
app.use("/medecin", DoctorRoute);
app.use("/categoriePro", CategoriePtoRoute);
app.use("/event", EventRoute);
app.use("/programme", ProgrammeRoute);
app.use("/discussion", DiscussionRoute);
app.use("/participant", ParticapntRoute);
app.use("/comment", CommentRoute);
app.use("/RequestAdmin", RequestAdminRoute);
app.use("/Farma", FarmaRoute);

//mongoose connection
mongoose.connect(process.env.MONGO_URL, {}).then(
  () => {
    console.log("Database connceted");
  },
  (error) => {
    console.log("Database can't be connected :" + error);
  }
);

///run server
app.listen(process.env.PORT, () =>
  console.log(`Running Express Server on Port  ${process.env.PORT} `)
);
