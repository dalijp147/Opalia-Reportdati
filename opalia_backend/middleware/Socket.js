const socketIo = require("socket.io");
let io;

const initializeSocket = (server) => {
  io = socketIo(server, {
    cors: {
      origin: ["http://localhost:5173", "http://10.0.2.2:3001"], // Allow all origins for simplicity, but refine this in production
      methods: ["GET", "POST"],
    },
  });

  io.on("connection", (socket) => {
    console.log("New client connected to med and events");

    socket.on("disconnect", () => {
      console.log("Client disconnected");
    });
  });
};

const getIo = () => {
  if (!io) {
    throw new Error("Socket.io not initialized!");
  }
  return io;
};

module.exports = { initializeSocket, getIo };
