import React, { useEffect, useState } from "react";
import axios from "axios";
import {
  Table,
  Button,
  Space,
  Modal,
  Form,
  Input,
  Checkbox,
  message,
  Select,
  Typography,
} from "antd";
import { PlusOutlined } from "@ant-design/icons";
const { Search } = Input;
const { Option } = Select;

const ParticipantsPage = () => {
  const [participants, setParticipants] = useState([]);
  const [doctors, setDoctors] = useState([]);
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [isUpdate, setIsUpdate] = useState(false);
  const [currentParticipant, setCurrentParticipant] = useState(null);
  const [form] = Form.useForm();
  const [searchQuery, setSearchQuery] = useState("");
  useEffect(() => {
    fetchParticipants();
    fetchDoctors();
    fetchEvents();
  }, []);

  const fetchParticipants = async () => {
    setLoading(true);
    try {
      const response = await axios.get("http://localhost:3001/participant/");
      setParticipants(response.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
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

  const handleAddParticipant = () => {
    form.resetFields();
    setIsUpdate(false);
    setIsModalVisible(true);
  };

  const handleEditParticipant = (record) => {
    setIsUpdate(true);
    setCurrentParticipant(record);
    form.setFieldsValue({
      ...record,
      speaker: record.speaker,
      participon: record.participon,
    });
    setIsModalVisible(true);
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

  const handleApproveParticipant = async (id) => {
    try {
      await axios.patch(`http://localhost:3001/participant/approve/${id}`);
      message.success("Participant successfully approved!");
      setParticipants((prevUsers) =>
        prevUsers.map((user) =>
          user._id === id ? { ...user, isApproved: true } : user
        )
      );
    } catch (error) {
      message.error("Failed to approve participant!");
    }
  };

  const handleDisapproveParticipant = async (id) => {
    try {
      await axios.patch(`http://localhost:3001/participant/disapprove/${id}`);
      message.success("Participant successfully disapproved!");
      setParticipants((prevUsers) =>
        prevUsers.map((user) =>
          user._id === id ? { ...user, isApproved: false } : user
        )
      );
    } catch (error) {
      message.error("Failed to disapprove participant!");
    }
  };

  const handleFormSubmit = async (values) => {
    try {
      if (isUpdate && currentParticipant) {
        await axios.put(
          `http://localhost:3001/participant/update/${currentParticipant._id}`,
          values
        );
        message.success("Participant successfully updated!");
      } else {
        await axios.post("http://localhost:3001/participant/create", values);
        message.success("Participant successfully created!");
      }
      setIsModalVisible(false);
      fetchParticipants();
    } catch (error) {
      message.error("Failed to save participant!");
    }
  };

  if (error) {
    return <div>Error: {error.message}</div>;
  }
  const filteredUsers = participants.filter(
    (user) =>
      user.doctorId.familyname
        .toLowerCase()
        .includes(searchQuery.toLowerCase()) ||
      user.doctorId.username.toLowerCase().includes(searchQuery.toLowerCase())
  );
  const handleSearch = (query) => {
    setSearchQuery(query);
  };
  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Participants et orateurs</Typography.Title>
      <Search
        placeholder="Rechercher un Participants"
        onSearch={handleSearch}
        onChange={(e) => handleSearch(e.target.value)}
        style={{ width: 300, marginBottom: 20 }}
      />
      <Button
        type="primary"
        danger
        icon={<PlusOutlined />}
        onClick={handleAddParticipant}
      >
        Ajouter
      </Button>

      <Table
        loading={loading}
        columns={[
          {
            title: "Docteur",
            dataIndex: ["doctorId", "username"],
          },
          { title: "Événement", dataIndex: ["eventId", "eventname"] },
          {
            title: "Orateur",
            dataIndex: "speaker",
            render: (text) => (text ? "Oui" : "Non"),
          },
          {
            title: "Participant ordinaire",
            dataIndex: "participon",
            render: (text) => (text ? "Oui" : "Non"),
          },
          { title: "Déscription", dataIndex: "description" },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditParticipant(record)}>
                  Modifier
                </Button>
                <Button
                  onClick={() => handleDeleteParticipant(record._id)}
                  danger
                >
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
        ]}
        dataSource={filteredUsers}
        pagination={{ pageSize: 5 }}
      ></Table>

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
            rules={[{ required: true, message: "Please select a doctor" }]}
          >
            <Select placeholder="Select a doctor">
              {doctors.map((doctor) => (
                <Option key={doctor._id} value={doctor._id}>
                  {doctor.username} {/* Ensure your schema matches */}
                </Option>
              ))}
            </Select>
          </Form.Item>
          <Form.Item
            name="eventId"
            label="Événement"
            rules={[{ required: true, message: "Please select an event" }]}
          >
            <Select placeholder="Select an event">
              {events.map((event) => (
                <Option key={event._id} value={event._id}>
                  {event.eventname} {/* Ensure your schema matches */}
                </Option>
              ))}
            </Select>
          </Form.Item>
          <Form.Item name="speaker" valuePropName="checked">
            <Checkbox>Orateur à l'évenement</Checkbox>
          </Form.Item>
          <Form.Item name="participon" valuePropName="checked">
            <Checkbox>Participe à l'évenemnet</Checkbox>
          </Form.Item>
          <Form.Item
            name="description"
            label="Déscription"
            rules={[{ required: true, message: "Please enter description" }]}
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
    </Space>
  );
};

export default ParticipantsPage;
