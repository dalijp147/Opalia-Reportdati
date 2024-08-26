import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../services/remote/websocketService.dart';
import 'package:http/http.dart' as http;

class BadgesSocket extends StatefulWidget {
  const BadgesSocket({Key? key}) : super(key: key);

  @override
  State<BadgesSocket> createState() => _BadgesSocketState();
}

class _BadgesSocketState extends State<BadgesSocket> {
  late WebSocketService _socketService;
  int _notificationCount = 0;
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _initializeSocketService();
    loadNotificationCount();
    loadEvents();
  }

  void _initializeSocketService() {
    _socketService = WebSocketService();
    _listenForEvents();
  }

  Future<Map<String, dynamic>> fetchPatientDetails(String patientId) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3001/user/patients/$patientId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load patient details');
    }
  }

  void _listenForEvents() {
    _socketService.socket.on('newEvent', (data) {
      print('New event received in BadgesSocket: $data');
      if (mounted) {
        setState(() {
          _events.add(Map<String, dynamic>.from(data));
          _notificationCount += 1;
          saveNotificationCount();
          saveEvents();
        });
      }
    });

    _socketService.socket.on('new_medicament', (data) {
      print('New medicament received in BadgesSocket: $data');
      if (mounted) {
        setState(() {
          _events.add(Map<String, dynamic>.from(data));
          _notificationCount += 1;
          saveNotificationCount();
          saveEvents();
        });
      }
    });
    _socketService.socket.on('new_question', (data) async {
      print('New question received in BadgesSocket: $data');
      try {
        final patientId = data['patientId'] as String;
        final patientDetails = await fetchPatientDetails(patientId);

        final eventWithPatientDetails = {
          ...data as Map<String, dynamic>,
          'patientName': patientDetails['username'] ?? 'Unknown',
        };

        _handleNewEvent(eventWithPatientDetails);
      } catch (e) {
        print('Error fetching patient details: $e');
      }
    });
  }

  void _handleNewEvent(Map<String, dynamic> data) {
    if (mounted) {
      print('Handling new event: $data'); // Debug print statement
      setState(() {
        _events.add(data);
        _notificationCount += 1;
        saveNotificationCount();
        saveEvents();
      });
    }
  }

  Future<void> saveNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationCount', _notificationCount);
    print('Notification count saved: $_notificationCount');
  }

  Future<void> loadNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _notificationCount = prefs.getInt('notificationCount') ?? 0;
        print('Notification count loaded: $_notificationCount');
      });
    }
  }

  Future<void> saveEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String eventsJson = jsonEncode(_events);
    await prefs.setString('events', eventsJson);
    print('Events saved: $eventsJson');
  }

  Future<void> loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? eventsJson = prefs.getString('events');
    if (eventsJson != null && mounted) {
      setState(() {
        _events = List<Map<String, dynamic>>.from(jsonDecode(eventsJson));
        print('Events loaded: $eventsJson');
      });
    }
  }

  void _navigateToEventList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventListScreen(
          events: _events,
          onClearNotifications: () {
            setState(() {
              _notificationCount = 0;
              _events.clear();
              saveNotificationCount();
              saveEvents();
            });
          },
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _notificationCount = 0;
          saveNotificationCount();
        });
      }
    });
  }

  @override
  void dispose() {
    _socketService.socket
        .dispose(); // Close the socket connection when disposing the widget
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
          color: Colors.red,
        ),
        showBadge: _notificationCount > 0,
      ),
      onPressed: _navigateToEventList,
    );
  }
}

class EventListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> events;
  final VoidCallback onClearNotifications;
  EventListScreen({required this.events, required this.onClearNotifications});
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
      ),
      body: events == null || events!.isEmpty
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/Grouhome.png'), // Replace with your image path
                  fit: BoxFit
                      .cover, // Adjust the image to cover the entire screen
                ),
              ),
              child: Center(
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
              )),
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/Grouhome.png'), // Replace with your image path
                  fit: BoxFit
                      .cover, // Adjust the image to cover the entire screen
                ),
              ),
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: Colors.red,
                        ),
                      ),
                      child: ListTile(
                        leading: event['eventimage'] != null ||
                                event['mediImage'] != null
                            ? ClipOval(
                                child: Image.network(
                                  event['eventimage'] ?? event['mediImage'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 50.0,
                              ),
                        title: Text(
                          event['eventname'] != null
                              ? 'Nouveau Événement:  ${event['eventname'] ?? event['mediname'] ?? 'N/A'}'
                              : event['mediname'] != null
                                  ? 'Nouveau Medicament : ${event['mediname'] ?? 'N/A'}'
                                  : 'Nouvelle Question :  ${event['question'] ?? 'N/A'}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: event['eventname'] != null
                            ? Text(
                                'Date : ${formatter.format(DateTime.parse(event['dateEvent']))}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : SizedBox.shrink(),
                        onTap: () {
                          event['eventname'] != null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailScreen(event: event),
                                  ),
                                )
                              : Text('');
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['eventname'] ?? 'Event Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nom de l'évenement: ${event['eventname'] ?? 'N/A'}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            event['eventimage'] != null
                ? Image.network(event['eventimage'])
                : SizedBox.shrink(),
            SizedBox(height: 10),
            Text('Emplacement: ${event['eventLocalisation'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text("Date de l'évenement: ${event['dateEvent'] ?? 'N/A'}"),
            SizedBox(height: 10),
            Text(
                'Nombre de Participant max: ${event['nombreparticipant'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Description: ${event['eventdescription'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
