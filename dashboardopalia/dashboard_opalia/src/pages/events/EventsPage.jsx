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
} from "antd";
import React, { useEffect, useState } from "react";
import axios from "axios";
import moment from "moment";
import { PlusOutlined, UploadOutlined } from "@ant-design/icons";

const EventsPage = () => {
  const [events, setevents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);

  const [isUpdate, setIsUpdate] = useState(false);
  const [currentEvent, setCurrentEvent] = useState(null);
  const [form] = Form.useForm();
  const [fileList, setFileList] = useState([]);
  useEffect(() => {
    fetchEvents();
  }, []);
  const baseUrl = "http://localhost:3001";
  const fetchEvents = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/event/`);
      setevents(response.data.data);
      setLoading(false);
    } catch (error) {
      setError(error);
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
          `${baseUrl}/event/events/${currentEvent._id}`,
          formData
        );
        message.success("Event successfully updated!");
      } else {
        await axios.post(`${baseUrl}/event/create`, formData);
        message.success("Event successfully created!");
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
  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Evenement</Typography.Title>
      <Button
        type="primary"
        danger
        icon={<PlusOutlined />}
        onClick={handleAddEvent}
      >
        Ajouter une évenement
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
            title: "Date",
            dataIndex: "dateEvent",
            render: (text) => moment(text).format("YYYY-MM-DD HH:mm:ss"),
          },
          { title: "Emplacement", dataIndex: "eventLocalisation" },
          {
            title: "Numero de particiapant maximal",
            dataIndex: "nombreparticipant",
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditEvent(record)}>Edit</Button>
                <Button onClick={() => handleDeleteEvent(record._id)} danger>
                  Delete
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={events}
        pagination={{
          pageSize: 5,
        }}
      ></Table>
      <Modal
        title={isUpdate ? "Update Event" : "Create Event"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Form form={form} layout="vertical" onFinish={handleFormSubmit}>
          <Form.Item
            name="eventname"
            label="Event Name"
            rules={[{ required: true, message: "Please enter event name" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="eventdescription"
            label="Event Description"
            rules={[
              { required: true, message: "Please enter event description" },
            ]}
          >
            <Input.TextArea />
          </Form.Item>
          <Form.Item
            name="eventLocalisation"
            label="Event Location"
            rules={[{ required: true, message: "Please enter event location" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="dateEvent"
            label="Event Date"
            rules={[{ required: true, message: "Please select event date" }]}
          >
            <DatePicker showTime />
          </Form.Item>
          <Form.Item
            name="nombreparticipant"
            label="Number of Participants"
            rules={[
              {
                required: true,
                message: "Please enter number of participants",
              },
            ]}
          >
            <InputNumber min={1} />
          </Form.Item>
          <Form.Item name="eventimage" label="Event Image">
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
            <Button type="primary" htmlType="submit">
              {isUpdate ? "Update" : "Create"}
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </Space>
  );
};

export default EventsPage;
