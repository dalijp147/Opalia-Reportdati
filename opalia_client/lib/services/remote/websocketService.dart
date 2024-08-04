import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  static final WebSocketService _instance =
      WebSocketService._internal('http://10.0.2.2:3001');
  final String url;
  late IO.Socket socket;

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal(this.url) {
    _connect();
  }

  void _connect() {
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .enableAutoConnect()
          .setReconnectionDelay(1000)
          .setReconnectionAttempts(2)
          .build(),
    );

    socket.onConnect((_) {
      print('Connected to WebSocket');
    });

    socket.onDisconnect((_) {
      print('Disconnected from WebSocket');
    });

    socket.on('new_comment', (data) {
      print('New comment: $data');
      // Handle new comment
    });

    socket.on('new_question', (data) {
      print('New question: $data');
      // Handle new question
    });
    socket.on('new_discussion', (data) {
      print('New discussion: $data');
      // Handle new question
    });

    socket.on('new_dicucomment', (data) {
      print('new_dicucomment : $data');
      // Handle new question
    });
    socket.on('new_answer', (data) {
      print('New Answer: $data');
      // Handle new answer
    });
    socket.on('delete_dicucomment', (data) {
      print('Comment deleted: $data');
      // Handle comment deletion - trigger screen refresh or data fetch
      // For example, you might notify listeners or call a method to refresh the UI
    });
    socket.on('newEvent', (data) {
      print('New event: $data');
      // Handle new event
    });
    socket.on('new_medicament', (data) {
      print('New event: $data');
      // Handle new event
    });
  }

  void send(String event, dynamic data) {
    socket.emit(event, data);
  }

  void reconnect() {
    if (!socket.connected) {
      socket.connect();
    }
  }
}
