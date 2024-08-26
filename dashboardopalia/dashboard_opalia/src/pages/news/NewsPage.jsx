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
  Select,
  Upload,
  message,
} from "antd";
import React, { useEffect, useState } from "react";
import axios from "axios";
import moment from "moment";
import { PlusOutlined, UploadOutlined } from "@ant-design/icons";
const { Search } = Input;
const NewsPage = () => {
  const [news, setNews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [cat, setCat] = useState([]);
  const [isUpdate, setIsUpdate] = useState(false);
  const [currentEvent, setCurrentEvent] = useState(null);
  const [form] = Form.useForm();
  const [fileList, setFileList] = useState([]);
  const [searchQuery, setSearchQuery] = useState("");
  useEffect(() => {
    fetchNews();
    fetchCat();
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
  const fetchCat = async () => {
    try {
      const response = await axios.get("http://localhost:3001/catNews/");
      setCat(response.data);
    } catch (error) {
      setError(error);
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
    const existingCat = news.find(
      (category) => category.newsTitle === values.newsTitle
    );

    if (existingCat && (!isUpdate || existingCat._id !== currentEvent._id)) {
      message.error("Titre existe déja");
      return;
    }
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
        await axios.put(`${baseUrl}/news/update/${currentEvent._id}`, formData);
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
  const handleSearch = (query) => {
    setSearchQuery(query);
  };

  const filteredSearch = news.filter(
    (user) =>
      user.newsTitle.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.categorienews.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.newsAuthor.toLowerCase().includes(searchQuery.toLowerCase())
  );
  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Actualité</Typography.Title>
      <Search
        placeholder="Rechercher Actualité"
        onSearch={handleSearch}
        onChange={(e) => handleSearch(e.target.value)}
        style={{ width: 300, marginBottom: 20 }}
      />
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
            title: "Nom de Catégorie",
            dataIndex: "categorienews",
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditNews(record)}>Modifier</Button>
                <Button onClick={() => handleDeleteNews(record._id)} danger>
                  Supprimer
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={filteredSearch}
        rowKey="_id"
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
            label="Détail de l'évenement"
            rules={[{ required: true, message: "Please enter event Détail" }]}
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
            label="Nom de Catégorie"
            rules={[{ required: true, message: "Please select a doctor" }]}
          >
            <Select placeholder="Select a doctor">
              {cat.map((doctor) => (
                <Option key={doctor._id} value={doctor.categorienewsnom}>
                  {doctor.categorienewsnom} {/* Ensure your schema matches */}
                </Option>
              ))}
            </Select>
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
            <Button type="primary" htmlType="submit" danger>
              {isUpdate ? "Modifier" : "Ajouter"}
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </Space>
  );
};

export default NewsPage;
