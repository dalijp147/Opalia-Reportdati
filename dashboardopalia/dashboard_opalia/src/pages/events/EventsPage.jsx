import {
  Typography,
  Space,
  Table,
  Avatar,
  Button,
  Modal,
  Form,
  Input,
  DatePicker,
  InputNumber,
  Upload,
  message,
  Badge,
} from "antd";
import React, { useEffect, useState } from "react";
import axios from "axios";
import moment from "moment";
import { PlusOutlined, UploadOutlined } from "@ant-design/icons";
const { Search } = Input;
import { useNavigate } from "react-router-dom";

const EventsPage = () => {
  const navigate = useNavigate();

  const [events, setevents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [isUpdate, setIsUpdate] = useState(false);
  const [currentEvent, setCurrentEvent] = useState(null);
  const [form] = Form.useForm();
  const [fileList, setFileList] = useState([]);
  const [participants, setParticipants] = useState([]);
  const [isParticipantsModalVisible, setIsParticipantsModalVisible] =
    useState(false);

  useEffect(() => {
    fetchEvents();
  }, []);
  const baseUrl = "http://localhost:3001";
  const fetchEvents = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/event/`);
      const eventData = response.data.data;

      // Fetch participants for each event
      await Promise.all(
        eventData.map(async (event) => {
          const participantsResponse = await axios.get(
            `${baseUrl}/participant/participon/${event._id}`
          );
          setParticipants((prev) => ({
            ...prev,
            [event._id]: participantsResponse.data,
          }));
        })
      );

      setevents(eventData);
    } catch (error) {
      setError(error);
      message.error("Failed to fetch events!");
    } finally {
      setLoading(false);
    }
  };

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  const getPathFromUrl = (url) => {
    try {
      const urlObject = new URL(url);
      return urlObject.pathname;
    } catch (error) {
      console.error("Invalid URL: ", url);
      return url; // return the original URL if it's invalid
    }
  };
  const handleAddEvent = () => {
    form.resetFields();
    setFileList([]);
    setIsUpdate(false);
    setIsModalVisible(true);
  };
  const handleEditEvent = (record) => {
    setIsUpdate(true);
    setCurrentEvent(record);
    form.setFieldsValue({
      ...record,
      dateEvent: moment(record.dateEvent),
    });
    setFileList([]);
    setIsModalVisible(true);
  };
  const handleDeleteEvent = async (id) => {
    try {
      await axios.delete(`${baseUrl}/event/delete/${id}`);
      message.success("Event successfully deleted!");
      fetchEvents();
    } catch (error) {
      message.error("Failed to delete event!");
    }
  };
  const handleFormSubmit = async (values) => {
    const formData = new FormData();
    Object.keys(values).forEach((key) => {
      if (key !== "eventimage") {
        formData.append(key, values[key]);
      }
    });
    if (fileList.length > 0) {
      formData.append("eventimage", fileList[0].originFileObj);
    }

    try {
      if (isUpdate && currentEvent) {
        await axios.put(
          ` ${baseUrl}/event/events/${currentEvent._id}`,
          formData
        );
        message.success("Événement modifier avec succés");
      } else {
        await axios.post(`${baseUrl}/event/create`, formData);
        message.success("Événement ajouter avec succés");
      }
      setIsModalVisible(false);
      fetchEvents();
    } catch (error) {
      message.error("Failed to save event!");
    }
  };
  const handleFileChange = ({ fileList }) => {
    setFileList(fileList);
  };
  const handleSearch = (query) => {
    setSearchQuery(query);
  };

  const filteredEvents = events.filter(
    (user) =>
      user.eventname.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.eventLocalisation.toLowerCase().includes(searchQuery.toLowerCase())
  );
  const handleViewDetails = (event) => {
    navigate(`/event/${event._id}`, { state: { event } });
  };
  const isEventFull = (eventId) => {
    const eventParticipants = participants[eventId] || [];
    const event = events.find((e) => e._id === eventId);
    return eventParticipants.length >= event?.nombreparticipant;
  };

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Événement</Typography.Title>
      <Search
        placeholder="Rechercher un docteur"
        onSearch={handleSearch}
        onChange={(e) => handleSearch(e.target.value)}
        style={{ width: 300, marginBottom: 20 }}
      />
      <Button
        type="primary"
        danger
        icon={<PlusOutlined />}
        onClick={handleAddEvent}
      >
        Ajouter un évenement
      </Button>

      <Table
        loading={loading}
        columns={[
          {
            title: "Image",
            dataIndex: "eventimage",
            key: "eventimage",
            render: (image) => {
              const imagePath = getPathFromUrl(image);

              const fullImageUrl = `${baseUrl}${imagePath}`;

              console.log("Full Image URL: ", fullImageUrl);
              return <Avatar src={fullImageUrl} />;
            },
          },
          { title: "Nom de l'évenement", dataIndex: "eventname" },
          {
            title: "Date de l'événemnet",
            dataIndex: "dateEvent",
            render: (text) => moment(text).format("YYYY-MM-DD HH:mm:ss"),
          },
          { title: "Emplacement", dataIndex: "eventLocalisation" },
          {
            title: "Numéro de particiapant maximal",
            dataIndex: "nombreparticipant",
          },
          {
            title: "État",
            key: "status",
            render: (text, record) => (
              <Badge
                count={
                  isEventFull(record._id) ? "Événement Plein" : "Disponible"
                }
                style={{
                  backgroundColor: isEventFull(record._id)
                    ? "#f5222d"
                    : "#52c41a",
                  color: "#fff",
                  width: 150,
                  height: 50,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  borderRadius: 4,
                }}
              />
            ),
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditEvent(record)}>
                  Modifier
                </Button>
                <Button onClick={() => handleDeleteEvent(record._id)} danger>
                  Supprimer
                </Button>{" "}
                <Button onClick={() => handleViewDetails(record)}>
                  View Details
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={filteredEvents}
        rowKey="_id"
        pagination={{
          pageSize: 5,
        }}
      ></Table>
      <Modal
        title={isUpdate ? "Modifier Événement" : "Ajouter Événement"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Form form={form} layout="vertical" onFinish={handleFormSubmit}>
          <Form.Item
            name="eventname"
            label="Nom de l'évenement"
            rules={[{ required: true, message: "Please enter event name" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="eventdescription"
            label="Déscription"
            rules={[
              { required: true, message: "Please enter event description" },
            ]}
          >
            <Input.TextArea />
          </Form.Item>
          <Form.Item
            name="eventLocalisation"
            label="Emplacement"
            rules={[{ required: true, message: "Please enter event location" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="dateEvent"
            label="Date de l'évenement"
            rules={[{ required: true, message: "Please select event date" }]}
          >
            <DatePicker showTime />
          </Form.Item>
          <Form.Item
            name="nombreparticipant"
            label="Nombre maximal de Participants"
            rules={[
              {
                required: true,
                message: "Please enter number of participants",
              },
            ]}
          >
            <InputNumber min={1} />
          </Form.Item>
          <Form.Item name="eventimage" label="Image">
            <Upload
              listType="picture"
              beforeUpload={() => false}
              fileList={fileList}
              onChange={handleFileChange}
              maxCount={1}
            >
              <Button icon={<UploadOutlined />}>Upload (Max: 1)</Button>
            </Upload>
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" danger>
              {isUpdate ? "Mofifier" : "Ajouter"}
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </Space>
  );
};

export default EventsPage;
