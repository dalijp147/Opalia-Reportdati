import React, { useState } from "react";
import { Button, Layout } from "antd";
import SideBar from "./components/SideBar";
import CustomHeader from "./components/Header";
import AppFooter from "./components/Footer";
import { MenuFoldOutlined, MenuUnfoldOutlined } from "@ant-design/icons";
const { Sider, Header, Content } = Layout;
import "./App.css";
import AppRoute from "./AppRoute";
import { useAuthContext } from "./hooks/useAuthContext";
const App = () => {
  const [collapsed, setCollapsed] = useState(false);
  const { user } = useAuthContext();
  return (
    <Layout>
      {user && (
        <Sider
          style={{ backgroundColor: "rgba(236, 233, 233, 0.884)" }}
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
      )}
      <Layout>
        {user && (
          <Header className="header">
            <CustomHeader />
          </Header>
        )}
        <Content className="content">
          <AppRoute />
        </Content>
      </Layout>
    </Layout>
  );
};

export default App;
