import React, { useState, useEffect } from "react";
import axios from "axios";
import { Table, Typography, Spin, Alert } from "antd";

const { Text } = Typography;

const WinnerComponent = () => {
  const [winners, setWinners] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    setLoading(true);
    axios
      .get(`http://localhost:3001/result/winner/true`)
      .then((response) => {
        setWinners(response.data);
        setLoading(false);
      })
      .catch((error) => {
        setError(error.message || "Failed to fetch winners.");
        setLoading(false);
      });
  }, []);

  const columns = [
    {
      title: "Doctor",
      dataIndex: ["doctorId", "username"],
    },
    {
      title: "Prize",
      dataIndex: "prize",
    },
  ];

  if (loading) return <Spin size="large" />;
  if (error) return <Alert message={error} type="error" />;

  return (
    <>
      <Typography.Title>Liste des gagnants du quiz</Typography.Title>
      {winners.length === 0 ? (
        <Text type="secondary">Pas de gagnant</Text>
      ) : (
        <Table columns={columns} dataSource={winners} rowKey="_id" />
      )}
    </>
  );
};

export default WinnerComponent;
