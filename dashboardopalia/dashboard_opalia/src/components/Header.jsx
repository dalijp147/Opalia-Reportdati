import { Row, Col, Typography, Input, Button } from "antd";

import React from "react";
import { Link } from "react-router-dom";
import Search from "antd/es/input/Search";
import { MessageOutlined, NotificationOutlined } from "@ant-design/icons";
import { useAuthContext } from "../hooks/useAuthContext";
import { useLogout } from "../hooks/useLogout";

const { Text, Title } = Typography;
const CustomHeader = () => {
  const { user } = useAuthContext();
  const { logout } = useLogout();
  const handleClick = () => {
    logout();
  };
  return (
    <Row
      align="middle"
      justify="space-between"
      style={{ padding: "10px 20px", borderBottom: "1px solid #e8e8e8" }}
    >
      <Col>
        <Title level={3} type="secondary" style={{ marginTop: 5 }}>
          Bonjour
        </Title>
      </Col>
      <Col>
        <Row align="middle" gutter={20}>
          <Col>
            <Search placeholder="Recherche" allowClear />
          </Col>
          <Col>
            {user ? (
              <>
                <Text>Admin</Text>
                <Button
                  type="primary"
                  onClick={handleClick}
                  style={{ marginLeft: 10 }}
                  danger
                >
                  Log out
                </Button>
              </>
            ) : (
              <>
                <Link to="/login" style={{ marginRight: 10 }}>
                  Login
                </Link>
                <Link to="/signup">Signup</Link>
              </>
            )}
          </Col>
        </Row>
      </Col>
    </Row>
  );
};

export default CustomHeader;
