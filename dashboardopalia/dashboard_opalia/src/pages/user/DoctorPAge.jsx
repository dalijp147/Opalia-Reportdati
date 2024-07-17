import {
  Typography,
  Card,
  Space,
  Statistic,
  Table,
  Button,
  Avatar,
} from "antd";
import axios from "axios";
import React, { useEffect, useState } from "react";

const DoctorPage = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [fileList, setFileList] = useState([]);
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
      fetchMedecin();
    } catch (error) {
      message.error("Failed to delete Medecin!");
    }
  };
  const handleFileChange = ({ fileList }) => {
    setFileList(fileList);
  };
  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Docteur</Typography.Title>

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
          { title: "Numéro de telephone", dataIndex: "numeroTel" },
          { title: "Spécialité", dataIndex: "specialite" },
          { title: "Numéro de license", dataIndex: "licenseNumber" },
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
        dataSource={users}
        pagination={{
          pageSize: 6,
        }}
      ></Table>
    </Space>
  );
};

export default DoctorPage;
