const express = require("express");
const http = require("http");
const WebSocket = require("ws");

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

wss.on("connection", (ws) => {
  console.log("Client web socket connected");

  ws.on("close", () => {
    console.log("Client web socket disconnected");
  });
});

function broadcastMessage(message) {
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

function broadcastNewComment(req, res, next) {
  res.on("finish", () => {
    if (res.statusCode === 200 && res.locals.newComment) {
      broadcastMessage(
        JSON.stringify({
          type: "new_comment",
          data: res.locals.newComment,
        })
      );
    }
  });
  next();
}

module.exports = { broadcastNewComment };
