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
  TimePicker,
  Input,
  List,
  Table,
  Badge,
  Modal,
  Form,
  Select,
  Checkbox,
} from "antd";
import moment from "moment";
import { PlusOutlined } from "@ant-design/icons";
import { ArrowLeftOutlined } from "@ant-design/icons";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";

const EventDetailsPage = () => {
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [isModalVisibleee, setIsModalVisibleee] = useState(false);
  const [isUpdate, setIsUpdate] = useState(false);
  const [isUpdateProg, setIsUpdateProg] = useState(false);
  const [doctors, setDoctors] = useState([]);
  const [events, setEvents] = useState([]);
  const { eventId } = useParams();
  const navigate = useNavigate();
  const [event, setEvent] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const baseUrl = "http://localhost:3001";
  const [participants, setParticipants] = useState([]);
  const [programmes, setProgrames] = useState([]);
  const [currentProgramme, setCurrentProgramme] = useState(null);
  const [form] = Form.useForm();
  const [speakers, setSpeakers] = useState([]);
  useEffect(() => {
    fetchEventDetails();
    fetchProgramme();
    fetchParticipants();
    fetchDoctors();
    fetchEvents();
    fetchSpeakersByEvent(eventId); // Ensure this is used after declaration
  }, [eventId]);
  const fetchSpeakersByEvent = async (eventId) => {
    try {
      const response = await axios.get(
        `http://localhost:3001/participant/speaker/true/${eventId}`
      );
      setSpeakers(response.data);
    } catch (error) {
      console.error("Failed to fetch speakers:", error);
    }
  };
  const fetchDoctors = async () => {
    try {
      const response = await axios.get("http://localhost:3001/medecin/");
      setDoctors(response.data);
    } catch (error) {
      setError(error);
    }
  };
  const fetchEvents = async () => {
    try {
      const response = await axios.get("http://localhost:3001/event/");
      setEvents(response.data.data);
    } catch (error) {
      setError(error);
    }
  };
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

  const fetchProgramme = async () => {
    setLoading(true);
    try {
      const response = await axios.get(
        `${baseUrl}/programme/byevent/${eventId}`
      );
      setProgrames(response.data);
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

  const handleEventChange = (eventId) => {
    fetchSpeakersByEvent(eventId); // Ensure this is used after declaration
  };

  const handleAddParticipant = () => {
    form.resetFields();
    setIsUpdate(false);
    setIsModalVisible(true);
  };

  const handleAddProgramme = () => {
    form.resetFields();
    setIsUpdate(false);
    setCurrentProgramme(null); // Reset current programme for a new entry
    setIsModalVisibleee(true);
  };
  const handleDeleteProgramme = async (id) => {
    try {
      await axios.delete(`http://localhost:3001/programme/delete/${id}`);
      message.success("Programme successfully deleted!");
      fetchProgrammes();
    } catch (error) {
      message.error("Failed to delete programme!");
    }
  };
  const handleEditProgramme = (record) => {
    setIsUpdate(true);
    setCurrentProgramme(record);

    // Map the speakers to their IDs and convert time to moment object
    const mappedProg = record.prog.map((item) => ({
      ...item,
      time: moment(item.time), // Ensure time is converted to moment object
      speaker: item.speaker.map((sp) => sp._id), // Map speakers to their _id
    }));

    form.setFieldsValue({
      ...record,
      prog: mappedProg,
    });

    fetchSpeakersByEvent(record.event._id); // Fetch speakers for the selected event
    setIsModalVisibleee(true);
  };
  const handleDeleteParticipant = async (id) => {
    try {
      await axios.delete(`http://localhost:3001/participant/delete/${id}`);
      message.success("Participant successfully deleted!");
      setParticipants((prevUsers) =>
        prevUsers.filter((user) => user._id !== id)
      );
    } catch (error) {
      message.error("Failed to delete participant!");
    }
  };
  const handleFormSubmitt = async (values) => {
    const data = {
      ...values,
      prog: values.prog.map((item) => ({
        ...item,
        time: item.time.toISOString(), // Convert time back to ISO string for the database
      })),
      event: eventId,
    };

    try {
      if (isUpdate && currentProgramme) {
        await axios.put(
          `http://localhost:3001/programme/update/${currentProgramme._id}`,
          data
        );
        message.success("Programme successfully updated!");
      } else {
        await axios.post("http://localhost:3001/programme/create", data);
        message.success("Programme successfully created!");
      }
      setIsModalVisibleee(false);
      fetchProgramme(); // Refresh the list of programs after adding/updating
    } catch (error) {
      message.error("Failed to save programme!");
    }
  };
  const handleFormSubmit = async (values) => {
    try {
      const participantData = {
        ...values,
        eventId, // Automatically set the event ID from the current event
      };
      if (isUpdate && currentParticipant) {
        await axios.put(
          `http://localhost:3001/participant/update/${currentParticipant._id}`,
          participantData
        );
        message.success("Participant successfully updated!");
      } else {
        await axios.post(
          "http://localhost:3001/participant/create",
          participantData
        );
        message.success("Participant successfully created!");
      }
      setIsModalVisible(false);
      fetchParticipants();
    } catch (error) {
      message.error("Failed to save participant!");
    }
  };
  const renderSpeakers = (speakers) => {
    if (!Array.isArray(speakers) || speakers.length === 0) {
      return "No speakers";
    }

    return speakers
      .map((speaker) => speaker.doctorId?.username || "Unknown") // Safely access the username
      .join(", ");
  };
  if (error) {
    return <div>Error: {error.message}</div>;
  }
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
    {
      title: "Action",
      key: "action",
      render: (text, record) => (
        <Space size="middle">
          <Button onClick={() => handleDeleteParticipant(record._id)} danger>
            Supprimer
          </Button>
          {/* <Button
            onClick={() => handleApproveParticipant(record._id)}
            type="primary"
          >
            Approuver
          </Button>
          <Button
            onClick={() => handleDisapproveParticipant(record._id)}
            type="default"
          >
            Désapprouver
          </Button> */}
        </Space>
      ),
    },
  ];

  const columnsprog = [
    {
      title: "Événement",
      dataIndex: ["event", "eventname"], // Ensure this matches your event's schema
      key: "event",
    },
    {
      title: "Détail du Programme",
      key: "prog",
      render: (text, record) =>
        record.prog.map((prog) => (
          <div key={prog._id}>
            <p>Heure: {moment(prog.time).format("HH:mm")}</p>
            <p>Titre: {prog.title}</p>
            <p>Speakers: {renderSpeakers(prog.speaker)}</p>
          </div>
        )),
    },
    {
      title: "Action",
      key: "action",
      render: (text, record) => (
        <Space size="middle">
          <Button onClick={() => handleDeleteProgramme(record._id)} danger>
            Supprimer
          </Button>
          <Button onClick={() => handleEditProgramme(record)}>Modifier</Button>
        </Space>
      ),
    },
  ];

  // Prepare data for the chart
  const chartData = [
    {
      name: event.eventname,
      Participants: participants.length,
      "Max Participants": event.nombreparticipant,
    },
  ];

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Badge
        count={isEventFull() ? "Événement Plein" : "Disponible"}
        style={{
          backgroundColor: isEventFull() ? "#f5222d" : "#52c41a",
          color: "#fff",
          width: 200,
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
          </Col>
          <Col span={24}>
            <Row justify="space-between" align="middle">
              <Col>
                <Typography.Title level={4}>
                  Participants et orateurs
                </Typography.Title>
              </Col>
              <Col>
                <Button
                  onClick={handleAddParticipant}
                  type="primary"
                  danger
                  disabled={isEventFull()}
                >
                  Ajouter Orateur
                </Button>
              </Col>
            </Row>

            <Table
              bordered
              dataSource={participants}
              columns={columns}
              rowKey="id"
              locale={{
                emptyText: "Aucun Participant",
              }}
            />
            <Modal
              title={isUpdate ? "Modifier Participant" : "Ajouter Participant"}
              visible={isModalVisible}
              onCancel={() => setIsModalVisible(false)}
              footer={null}
            >
              <Form form={form} layout="vertical" onFinish={handleFormSubmit}>
                <Form.Item
                  name="doctorId"
                  label="Docteur"
                  rules={[
                    { required: true, message: "Please select a doctor" },
                  ]}
                >
                  <Select placeholder="Select a doctor">
                    {doctors.map((doctor) => (
                      <Option key={doctor._id} value={doctor._id}>
                        {doctor.username} {/* Ensure your schema matches */}
                      </Option>
                    ))}
                  </Select>
                </Form.Item>

                <Form.Item name="speaker" valuePropName="checked">
                  <Checkbox>Speaker à l'évenement</Checkbox>
                </Form.Item>

                <Form.Item
                  name="description"
                  label="Déscription"
                  rules={[
                    { required: true, message: "Please enter description" },
                  ]}
                >
                  <Input.TextArea />
                </Form.Item>
                <Form.Item>
                  <Button type="primary" htmlType="submit" danger>
                    {isUpdate ? "Modifier" : "Ajouter"}
                  </Button>
                </Form.Item>
              </Form>
            </Modal>
          </Col>
          <Col span={24}>
            <Row justify="space-between" align="middle">
              <Col>
                <Typography.Title level={4}>Programme</Typography.Title>
              </Col>
              <Col>
                <Button
                  // onClick={() => handleViewProgramme()}
                  type="primary"
                  danger
                  onClick={handleAddProgramme}
                >
                  Ajouter Programme
                </Button>
              </Col>
            </Row>

            <Table
              bordered
              dataSource={programmes}
              columns={columnsprog}
              rowKey="id"
              locale={{
                emptyText:
                  "Aucun programme disponible, veuillez ajouter programme",
              }}
            />
            <Modal
              title={isUpdateProg ? "Modifier Programme" : "Ajouter Programme"}
              visible={isModalVisibleee}
              onCancel={() => setIsModalVisibleee(false)}
              footer={null}
            >
              <Form form={form} layout="vertical" onFinish={handleFormSubmitt}>
                <Form.List name="prog">
                  {(fields, { add, remove }) => (
                    <>
                      {fields.map((field) => (
                        <Space
                          key={field.key}
                          style={{ display: "flex", marginBottom: 8 }}
                          align="baseline"
                        >
                          <Form.Item
                            {...field}
                            name={[field.name, "time"]}
                            fieldKey={[field.fieldKey, "time"]}
                            rules={[
                              { required: true, message: "Please select time" },
                            ]}
                          >
                            <TimePicker format="HH:mm" />
                          </Form.Item>
                          <Form.Item
                            {...field}
                            name={[field.name, "title"]}
                            fieldKey={[field.fieldKey, "title"]}
                            rules={[
                              { required: true, message: "Please enter title" },
                            ]}
                          >
                            <Input placeholder="Title" />
                          </Form.Item>
                          <Form.Item
                            {...field}
                            name={[field.name, "speaker"]}
                            fieldKey={[field.fieldKey, "speaker"]}
                            rules={[
                              {
                                required: true,
                                message: "Please select speakers",
                              },
                            ]}
                            style={{ width: 150 }}
                          >
                            <Select mode="multiple">
                              {speakers.map((speaker) => (
                                <Option key={speaker._id} value={speaker._id}>
                                  {speaker.doctorId.username}
                                </Option>
                              ))}
                            </Select>
                          </Form.Item>
                          <Button
                            type="danger"
                            onClick={() => remove(field.name)}
                            style={{ width: 60 }}
                          >
                            supprimer
                          </Button>
                        </Space>
                      ))}
                      <Button
                        type="dashed"
                        onClick={() => add()}
                        block
                        icon={<PlusOutlined />}
                      >
                        Ajouter un Programme
                      </Button>
                    </>
                  )}
                </Form.List>
                <Form.Item>
                  <Button type="primary" htmlType="submit" danger>
                    {isUpdateProg ? "Modifier" : "Ajouter"}
                  </Button>
                </Form.Item>
              </Form>
            </Modal>
          </Col>
          <Col span={24}>
            <Typography.Title level={4}>
              Participants vs Max Participants
            </Typography.Title>
            <ResponsiveContainer width="100%" height={450}>
              <BarChart data={chartData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis
                  allowDecimals={false} // This ensures the Y-axis shows only integer values
                  tickFormatter={(value) =>
                    Number.isInteger(value) ? value : ""
                  } // Further ensures no floating numbers
                />
                <Tooltip />
                <Legend />
                <Bar dataKey="Participants" fill="#82ca9d" />
                <Bar dataKey="Max Participants" fill="red" />
              </BarChart>
            </ResponsiveContainer>
          </Col>
        </Row>
      </Card>
    </Space>
  );
};

export default EventDetailsPage;
