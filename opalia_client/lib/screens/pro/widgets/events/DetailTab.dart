import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../../models/events.dart';

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
    final x = await ApiServicePro.getParticipanttExist("");
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
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.red,
            ),
            Text(widget.event.eventname!),
          ],
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
                          content:
                              Text('veut tu te d é inscrire apuyer sur ok'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () async {
                                // await ApiServicePro.deleteParticipant(
                                //   widget.event.participantId!,
                                // );
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
                      "6675806edce8448c19dfdf3b",
                      widget.event.EventId,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    'Inscription',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
      ],
    );
  }
}
