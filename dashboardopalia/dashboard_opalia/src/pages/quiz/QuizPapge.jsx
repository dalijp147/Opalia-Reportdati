import React, { useState, useEffect } from "react";
import {
  Typography,
  Space,
  Table,
  Button,
  Modal,
  Form,
  Input,
  message,
} from "antd";
import axios from "axios";
import { PlusOutlined, MinusCircleOutlined } from "@ant-design/icons";
const QuizPapge = () => {
  const [quizzes, setQuizzes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [isUpdate, setIsUpdate] = useState(false);
  const [currentQuiz, setCurrentQuiz] = useState(null);
  const [form] = Form.useForm();

  useEffect(() => {
    fetchQuizzes();
  }, []);

  const baseUrl = "http://localhost:3001";

  const fetchQuizzes = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${baseUrl}/quiz`);
      setQuizzes(response.data);
      setLoading(false);
    } catch (error) {
      setError(error);
      setLoading(false);
    }
  };

  const handleAddQuiz = () => {
    form.resetFields();
    setIsUpdate(false);
    setIsModalVisible(true);
  };

  const handleDeleteQuiz = async (id) => {
    try {
      await axios.delete(`${baseUrl}/quiz/delete/${id}`);
      message.success("Quiz successfully deleted!");
      fetchQuizzes();
    } catch (error) {
      message.error("Failed to delete quiz!");
    }
  };

  const handleFormSubmit = async (values) => {
    try {
      if (isUpdate && currentQuiz) {
        await axios.put(`${baseUrl}/quiz/${currentQuiz._id}`, values);
        message.success("Quiz successfully updated!");
      } else {
        await axios.post(`${baseUrl}/quiz/`, values);
        message.success("Quiz successfully created!");
      }
      setIsModalVisible(false);
      fetchQuizzes();
    } catch (error) {
      message.error("Failed to save quiz!");
    }
  };

  const columns = [
    { title: "Questions", dataIndex: "questions", key: "questions" },
    { title: "Answers", dataIndex: "answers", key: "answers" },
    {
      title: "Options",
      dataIndex: "options",
      key: "options",
      render: (options) => options.join(", "),
    },
    {
      title: "Actions",
      key: "actions",
      render: (text, record) => (
        <Space size="middle">
          <Button onClick={() => handleEditQuiz(record)}>Modifier</Button>
          <Button onClick={() => handleDeleteQuiz(record._id)} danger>
            Supprimer
          </Button>
        </Space>
      ),
    },
  ];

  const handleEditQuiz = (record) => {
    setIsUpdate(true);
    setCurrentQuiz(record);
    form.setFieldsValue(record);
    setIsModalVisible(true);
  };

  return (
    <Space size={20} direction="vertical" style={{ width: "100%" }}>
      <Typography.Title>Quiz</Typography.Title>
      <Button
        type="primary"
        danger
        icon={<PlusOutlined />}
        onClick={handleAddQuiz}
      >
        Ajouter une Quiz
      </Button>
      <Table
        loading={loading}
        columns={columns}
        dataSource={quizzes}
        rowKey="_id"
        pagination={{ pageSize: 5 }}
      />
      <Modal
        title={isUpdate ? "Modifier Quiz" : "Ajouter une Quiz"}
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Form form={form} layout="vertical" onFinish={handleFormSubmit}>
          <Form.Item
            name="questions"
            label="Questions"
            rules={[{ required: true, message: "Please enter the question" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item
            name="answers"
            label="Answers"
            rules={[
              {
                required: true,
                message: "Please enter the correct answer index",
              },
            ]}
          >
            <Input type="number" />
          </Form.Item>
          <Form.List name="options">
            {(fields, { add, remove }) => (
              <>
                {fields.map(({ key, name, fieldKey, ...restField }) => (
                  <Form.Item key={key} label={`Option ${name + 1}`} required>
                    <Form.Item
                      {...restField}
                      name={name}
                      fieldKey={fieldKey}
                      noStyle
                      rules={[{ required: true, message: "Missing option" }]}
                    >
                      <Input style={{ width: "85%" }} />
                    </Form.Item>
                    <MinusCircleOutlined
                      onClick={() => remove(name)}
                      style={{ marginLeft: "10px", color: "red" }}
                    />
                  </Form.Item>
                ))}
                <Form.Item>
                  <Button
                    type="dashed"
                    onClick={() => add()}
                    block
                    icon={<PlusOutlined />}
                  >
                    Add Option
                  </Button>
                </Form.Item>
              </>
            )}
          </Form.List>
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

export default QuizPapge;
