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

const CategorieNewsPage = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [cat, setCat] = useState([]);
  const [isUpdate, setIsUpdate] = useState(false);
  const [currentEvent, setCurrentEvent] = useState(null);
  const [form] = Form.useForm();

  const baseUrl = "http://localhost:3001";

  useEffect(() => {
    fetchCat();
  }, []);

  const fetchCat = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/catNews`);
      setCat(response.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
    }
  };

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  const handleAddCategorie = () => {
    form.resetFields();
    setIsUpdate(false);
    setIsModalVisible(true);
  };

  const handleEditCategorie = (record) => {
    setIsUpdate(true);
    setCurrentEvent(record);
    form.setFieldsValue({
      ...record,
    });
    setIsModalVisible(true);
  };

  const handleDeleteCategorie = async (id) => {
    try {
      await axios.delete(`${baseUrl}/catNews/delete/${id}`);
      message.success("Category successfully deleted!");
      fetchCat();
    } catch (error) {
      message.error("Failed to delete category!");
    }
  };

  const handleFormSubmit = async (values) => {
    try {
      const existingCat = cat.find(
        (category) => category.categorienewsnom === values.categorienewsnom
      );

      if (existingCat && (!isUpdate || existingCat._id !== currentEvent._id)) {
        message.error("Category with this name already exists!");
        return;
      }
      if (isUpdate && currentEvent) {
        await axios.put(
          `${baseUrl}/catNews/update/${currentEvent._id}`,
          values
        );
        message.success("Category successfully updated!");
      } else {
        await axios.post(`${baseUrl}/catNews/`, values);
        message.success("Category successfully created!");
      }
      setIsModalVisible(false);
      fetchCat();
    } catch (error) {
      message.error("Failed to save category!");
    }
  };

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Liste des categories d'actualité</Typography.Title>
      <Button
        type="primary"
        icon={<PlusOutlined />}
        onClick={handleAddCategorie}
        danger
      >
        Ajouter une categories d'actualité
      </Button>
      <Table
        loading={loading}
        columns={[
          {
            title: "Nom de Catégorie",
            dataIndex: "categorienewsnom",
            key: "categorienewsnom",
          },
          {
            title: "Action",
            key: "action",
            render: (text, record) => (
              <Space size="middle">
                <Button onClick={() => handleEditCategorie(record)}>
                  Edit
                </Button>
                <Button
                  onClick={() => handleDeleteCategorie(record._id)}
                  danger
                >
                  Delete
                </Button>
              </Space>
            ),
          },
        ]}
        dataSource={cat}
        pagination={{ pageSize: 5 }}
        rowKey="_id"
      />
      <Modal
        title={isUpdate ? "Edit Category" : "Add Category"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Form form={form} layout="vertical" onFinish={handleFormSubmit}>
          <Form.Item
            name="categorienewsnom"
            label="Nom de Catégorie"
            rules={[
              { required: true, message: "Please enter the category name" },
            ]}
          >
            <Input />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" danger>
              {isUpdate ? "Modfier" : "Ajouter"}
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </Space>
  );
};
export default CategorieNewsPage;
