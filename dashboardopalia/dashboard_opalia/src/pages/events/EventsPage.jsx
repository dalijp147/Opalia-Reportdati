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
  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Événement</Typography.Title>
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
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditEvent(record)}>
                  Modifier
                </Button>
                <Button onClick={() => handleDeleteEvent(record._id)} danger>
                  Supprimer
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
