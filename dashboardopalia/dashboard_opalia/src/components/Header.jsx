import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { Badge, Button, Drawer, List, Space, Typography } from "antd";
import { BellFilled, MailOutlined } from "@ant-design/icons";
import io from "socket.io-client";
import { useAuthContext } from "../hooks/useAuthContext";
import { useLogout } from "../hooks/useLogout";
const socket = io("http://localhost:3001");

const CustomHeader = () => {
  const [comments, setComments] = useState([]);
  const [notifications, setNotifications] = useState([]);
  const [commentsOpen, setCommentsOpen] = useState(false);
  const [notificationsOpen, setNotificationsOpen] = useState(false);
  const { user } = useAuthContext();
  const { logout } = useLogout();

  const handleClick = () => {
    logout();
  };

  useEffect(() => {
    // Listen for new doctor notifications from the server
    socket.on("new doctor", (notification) => {
      console.log("New doctor notification received:", notification);
      setNotifications((prevNotifications) => [
        ...prevNotifications,
        { ...notification, type: "doctor" },
      ]);
      setNotificationsOpen(true);
    });

    // Listen for new participant notifications from the server
    socket.on("newParticipant", (notification) => {
      console.log("New participant notification received:", notification);
      setNotifications((prevNotifications) => [
        ...prevNotifications,
        { ...notification, type: "participant" },
      ]);
      setNotificationsOpen(true);
    });

    // Cleanup on component unmount
    return () => {
      socket.off("new doctor");
      socket.off("newParticipant");
    };
  }, []);

  return (
    <div className="AppHeader">
      <Typography.Title></Typography.Title>
      <Space>
        <Badge count={comments.length} dot>
          <MailOutlined
            style={{ fontSize: 24 }}
            onClick={() => {
              setCommentsOpen(true);
            }}
          />
        </Badge>
        <Badge count={notifications.length}>
          <BellFilled
            style={{ fontSize: 24 }}
            onClick={() => {
              setNotificationsOpen(true);
            }}
          />
        </Badge>
        {user ? (
          <>
            <Typography.Text>Admin</Typography.Text>
          </>
        ) : (
          <>
            <Link to="/login" style={{ marginRight: 10 }}>
              Login
            </Link>
            <Link to="/signup">Signup</Link>
          </>
        )}
      </Space>
      <Drawer
        title="Notifications"
        placement="right"
        onClose={() => setNotificationsOpen(false)}
        open={notificationsOpen}
      >
        <List
          dataSource={notifications}
          renderItem={(item) => (
            <List.Item key={item.id}>
              <Typography.Text>
                {item.type === "doctor" ? (
                  <>
                    Nouveau docteur ajouté en attente d'approbation:{" "}
                    {item.username}
                  </>
                ) : (
                  <>
                    Nouveau participant: {item.doctorId.username} à l'évenement{" "}
                    {item.event.eventname}
                  </>
                )}
              </Typography.Text>
            </List.Item>
          )}
        />
      </Drawer>
    </div>
  );
};

export default CustomHeader;
