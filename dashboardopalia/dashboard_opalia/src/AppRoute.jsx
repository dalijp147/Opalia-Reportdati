import React from "react";
import { Routes, Route } from "react-router-dom";
import DashboardPage from "./pages/dashboard/DashboardPage";
import EventsPage from "./pages/events/EventsPage";
import NewsPage from "./pages/news/NewsPage";
import QuizPapge from "./pages/quiz/QuizPapge";
import UserPage from "./pages/user/UserPage";
import DoctorPage from "./pages/user/DoctorPAge";
import ProgrammePage from "./pages/programme/ProgrammePage";
import ParticipantsPage from "./pages/user/ParticipantPage";
const AppRoute = () => {
  return (
    <Routes>
      <Route path="/" element={<DashboardPage />}></Route>{" "}
      <Route path="/events" element={<EventsPage />}></Route>{" "}
      <Route path="/news" element={<NewsPage />}></Route>{" "}
      <Route path="/quiz" element={<QuizPapge />}></Route>{" "}
      <Route path="/user" element={<UserPage />}></Route>{" "}
      <Route path="/doc" element={<DoctorPage />}></Route>{" "}
      <Route path="/Programme" element={<ProgrammePage />}></Route>{" "}
      <Route path="/Participant" element={<ParticipantsPage />}></Route>
    </Routes>
  );
};

export default AppRoute;
