import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/screens/pro/pages/Events/DetailEventScreen.dart';
import 'package:opalia_client/screens/pro/widgets/Reusiblewidgets/Drawerwidgets.dart';

import '../../../../models/events.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../widgets/Reusiblewidgets/AppBarWidgetPro.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Events>? allEvents = [];
  late Future<Events> futureAppointment;
  Future<void> _fetchMedicament() async {
    try {
      final events = await ApiServicePro.getAllEvents();
      setState(() {
        allEvents = events;
      });
    } catch (e) {
      print('Failed to fetch categorie: $e');
    }
  }

  @override
  void initState() {
    _fetchMedicament();
    super.initState();
  }

  var formatter = new DateFormat('yyyy-MM-dd');
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
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Evenement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: allEvents!.length,
                itemBuilder: (context, index) {
                  final event = allEvents![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 250,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2, color: Colors.red),
                        color: Colors.white,
                      ),
                      child: Column(children: [
                        Image.network(
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 100,
                              width: double.infinity,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          (event.eventimage == null || event.eventimage == "")
                              ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                              : event.eventimage!,
                          height: 100,
                          width: 250,
                          fit: BoxFit.scaleDown,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            // You can add logging here to see what the error is
                            print('Error loading image: $error');
                            return Image.network(
                              height: 100,
                              width: 100,
                              "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                            );
                          },
                        ),
                        Text(
                          event.eventname!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              event.eventLocation!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${formatter.format(event.dateEvent!)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Get.to(DetailEventScreen(event: event));
                                },
                                child: Text('Decouvrire'))
                          ],
                        )
                      ]),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
