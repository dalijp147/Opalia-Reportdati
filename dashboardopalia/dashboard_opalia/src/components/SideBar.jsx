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
import { useLogout } from "../hooks/useLogout";
const SideBar = () => {
  const navigate = useNavigate();
  const { logout } = useLogout();

  const handleClick = () => {
    logout();
  };
  return (
    <>
      <Flex align="center" justify="center">
        <div>
          <img src={Diamond} style={{ width: "100px", height: "100px" }} />
        </div>
      </Flex>
      <Menu
        onClick={(item) => {
          if (item.key === "/logout") {
            handleClick();
          } else {
            navigate(item.key);
          }
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
            label: "Docteur",
          },

          {
            key: "/e",
            icon: <ContactsOutlined />,
            label: "Événement",
            children: [
              { key: "/events", label: "Liste des Événement" },
              { key: "/feedback", label: "Les retours sur l'évenement" },
            ],
          },
          {
            key: "/Participant",
            icon: <FaUserGroup />,
            label: "Participant",
          },
          {
            key: "/Programme",
            icon: <TfiAgenda />,
            label: "Programme",
          },

          {
            key: "/n",
            icon: <IoNewspaperOutline />,
            label: "Actualité",

            children: [
              { key: "/news", label: "Liste des Actualités" },
              { key: "/categorie", label: "Liste des categories d'actualités" },
            ],
          },
          {
            key: "/quiz",
            icon: <MdOutlineGamepad />,
            label: "Quiz",
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
