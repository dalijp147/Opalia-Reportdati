import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/models/feedback.dart';
import 'package:opalia_client/models/events.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';
import '../../../../../../models/particpant.dart';

class AvisTabScreen extends StatefulWidget {
  final String doctorId;
  const AvisTabScreen({Key? key, required this.doctorId}) : super(key: key);

  @override
  _AvisTabScreenState createState() => _AvisTabScreenState();
}

class _AvisTabScreenState extends State<AvisTabScreen> {
  List<Events>? speakerEvents;
  List<Feeddback>? feedbacks = [];
  bool isLoading = true;

  Future<void> _fetchParticipantbyevent() async {
    try {
      // Fetch the participant's events
      final participants =
          await ApiServicePro.fetchparticipantbyeventSPEAKERS(widget.doctorId);
      setState(() {
        // Map the participants to their respective event IDs
        speakerEvents = participants.map((parti) => parti.eventId!).toList();
      });

      // Fetch feedbacks for each event
      for (var event in speakerEvents!) {
        final fetchedFeedbacks = await ApiServicePro.getFeeds(event.EventId);
        setState(() {
          feedbacks!.addAll(fetchedFeedbacks ?? []);
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch participant or feedback: $e');
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
    var formatter = DateFormat('EEEE, d MMMM yyyy', 'fr_FR');
    return Container(
      padding: EdgeInsets.all(8.0),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : feedbacks == null || feedbacks!.isEmpty
              ? Center(child: Text('No feedbacks available'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: feedbacks!.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbacks![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      feedback.participantId!.image!),
                                  radius: 20,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            feedback.participantId!.name!,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            feedback.participantId!.familyname!,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: List.generate(5, (starIndex) {
                                          return Icon(
                                            starIndex < feedback.etoile!
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow[700],
                                            size: 20,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(feedback.comment!),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                    // ListTile(
                    //   leading: Image.network(feedback.participantId!.image!),
                    //   title: Text(feedback.participantId?.name ?? 'Unknown'),
                    //   subtitle: Text(feedback.comment ?? 'No comment'),
                    // );
                  },
                ),
    );
  }
}
