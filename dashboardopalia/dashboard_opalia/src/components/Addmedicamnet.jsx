import React, { useState } from "react";
import axios from "axios";
import { Form, Input, Button, Upload, Select, message } from "antd";
import { UploadOutlined } from "@ant-design/icons";

const { Option } = Select;

const AddMedicament = () => {
  const [file, setFile] = useState(null);

  const handleFileChange = (info) => {
    if (info.file.status === "done") {
      setFile(info.file.originFileObj);
    }
  };

  const handleFormSubmit = async (values) => {
    const formData = new FormData();
    formData.append("mediname", values.mediname);
    formData.append("medidesc", values.medidesc);
    formData.append("mediImage", file);
    formData.append("categorie", values.categorie);
    formData.append("forme", values.forme);
    formData.append("dci", values.dci);
    formData.append("presentationmedi", values.presentationmedi);
    formData.append("classeparamedicalemedi", values.classeparamedicalemedi);
    formData.append("sousclassemedi", values.sousclassemedi);
    formData.append("categoriePro", values.categoriePro);

    try {
      const response = await axios.post("http://localhost:3001/medicament/", formData);
      message.success("Médicament ajouté avec succès");
    } catch (error) {
      message.error("Erreur lors de l'ajout du médicament");
    }
  };

  return (
    <Form layout="vertical" onFinish={handleFormSubmit}>
      <Form.Item
        name="mediname"
        label="Nom du médicament"
        rules={[{ required: true }]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="medidesc"
        label="Description"
        rules={[{ required: true }]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="categorie"
        label="Catégorie"
        rules={[{ required: true }]}
      >
        <Input />
      </Form.Item>
      <Form.Item name="forme" label="Forme" rules={[{ required: true }]}>
        <Input />
      </Form.Item>
      <Form.Item name="dci" label="DCI" rules={[{ required: true }]}>
        <Input />
      </Form.Item>
      <Form.Item
        name="presentationmedi"
        label="Présentation"
        rules={[{ required: true }]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="classeparamedicalemedi"
        label="Classe Paramedicale"
        rules={[{ required: true }]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="sousclassemedi"
        label="Sous-classe"
        rules={[{ required: true }]}
      >
        <Input />
      </Form.Item>
      <Form.Item
        name="categoriePro"
        label="Catégorie Professionnelle"
        rules={[{ required: true }]}
      >
        <Input />
      </Form.Item>
      <Form.Item label="Image">
        <Upload
          listType="picture"
          beforeUpload={() => false}
          onChange={handleFileChange}
        >
          <Button icon={<UploadOutlined />}>Télécharger l'image</Button>
        </Upload>
      </Form.Item>
      <Form.Item>
        <Button type="primary" htmlType="submit">
          Ajouter
        </Button>
      </Form.Item>
    </Form>
  );
};

export default AddMedicament;
