import { Typography, Space, Table, Button, Form, Rate, message } from "antd";
import React, { useEffect, useState } from "react";
import axios from "axios";
import moment from "moment";
import { PlusOutlined, UploadOutlined } from "@ant-design/icons";
const FeedbackPage = () => {
  const [feedback, setFeedback] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);

  const [isUpdate, setIsUpdate] = useState(false);
  const [currentEvent, setCurrentEvent] = useState(null);
  const [form] = Form.useForm();
  const [fileList, setFileList] = useState([]);
  useEffect(() => {
    fetchFeedback();
  }, []);
  const baseUrl = "http://localhost:3001";
  const fetchFeedback = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/feedback/`);
      setFeedback(response.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
    }
  };

  if (error) {
    return <div>Error: {error.message}</div>;
  }
  const handleDeletefeedback = async (id) => {
    try {
      await axios.delete(`${baseUrl}/feedback/delete/${id}`);
      message.success("feedback successfully deleted!");
      fetchFeedback();
    } catch (error) {
      message.error("Failed to delete feedback!");
    }
  };
  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Événement</Typography.Title>

      <Table
        loading={loading}
        columns={[
          {
            title: "Particiapant",
            dataIndex: ["participantId", "username"],
          },
          { title: "Événement", dataIndex: ["eventId", "eventname"] },

          {
            title: "Note de l'événement",
            dataIndex: "etoile",
            render: (text) => <Rate disabled defaultValue={text} />,
          },
          {
            title: "Commentaire",
            dataIndex: "comment",
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleDeletefeedback(record._id)} danger>
                  Supprimer
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={feedback}
        pagination={{
          pageSize: 5,
        }}
      ></Table>
    </Space>
  );
};

export default FeedbackPage;
