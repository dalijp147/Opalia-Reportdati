import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/events.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../widgets/Allappwidgets/AppBarWidgetPro.dart';
import 'EventsScreen.dart';

class FilterEventScreen extends StatefulWidget {
  const FilterEventScreen({super.key});

  @override
  State<FilterEventScreen> createState() => _FilterEventScreenState();
}

class _FilterEventScreenState extends State<FilterEventScreen> {
  List<Events>? allEvents = [];
  List<Events>? pastEvents = [];
  List<Events>? upcomingEvents = [];
  List<Events>? filteredEvents = [];
  bool isCategorieProSelected = true;
  String? selectedLocation;
  var formatter = DateFormat('yyyy-MM-dd');
  List<String> locations = []; // List of unique event locations

  Future<void> _fetchEvents() async {
    try {
      final events = await ApiServicePro.getAllEvents();
      final now = DateTime.now();

      setState(() {
        allEvents = events;
        pastEvents =
            events!.where((event) => event.dateEvent!.isBefore(now)).toList();
        upcomingEvents =
            events.where((event) => event.dateEvent!.isAfter(now)).toList();
        locations = events
            .map((event) => event.eventLocation!)
            .toSet()
            .toList(); // Extract unique locations
        _filterEvents();
      });
    } catch (e) {
      print('Failed to fetch events: $e');
    }
  }

  void _filterEvents() {
    final eventsToFilter = isCategorieProSelected ? pastEvents : upcomingEvents;
    if (selectedLocation != null && selectedLocation!.isNotEmpty) {
      filteredEvents = eventsToFilter!
          .where((event) => event.eventLocation == selectedLocation)
          .toList();
    } else {
      filteredEvents = eventsToFilter!;
    }
  }

  @override
  void initState() {
    _fetchEvents();
    super.initState();
  }

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
        centerTitle: true,
        title: Text(
          'Filtrer par date et lieu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Grouhome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCategoryButton('Prochain évenement', false),
                        _buildCategoryButton('Événements passés', true),
                      ],
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      hint: Text("Seletionner une localisation"),
                      value: selectedLocation,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLocation = newValue;
                          _filterEvents();
                        });
                      },
                      items: locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: filteredEvents == null || filteredEvents!.isEmpty
                  ? Center(
                      child: Text('evenement en attente'),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchEvents,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/Grouhome.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: filteredEvents!.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents![index];
                            return EventCard(
                              event: event,
                              formatter: formatter,
                              onRefresh: _fetchEvents,
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

  Widget _buildCategoryButton(String title, bool isPast) {
    return Container(
      height: 70,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(255, 235, 235, 1),
            Color.fromRGBO(255, 255, 255, 1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isCategorieProSelected = isPast;
            _filterEvents();
          });
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  isCategorieProSelected == isPast ? Colors.red : Colors.grey,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
