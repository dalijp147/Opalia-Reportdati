import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/models/medecin.dart';

import '../../../../../../models/events.dart';
import '../../../../../../models/particpant.dart';
import '../../../../../../services/remote/apiServicePro.dart';

class EventTabPatScreen extends StatefulWidget {
  final Medecin docId;
  const EventTabPatScreen({super.key, required this.docId});

  @override
  State<EventTabPatScreen> createState() => _EventTabPatScreenState();
}

class _EventTabPatScreenState extends State<EventTabPatScreen> {
  List<Particpant>? allParticpant;
  bool isLoading = true;
  var formatter = DateFormat('EEEE, d MMMM yyyy', 'fr_FR');
  Future<void> _fetchParticipantbyevent() async {
    try {
      final participant = await ApiServicePro.fetchparticipantbyeventSPEAKERS(
          widget.docId.doctorId);
      setState(
        () {
          allParticpant = participant;
          isLoading = false;
        },
      );
    } catch (e) {
      print('Failed to fetch participant: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchParticipantbyevent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : allParticpant == null || allParticpant!.isEmpty
              ? Center(child: Text('pas de speaker '))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: allParticpant!.length, // total number of items
                  itemBuilder: (context, index) {
                    final parti = allParticpant![index];
                    return GestureDetector(
                      onTap: () {
                        // Get.to(DetailParticipant(
                        //   specialite: parti.doctorId!.specialite!,
                        //   description: parti.description!,
                        //   image: parti.doctorId!.image!,
                        //   nom: parti.doctorId!.name!,
                        //   prenom: parti.doctorId!.familyname!,
                        //   event: parti.eventId!,
                        // ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 170,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.network(
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        height: 100,
                                        width:
                                            100, // Ensure the image has a fixed width
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    (parti.eventId!.eventimage == null ||
                                            parti.eventId!.eventimage == "")
                                        ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                                        : parti.eventId!.eventimage!,
                                    height: 100,
                                    width: 100, // Fixed width
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      print('Error loading image: $error');
                                      return Image.network(
                                        height: 100,
                                        width: 100, // Fixed width
                                        "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        10), // Add spacing between image and column
                                Expanded(
                                  // Expands to take the remaining space
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 40,
                                      left: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${formatter.format(parti.eventId!.dateEvent!)}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          parti.eventId!.eventname!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.location_on,
                                                color: Colors.black54),
                                            SizedBox(width: 5),
                                            Flexible(
                                              // Ensure the text doesn't overflow by wrapping
                                              child: Text(
                                                parti.eventId!.eventLocation!,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                ),
    );
  }
}
