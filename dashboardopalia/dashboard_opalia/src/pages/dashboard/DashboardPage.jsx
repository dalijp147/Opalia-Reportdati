import React, { useEffect, useState } from "react";
import { Typography, Card, Space, Statistic, Table } from "antd";
import { FaUserDoctor, FaUserGroup } from "react-icons/fa6";
import { CalendarOutlined } from "@ant-design/icons";
import { MdEvent, MdOutlineQuiz } from "react-icons/md";
import axios from "axios";
import WinnerComponent from "../../components/winnerPage";

const DashboardPage = () => {
  const [userCount, setUserCount] = useState(0);
  const [eventCount, seteventCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [doctorCount, setDoctorCount] = useState(0);
  const [quizCount, setquizCount] = useState(0);
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
  }, []);

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>DashBoard</Typography.Title>
      <Space direction="horizontal">
        {" "}
        <DashBoardCard
          icon={<FaUserGroup style={iconStyle} />}
          title={"User"}
          value={userCount}
        />{" "}
        <DashBoardCard
          icon={<FaUserDoctor style={iconStyle} />}
          title={"Doctor"}
          value={doctorCount}
        />{" "}
        <DashBoardCard
          icon={<MdOutlineQuiz style={iconStyle} />}
          title={"Nombre de question"}
          value={quizCount}
        />{" "}
        <DashBoardCard
          icon={<MdEvent style={iconStyle} />}
          title={"Événement"}
          value={eventCount}
        />{" "}
      </Space>
      {/* <div>
        <h1>User List</h1>

        <ul>
          {users.map((user) => (
            <li key={user._id}>{user.username}</li> // Assuming users have an _id and name
          ))}
        </ul>
      </div> */}

      <div style={{ display: "flex", width: "100%" }}>
        <div style={{ flex: 1 }}>
          <Users />
        </div>
        <div style={{ width: "50px" }}></div>
        <div style={{ flex: 1 }}>
          <WinnerComponent />
        </div>
      </div>
    </Space>
  );
};
function DashBoardCard({ title, value, icon }) {
  return (
    <Card>
      <Space direction="horizontal">
        {" "}
        {icon}
        <Statistic title={title} value={value} />{" "}
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
      <Typography.Title>Liste d'utilisateur</Typography.Title>
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
