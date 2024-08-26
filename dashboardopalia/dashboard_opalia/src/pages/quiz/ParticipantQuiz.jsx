import { Typography, Space, Table, Avatar, Button, message, Input } from "antd";
import React, { useEffect, useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

const { Search } = Input;

const ParticipantQuizPage = () => {
  const navigate = useNavigate();

  const [participants, setParticipants] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchQuery, setSearchQuery] = useState("");

  useEffect(() => {
    fetchParticipants();
  }, []);

  const baseUrl = "http://localhost:3001";

  const fetchParticipants = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/result/`);
      setParticipants(response.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
    }
  };

  const getPathFromUrl = (url) => {
    try {
      const urlObject = new URL(url);
      return urlObject.pathname;
    } catch (error) {
      console.error("Invalid URL: ", url);
      return url;
    }
  };

  const handleDeleteEvent = async (id) => {
    try {
      await axios.delete(`${baseUrl}/result/delete/${id}`);
      message.success("Participant successfully deleted!");
      fetchParticipants();
    } catch (error) {
      message.error("Failed to delete participant!");
    }
  };

  const handleSearch = (query) => {
    setSearchQuery(query);
  };

  const filteredParticipants = participants.filter(
    (user) =>
      user.doctorId.username
        .toLowerCase()
        .includes(searchQuery.toLowerCase()) ||
      user.cadeau.toLowerCase().includes(searchQuery.toLowerCase())
  );

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Participant au Quiz</Typography.Title>
      <Search
        placeholder="Rechercher un participant"
        onSearch={handleSearch}
        onChange={(e) => handleSearch(e.target.value)}
        style={{ width: 300, marginBottom: 20 }}
      />
      <Table
        loading={loading}
        columns={[
          {
            title: "Image",
            dataIndex: ["doctorId", "image"],
            render: (image) => {
              const imagePath = getPathFromUrl(image);
              const fullImageUrl = `${baseUrl}${imagePath}`;
              return <Avatar src={fullImageUrl} />;
            },
          },
          {
            title: "Nom du participant",
            dataIndex: ["doctorId", "userid"], // this won't work as intended, so we use render
            render: (text, record) => {
              // Check if `doctorId` or `userid` exists and display the corresponding `username`
              const username =
                record.doctorId?.username + " " + record.doctorId?.familyname ||
                record.userid?.username + " " + record.userid?.familyname;
              return username || "Unknown";
            },
          },
          { title: "Points", dataIndex: "points" },
          { title: "Cadeau", dataIndex: "cadeau" },
          {
            title: "Gagner",
            dataIndex: "gagner",
            render: (gagner) => (gagner ? "Oui" : "Non"),
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleDeleteEvent(record._id)} danger>
                  Supprimer
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={filteredParticipants}
        rowKey="_id"
        pagination={{
          pageSize: 5,
        }}
      />
    </Space>
  );
};

export default ParticipantQuizPage;
