import React, { useState, useEffect } from "react";
import axios from "axios";
import { Table, Typography, Spin, Alert, Space, Button } from "antd";

const { Text } = Typography;

const WinnerComponent = () => {
  const [winners, setWinners] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  useEffect(() => {
    fetchwinners();
  }, []);
  const fetchwinners = async () => {
    setLoading(true);
    try {
      const response = await axios.get(
        `http://localhost:3001/result/winner/true`
      );
      setWinners(response.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
    }
  };

  const handleDeletewinners = async (id) => {
    try {
      await axios.delete(`http://localhost:3001/result/delete/${id}`);
      message.success("winner supprimé avec succés");
      fetchwinners();
    } catch (error) {
      message.error("Failed to delete winner!");
    }
  };
  const columns = [
    {
      title: "Patient",
      dataIndex: ["userid", "username"],
    },
    {
      title: "Doctor",
      dataIndex: ["doctorId", "username"],
    },
    {
      title: "Prize",
      dataIndex: "cadeau",
    },
    {
      title: "Action",
      key: "action",
      render: (text, record) => (
        <Space size="middle">
          <Button onClick={() => handleDeletewinners(record._id)} danger>
            Supprimer
          </Button>{" "}
        </Space>
      ),
    },
  ];

  if (loading) return <Spin size="large" />;
  if (error) return <Alert message={error} type="error" />;

  return (
    <>
      <Typography.Title>Liste des gagnants du quiz</Typography.Title>

      <Table
        columns={columns}
        dataSource={winners}
        rowKey="_id"
        locale={{
          emptyText: "Pas de gagnants",
        }}
      />
    </>
  );
};

export default WinnerComponent;
