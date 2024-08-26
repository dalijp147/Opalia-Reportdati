import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/models/medecin.dart';
import 'package:opalia_client/screens/pro/pages/Events/Participant/tab/AvisTab.dart';
import 'package:opalia_client/screens/pro/pages/Events/Participant/tab/DetailPatTab.dart';
import 'package:opalia_client/screens/pro/pages/Events/Participant/tab/EventTabPat.dart';

import '../../../../../models/events.dart';

class DetailParticipant extends StatefulWidget {
  final String description;
  final String image;
  final String nom;
  final String prenom;
  final String specialite;
  final Events event;
  final Medecin DocId;

  const DetailParticipant({
    Key? key,
    required this.description,
    required this.image,
    required this.nom,
    required this.specialite,
    required this.prenom,
    required this.event,
    required this.DocId,
  }) : super(key: key);

  @override
  State<DetailParticipant> createState() => _DetailParticipantState();
}

class _DetailParticipantState extends State<DetailParticipant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
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
            SizedBox(
              height: 10,
            ),
            Container(
              height: 180, // Set a fixed height for the image and doctor info
              child: Column(
                children: [
                  ClipOval(
                    child: Image.network(
                      widget.image.isEmpty
                          ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                          : widget.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 70,
                          width: 70,
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
                        return ClipOval(
                          child: Image.network(
                            "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Docteur ${widget.prenom}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 5),
                          Text(
                            widget.nom,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Text(
                        widget.specialite,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      labelStyle: TextStyle(fontSize: 16),
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.red,
                      tabs: [
                        Tab(text: 'À Propos'),
                        Tab(text: 'Événements'),
                        Tab(text: 'Avis'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          DetailTabParticipant(
                            Description: widget.description,
                          ),
                          EventTabPatScreen(
                            docId: widget.DocId,
                          ),
                          AvisTabScreen(
                            doctorId: widget.DocId.doctorId!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
