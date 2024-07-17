import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import DashboardPage from "./pages/dashboard/DashboardPage";
import EventsPage from "./pages/events/EventsPage";
import NewsPage from "./pages/news/NewsPage";
import QuizPapge from "./pages/quiz/QuizPapge";
import UserPage from "./pages/user/UserPage";
import DoctorPage from "./pages/user/DoctorPAge";
import ProgrammePage from "./pages/programme/ProgrammePage";
import ParticipantsPage from "./pages/user/ParticipantPage";
import CategorieNewsPage from "./pages/news/CategorieNewsPage";
import FeedbackPage from "./pages/events/FeedbackPage";
import Login from "./pages/auth/Login";
import Signup from "./pages/auth/Signup";

import { useAuthContext } from "./hooks/useAuthContext";
const AppRoute = () => {
  const { user } = useAuthContext();
  return (
    <Routes>
      <Route
        path="/"
        element={user ? <DashboardPage /> : <Navigate to="/login" />}
      />
      <Route
        path="/login"
        element={!user ? <Login /> : <Navigate to="/" />}
      ></Route>{" "}
      <Route
        path="/signup"
        element={user ? <Signup /> : <Navigate to="/" />}
      ></Route>{" "}
      <Route
        path="/events"
        element={user ? <EventsPage /> : <Navigate to="/login" />}
      ></Route>{" "}
      <Route
        path="/feedback"
        element={user ? <FeedbackPage /> : <Navigate to="/login" />}
      ></Route>{" "}
      <Route
        path="/news"
        element={user ? <NewsPage /> : <Navigate to="/login" />}
      ></Route>{" "}
      <Route
        path="/categorie"
        element={user ? <CategorieNewsPage /> : <Navigate to="/login" />}
      ></Route>{" "}
      <Route
        path="/quiz"
        element={user ? <QuizPapge /> : <Navigate to="/login" />}
      ></Route>{" "}
      <Route
        path="/user"
        element={user ? <UserPage /> : <Navigate to="/login" />}
      ></Route>{" "}
      <Route
        path="/doc"
        element={user ? <DoctorPage /> : <Navigate to="/login" />}
      ></Route>{" "}
      <Route
        path="/Programme"
        element={user ? <ProgrammePage /> : <Navigate to="/login" />}
      ></Route>{" "}
      <Route
        path="/Participant"
        element={user ? <ParticipantsPage /> : <Navigate to="/login" />}
      ></Route>
    </Routes>
  );
};

export default AppRoute;
