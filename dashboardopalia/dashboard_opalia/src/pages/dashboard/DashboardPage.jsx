import React, { useEffect, useState } from "react";
import { Typography, Card, Space, Statistic, Table } from "antd";
import { FaUserDoctor, FaUserGroup } from "react-icons/fa6";
import { ContactsOutlined } from "@ant-design/icons";
import axios from "axios";

const DashboardPage = () => {
  return (
    <Space size={20} direction="vertical">
      <Typography.Title>DashBoard</Typography.Title>
      <Space direction="horizontal">
        {" "}
        <DashBoardCard
          icon={
            <FaUserGroup
              style={{
                backgroundColor: "rgba(255,0,0,0.7)",
                borderRadius: 20,
                padding: 8,
                fontSize: 26,
                color: "white ",
              }}
            />
          }
          title={"User"}
          value={12}
        />{" "}
        <DashBoardCard
          icon={
            <FaUserDoctor
              style={{
                backgroundColor: "rgba(255,0,0,0.7)",
                borderRadius: 20,
                padding: 8,
                fontSize: 26,
                color: "white ",
              }}
            />
          }
          title={"Doctor"}
          value={12}
        />{" "}
        <DashBoardCard
          icon={
            <ContactsOutlined
              style={{
                backgroundColor: "rgba(255,0,0,0.7)",
                borderRadius: 20,
                padding: 8,
                fontSize: 24,
                color: "white ",
              }}
            />
          }
          title={"Events"}
          value={12}
        />{" "}
        <DashBoardCard
          icon={
            <FaUserDoctor
              style={{
                backgroundColor: "rgba(255,0,0,0.7)",
                borderRadius: 20,
                padding: 8,
                fontSize: 26,
                color: "white ",
              }}
            />
          }
          title={"Doctor"}
          value={12}
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
      <Space>
        <Users />
      </Space>
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
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  useEffect(() => {
    axios
      .get("http://localhost:3001/user/")
      .then((response) => {
        setUsers(response.data);
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
      <Typography.Text>User</Typography.Text>
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
export default DashboardPage;
