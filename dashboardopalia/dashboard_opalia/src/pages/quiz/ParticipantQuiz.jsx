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

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Participant au Quiz</Typography.Title>

      <Table
        loading={loading}
        columns={[
          {
            title: "Image",
            dataIndex: ["doctorId", "userid"], // Using render to handle both doctorId and userid
            render: (text, record) => {
              // Fallback URL for cases when no image is available
              const defaultImageUrl = `${baseUrl}/path-to-default-avatar.png`;

              // Get image from doctorId if it exists, otherwise from userid
              const image = record.doctorId?.image || record.userid?.image;

              // Check if the image exists and generate the full image URL
              const imagePath = image ? getPathFromUrl(image) : null;
              const fullImageUrl = imagePath
                ? `${baseUrl}${imagePath}`
                : defaultImageUrl;

              // Return an Avatar component with the constructed URL
              return <Avatar src={fullImageUrl} />;
            },
          },
          {
            title: "Nom du participant",
            dataIndex: ["doctorId", "userid"], // this still won't work as intended, so we use render
            render: (text, record) => {
              let username = "Unknown";

              if (record.doctorId) {
                // If doctorId exists, use its username and familyname
                username = `${record.doctorId.username || ""} ${
                  record.doctorId.familyname || ""
                }`.trim();
              } else if (record.userid) {
                // If userid exists and doctorId is not available, use its username and familyname
                username = `${record.userid.username || ""} ${
                  record.userid.familyname || ""
                }`.trim();
              }

              // If both username and familyname are empty, return "Unknown"
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
        dataSource={participants}
        rowKey="_id"
        pagination={{
          pageSize: 5,
        }}
      />
    </Space>
  );
};

export default ParticipantQuizPage;
