import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'discussion/viewAnswer.dart';

class BadgesSocketPatient extends StatefulWidget {
  const BadgesSocketPatient({super.key});

  @override
  State<BadgesSocketPatient> createState() => _BadgesSocketPatientState();
}

class _BadgesSocketPatientState extends State<BadgesSocketPatient> {
  late IO.Socket socket;
  int _notificationCount = 0;
  List<Map<String, dynamic>> _answers = [];

  @override
  void initState() {
    super.initState();
    loadNotificationCount();
    loadAnswers();
    initSocket();
  }

  void initSocket() {
    socket = IO.io('http://10.0.2.2:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('connect', (_) {
      print('Connected to the server');
    });

    socket.on('new answer', (data) {
      print('New answer created: $data');
      setState(() {
        _answers.add(Map<String, dynamic>.from(data));
        _notificationCount += 1;
        saveNotificationCount();
        saveAnswers();
      });
    });

    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });

    socket.connect();
  }

  Future<void> saveNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationCount', _notificationCount);
  }

  Future<void> loadNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationCount = prefs.getInt('notificationCount') ?? 0;
    });
  }

  Future<void> saveAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String answersJson = jsonEncode(_answers);
    await prefs.setString('answers', answersJson);
  }

  Future<void> loadAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? answersJson = prefs.getString('answers');
    if (answersJson != null) {
      setState(() {
        _answers = List<Map<String, dynamic>>.from(jsonDecode(answersJson));
      });
    }
  }

  void _navigateToAnswerList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnswerListScreen(
          answers: _answers,
          onClearNotifications: () {
            setState(() {
              _notificationCount = 0;
              _answers.clear();
              saveNotificationCount();
              saveAnswers();
            });
          },
        ),
      ),
    ).then((_) {
      // Reset notification count after viewing
      setState(() {
        _notificationCount = 0;
        saveNotificationCount();
      });
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: badges.Badge(
        position: badges.BadgePosition.topEnd(top: 0, end: 3),
        badgeContent: Text(
          _notificationCount.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: Icon(
          Icons.notifications_active_outlined,
        ),
        showBadge: _notificationCount > 0,
      ),
      onPressed: _notificationCount > 0
          ? _navigateToAnswerList
          : _navigateToAnswerList,
    );
  }
}

class AnswerListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> answers;
  final VoidCallback onClearNotifications;
  AnswerListScreen({required this.answers, required this.onClearNotifications});
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [1, 0.1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              // Clear notifications and call the callback
              onClearNotifications();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('Notification'),
        centerTitle: true,
      ),
      body: answers == null || answers!.isEmpty
          ? Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/notif.png', scale: 0.5),
                Text(
                  'Aucune notification',
                  style: TextStyle(fontSize: 25),
                )
              ],
            ))
          : ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final answer = answers[index];
                return ListTile(
                  title: Text(
                    "Reponse: ${answer['answer'] ?? 'N/A'}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Par: ${answer['doctorId' 'username'] ?? 'N/A'}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewAnswersScreen(
                          questionId: answer['questionId'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
