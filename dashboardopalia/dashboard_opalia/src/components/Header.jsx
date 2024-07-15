import { Flex, Typography } from "antd";
import React from "react";
import Search from "antd/es/input/Search";
import { MessageOutlined, NotificationOutlined } from "@ant-design/icons";
const CustomHeader = () => {
  return (
    <Flex align="center" justify="space-between">
      <Typography.Title level={3} type="secondary">
        Bonjour
      </Typography.Title>
      <Flex align="center" gap="3rem">
        <Search placeholder="Recherche" allowClear />
        <Flex align="center" gap="10px">
          <MessageOutlined />
          <NotificationOutlined />
        </Flex>
      </Flex>
    </Flex>
  );
};

export default CustomHeader;
