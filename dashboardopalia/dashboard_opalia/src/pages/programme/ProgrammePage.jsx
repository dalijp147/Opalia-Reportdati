import React, { useEffect, useState } from "react";
import axios from "axios";
import {
  Table,
  Button,
  Space,
  Modal,
  Form,
  Input,
  TimePicker,
  Select,
  message,
  Typography,
} from "antd";
import { PlusOutlined } from "@ant-design/icons";
import moment from "moment";

const { Option } = Select;

const ProgrammesPage = () => {
  const [programmes, setProgrammes] = useState([]);
  const [partipants, setParticipants] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [isUpdate, setIsUpdate] = useState(false);
  const [currentProgramme, setCurrentProgramme] = useState(null);
  const [form] = Form.useForm();
  const [events, setEvents] = useState([]);
  const [speakers, setSpeakers] = useState([]);
  useEffect(() => {
    fetchProgrammes();
    fetchParticipantById();
    fetchEvents();
  }, []);

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
  const handleEventChange = (eventId) => {
    fetchSpeakersByEvent(eventId);
  };

  const fetchEvents = async () => {
    try {
      const response = await axios.get("http://localhost:3001/event/");
      setEvents(response.data.data);
    } catch (error) {
      setError(error);
    }
  };
  const fetchProgrammes = async () => {
    setLoading(true);
    try {
      const response = await axios.get("http://localhost:3001/programme/");
      setProgrammes(response.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
    }
  };

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  const handleAddProgramme = () => {
    form.resetFields();
    setIsUpdate(false);
    setIsModalVisible(true);
  };

  const handleEditProgramme = (record) => {
    setIsUpdate(true);
    setCurrentProgramme(record);
    form.setFieldsValue({
      ...record,
      event: record.event._id,
      prog: record.prog.map((item) => ({
        ...item,
        time: moment(item.time),
      })),
    });
    fetchSpeakersByEvent(record.event._id); // Fetch speakers for the selected event
    setIsModalVisible(true);
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

  const handleFormSubmit = async (values) => {
    const data = {
      ...values,
      prog: values.prog.map((item) => ({
        ...item,
        time: item.time.toISOString(),
      })),
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
      setIsModalVisible(false);
      fetchProgrammes();
    } catch (error) {
      message.error("Failed to save programme!");
    }
  };
  const fetchParticipantById = async (id) => {
    if (!id) return "Unknown";
    if (partipants[id]) {
      return partipants[id];
    }
    try {
      const response = await axios.get(
        `http://localhost:3001/participant/participant/${id}`
      );
      const participant = response.data;
      setParticipants((prev) => ({ ...prev, [id]: participant }));
      return participant;
    } catch (error) {
      console.error("Failed to fetch participant:", error);
      return null;
    }
  };

  const renderSpeakers = (speakerIds) => {
    const [speakerDetails, setSpeakerDetails] = useState({});

    useEffect(() => {
      const fetchAllSpeakers = async () => {
        const details = {};
        for (const id of speakerIds) {
          const participant = await fetchParticipantById(id);
          details[id] = participant ? participant.username : "Unknown";
        }
        setSpeakerDetails(details);
      };
      fetchAllSpeakers();
    }, [speakerIds]);
    if (!Array.isArray(speakerIds)) {
      return "No speakers";
    }

    return speakerIds
      .map((id) => {
        const participant = speakerDetails[id];
        return participant ? participant.username : "Loading...";
      })
      .join(", ");
  };

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      {" "}
      <Typography.Title>Programme</Typography.Title>
      <Button
        type="primary"
        danger
        icon={<PlusOutlined />}
        onClick={handleAddProgramme}
      >
        Ajouter Programme
      </Button>
      <Table
        key={programmes._id}
        loading={loading}
        columns={[
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
                  <p>heur: {moment(prog.time).format("HH:mm")}</p>
                  <p>titre: {prog.title}</p>
                  {/* //  <p>Speakers: {renderSpeakers(prog.speaker)}</p> */}
                </div>
              )),
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditProgramme(record)}>
                  Modifier
                </Button>
                <Button
                  onClick={() => handleDeleteProgramme(record._id)}
                  danger
                >
                  Supprimer
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={programmes}
        pagination={{ pageSize: 5 }}
        rowKey="_id"
      ></Table>
      <Modal
        title={isUpdate ? "Modifier Programme" : "Ajouter Programme"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Form form={form} layout="vertical" onFinish={handleFormSubmit}>
          <Form.Item
            name="event"
            label="Événement"
            rules={[{ required: true, message: "Please select an event" }]}
          >
            <Select onChange={handleEventChange}>
              {events.map((event) => (
                <Option key={event._id} value={event._id}>
                  {event.eventname}
                </Option>
              ))}
            </Select>
          </Form.Item>
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
                        { required: true, message: "Please select speakers" },
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
              {isUpdate ? "Modifier" : "Ajouter"}
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </Space>
  );
};

export default ProgrammesPage;
