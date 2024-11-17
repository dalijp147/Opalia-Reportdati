import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/screens/pro/pages/Events/DetailEventScreen.dart';
import 'package:opalia_client/screens/pro/pages/Events/DetailPageEvent.dart';
import 'package:opalia_client/screens/pro/pages/Events/feedback/FeedbackPopup.dart';
import 'package:opalia_client/screens/pro/widgets/Allappwidgets/Drawerwidgets.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/events.dart';
import '../../../../models/particpant.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../widgets/Allappwidgets/AppBarWidgetPro.dart';
import 'FilterbyDateScreen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Events>? allEvents = [];
  late Future<List<Events>> futureEvents;
  var formatter = DateFormat('yyyy-MM-dd');
  final TextEditingController _controller = TextEditingController();
  DateTime? selectedDate;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _filterEventsByDate();
    }
  }

  void _filterEventsByDate() {
    setState(() {
      allEvents = allEvents!.where((event) {
        return event.dateEvent!.year == selectedDate!.year &&
            event.dateEvent!.month == selectedDate!.month &&
            event.dateEvent!.day == selectedDate!.day;
      }).toList();
    });
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

  void _showNearestEvents() {
    setState(() {
      allEvents!.sort((a, b) {
        return a.dateEvent!
            .difference(DateTime.now())
            .inDays
            .compareTo(b.dateEvent!.difference(DateTime.now()).inDays);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      drawer: DrawerWidgetPro(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/Grouhome.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the image to cover the entire screen
          ),
        ),
        child: Column(
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
                    'Événement',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          controller: _controller,
                          decoration: InputDecoration(
                            hoverColor: Colors.red,
                            constraints: BoxConstraints(maxWidth: 300),
                            labelText: 'Recherche',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return allEvents!
                              .where((user) => user.eventname!
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.eventname!),
                            leading: Image.network(
                              (suggestion.eventimage == null ||
                                      suggestion.eventimage!.isEmpty)
                                  ? "https://fastly.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI"
                                  : suggestion.eventimage!,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                // You can add logging here to see what the error is
                                print('Error loading image: $error');
                                return Image.network(
                                  "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                                );
                              },
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          // Handle when a suggestion is selected.
                          _controller.text = suggestion.eventname!;
                          Get.to(
                            Get.to(DetailEventScreen(event: suggestion)),
                          );
                          print(suggestion.eventname!);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.red),
                      onPressed: () {
                        // _showNearestEvents();
                        Get.to(FilterEventScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: allEvents == null || allEvents!.isEmpty
                  ? Center(
                      child: Text('événement en atente..'),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchEvents,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/Grouhome.png'), // Replace with your image path
                            fit: BoxFit
                                .cover, // Adjust the image to cover the entire screen
                          ),
                        ),
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
            ),
          ],
        ),
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
      final participantStatus = await ApiServicePro.isParticipant(
          PreferenceUtils.getuserid(), widget.event.EventId!);
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
      final x = await ApiServicePro.isParticipant(
          PreferenceUtils.getuserid(), widget.event.EventId!);
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
        height: (showFeedbackButton && !hasFeedback) ? 400 : 400,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
              spreadRadius: 3, // How far the shadow extends
              blurRadius: 1, // Softness of the shadow
              offset: Offset(0, 3), // Offset for x and y axes
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                // Image widget
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.event.eventimage == null ||
                              widget.event.eventimage!.isEmpty
                          ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                          : widget.event.eventimage!,
                      height: (showFeedbackButton && !hasFeedback) ? 150 : 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 150,
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
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        print('Error loading image: $error');
                        return Image.network(
                          "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                          height: 150,
                          width: 100,
                        );
                      },
                    ),
                  ),
                ),
                // Date text widget
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    height: 50,
                    width: 60,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Color.fromARGB(255, 255, 246, 246).withOpacity(0.5),
                    child: Text(
                      '${widget.formatter.format(widget.event.dateEvent!)}',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.event.eventname!.capitalizeFirst!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.red),
                    SizedBox(width: 3),
                    Text("Nombre de participant inscrit"),
                    SizedBox(width: 5),
                    Text(
                      isLoading
                          ? 'Loading...'
                          : allParticpant?.length.toString() ?? '0',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: isEventFull && !isParticipant
                      ? null
                      : () {
                          // Get.to(DetailEventScreen(event: widget.event));
                          Get.to(DetailPageEvent(
                            event: widget.event,
                          ));
                        },
                  child: Text(
                    'Découvrir',
                    style: TextStyle(
                        fontSize: 15,
                        color:
                            isEventFull && !isParticipant ? null : Colors.red),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        _openMap(
                            context, widget.event.eventLocation ?? 'unknown');
                      },
                      child: Text(
                        widget.event.eventLocation!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 10),
            isFeedbackLoading
                ? CircularProgressIndicator()
                : hasFeedback
                    ? Text('donner votre feedback',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
                    : Text('',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
            SizedBox(height: 10),
            if (showFeedbackButton && hasFeedback)
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
