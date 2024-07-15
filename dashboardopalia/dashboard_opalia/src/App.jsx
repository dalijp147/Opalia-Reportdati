import React, { useState } from "react";
import { Button, Layout } from "antd";
import SideBar from "./components/SideBar";
import CustomHeader from "./components/Header";
import { MenuFoldOutlined, MenuUnfoldOutlined } from "@ant-design/icons";
const { Sider, Header, Content } = Layout;
import "./App.css";
import AppRoute from "./AppRoute";
const App = () => {
  const [collapsed, setCollapsed] = useState(false);
  return (
    <Layout>
      <Sider
        theme="light"
        trigger={null}
        collapsible
        collapsed={collapsed}
        className="sider"
      >
        <SideBar />
        <Button
          type="text"
          icon={collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
          onClick={() => setCollapsed(!collapsed)}
          className="trigger-btn"
        />
      </Sider>
      <Layout>
        <Header className="header">
          {" "}
          <CustomHeader />
        </Header>
        <Content className="content">
          <AppRoute />
        </Content>
      </Layout>
    </Layout>
  );
};

export default App;
