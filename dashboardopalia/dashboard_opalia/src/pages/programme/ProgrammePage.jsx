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
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [isUpdate, setIsUpdate] = useState(false);
  const [currentProgramme, setCurrentProgramme] = useState(null);
  const [form] = Form.useForm();

  useEffect(() => {
    fetchProgrammes();
  }, []);

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
    setIsModalVisible(true);
  };

  const handleDeleteProgramme = async (id) => {
    try {
      await axios.delete(`http://localhost:3001/programmes/${id}`);
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
          `http://localhost:3001/programmes/${currentProgramme._id}`,
          data
        );
        message.success("Programme successfully updated!");
      } else {
        await axios.post("http://localhost:3001/programmes", data);
        message.success("Programme successfully created!");
      }
      setIsModalVisible(false);
      fetchProgrammes();
    } catch (error) {
      message.error("Failed to save programme!");
    }
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
        loading={loading}
        columns={[
          {
            title: "Event",
            dataIndex: ["event", "eventname"], // Ensure this matches your event's schema
            key: "event",
          },
          {
            title: "Programme Details",
            key: "prog",
            render: (text, record) =>
              record.prog.map((prog) => (
                <div key={prog._id}>
                  <p>Time: {moment(prog.time).format("HH:mm")}</p>
                  <p>Title: {prog.title}</p>
                  <p>
                    Speakers: {prog.speaker.map((sp) => sp.name).join(", ")}
                  </p>
                </div>
              )),
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditProgramme(record)}>
                  Edit
                </Button>
                <Button
                  onClick={() => handleDeleteProgramme(record._id)}
                  danger
                >
                  Delete
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
        title={isUpdate ? "Edit Programme" : "Add Programme"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Form form={form} layout="vertical" onFinish={handleFormSubmit}>
          <Form.Item
            name="event"
            label="Event"
            rules={[{ required: true, message: "Please select an event" }]}
          >
            <Select>
              {/* You would need to fetch events and populate the options here */}
              <Option value="event1">Event 1</Option>
              <Option value="event2">Event 2</Option>
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
                    >
                      <Select mode="multiple">
                        {/* You would need to fetch speakers and populate the options here */}
                        <Option value="speaker1">Speaker 1</Option>
                        <Option value="speaker2">Speaker 2</Option>
                      </Select>
                    </Form.Item>
                    <Button type="danger" onClick={() => remove(field.name)}>
                      Remove
                    </Button>
                  </Space>
                ))}
                <Button
                  type="dashed"
                  onClick={() => add()}
                  block
                  icon={<PlusOutlined />}
                >
                  Add Programme
                </Button>
              </>
            )}
          </Form.List>
          <Form.Item>
            <Button type="primary" htmlType="submit">
              {isUpdate ? "Update" : "Add"}
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </Space>
  );
};

export default ProgrammesPage;
