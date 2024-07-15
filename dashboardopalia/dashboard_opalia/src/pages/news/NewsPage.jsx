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
const NewsPage = () => {
  const [news, setNews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);

  const [isUpdate, setIsUpdate] = useState(false);
  const [currentEvent, setCurrentEvent] = useState(null);
  const [form] = Form.useForm();
  const [fileList, setFileList] = useState([]);
  useEffect(() => {
    fetchNews();
  }, []);
  const baseUrl = "http://localhost:3001";
  const fetchNews = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/news/`);
      setNews(response.data);
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

  const handleAddNews = () => {
    form.resetFields();
    setFileList([]);
    setIsUpdate(false);
    setIsModalVisible(true);
  };
  const handleEditNews = (record) => {
    setIsUpdate(true);
    setCurrentEvent(record);
    form.setFieldsValue({
      ...record,
      newsPublication: moment(record.newsPublication),
    });
    setFileList([]);
    setIsModalVisible(true);
  };
  const handleDeleteNews = async (id) => {
    try {
      await axios.delete(`${baseUrl}/news/delete/${id}`);
      message.success("news successfully deleted!");
      fetchNews();
    } catch (error) {
      message.error("Failed to delete news!");
    }
  };
  const handleFormSubmit = async (values) => {
    const formData = new FormData();
    Object.keys(values).forEach((key) => {
      if (key !== "newsImage") {
        formData.append(key, values[key]);
      }
    });
    if (fileList.length > 0) {
      formData.append("newsImage", fileList[0].originFileObj);
    }

    try {
      if (isUpdate && currentEvent) {
        await axios.put(
          `${baseUrl}/news/update/${currentEvent._id}`,
          formData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );
        message.success("News successfully updated!");
      } else {
        await axios.post(`${baseUrl}/news/new`, formData);
        message.success("News successfully created!");
      }
      setIsModalVisible(false);
      fetchNews();
    } catch (error) {
      console.log(error);
      message.error("Failed to save News!");
    }
  };
  const handleFileChange = ({ fileList }) => {
    setFileList(fileList);
  };
  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Actualité</Typography.Title>
      <Button
        type="primary"
        danger
        icon={<PlusOutlined />}
        onClick={handleAddNews}
      >
        Ajouter une actualité
      </Button>

      <Table
        loading={loading}
        columns={[
          {
            title: "Image",
            dataIndex: "newsImage",
            key: "newsImage",
            render: (image) => {
              // const imagePath = getPathFromUrl(image);

              // const fullImageUrl = `${baseUrl}${imagePath}`;

              // console.log("Full Image URL: ", fullImageUrl);
              return <Avatar src={image} />;
            },
          },
          { title: "Titre", dataIndex: "newsTitle" },
          { title: "Autheur", dataIndex: "newsAuthor" },
          {
            title: "Date de Publication",
            dataIndex: "newsPublication",
            render: (text) => moment(text).format("YYYY-MM-DD HH:mm:ss"),
          },

          {
            title: "Nom de Categorie ",
            dataIndex: "categorienews",
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditNews(record)}>Edit</Button>
                <Button onClick={() => handleDeleteNews(record._id)} danger>
                  Delete
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={news}
        pagination={{
          pageSize: 5,
        }}
      ></Table>
      <Modal
        title={isUpdate ? "Modifier actualite" : "Ajouter Actualité"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Form form={form} layout="vertical" onFinish={handleFormSubmit}>
          <Form.Item
            name="newsTitle"
            label="Titre"
            rules={[{ required: true, message: "Please enter event name" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="newsAuthor"
            label="Autheur"
            rules={[{ required: true, message: "Please enter Autheur" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="newsDetail"
            label="Détaille de l'évenement"
            rules={[{ required: true, message: "Please enter event Détaille" }]}
          >
            <Input.TextArea />
          </Form.Item>
          <Form.Item
            name="newsPublication"
            label="Date de publication"
            rules={[
              {
                required: true,
                message: "S'il vous plaiez selection une date de publication",
              },
            ]}
          >
            <DatePicker showTime />
          </Form.Item>
          <Form.Item
            name="categorienews"
            label="categorie d'actualité"
            rules={[
              {
                required: true,
                message: "Please enter categorie d'actualité",
              },
            ]}
          >
            <Input />
          </Form.Item>
          <Form.Item name="newsImage" label="News Image">
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
              {isUpdate ? "Modifier" : "Ajouter"}
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </Space>
  );
};

export default NewsPage;
