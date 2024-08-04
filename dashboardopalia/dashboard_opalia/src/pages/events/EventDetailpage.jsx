import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import axios from "axios";
import {
  Space,
  Typography,
  Avatar,
  Button,
  Card,
  Row,
  Col,
  message,
  List,
  Table,
  Badge,
} from "antd";
import moment from "moment";
import { ArrowLeftOutlined } from "@ant-design/icons";

const EventDetailsPage = () => {
  const { eventId } = useParams();
  const navigate = useNavigate();
  const [event, setEvent] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const baseUrl = "http://localhost:3001";
  const [participants, setParticipants] = useState([]);

  useEffect(() => {
    fetchEventDetails();
    fetchParticipants();
  }, []);
  const fetchParticipants = async () => {
    setLoading(true);
    try {
      const response = await axios.get(
        `${baseUrl}/participant/participon/${eventId}`
      );
      setParticipants(response.data);
    } catch (error) {
      setError(error);
    } finally {
      setLoading(false);
    }
  };

  const fetchEventDetails = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/event/${eventId}`);
      setEvent(response.data.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
    }
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error.message}</div>;
  }
  const isEventFull = () => {
    if (!event || !participants) return false;
    return participants.length >= event.nombreparticipant;
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

  const handleBack = () => {
    navigate.goBack();
  };
  const columns = [
    {
      title: "Prénom",
      dataIndex: ["doctorId", "username"],
      key: "username",
    },
    {
      title: "Nom",
      dataIndex: ["doctorId", "familyname"],
      key: "familyname",
    },
    {
      title: "Spécialité",
      dataIndex: ["doctorId", "specialite"],
      key: "specialite",
    },
    {
      title: "Email",
      dataIndex: ["doctorId", "email"],
      key: "email",
    },
    {
      title: "Numéro de Téléphone",
      dataIndex: ["doctorId", "numeroTel"],
      key: "numeroTel",
    },
    {
      title: "Role",
      dataIndex: "speaker",
      key: "role",
      render: (text, record) => (record.speaker ? "Speaker" : "Participant"),
    },
  ];

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Button icon={<ArrowLeftOutlined />} onClick={handleBack}>
        Retour
      </Button>{" "}
      <Badge
        count={isEventFull() ? "Événement Plein" : "Disponible"}
        style={{
          backgroundColor: isEventFull() ? "#f5222d" : "#52c41a",
          color: "#fff",
          width: 150,
          height: 50,
          lineHeight: "50px",
          textAlign: "center",
          borderRadius: 4,
          fontSize: "16px",
          fontWeight: "bold",
        }}
      />
      <Typography.Title>Details de l'événement</Typography.Title>
      <Card>
        <Row gutter={[16, 16]}>
          <Col span={24} style={{ textAlign: "center" }}>
            {event.eventimage && (
              <Avatar
                src={`${baseUrl}${getPathFromUrl(event.eventimage)}`}
                size={150}
              />
            )}
          </Col>
          <Col span={24}>
            <Typography.Title level={4}>{event.eventname}</Typography.Title>
          </Col>
          <Col span={24}>
            <Typography.Text strong>Date de l'évenement:</Typography.Text>
            <Typography.Paragraph>
              {moment(event.dateEvent).format("YYYY-MM-DD HH:mm:ss")}
            </Typography.Paragraph>
          </Col>
          <Col span={24}>
            <Typography.Text strong>Emplacement:</Typography.Text>
            <Typography.Paragraph>
              {event.eventLocalisation}
            </Typography.Paragraph>
          </Col>
          <Col span={24}>
            <Typography.Text strong>
              Nombre maximal de Participants:
            </Typography.Text>
            <Typography.Paragraph>
              {event.nombreparticipant}
            </Typography.Paragraph>
          </Col>
          <Col span={24}>
            <Typography.Text strong>Description:</Typography.Text>
            <Typography.Paragraph>
              {event.eventdescription}
            </Typography.Paragraph>
          </Col>{" "}
          <Col span={24}>
            <Typography.Title level={4}>Participants</Typography.Title>

            <Table
              bordered
              dataSource={participants}
              columns={columns}
              rowKey="id" // Replace with a unique identifier for each participant
            />
          </Col>
        </Row>
      </Card>
    </Space>
  );
};

export default EventDetailsPage;
