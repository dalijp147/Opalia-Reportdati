import { Typography, Space, Table, Button, Avatar, message, Input } from "antd";
import axios from "axios";
import React, { useEffect, useState } from "react";
import io from "socket.io-client";

const socket = io("http://localhost:3001");
const { Search } = Input;

const DoctorPage = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchQuery, setSearchQuery] = useState("");

  useEffect(() => {
    fetchMedecin();
  }, []);

  const baseUrl = "http://localhost:3001";

  const fetchMedecin = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/medecin/`);
      setUsers(response.data);
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
      return url; // return the original URL if it's invalid
    }
  };

  const handleDeleteMedecin = async (id) => {
    try {
      await axios.delete(`${baseUrl}/medecin/delete/${id}`);
      message.success("Medecin successfully deleted!");
      setUsers((prevUsers) => prevUsers.filter((user) => user._id !== id));
    } catch (error) {
      message.error("Failed to delete Medecin!");
    }
  };

  const handleApproveMedecin = async (id) => {
    try {
      await axios.patch(`${baseUrl}/medecin/approve/${id}`);
      message.success("Medecin successfully approved!");
      setUsers((prevUsers) =>
        prevUsers.map((user) =>
          user._id === id ? { ...user, isApproved: true } : user
        )
      );
    } catch (error) {
      message.error("Failed to approve Medecin!");
    }
  };

  const handleDisapproveMedecin = async (id) => {
    try {
      await axios.patch(`${baseUrl}/medecin/disapprove/${id}`);
      message.success("Medecin successfully disapproved!");
      setUsers((prevUsers) =>
        prevUsers.map((user) =>
          user._id === id ? { ...user, isApproved: false } : user
        )
      );
    } catch (error) {
      message.error("Failed to disapprove Medecin!");
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
      user.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.specialite.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Docteur</Typography.Title>
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
              return <Avatar src={fullImageUrl} />;
            },
            width: 100,
          },
          {
            title: "Nom",
            dataIndex: "familyname",
            key: "familyname",
            width: 150,
          },
          {
            title: "Prénom",
            dataIndex: "username",
            key: "username",
            width: 150,
          },
          { title: "Email", dataIndex: "email", key: "email", width: 200 },
          {
            title: "Numéro de telephone",
            dataIndex: "numeroTel",
            key: "numeroTel",
            width: 150,
          },
          {
            title: "Spécialité",
            dataIndex: "specialite",
            key: "specialite",
            width: 150,
          },
          {
            title: "Numéro de license",
            dataIndex: "licenseNumber",
            key: "licenseNumber",
            width: 150,
          },
          {
            title: "Statut d'approbation",
            dataIndex: "isApproved",
            key: "isApproved",
            render: (isApproved) => (isApproved ? "Approved" : "Pending"),
            width: 150,
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button
                  type="primary"
                  onClick={() => handleApproveMedecin(record._id)}
                  disabled={record.isApproved}
                >
                  Approuver
                </Button>
                <Button
                  type="default"
                  onClick={() => handleDisapproveMedecin(record._id)}
                  disabled={!record.isApproved}
                >
                  Désapprouver
                </Button>
                <Button onClick={() => handleDeleteMedecin(record._id)} danger>
                  Supprimer
                </Button>
              </Space>
            ),
            width: 250,
          },
        ]}
        dataSource={filteredUsers}
        rowKey="_id"
        pagination={{
          pageSize: 5,
        }}
        scroll={{ x: 1300 }}
      ></Table>
    </Space>
  );
};

export default DoctorPage;
