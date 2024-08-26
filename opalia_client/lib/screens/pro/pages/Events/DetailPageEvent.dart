import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/screens/pro/widgets/events/DiscussionTab.dart';
import 'package:opalia_client/screens/pro/widgets/events/ParticipantTab.dart';
import 'package:opalia_client/screens/pro/widgets/events/ProgarmTab.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/events.dart';
import '../../../../services/local/sharedprefutils.dart';
import '../../../../services/remote/apiServicePro.dart';

class DetailPageEvent extends StatefulWidget {
  final Events event;
  const DetailPageEvent({super.key, required this.event});

  @override
  State<DetailPageEvent> createState() => _DetailPageEventState();
}

class _DetailPageEventState extends State<DetailPageEvent> {
  var formatter = DateFormat('EEEE, d MMMM yyyy', 'fr_FR');
  bool verif = false;
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

  @override
  void initState() {
    super.initState();
    verify();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    width: double.infinity,
                    child: Image.network(
                      fit: BoxFit.fill,
                      (widget.event.eventimage == null ||
                              widget.event.eventimage == "")
                          ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                          : widget.event.eventimage!,
                    ),
                  ),
                  buttonArrow(context),
                  scroll(),
                ],
              ),
            ),
            inscriptionButton(),
          ],
        ),
      ),
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 1.0,
      minChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 30,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.event.eventname!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Color.fromRGBO(
                            86,
                            105,
                            255,
                            0.2,
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          size: 27.0,
                          Icons.calendar_month,
                          color: Color.fromRGBO(243, 124, 124, 1),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${formatter.format(widget.event.dateEvent!).capitalizeFirst}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openMap(
                              context, widget.event.eventLocation ?? 'unknown');
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Color.fromRGBO(
                              86,
                              105,
                              255,
                              0.2,
                            ),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            size: 27.0,
                            Icons.location_on,
                            color: Color.fromRGBO(243, 124, 124, 1),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.event.eventLocation!.capitalizeFirst!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(ParticipantTab(event: widget.event));
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Color.fromRGBO(
                              86,
                              105,
                              255,
                              0.2,
                            ),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            size: 27.0,
                            Icons.people_alt,
                            color: Color.fromRGBO(243, 124, 124, 1),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "les orateurs de l'événement",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(ProgramTab(event: widget.event));
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Color.fromRGBO(
                              86,
                              105,
                              255,
                              0.2,
                            ),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            size: 27.0,
                            Icons.schedule_outlined,
                            color: Color.fromRGBO(243, 124, 124, 1),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Programme de l'événement",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(DiscussionTab(event: widget.event));
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Color.fromRGBO(
                              86,
                              105,
                              255,
                              0.2,
                            ),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            size: 27.0,
                            Icons.mark_chat_unread_rounded,
                            color: Color.fromRGBO(243, 124, 124, 1),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Discuter avec les autre participants',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "A propos de l'événement",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'nombre maximal de participant : ${widget.event.nombreparticipant}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.event.eventdescription!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget inscriptionButton() {
    return verif
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Se Désinscrire!'),
                      content: Text('Veux-tu te désinscrire? Appuyez sur OK.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Oui'),
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
                          child: Text('Non'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                primary: Color.fromRGBO(243, 124, 124, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Déjà inscrit',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          )
        : Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: Colors.white,
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
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                primary: Color.fromRGBO(243, 124, 124, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Inscrivez-vous',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          );
  }
}
