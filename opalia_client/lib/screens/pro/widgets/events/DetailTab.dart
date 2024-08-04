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
  var formatter = DateFormat('yyyy-MM-dd');
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

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not open the map. URL: $googleMapsUrl'),
      ));
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Image.network(
              fit: BoxFit.cover,
              widget.event.eventimage == null ||
                      widget.event.eventimage!.isEmpty
                  ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                  : widget.event.eventimage!,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                widget.event.eventname!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              _openMap(context, widget.event.eventLocation ?? 'unknown');
            },
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.event.eventLocation!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.date_range, color: Colors.red),
              SizedBox(width: 5),
              Text(
                '${formatter.format(widget.event.dateEvent!)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Description :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.event.eventdescription!,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 20),
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
                            content:
                                Text('Veux-tu te désinscrire? Appuyez sur OK.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Oui'),
                                onPressed: () async {
                                  await ApiServicePro
                                      .deleteParticipantbydoctorid(
                                    PreferenceUtils.getuserid(),
                                  );
                                  setState(() {
                                    verif = false;
                                  });
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                              TextButton(
                                child: Text('Non'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Déjà inscrit',
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(
                      'Inscription',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
