import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/events.dart';
import '../../../../models/particpant.dart';

class DetailTab extends StatefulWidget {
  final Events event;
  const DetailTab({super.key, required this.event});

  @override
  State<DetailTab> createState() => _DetailTabState();
}

class _DetailTabState extends State<DetailTab> {
  var formatter = new DateFormat('yyyy-MM-dd');
  bool verif = false;
  Future<bool> verify() async {
    final x =
        await ApiServicePro.getParticipanttExist(PreferenceUtils.getuserid());
    if (x == true) {
      setState(() {
        verif = x;
      });

      print("ok");
      print(verif);
      return verif;
    } else {
      print("error");
      return verif;
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

  @override
  void initState() {
    verify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            width: double.infinity,
            child: Image.network(
              (widget.event.eventimage == null || widget.event.eventimage == "")
                  ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                  : widget.event.eventimage!,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.event.eventname!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            _openMap(context, widget.event.eventLocation ?? 'unknown');
          },
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              Text(widget.event.eventLocation!),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.date_range,
              color: Colors.red,
            ),
            Text(
              '${formatter.format(widget.event.dateEvent!)}',
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        const Text(
          "Description :",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.event.eventdescription!,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        verif
            ? Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Se Désinscrire!'),
                          content: Text('veut tu te désinscrire apuyer sur ok'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('oui'),
                              onPressed: () async {
                                await ApiServicePro.deleteParticipantbydoctorid(
                                  PreferenceUtils.getuserid(),
                                );
                                setState(() {
                                  verif = false;
                                });
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: Text('non'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Déja inscrit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    await ApiServicePro.postParticipant(
                      true,
                      PreferenceUtils.getuserid(),
                      widget.event.EventId,
                    );
                    setState(() {
                      verif = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    'Inscription',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
      ],
    );
  }
}
