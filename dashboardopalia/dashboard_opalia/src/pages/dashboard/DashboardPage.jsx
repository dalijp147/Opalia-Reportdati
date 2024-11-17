// DashboardPage.js
import React, { useEffect, useState } from "react";
import { Typography, Card, Space, Statistic, Table } from "antd";
import { FaUserDoctor, FaUserGroup } from "react-icons/fa6";
import { MdEvent, MdOutlineQuiz } from "react-icons/md";
import { VscFeedback } from "react-icons/vsc";
import axios from "axios";
import WinnerComponent from "../../components/winnerPage";
import ChartComponent from "../../components/ChartComponent";
import MapComponent from "../../components/MapComponent";
import ChartttComponent from "../../components/CahrtttComponent";
import { FaPeopleRobbery } from "react-icons/fa6";
const DashboardPage = () => {
  const [userCount, setUserCount] = useState(0);
  const [eventCount, seteventCount] = useState(0);
  const [feedbackCount, setFeedbackCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [doctorCount, setDoctorCount] = useState(0);
  const [quizCount, setquizCount] = useState(0);
  const [quizpartiCount, setquizpartiCount] = useState(0);
  const [error, setError] = useState(null);

  useEffect(() => {
    axios
      .get("http://localhost:3001/user/")
      .then((response) => setUserCount(response.data.length))
      .catch((error) => console.error("Error fetching user data:", error));
    axios
      .get("http://localhost:3001/medecin/")
      .then((response) => setDoctorCount(response.data.length))
      .catch((error) => console.error("Error fetching doctor data:", error));
    axios
      .get("http://localhost:3001/event/")
      .then((response) => seteventCount(response.data.data.length))
      .catch((error) => console.error("Error fetching event data:", error));
    axios
      .get("http://localhost:3001/quiz/")
      .then((response) => setquizCount(response.data.length))
      .catch((error) => console.error("Error fetching quiz data:", error));
    axios
      .get("http://localhost:3001/feedback/")
      .then((response) => setFeedbackCount(response.data.length))
      .catch((error) => console.error("Error fetching feedback data:", error));
    axios
      .get("http://localhost:3001/result/")
      .then((response) => setquizpartiCount(response.data.length))
      .catch((error) => console.error("Error fetching feedback data:", error));
  }, []);

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Accueil</Typography.Title>
      <Space direction="horizontal">
        <DashBoardCard
          icon={<FaUserGroup style={iconStyle} />}
          title={"Nombre de patient"}
          value={userCount}
        />
        <DashBoardCard
          icon={<FaUserDoctor style={iconStyle} />}
          title={"Nombre de médecin"}
          value={doctorCount}
        />
        <DashBoardCard
          icon={<MdOutlineQuiz style={iconStyle} />}
          title={"Nombre de question"}
          value={quizCount}
        />
        <DashBoardCard
          icon={<MdEvent style={iconStyle} />}
          title={"Nombre d'événement"}
          value={eventCount}
        />
        <DashBoardCard
          icon={<VscFeedback style={iconStyle} />}
          title={"Nombre de Feedback des évenements"}
          value={feedbackCount}
        />
        <DashBoardCard
          icon={<FaPeopleRobbery style={iconStyle} />}
          title={"Nombre de participant au quiz"}
          value={quizpartiCount}
        />
      </Space>

      <div style={{ display: "flex", width: "100%" }}>
        <div style={{ flex: 1 }}>
          <Users />
          <Typography.Title>
            Nombre de participant par Événement
          </Typography.Title>
          <ChartttComponent />
        </div>
        <div style={{ width: "50px" }}></div>
        <div style={{ flex: 1 }}>
          <WinnerComponent /> {/* Adjust the margin as needed */}
          <ChartComponent doctors={doctorCount} patients={userCount} />
        </div>
      </div>
    </Space>
  );
};

function DashBoardCard({ title, value, icon }) {
  return (
    <Card>
      <Space direction="horizontal">
        {icon}
        <Statistic title={title} value={value} />
      </Space>
    </Card>
  );
}

function Users() {
  const [userCount, setUserCount] = useState(0);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    axios
      .get("http://localhost:3001/user/")
      .then((response) => {
        setUsers(response.data);
        setUserCount(response.data.length);
        setLoading(false);
      })
      .catch((error) => {
        setError(error);
        setLoading(false);
      });
  }, []);

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  return (
    <>
      <Typography.Title>Liste des patients</Typography.Title>
      <Table
        columns={[
          { title: "Nom", dataIndex: "familyname" },
          { title: "Prenom", dataIndex: "username" },
          { title: "Email", dataIndex: "email" },
        ]}
        dataSource={users}
      ></Table>
    </>
  );
}

const iconStyle = {
  backgroundColor: "rgba(255,0,0,0.7)",
  borderRadius: 20,
  padding: 8,
  fontSize: 30,
  color: "white",
};

export default DashboardPage;
