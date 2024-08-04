import React, { useState, useEffect } from "react";
import axios from "axios";
import {
  Table,
  Select,
  message,
  Button,
  Space,
  Form,
  Input,
  Modal,
  Upload,
  Typography,
} from "antd";
import { UploadOutlined } from "@ant-design/icons";

const { Search } = Input;
const { Option } = Select;

const MedicamentsByCategory = () => {
  const [categories, setCategories] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [medicaments, setMedicaments] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [form] = Form.useForm();
  const [searchQuery, setSearchQuery] = useState("");
  const [isEditing, setIsEditing] = useState(false);
  const [currentMedicament, setCurrentMedicament] = useState(null);

  useEffect(() => {
    fetchCategories();
    fetchMedicamentsAll();
  }, []);

  const fetchCategories = async () => {
    try {
      const [responsePro, responseCat] = await Promise.all([
        axios.get("http://localhost:3001/categoriePro/"),
        axios.get("http://localhost:3001/catgorie/"),
      ]);

      const combinedCategories = [
        ...responsePro.data.data,
        ...responseCat.data.data,
      ];
      setCategories(combinedCategories);
    } catch (error) {
      message.error("Erreur lors de la récupération des catégories");
    }
  };
  const fetchMedicaments = async (category) => {
    setLoading(true);
    try {
      const response = await axios.get(
        `http://localhost:3001/medicament/cat/${category}`
      );
      setMedicaments(response.data.data);
    } catch (error) {
      message.error("Erreur lors de la récupération des médicaments");
    } finally {
      setLoading(false);
    }
  };

  const fetchMedicamentsAll = async () => {
    setLoading(true);
    try {
      const response = await axios.get("http://localhost:3001/medicament/");
      setMedicaments(response.data.data);
    } catch (error) {
      message.error("Erreur lors de la récupération des médicaments");
    } finally {
      setLoading(false);
    }
  };

  const handleCategoryChange = (value) => {
    setSelectedCategory(value);
    fetchMedicaments(value);
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://localhost:3001/medicament/delete/${id}`);
      message.success("Medicament deleted successfully");
    } catch (error) {
      message.error("Failed to delete medicament");
    }
  };

  const handleAddOrUpdateMedicament = async (values) => {
    try {
      const formData = new FormData();
      for (const key in values) {
        if (key === "mediImage" && values[key]?.file) {
          formData.append(key, values[key].file.originFileObj);
        } else {
          formData.append(key, values[key]);
        }
      }
      if (isEditing) {
        await axios.put(
          `http://localhost:3001/medicament/update/${currentMedicament._id}`,
          formData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );
        message.success("Medicament updated successfully");
      } else {
        await axios.post("http://localhost:3001/medicament/", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        });
        message.success("Medicament added successfully");
      }
      setIsModalVisible(false);
      fetchMedicamentsAll();
      form.resetFields();
    } catch (error) {
      message.error("Failed to save medicament");
    }
  };

  const handleEdit = (medicament) => {
    setCurrentMedicament(medicament);
    form.setFieldsValue(medicament);
    setIsEditing(true);
    setIsModalVisible(true);
  };

  const handleSearch = (query) => {
    setSearchQuery(query);
  };

  const filteredMedicaments = medicaments.filter((medicament) =>
    medicament.mediname.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const columns = [
    { title: "Nom", dataIndex: "mediname", key: "mediname" },
    {
      title: "Image",
      dataIndex: "mediImage",
      key: "mediImage",
      render: (text) => <img src={text} alt="Medi" width={50} />,
    },
    { title: "Forme", dataIndex: "forme", key: "forme" },
    { title: "DCI", dataIndex: "dci", key: "dci" },
    {
      title: "Présentation",
      dataIndex: "presentationmedi",
      key: "presentationmedi",
    },
    {
      title: "Classe Paramedicale",
      dataIndex: "classeparamedicalemedi",
      key: "classeparamedicalemedi",
    },
    {
      title: "Sous-classe",
      dataIndex: "sousclassemedi",
      key: "sousclassemedi",
    },
    {
      title: "Catégorie",
      key: "categorie",
      render: (text, record) => {
        const categoriePro = record.categoriePro
          ? record.categoriePro.categorienompro
          : null;
        const categorie = record.categorie
          ? record.categorie.categorienom
          : null;
        return (
          <>
            {categoriePro && <span>{categoriePro}</span>}
            {categorie && categoriePro && <span> / </span>}
            {categorie && <span>{categorie}</span>}
          </>
        );
      },
    },
    {
      title: "Actions",
      key: "actions",
      render: (text, record) => (
        <Space size="middle">
          <Button type="primary" onClick={() => handleEdit(record)}>
            Modifier
          </Button>
          <Button
            type="primary"
            danger
            onClick={() => handleDelete(record._id)}
          >
            Supprimer
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Médicament</Typography.Title>
      <Search
        placeholder="Rechercher un médicament"
        onSearch={handleSearch}
        onChange={(e) => handleSearch(e.target.value)}
        style={{ width: 300, marginBottom: 20 }}
      />
      <Select
        placeholder="Sélectionnez une catégorie"
        style={{ width: 300, marginBottom: 20 }}
        onChange={handleCategoryChange}
      >
        {categories.map((category) => (
          <Option key={category._id} value={category._id}>
            {category.categorienompro || category.categorienom}
          </Option>
        ))}
      </Select>
      <Button
        type="primary"
        onClick={() => {
          setIsEditing(false);
          setIsModalVisible(true);
        }}
        style={{ marginBottom: 20 }}
        danger
      >
        Ajouter un Médicament
      </Button>
      <Table
        columns={columns}
        dataSource={filteredMedicaments}
        rowKey="_id"
        loading={loading}
        pagination={{ pageSize: 10 }}
      />
      <Modal
        title={isEditing ? "Modifier Médicament" : "Ajouter un Médicament"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
        width={700}
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleAddOrUpdateMedicament}
        >
          <Form.Item
            name="mediname"
            label="Nom"
            rules={[{ required: true, message: "Veuillez entrer le nom" }]}
          >
            <Input />
          </Form.Item>

          <Form.Item
            name="mediImage"
            label="Image"
            rules={[
              {
                required: !isEditing,
                message: "Veuillez télécharger une image",
              },
            ]}
          >
            <Upload
              beforeUpload={() => false} // Disable auto-upload
              onChange={({ file }) => form.setFieldsValue({ mediImage: file })}
              showUploadList={false}
            >
              <Button icon={<UploadOutlined />}>Télécharger une image</Button>
            </Upload>
          </Form.Item>

          <Form.Item
            name="forme"
            label="Forme"
            rules={[{ required: true, message: "Veuillez entrer la forme" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="dci"
            label="DCI"
            rules={[{ required: true, message: "Veuillez entrer le DCI" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="presentationmedi"
            label="Présentation"
            rules={[
              { required: true, message: "Veuillez entrer la présentation" },
            ]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="classeparamedicalemedi"
            label="Classe Paramedicale"
            rules={[
              {
                required: true,
                message: "Veuillez entrer la classe paramedicale",
              },
            ]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="sousclassemedi"
            label="Sous-classe"
            rules={[
              { required: true, message: "Veuillez entrer la sous-classe" },
            ]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="categoriePro"
            label="Catégorie Professionnelle"
            rules={[
              {
                message: "Veuillez entrer la catégorie professionnelle",
              },
            ]}
          >
            <Select>
              {categories.map((category) => (
                <Option key={category._id} value={category._id}>
                  {category.categorienompro || category.categorienom}
                </Option>
              ))}
            </Select>
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" style={{ marginRight: 8 }}>
              {isEditing ? "Modifier" : "Ajouter"}
            </Button>
            <Button onClick={() => setIsModalVisible(false)}>Annuler</Button>
          </Form.Item>
        </Form>
      </Modal>
    </Space>
  );
};

export default MedicamentsByCategory;
