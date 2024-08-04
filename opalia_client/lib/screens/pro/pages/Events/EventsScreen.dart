import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/screens/pro/pages/Events/DetailEventScreen.dart';
import 'package:opalia_client/screens/pro/pages/Events/feedback/FeedbackPopup.dart';
import 'package:opalia_client/screens/pro/widgets/Reusiblewidgets/Drawerwidgets.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/events.dart';
import '../../../../models/particpant.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../widgets/Reusiblewidgets/AppBarWidgetPro.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Events>? allEvents = [];
  late Future<List<Events>> futureEvents;
  var formatter = DateFormat('yyyy-MM-dd');

  Future<void> _fetchEvents() async {
    try {
      final events = await ApiServicePro.getAllEvents();
      setState(() {
        allEvents = events;
      });
    } catch (e) {
      print('Failed to fetch events: $e');
    }
  }

  Future<void> _deletePastEventsOnStart() async {
    await ApiServicePro.deletePastEvent();
  }

  void _refreshEvents() {
    _fetchEvents();
  }

  @override
  void initState() {
    // _deletePastEventsOnStart();
    _fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      drawer: DrawerWidgetPro(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.event_note,
                  color: Colors.red,
                ),
                SizedBox(width: 10),
                Text(
                  'Evenement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: allEvents == null || allEvents!.isEmpty
                ? Center(
                    child: Text('evenement en atente'),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchEvents,
                    child: ListView.builder(
                      itemCount: allEvents!.length,
                      itemBuilder: (context, index) {
                        final event = allEvents![index];
                        return EventCard(
                          event: event,
                          formatter: formatter,
                          onRefresh: _refreshEvents,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  final Events event;
  final DateFormat formatter;
  final VoidCallback onRefresh;
  const EventCard(
      {required this.event, required this.formatter, required this.onRefresh});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  List<Particpant>? allParticpant;
  bool isLoading = true;
  bool isFeedbackLoading = true;
  bool showFeedbackButton = false;
  bool hasFeedback = false;
  bool isParticipant = false;
  Future<void> _checkParticipation() async {
    try {
      final userId = await PreferenceUtils.getuserid();
      print('User ID: $userId'); // Debug print
      final participantStatus =
          await ApiServicePro.isParticipant(userId, widget.event.EventId!);
      print('Participant Status: $participantStatus'); // Debug print
      setState(() {
        isParticipant = participantStatus;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to check participant status: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openMap(BuildContext context, String location) async {
    String query = Uri.encodeComponent(location);
    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$query";

    print('Attempting to launch URL: $googleMapsUrl'); // Debugging line

    // ignore: deprecated_member_use
    if (await canLaunch(googleMapsUrl)) {
      // ignore: deprecated_member_use
      await launch(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not open the map. URL: $googleMapsUrl')));
      throw 'Could not open the map. URL: $googleMapsUrl';
    }
  }

  Future<void> _fetchParticipants() async {
    try {
      final participants = await ApiServicePro.fetchparticipantbyevent(
          true, widget.event.EventId!);
      setState(() {
        allParticpant = participants;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch participants: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _fetchParticipants();
    _checkFeedback();
    _scheduleFeedbackPopup();
    _checkParticipation();
    super.initState();
  }

  Future<void> _checkFeedback() async {
    final userId = PreferenceUtils.getuserid();
    if (userId != null) {
      final x =
          await ApiServicePro.doesFeedbackExist(userId, widget.event.EventId!);
      setState(() {
        hasFeedback = x;
        isFeedbackLoading = false;
      });
      widget.onRefresh();
    } else {
      print('User ID is null');
      setState(() {
        isFeedbackLoading = false;
      });
    }
  }

  void _scheduleFeedbackPopup() {
    DateTime eventEndTime = widget.event.dateEvent!;
    DateTime feedbackPopupTime = eventEndTime.add(Duration(minutes: 5));

    Duration timeDifference = feedbackPopupTime.difference(DateTime.now());

    if (timeDifference.isNegative) {
      // If the feedbackPopupTime has already passed, show the feedback button immediately
      setState(() {
        showFeedbackButton = true;
      });
      print('Feedback button should appear immediately.');
    } else {
      Timer(timeDifference, () {
        setState(() {
          showFeedbackButton = true;
        });
        print('Feedback button should appear after $timeDifference.');
        showFeedbackPopup(context, widget.event.EventId!, _hideFeedbackButton);
      });
    }
  }

  void _hideFeedbackButton() {
    setState(() {
      showFeedbackButton = false;
    });
    widget.onRefresh();
    print('Feedback button hidden.');
  }

  @override
  Widget build(BuildContext context) {
    bool isEventFull = allParticpant != null &&
        allParticpant!.length >= widget.event.nombreparticipant!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 390,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: Colors.red),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image.network(
              widget.event.eventimage == null ||
                      widget.event.eventimage!.isEmpty
                  ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                  : widget.event.eventimage!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 100,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                print('Error loading image: $error');
                return Image.network(
                  "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                  height: 100,
                  width: 100,
                );
              },
            ),
            SizedBox(height: 10),
            Text(
              widget.event.eventname!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 10),
            Text(
              'nombre maximal de participant : ${widget.event.nombreparticipant}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        _openMap(
                            context, widget.event.eventLocation ?? 'unknown');
                      },
                      child: Text(
                        widget.event.eventLocation!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.red),
                    SizedBox(width: 5),
                    Text(
                      isLoading
                          ? 'Loading...'
                          : allParticpant?.length.toString() ?? '0',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.red),
                    SizedBox(width: 5),
                    Text(
                      '${widget.formatter.format(widget.event.dateEvent!)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
                ElevatedButton(
                  onPressed: isEventFull && !isParticipant
                      ? null
                      : () {
                          Get.to(DetailEventScreen(event: widget.event));
                        },
                  // onPressed: () {
                  //   Get.to(DetailEventScreen(event: widget.event));
                  // },
                  child: Text('Découvrir'),
                )
              ],
            ),
            isFeedbackLoading
                ? CircularProgressIndicator()
                : hasFeedback
                    ? Text('Tu a deja donner un feedback',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
                    : Text('vous recevrez un  formulaire prochainement',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
            if (showFeedbackButton && !hasFeedback)
              ElevatedButton(
                onPressed: () {
                  showFeedbackPopup(
                      context, widget.event.EventId!, _hideFeedbackButton);
                },
                child: Text('Feedback'),
              ),
            if (isEventFull)
              Text('Événement Plein',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  )),
          ],
        ),
      ),
    );
  }
}

void showFeedbackPopup(
    BuildContext context, String event, VoidCallback onFeedbackSubmitted) {
  showDialog(
    context: context,
    builder: (context) => FeedbackPopup(event: event),
  ).then((newFeedback) {
    if (newFeedback != null) {
      // Handle the new feedback
      print('Feedback submitted: $newFeedback');
      Future.delayed(Duration(milliseconds: 100), onFeedbackSubmitted);
    }
  });
}
