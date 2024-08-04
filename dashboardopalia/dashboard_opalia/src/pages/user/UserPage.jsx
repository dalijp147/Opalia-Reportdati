import {
  Typography,
  Card,
  Space,
  message,
  Table,
  Button,
  Avatar,
  Input,
} from "antd";
import axios from "axios";
import React, { useEffect, useState } from "react";
const { Search } = Input;
const UserPage = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [fileList, setFileList] = useState([]);
  const [searchQuery, setSearchQuery] = useState("");
  useEffect(() => {
    fetchMedecin();
  }, []);
  const baseUrl = "http://localhost:3001";
  const fetchMedecin = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/user/`);
      setUsers(response.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
    }
  };
  if (error) {
    return <div>Error: {error.message}</div>;
  }
  const handleDeleteMedecin = async (id) => {
    try {
      await axios.delete(`${baseUrl}/user/delete/${id}`);
      message.success("user successfully deleted!");
      fetchMedecin();
    } catch (error) {
      message.error("user to delete Medecin!");
    }
  };
  const getPathFromUrl = (url) => {
    try {
      const urlObject = new URL(url);
      return urlObject.pathname;
    } catch (error) {
      console.error("Invalid URL: ", url);
      return url; // return the original URL if it's invalid
    }
  };
  const handleFileChange = ({ fileList }) => {
    setFileList(fileList);
  };
  const handleSearch = (query) => {
    setSearchQuery(query);
  };

  const filteredUsers = users.filter(
    (user) =>
      user.familyname.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.username.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.email.toLowerCase().includes(searchQuery.toLowerCase())
  );
  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Patient</Typography.Title>
      <Search
        placeholder="Rechercher un docteur"
        onSearch={handleSearch}
        onChange={(e) => handleSearch(e.target.value)}
        style={{ width: 300, marginBottom: 20 }}
      />
      <Table
        loading={loading}
        columns={[
          {
            title: "Image",
            dataIndex: "image",
            key: "image",
            render: (image) => {
              const imagePath = getPathFromUrl(image);

              const fullImageUrl = `${baseUrl}${imagePath}`;

              console.log("Full Image URL: ", fullImageUrl);
              return <Avatar src={fullImageUrl} />;
            },
          },
          { title: "Nom", dataIndex: "familyname" },
          { title: "Prénom", dataIndex: "username" },
          { title: "Email", dataIndex: "email" },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleDeleteMedecin(record._id)} danger>
                  Supprimer
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={filteredUsers}
        rowKey="_id"
        pagination={{
          pageSize: 6,
        }}
      ></Table>
    </Space>
  );
};

export default UserPage;
