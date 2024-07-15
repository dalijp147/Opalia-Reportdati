import { Flex, Menu } from "antd";
import React from "react";
import { FaLeaf } from "react-icons/fa6";
import {
  UserOutlined,
  ContactsOutlined,
  LoginOutlined,
} from "@ant-design/icons";
import { FaUserDoctor, FaUserGroup } from "react-icons/fa6";
import { useNavigate } from "react-router-dom";
import { IoNewspaperOutline } from "react-icons/io5";
import { MdOutlineGamepad } from "react-icons/md";
import { TfiAgenda } from "react-icons/tfi";
import { LuLayoutDashboard } from "react-icons/lu";
import Diamond from "../../src/assets/opalia.png";
const SideBar = () => {
  const navigate = useNavigate();
  return (
    <>
      <Flex align="center" justify="center">
        <div>
          <img src={Diamond} style={{ width: "100px", height: "100px" }} />
        </div>
      </Flex>
      <Menu
        onClick={(item) => {
          navigate(item.key);
        }}
        className="menu-bar"
        items={[
          {
            key: "/",
            icon: <LuLayoutDashboard />,
            label: "DashBoard",
          },
          {
            key: "/user",
            icon: <UserOutlined />,
            label: "Patient",
          },
          {
            key: "/doc",
            icon: <FaUserDoctor />,
            label: "Doctor",
          },
          {
            key: "/Participant",
            icon: <FaUserGroup />,
            label: "Participant",
          },
          {
            key: "/events",
            icon: <ContactsOutlined />,
            label: "Events",
          },
          {
            key: "/news",
            icon: <IoNewspaperOutline />,
            label: "News",
          },
          {
            key: "/quiz",
            icon: <MdOutlineGamepad />,
            label: "Quiz",
          },
          {
            key: "/Programme",
            icon: <TfiAgenda />,
            label: "Programme",
          },

          {
            key: "/logout",
            icon: <LoginOutlined />,
            label: "Deconnecter",
          },
        ]}
      />
    </>
  );
};

export default SideBar;
